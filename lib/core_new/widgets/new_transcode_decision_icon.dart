import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/stream_decision.dart';
import '../helpers/new_color_palette_helper.dart';
import '../helpers/new_icon_helper.dart';

class NewTranscodeDecisionIcon extends StatelessWidget {
  final StreamDecision transcodeDecision;

  const NewTranscodeDecisionIcon({
    Key? key,
    required this.transcodeDecision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      NewIconHelper.mapTranscodeDecisionToIcon(transcodeDecision),
      size: 15,
      color: TautulliColorPalette.not_white,
    );
  }
}
