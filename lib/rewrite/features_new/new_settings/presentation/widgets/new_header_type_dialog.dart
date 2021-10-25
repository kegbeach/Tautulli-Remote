import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import 'new_header_config_dialog.dart';

class NewHeaderTypeDialog extends StatelessWidget {
  final String? tautulliId;
  final bool registerDevice;
  final List<NewCustomHeaderModel> currentHeaders;

  const NewHeaderTypeDialog({
    Key? key,
    this.tautulliId,
    this.registerDevice = false,
    this.currentHeaders = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool authorizationKeyExists;
    try {
      currentHeaders.firstWhere(
        (header) => header.key.toLowerCase() == 'authorization',
      );
      authorizationKeyExists = true;
    } on StateError catch (_) {
      authorizationKeyExists = false;
    }
    return SimpleDialog(
      children: [
        ListTile(
          enabled: !authorizationKeyExists,
          leading: FaIcon(
            FontAwesomeIcons.solidAddressCard,
            color: !authorizationKeyExists
                ? TautulliColorPalette.not_white
                : Colors.grey,
          ),
          title: const Text('Basic Authentication'),
          subtitle: authorizationKeyExists
              ? const Text('Authorization header exists')
              : null,
          onTap: () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) {
                return NewHeaderConfigDialog(
                  tautulliId: tautulliId,
                  basicAuth: true,
                  registerDevice: registerDevice,
                  currentHeaders: currentHeaders,
                );
              },
            );
          },
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.addressCard,
            color: TautulliColorPalette.not_white,
          ),
          title: const Text('Custom'),
          onTap: () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) {
                return NewHeaderConfigDialog(
                  tautulliId: tautulliId,
                  registerDevice: registerDevice,
                  currentHeaders: currentHeaders,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
