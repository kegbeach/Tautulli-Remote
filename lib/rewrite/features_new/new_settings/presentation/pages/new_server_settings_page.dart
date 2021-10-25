import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/rewrite/core_new/database/data/models/new_custom_header_model.dart';
import 'package:tautulli_remote/rewrite/core_new/helpers/new_color_palette_helper.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/presentation/widgets/new_delete_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core_new/widgets/settings_not_loaded.dart';
import '../bloc/new_settings_bloc.dart';
import '../widgets/add_custom_header_button.dart';
import '../widgets/custom_headers_list.dart';
import '../widgets/server_device_token_tile.dart';
import '../widgets/server_primary_connection_tile.dart';
import '../widgets/server_secondary_connection_tile.dart';

class NewServerSettingsPage extends StatelessWidget {
  final String plexName;
  final int serverId;

  const NewServerSettingsPage({
    Key? key,
    required this.plexName,
    required this.serverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewServerSettingsView(
      plexName: plexName,
      serverId: serverId,
    );
  }
}

class NewServerSettingsView extends StatelessWidget {
  final String plexName;
  final int serverId;

  const NewServerSettingsView({
    Key? key,
    required this.plexName,
    required this.serverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plexName),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trashAlt,
              color: TautulliColorPalette.not_white,
            ),
            onPressed: () async {
              final delete = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return NewDeleteDialog(
                    title: Text(
                      'Are you sure you want to remove $plexName?',
                    ),
                  );
                },
              );

              if (delete) {
                context.read<NewSettingsBloc>().add(
                      NewSettingsDeleteServer(
                        id: serverId,
                        plexName: plexName,
                      ),
                    );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<NewSettingsBloc, NewSettingsState>(
        builder: (context, state) {
          if (state is NewSettingsSuccess) {
            final server = state.serverList.firstWhere(
              (serverModel) => serverModel.id == serverId,
            );

            return ListView(
              children: [
                ServerPrimaryConnectionTile(server),
                ServerSecondaryConnectionTile(server),
                ServerDeviceTokenTile(server),
                if (server.customHeaders.isNotEmpty)
                  CustomHeadersList(
                    server: server,
                    maskSensitiveInfo: state.maskSensitiveInfo,
                  ),
                AddCustomHeaderButton(
                  paddingTop: state.serverList.isEmpty ? 8 : 0,
                  server: server,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  title: Text('Open $plexName in browser'),
                  trailing: const FaIcon(
                    FontAwesomeIcons.externalLinkAlt,
                    color: TautulliColorPalette.not_white,
                    size: 20,
                  ),
                  onTap: () async {
                    final Map<String, String> headers = {};

                    for (NewCustomHeaderModel header in server.customHeaders) {
                      headers[header.key] = header.value;
                    }

                    if (server.primaryActive) {
                      await launch(
                        server.primaryConnectionAddress,
                        headers: headers,
                      );
                    } else {
                      if (server.secondaryConnectionAddress != null) {
                        await launch(
                          server.secondaryConnectionAddress!,
                          headers: headers,
                        );
                      }
                    }
                  },
                ),
              ],
            );
          }
          return const SettingsNotLoaded();
        },
      ),
    );
  }
}
