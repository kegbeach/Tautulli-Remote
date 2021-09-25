import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/loading_state.dart';
import '../helpers/new_color_palette_helper.dart';

class NewServerHeader extends StatelessWidget {
  final String serverName;
  final LoadingState? loadingState;
  final Color? backgroundColor;
  final Widget? secondaryWidget;

  const NewServerHeader({
    Key? key,
    required this.serverName,
    this.loadingState,
    this.backgroundColor,
    this.secondaryWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.only(
        left: 4,
        top: 8.2,
        bottom: 12.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                serverName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor,
                ),
              ),
              if (loadingState == LoadingState.inProgress)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              if (loadingState == LoadingState.failure)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: FaIcon(
                    FontAwesomeIcons.exclamationCircle,
                    size: 15,
                    color: TautulliColorPalette.not_white,
                  ),
                ),
            ],
          ),
          if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}
