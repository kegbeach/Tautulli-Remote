import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../bloc/new_settings_bloc.dart';
import 'connection_address_dialog.dart';
import 'connection_status_indicator.dart';

class ServerPrimaryConnectionTile extends StatelessWidget {
  final NewServerModel server;

  const ServerPrimaryConnectionTile(
    this.server, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState =
        context.read<NewSettingsBloc>().state as NewSettingsSuccess;

    return ListTile(
      title: const Text('Primary Connection Address'),
      subtitle: _subtitle(
        maskSensitiveInfo: settingsState.maskSensitiveInfo,
      ),
      trailing: ConnectionStatusIndicator(
        server.primaryActive
            ? ConnectionStatus.active
            : ConnectionStatus.passive,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ConnectionAddressDialog(
            primary: true,
            server: server,
          ),
        );
      },
      onLongPress: () {
        Clipboard.setData(
          ClipboardData(text: server.primaryConnectionAddress),
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

  Widget _subtitle({required bool maskSensitiveInfo}) {
    if (!maskSensitiveInfo) {
      return Text(server.primaryConnectionAddress);
    }
    return const Text('*Hidden Connection Address*');
  }
}
