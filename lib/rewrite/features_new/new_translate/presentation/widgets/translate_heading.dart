import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';

class TranslateHeading extends StatelessWidget {
  const TranslateHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          indent: 50,
          endIndent: 50,
          height: 50,
          color: PlexColorPalette.gamboge,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: const [
              Text(
                'Thank you for helping to translate Tautulli Remote!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'If you would like to add a new language please submit a feature request on GitHub.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(
          indent: 50,
          endIndent: 50,
          height: 50,
          color: PlexColorPalette.gamboge,
        ),
      ],
    );
  }
}
