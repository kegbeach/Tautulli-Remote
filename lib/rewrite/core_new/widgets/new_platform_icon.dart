import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../helpers/new_asset_helper.dart';
import '../helpers/new_color_palette_helper.dart';

class NewPlatformIcon extends StatelessWidget {
  final platform;

  NewPlatformIcon(this.platform);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        child: Container(
          color: TautulliColorPalette.mapPlatformToColor(platform),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: WebsafeSvg.asset(
              NewAssetHelper.mapPlatformToPath(platform),
            ),
          ),
        ),
      ),
    );
  }
}
