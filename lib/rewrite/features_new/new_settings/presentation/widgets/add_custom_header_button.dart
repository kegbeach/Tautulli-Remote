import 'package:flutter/material.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import 'new_header_type_dialog.dart';

class AddCustomHeaderButton extends StatelessWidget {
  final double paddingTop;
  final NewServerModel server;

  const AddCustomHeaderButton({
    Key? key,
    this.paddingTop = 0,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: TautulliColorPalette.gunmetal,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => NewHeaderTypeDialog(
                    tautulliId: server.tautulliId,
                    currentHeaders: server.customHeaders,
                  ),
                );
              },
              child: const Text('Add Custom HTTP Header'),
            ),
          ),
        ],
      ),
    );
  }
}
