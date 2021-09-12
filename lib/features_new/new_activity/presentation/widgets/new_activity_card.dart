import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/enums/enums.dart' as enums;
import '../../../../core_new/enums/media_type.dart';
import '../../../../core_new/widgets/new_card_base.dart';
import '../../../../core_new/widgets/new_platform_icon.dart';
import '../../../../core_new/widgets/new_poster_chooser.dart';
import '../../../new_settings/presentation/bloc/new_settings_bloc.dart';
import '../../data/models/new_activity_model.dart';
import '../bloc/new_activity_bloc.dart';
import '../bloc/new_geo_ip_bloc.dart';
import 'new_activity_card_icon_row.dart';
import 'new_activity_card_info.dart';
import 'new_activity_modal_bottom_sheet.dart';
import 'new_background_image_chooser.dart';
import 'new_progress_bar.dart';
import 'new_status_poster_overlay.dart';
import 'new_time_left.dart';

class NewActivityCard extends StatelessWidget {
  final NewActivityModel activity;
  final String tautulliId;

  const NewActivityCard({
    Key? key,
    required this.activity,
    required this.tautulliId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showActivityModalBottomSheet(
          context: context,
          settingsBloc: context.read<NewSettingsBloc>(),
          activityBloc: context.read<NewActivityBloc>(),
          geoIpBloc: context.read<NewGeoIpBloc>(),
          activity: activity,
          tautulliId: tautulliId,
        );
      },
      child: NewCardBase(
        padding: const EdgeInsets.all(0),
        backgroundWidget: NewBackgroundImageChooser(
          activity: activity,
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    //* Poster
                    Stack(
                      children: [
                        NewPosterChooser(itemModel: activity),
                        if (activity.state != enums.State.playing)
                          NewStatusPosterOverlay(state: activity.state),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  //* Activity Info
                                  Expanded(
                                    child: NewActivityCardInfo(
                                      activity: activity,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //* Platform icon
                                        NewPlatformIcon(activity.platformName),
                                        //* Media Type and Transcode Decision Icons (except photo)
                                        if (activity.mediaType !=
                                            MediaType.photo)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 3,
                                            ),
                                            child: NewActivityCardIconRow(
                                                activity: activity),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //* User name
                                //TODO: Add sensitive info masking
                                Text(activity.friendlyName),
                                //* Time left or Live tv channel
                                //* or Photo Media Type and Transcode Decision Icons
                                !activity.live && activity.duration != null
                                    ? NewTimeLeft(
                                        duration: activity.duration!,
                                        progressPercent:
                                            activity.progressPercent,
                                      )
                                    : activity.live
                                        ? Text(
                                            '${activity.channelCallSign} ${activity.channelIdentifier}',
                                          )
                                        : activity.mediaType == MediaType.photo
                                            ? NewActivityCardIconRow(
                                                activity: activity,
                                              )
                                            : const SizedBox(
                                                height: 0, width: 0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //* Progress bar
            Container(
              height: 5,
              child: activity.mediaType == MediaType.photo || activity.live
                  ? const NewProgressBar(
                      progress: 100,
                      transcodeProgress: 0,
                    )
                  : NewProgressBar(
                      progress: activity.progressPercent,
                      transcodeProgress: activity.transcodeProgress,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActivityModalBottomSheet({
    required BuildContext context,
    required NewSettingsBloc settingsBloc,
    required NewActivityBloc activityBloc,
    required NewGeoIpBloc geoIpBloc,
    required NewActivityModel activity,
    required String tautulliId,
  }) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      //TODO: Add constraints once available in stable
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: settingsBloc,
            ),
            BlocProvider.value(
              value: activityBloc,
            ),
            BlocProvider.value(
              value: geoIpBloc
                ..add(
                  NewGeoIpLoad(
                    tautulliId: tautulliId,
                    ipAddress: activity.ipAddress,
                  ),
                ),
              child: Container(),
            ),
          ],
          child: NewActivityModalBottomSheet(
            activity: activity,
          ),
        );
      },
    );
  }
}
