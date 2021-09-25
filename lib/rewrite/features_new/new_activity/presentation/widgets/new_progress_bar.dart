import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';

class NewProgressBar extends StatelessWidget {
  final int progress;
  final int transcodeProgress;

  const NewProgressBar({
    Key? key,
    required this.progress,
    required this.transcodeProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LinearProgressIndicator(
          backgroundColor: PlexColorPalette.shark.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(
            PlexColorPalette.shuttle_gray.withOpacity(0.9),
          ),
          value: (transcodeProgress / 100).toDouble(),
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation(PlexColorPalette.gamboge),
          value: (progress / 100).toDouble(),
        ),
      ],
    );
  }
}
