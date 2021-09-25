import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/enums/media_type.dart';
import '../../../../core_new/helpers/new_activity_media_details_helper.dart';
import '../../../../core_new/helpers/new_ip_address_helper.dart';
import '../../../../core_new/widgets/inherited_constraints.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../new_settings/presentation/bloc/new_settings_bloc.dart';
import '../../data/models/new_activity_model.dart';
import '../../domain/entities/new_geo_ip.dart';
import '../bloc/new_geo_ip_bloc.dart';

class NewActivityDetails extends StatelessWidget {
  final NewActivityModel activity;

  const NewActivityDetails({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<NewSettingsBloc>();
    context.read<NewGeoIpBloc>().state;
    // print(InheritedConstraints.of(context)!.constraints);

    return Column(
      children: _buildList(
        context: context,
        activity: activity,
      ),
    );
  }
}

List<Widget> _buildList({
  required BuildContext context,
  required NewActivityModel activity,
}) {
  List<Widget> rows = [];

  bool isPublicIp;
  try {
    isPublicIp = NewIpAddressHelper.isPublic(activity.ipAddress);
  } catch (_) {
    isPublicIp = false;
  }

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.product(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.player(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.quality(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.optimizedVersion) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.optimized(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.syncedVersion) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.synced(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    const SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.stream(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.container(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.mediaType != MediaType.track) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.video(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != MediaType.photo) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.audio(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != MediaType.track &&
      activity.mediaType != MediaType.photo) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.subtitles(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    const SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.location(
      activity,
      //TODO: Pass settings for mask sensitive info instead of cosnt false
      false,
    ),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.relayed) {
    _buildRows(
      context: context,
      rowLists: NewActivityMediaDetailsHelper.locationDetails(
        type: 'relay',
        //TODO: Pass settings for mask sensitive info instead of cosnt false
        maskSensitiveInfo: false,
      ),
    ).forEach((row) {
      rows.add(row);
    });
  }

  // Build the GeoIP data row
  if (isPublicIp) {
    rows.add(
      BlocBuilder<NewGeoIpBloc, NewGeoIpState>(
        builder: (context, state) {
          if (state is NewGeoIpSuccess) {
            if (state.geoIpMap.containsKey(activity.ipAddress)) {
              NewGeoIp? geoIp = state.geoIpMap[activity.ipAddress];
              if (!activity.relayed && geoIp != null && geoIp.code != 'ZZ') {
                final List locationDetails =
                    NewActivityMediaDetailsHelper.locationDetails(
                  type: 'ip',
                  city: geoIp.city,
                  region: geoIp.region,
                  code: geoIp.code,
                  //TODO: Pass settings for mask sensitive info instead of cosnt false
                  maskSensitiveInfo: false,
                )[0];

                return _ActivityMediaDetailsRow(
                  constraints: InheritedConstraints.of(context)!.constraints,
                  left: locationDetails[0],
                  right: locationDetails[1],
                );
              }
              return const SizedBox(height: 0, width: 0);
            }
            return _ActivityMediaDetailsRow(
              constraints: InheritedConstraints.of(context)!.constraints,
              left: '',
              right: Row(
                children: [
                  const Text(LocaleKeys.media_details_location_error).tr(),
                ],
              ),
            );
          }
          return _ActivityMediaDetailsRow(
            constraints: InheritedConstraints.of(context)!.constraints,
            left: '',
            right: Row(
              children: [
                SizedBox(
                  height: 19,
                  width: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: const Text(LocaleKeys.media_details_location_loading)
                      .tr(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildRows(
    context: context,
    rowLists: NewActivityMediaDetailsHelper.bandwidth(activity),
  ).forEach((row) {
    rows.add(row);
  });

  return rows;
}

List<Widget> _buildRows({
  required BuildContext context,
  required List rowLists,
}) {
  List<Widget> rows = [];

  rowLists.forEach((row) {
    rows.add(
      _ActivityMediaDetailsRow(
        constraints: InheritedConstraints.of(context)!.constraints,
        left: row[0],
        right: row[1],
      ),
    );
  });

  return rows;
}

class _ActivityMediaDetailsRow extends StatelessWidget {
  final BoxConstraints constraints;
  final String? left;
  final Widget right;

  const _ActivityMediaDetailsRow({
    Key? key,
    required this.constraints,
    this.left,
    required this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 5,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: constraints.maxWidth / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          left ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      right,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
