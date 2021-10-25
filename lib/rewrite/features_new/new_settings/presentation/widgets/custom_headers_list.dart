import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/widgets/new_list_header.dart';
import '../bloc/new_settings_bloc.dart';
import '../widgets/new_delete_dialog.dart';
import 'new_header_config_dialog.dart';

class CustomHeadersList extends StatelessWidget {
  final NewServerModel server;
  final bool maskSensitiveInfo;

  const CustomHeadersList({
    Key? key,
    required this.server,
    required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    server.customHeaders.sort((a, b) => a.key.compareTo(b.key));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: NewListHeader(headingText: 'Custom HTTP Headers'),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: server.customHeaders
              .map(
                (header) => ListTile(
                  title: Text(header.key),
                  subtitle: Text(
                    !maskSensitiveInfo ? header.value : '*Hidden Header Key*',
                  ),
                  trailing: GestureDetector(
                    child: const FaIcon(
                      FontAwesomeIcons.trashAlt,
                      color: TautulliColorPalette.not_white,
                    ),
                    onTap: () async {
                      final delete = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return NewDeleteDialog(
                            title: Text(
                              "Are you sure you want to delete the header '${header.key}'?",
                            ),
                          );
                        },
                      );

                      if (delete) {
                        context.read<NewSettingsBloc>().add(
                              NewSettingsDeleteCustomHeader(
                                tautulliId: server.tautulliId,
                                key: header.key,
                              ),
                            );
                      }
                    },
                  ),
                  onTap: () {
                    final bool isBasicAuth = header.key == 'Authorization' &&
                        header.value.startsWith('Basic ');

                    if (isBasicAuth) {
                      try {
                        final List<String> creds = utf8
                            .decode(base64Decode(header.value.substring(6)))
                            .split(':');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return NewHeaderConfigDialog(
                              tautulliId: server.tautulliId,
                              basicAuth: true,
                              existingKey: creds[0],
                              existingValue: creds[1],
                            );
                          },
                        );
                      } catch (_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return NewHeaderConfigDialog(
                              tautulliId: server.tautulliId,
                              basicAuth: true,
                              existingKey: header.key,
                              existingValue: header.value,
                              currentHeaders: server.customHeaders,
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NewHeaderConfigDialog(
                            tautulliId: server.tautulliId,
                            basicAuth: false,
                            existingKey: header.key,
                            existingValue: header.value,
                            currentHeaders: server.customHeaders,
                          );
                        },
                      );
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
