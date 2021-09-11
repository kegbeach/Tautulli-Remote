import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core_new/enums/enums.dart' as enums;
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/helpers/new_icon_helper.dart';

class NewStatusPosterOverlay extends StatelessWidget {
  final enums.State state;

  const NewStatusPosterOverlay({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ),
        //* Icon
        AspectRatio(
          aspectRatio: 2 / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                NewIconHelper.mapStateToIcon(state),
                color: TautulliColorPalette.not_white,
                size: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
