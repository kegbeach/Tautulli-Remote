import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../../core_new/enums/enums.dart' as enums;
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/widgets/inherited_constraints.dart';
import '../../../../core_new/widgets/new_poster_chooser.dart';
import '../../data/models/new_activity_model.dart';
import 'new_activity_card_info.dart';
import 'new_activity_details.dart';
import 'new_background_image_chooser.dart';
import 'new_progress_bar.dart';
import 'new_status_poster_overlay.dart';
import 'new_time_eta.dart';
import 'new_time_total.dart';

class NewActivityModalBottomSheet extends StatelessWidget {
  final NewActivityModel activity;

  const NewActivityModalBottomSheet({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InheritedConstraints(
          constraints: constraints,
          // Required in order for use of an Expanded SingleChildScrollView
          // that contains ActivityDetails below
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Creates a transparent area for the poster to hover over
                        // Allows for that area to be tapped to dismiss the modal bottom sheet
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 30,
                            color: Colors.transparent,
                          ),
                        ),
                        //* Activity art section
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: SizedBox(
                            height: 130,
                            child: Stack(
                              children: [
                                NewBackgroundImageChooser(
                                  activity: activity,
                                  addBlur: false,
                                ),
                                //TODO: ImageFilter was causing issues with iOS, should see if issue still exists
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 25,
                                    sigmaY: 25,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            left: 98,
                                            bottom: 4,
                                            right: 4,
                                          ),
                                          child: NewActivityCardInfo(
                                            activity: activity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                          left: 98,
                                          top: 4,
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            //* User name
                                            Text(
                                              activity.friendlyName,
                                            ),
                                            //* Time left or Live tv channel
                                            !activity.live &&
                                                    activity.duration != null
                                                ? NewTimeTotal(
                                                    viewOffset:
                                                        activity.viewOffset,
                                                    duration:
                                                        activity.duration!,
                                                  )
                                                : activity.live
                                                    ? Text(
                                                        '${activity.channelCallSign} ${activity.channelIdentifier}',
                                                      )
                                                    : const SizedBox(
                                                        height: 0, width: 0),
                                          ],
                                        ),
                                      ),
                                      //* Progress bar
                                      activity.mediaType ==
                                                  enums.MediaType.photo ||
                                              activity.live
                                          ? const NewProgressBar(
                                              progress: 100,
                                              transcodeProgress: 0,
                                            )
                                          : NewProgressBar(
                                              progress:
                                                  activity.progressPercent,
                                              transcodeProgress:
                                                  activity.transcodeProgress,
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //* Poster
                    Positioned(
                      bottom: 10,
                      child: Container(
                        height: 130,
                        padding: const EdgeInsets.only(
                          left: 4,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: <Widget>[
                              NewPosterChooser(
                                itemModel: activity,
                              ),
                              if (activity.state == enums.State.paused ||
                                  activity.state == enums.State.buffering)
                                NewStatusPosterOverlay(state: activity.state),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (activity.duration != null)
                      Positioned(
                        right: 4,
                        bottom: 28,
                        child: NewTimeEta(
                          duration: activity.duration!,
                          progressPercent: activity.progressPercent,
                          //TODO: Add support for time format
                        ),
                      ),
                  ],
                ),
                //* Activity details section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          color: Theme.of(context).backgroundColor,
                          child: SingleChildScrollView(
                            child: NewActivityDetails(
                              activity: activity,
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          child: SafeArea(
                            bottom: true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 4,
                                        right: isNotBlank(activity.sessionId)
                                            ? 4
                                            : 0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: PlexColorPalette.gamboge,
                                        ),
                                        child: Text('View User'),
                                      ),
                                    ),
                                  ),
                                  if (activity.mediaType !=
                                      enums.MediaType.photo)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text('View Media'),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                PlexColorPalette.curious_blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  //TODO: Add check for plex pass from settingsbloc context
                                  if (isNotBlank(activity.sessionId))
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).errorColor,
                                          ),
                                          child: Text('Terminate'),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
