import 'package:flutter/material.dart';

import '../../../../core_new/enums/media_type.dart';
import '../../../../core_new/helpers/new_string_helper.dart';
import '../../data/models/new_activity_model.dart';

class NewActivityCardInfo extends StatelessWidget {
  final NewActivityModel activity;

  const NewActivityCardInfo({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        activity.mediaType == MediaType.episode
            ? _ActivityCardInfoH1(
                text: activity.grandparentTitle!,
                maxLines: 1,
              )
            : activity.mediaType == MediaType.movie
                ? _ActivityCardInfoH1(
                    text: activity.title,
                    maxLines: 3,
                  )
                : _ActivityCardInfoH1(
                    text: activity.title,
                    maxLines: 2,
                  ),
        activity.mediaType == MediaType.episode
            ? _ActivityCardInfoH2(text: activity.title)
            : activity.mediaType == MediaType.track
                ? _ActivityCardInfoH2(
                    text: activity.grandparentTitle!,
                    maxLines: 1,
                  )
                : const SizedBox(height: 0, width: 0),
        activity.mediaType == MediaType.movie && activity.year != null
            ? _ActivityCardInfoH3(text: activity.year.toString())
            : activity.mediaType == MediaType.episode &&
                    activity.parentMediaIndex != null
                ? _ActivityCardInfoH3(
                    text:
                        'S${activity.parentMediaIndex} • E${activity.mediaIndex}')
                : activity.mediaType == MediaType.episode &&
                        activity.originallyAvailableAt != null &&
                        activity.live
                    ? _ActivityCardInfoH3(text: activity.originallyAvailableAt!)
                    : activity.mediaType == MediaType.track
                        ? _ActivityCardInfoH3(text: activity.parentTitle!)
                        : activity.mediaType == MediaType.clip
                            ? _ActivityCardInfoH3(
                                text:
                                    '(${StringHelper.capitalize(activity.subType)})',
                              )
                            : const SizedBox(height: 0, width: 0),
      ],
    );
  }
}

class _ActivityCardInfoH1 extends StatelessWidget {
  final String text;
  final int? maxLines;

  const _ActivityCardInfoH1({
    Key? key,
    required this.text,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines != null ? maxLines : 1,
      style: const TextStyle(
        fontSize: 19,
        height: 1,
      ),
    );
  }
}

class _ActivityCardInfoH2 extends StatelessWidget {
  final String text;
  final int? maxLines;

  const _ActivityCardInfoH2({
    Key? key,
    required this.text,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines != null ? maxLines : 2,
        style: const TextStyle(
          fontSize: 16,
          height: 1,
        ),
      ),
    );
  }
}

class _ActivityCardInfoH3 extends StatelessWidget {
  final String text;

  const _ActivityCardInfoH3({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
