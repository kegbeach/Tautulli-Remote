import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../bloc/new_settings_bloc.dart';
import 'connection_address_dialog.dart';
import 'connection_status_indicator.dart';

class ServerSecondaryConnectionTile extends StatelessWidget {
  final NewServerModel server;

  const ServerSecondaryConnectionTile(
    this.server, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState =
        context.read<NewSettingsBloc>().state as NewSettingsSuccess;

    return ListTile(
      title: const Text('Secondary Connection Address'),
      subtitle: _subtitle(maskSensitiveInfo: settingsState.maskSensitiveInfo),
      trailing: ConnectionStatusIndicator(
        !server.primaryActive
            ? ConnectionStatus.active
            : isNotBlank(server.secondaryConnectionAddress)
                ? ConnectionStatus.passive
                : ConnectionStatus.disabled,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ConnectionAddressDialog(
            primary: false,
            server: server,
          ),
        );
      },
      onLongPress: () {
        if (isNotBlank(server.secondaryConnectionAddress)) {
          Clipboard.setData(
            ClipboardData(text: server.secondaryConnectionAddress),
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: TautulliColorPalette.gunmetal,
              content: Text('Copied to clipboard'),
            ),
          );
        }
      },
    );
  }

  Widget _subtitle({required bool maskSensitiveInfo}) {
    if (isBlank(server.secondaryConnectionAddress)) {
      return const Text('Not configured');
    }
    if (isNotBlank(server.secondaryConnectionAddress) && !maskSensitiveInfo) {
      return Text(server.secondaryConnectionAddress!);
    }
    return const Text('*Hidden Connection Address*');
  }
}
