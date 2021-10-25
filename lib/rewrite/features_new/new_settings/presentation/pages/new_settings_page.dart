import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/widgets/new_list_header.dart';
import '../../../../core_new/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core_new/widgets/settings_not_loaded.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_health_bloc.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_privacy_bloc.dart';
import '../bloc/new_settings_bloc.dart';
import '../widgets/new_activity_refresh_rate_dialog.dart';
import '../widgets/new_server_setup_instructions.dart';
import '../widgets/new_server_timeout_dialog.dart';
import '../widgets/new_settings_alert_banner.dart';
import '../widgets/new_settings_server_subtitle.dart';
import '../widgets/register_server_button.dart';
import 'new_server_settings_page.dart';

class NewSettingsPage extends StatelessWidget {
  const NewSettingsPage({Key? key}) : super(key: key);

  static const routeName = '/new_settings';

  @override
  Widget build(BuildContext context) {
    return const NewSettingsView();
  }
}

class NewSettingsView extends StatelessWidget {
  const NewSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onesignalPrivacyBloc = context.read<NewOnesignalPrivacyBloc>();
    final onesignalHealthBloc = context.read<NewOnesignalHealthBloc>();

    if (onesignalPrivacyBloc.state is NewOnesignalPrivacySuccess) {
      onesignalHealthBloc.add(NewOnesignalHealthCheck());
    }

    return ScaffoldWithInnerDrawer(
      title: const Text('Settings'),
      body: BlocBuilder<NewSettingsBloc, NewSettingsState>(
        builder: (context, state) {
          if (state is NewSettingsSuccess) {
            return ListView(
              children: [
                const NewSettingsAlertBanner(),
                const NewListHeader(
                  headingText: 'Tautulli Servers',
                  topPadding: 8,
                ),
                if (state.serverList.isEmpty)
                  // ignore: prefer_const_constructors
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 10,
                    ),
                    // ignore: prefer_const_constructors
                    child: NewServerSetupInstructions(),
                  ),
                if (state.serverList.isNotEmpty)
                  ReorderableColumn(
                    onReorder: (oldIndex, newIndex) {
                      final int? movedServerId = state.serverList[oldIndex].id;
                      //TODO: Update server sort
                      // context.read<NewSettingsBloc>().add(
                      //       NewSettingsUpdateSortIndex(
                      //         serverId: movedServerId,
                      //         oldIndex: oldIndex,
                      //         newIndex: newIndex,
                      //       ),
                      //     );
                    },
                    children: state.serverList
                        .map(
                          (server) => ListTile(
                            key: ValueKey(server.id),
                            title: Text(server.plexName),
                            subtitle: NewSettingsServerSubtitle(
                              server: server,
                              maskSensitiveInfo: state.maskSensitiveInfo,
                            ),
                            trailing: const FaIcon(
                              FontAwesomeIcons.cog,
                              color: TautulliColorPalette.not_white,
                            ),
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NewServerSettingsPage(
                                    plexName: server.plexName,
                                    serverId: server.id!,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: state.serverList.isEmpty ? 8 : 0,
                    left: 16,
                    right: 16,
                  ),
                  child: const RegisterServerButton(),
                ),
                const SizedBox(height: 20),
                const NewListHeader(
                  headingText: 'App Settings',
                ),
                //* Server Timeout
                ListTile(
                  title: const Text('Server Timeout'),
                  subtitle: _serverTimeoutDisplay(state.serverTimeout),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => NewServerTimeoutDialog(
                        initialValue: state.serverTimeout,
                      ),
                    );
                  },
                ),
                //* Activity Refresh Rate
                ListTile(
                  title: const Text('Activity Refresh Rate'),
                  subtitle: _serverRefreshRateDisplay(state.refreshRate),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => NewActivityRefreshRateDialog(
                        initialValue: state.refreshRate,
                      ),
                    );
                  },
                ),
                //* Advanced Settings
                ListTile(
                  title: const Text('Advanced Settings'),
                  trailing: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: TautulliColorPalette.not_white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new_advanced_settings');
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Divider(
                    color: TautulliColorPalette.not_white,
                  ),
                ),
                //* OneSignal Data Privacy
                ListTile(
                  title: const Text(
                    'OneSignal Data Privacy',
                    style: TextStyle(
                      color: TautulliColorPalette.smoke,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: TautulliColorPalette.smoke,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new_privacy');
                  },
                ),
                //* Help & Support
                ListTile(
                  title: const Text(
                    'Help & Support',
                    style: TextStyle(
                      color: TautulliColorPalette.smoke,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: TautulliColorPalette.smoke,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new_help');
                  },
                ),
                //* Changelog
                ListTile(
                  title: const Text(
                    'Changelog',
                    style: TextStyle(
                      color: TautulliColorPalette.smoke,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: TautulliColorPalette.smoke,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new_changelog');
                  },
                ),
                //* Help Translate
                ListTile(
                  title: const Text(
                    'Help Translate',
                    style: TextStyle(
                      color: TautulliColorPalette.smoke,
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: TautulliColorPalette.smoke,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/new_translate');
                  },
                ),
                //* About
                ListTile(
                  title: const Text(
                    'About',
                    style: TextStyle(
                      color: TautulliColorPalette.smoke,
                    ),
                  ),
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    showAboutDialog(
                      context: context,
                      applicationIcon: SizedBox(
                        height: 50,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                      applicationName: 'Tautulli Remote',
                      applicationVersion: packageInfo.version,
                      applicationLegalese:
                          'Licensed under the GNU General Public License v3.0',
                    );
                  },
                ),
              ],
            );
          }
          return const SettingsNotLoaded();
        },
      ),
    );
  }

  Widget _serverTimeoutDisplay(int timeout) {
    switch (timeout) {
      case (3):
        return const Text('3 sec');
      case (5):
        return const Text('5 sec');
      case (8):
        return const Text('8 sec');
      case (30):
        return const Text('30 sec');
      default:
        return const Text('15 sec (Default)');
    }
  }

  Widget _serverRefreshRateDisplay(int refreshRate) {
    switch (refreshRate) {
      case (5):
        return const Text('5 sec - Faster');
      case (7):
        return const Text('7 sec - Fast');
      case (10):
        return const Text('10 sec - Normal');
      case (15):
        return const Text('15 sec - Slow');
      case (20):
        return const Text('20 sec - Slower');
      default:
        return const Text('Disabled');
    }
  }
}
