import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../bloc/new_settings_bloc.dart';

class ServerDeviceTokenTile extends StatelessWidget {
  final NewServerModel server;

  const ServerDeviceTokenTile(
    this.server, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState =
        context.read<NewSettingsBloc>().state as NewSettingsSuccess;

    return ListTile(
      title: const Text(
        'Device Token',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        settingsState.maskSensitiveInfo
            ? '*Hidden Device Token*'
            : server.deviceToken,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TautulliColorPalette.gunmetal,
            content: const Text('Device tokens cannot be edited'),
            action: SnackBarAction(
              label: 'LEARN MORE',
              onPressed: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#device_tokens',
                );
              },
              textColor: TautulliColorPalette.not_white,
            ),
          ),
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: server.deviceToken),
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: TautulliColorPalette.gunmetal,
            content: Text('Copied to clipboard'),
          ),
        );
      },
    );
  }
}
