import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../../core_new/pages/status_page.dart';
import '../../../../core_new/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core_new/widgets/new_server_header.dart';
import '../../../../core_new/widgets/new_status_card.dart';
import '../../../../core_new/widgets/page_padding.dart';
import '../../../../core_new/widgets/settings_not_loaded.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../new_settings/presentation/bloc/new_settings_bloc.dart';
import '../../data/models/new_activity_model.dart';
import '../bloc/new_activity_bloc.dart';
import '../bloc/new_geo_ip_bloc.dart';
import '../widgets/new_activity_card.dart';
import '../widgets/new_bandwidth_header.dart';

class NewActivityPage extends StatelessWidget {
  const NewActivityPage({Key? key}) : super(key: key);

  static const routeName = '/new_activity';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSettingsBloc, NewSettingsState>(
      builder: (context, settingsState) {
        if (settingsState is NewSettingsSuccess) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => di.sl<NewActivityBloc>()
                  ..add(
                    NewActivityLoad(settingsState.serverList),
                  ),
              ),
              // Provide GeoIpBloc at the activity page level so all activity
              // details use the same bloc value.
              BlocProvider(
                create: (context) => di.sl<NewGeoIpBloc>(),
              ),
            ],
            child: const NewActivityView(),
          );
        }
        return const SettingsNotLoaded();
      },
    );
  }
}

class NewActivityView extends StatefulWidget {
  const NewActivityView({Key? key}) : super(key: key);

  @override
  _NewActivityViewState createState() => _NewActivityViewState();
}

class _NewActivityViewState extends State<NewActivityView>
    with WidgetsBindingObserver {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('WIDTH: ${MediaQuery.of(context).size.width}');
    print('HEIGHT: ${MediaQuery.of(context).size.height}');
    print('ASPECT: ${MediaQuery.of(context).size.aspectRatio}');
    return ScaffoldWithInnerDrawer(
      title: const Text('Activity'),
      body: BlocConsumer<NewActivityBloc, NewActivityState>(
        listener: (context, state) {
          if (state is NewActivityLoaded) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is NewActivityInitial) {
            //TODO: Clean up progress indicator
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (state is NewActivityFailure) {
            return StatusPage(
              message: 'No servers are configured',
              action: ElevatedButton(
                onPressed: () {
                  //TODO: Link to settings page
                },
                child: Text('GO TO SETTINGS'),
              ),
            );
          }
          if (state is NewActivityLoaded) {
            bool multiserver = state.activityMap.keys.toList().length > 1;

            return RefreshIndicator(
              onRefresh: () {
                final settingsState =
                    context.read<NewSettingsBloc>().state as NewSettingsSuccess;

                context.read<NewActivityBloc>().add(
                      NewActivityLoad(settingsState.serverList),
                    );

                return _refreshCompleter.future;
              },
              child: PagePadding(
                child: !multiserver
                    ? _buildSingleServerActivity(state.activityMap)
                    : _buildMultiserverActivity(state.activityMap),
              ),
            );
          }
          return StatusPage(
            message: 'Unknown Activity State',
            action: ElevatedButton(
              onPressed: () {
                //TODO: Link to support page.
              },
              child: const Text('CONTACT SUPPORT'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSingleServerActivity(
    Map<String, Map<String, dynamic>> activityMap,
  ) {
    final Map<String, dynamic> serverData =
        activityMap[activityMap.keys.first]!;
    NewFailure? failure = serverData['failure'];
    List activityList = serverData['activityList'];
    List<Widget> serverActivityWidgets = [];
    final double screenWidth = MediaQuery.of(context).size.width;

    if (failure != null) {
      return StatusPage(
        scrollable: true,
        message: NewFailureHelper.mapFailureToMessage(failure),
        suggestion: NewFailureHelper.mapFailureToSuggestion(failure),
      );
    } else {
      if (activityList.isNotEmpty) {
        for (NewActivityModel activity in activityList) {
          serverActivityWidgets.add(
            NewActivityCard(
              activity: activity,
              tautulliId: activityMap.keys.first,
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverStickyHeader(
              header: DecoratedBox(
                decoration: const BoxDecoration(
                  color: TautulliColorPalette.midnight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: NewBandwidthHeader(
                    bandwidthMap: serverData['bandwidth'],
                  ),
                ),
              ),
              sliver: SliverGrid.count(
                crossAxisCount: screenWidth > 1000
                    ? 3
                    : screenWidth > 580
                        ? 2
                        : 1,
                childAspectRatio: 2 / 0.75,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: serverActivityWidgets,
              ),
            ),
          ],
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return const StatusPage(
            scrollable: true,
            message: 'Nothing is currently being played.',
          );
        },
      );
    }
  }

  Widget _buildMultiserverActivity(
    Map<String, Map<String, dynamic>> activityMap,
  ) {
    List<Widget> activityWidgetList = [];
    final double screenWidth = MediaQuery.of(context).size.width;

    activityMap.forEach((serverId, serverData) {
      NewFailure? failure = serverData['failure'];
      List activityList = serverData['activityList'];
      List<Widget> serverActivityWidgets = [];

      if (failure != null) {
        serverActivityWidgets.add(
          NewStatusCard(
            failure: failure,
          ),
        );
      } else {
        if (activityList.isNotEmpty) {
          for (NewActivityModel activity in activityList) {
            serverActivityWidgets.add(
              NewActivityCard(
                activity: activity,
                tautulliId: serverId,
              ),
            );
          }
        } else {
          serverActivityWidgets.add(
            const NewStatusCard(
              customStatus: 'Nothing is currently being played.',
            ),
          );
        }
      }

      // Create sticky server headers
      activityWidgetList.add(
        SliverStickyHeader(
          header: NewServerHeader(
            backgroundColor: TautulliColorPalette.midnight,
            serverName: serverData['plex_name'],
            loadingState: serverData['loadingState'],
            secondaryWidget: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: NewBandwidthHeader(bandwidthMap: serverData['bandwidth']),
            ),
          ),
          sliver: SliverGrid.count(
            crossAxisCount: screenWidth > 1000
                ? 3
                : screenWidth > 580
                    ? 2
                    : 1,
            childAspectRatio: 2 / 0.75,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: serverActivityWidgets,
          ),
        ),
      );
    });

    return CustomScrollView(
      slivers: activityWidgetList,
    );
  }
}
