import 'package:flutter/material.dart';

import '../../../../core_new/widgets/new_media_type_icon.dart';
import '../../../../core_new/widgets/new_transcode_decision_icon.dart';
import '../../data/models/new_activity_model.dart';

class NewActivityCardIconRow extends StatelessWidget {
  final NewActivityModel activity;

  const NewActivityCardIconRow({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        NewMediaTypeIcon(
          mediaType: activity.mediaType,
        ),
        const SizedBox(width: 5),
        NewTranscodeDecisionIcon(transcodeDecision: activity.transcodeDecision),
      ],
    );
  }
}
