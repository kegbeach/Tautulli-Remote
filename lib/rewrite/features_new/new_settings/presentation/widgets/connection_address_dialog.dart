import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../core_new/database/data/models/new_server_model.dart';
import '../bloc/new_settings_bloc.dart';

class ConnectionAddressDialog extends StatelessWidget {
  final bool primary;
  final NewServerModel server;

  const ConnectionAddressDialog({
    Key? key,
    required this.primary,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    if (primary) {
      controller.text = server.primaryConnectionAddress;
    }
    if (!primary && server.secondaryConnectionAddress != null) {
      controller.text = server.secondaryConnectionAddress!;
    }

    return AlertDialog(
      title: Text(
        primary ? 'Primary Connection Address' : 'Secondary Connection Address',
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: primary
                ? 'Input your primary connection address'
                : 'Input your secondary connection address',
          ),
          validator: (value) {
            bool validUrl = isURL(
              value,
              protocols: ['http', 'https'],
              requireProtocol: true,
            );
            if ((primary && validUrl == false) ||
                (!primary &&
                    isNotBlank(controller.text) &&
                    validUrl == false)) {
              return 'Please enter a valid URL format';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('SAVE'),
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              if (isEmpty(controller.text) && !server.primaryActive) {
                context.read<NewSettingsBloc>().add(
                      NewSettingsUpdatePrimaryActive(
                        primaryActive: true,
                        server: server,
                      ),
                    );
              }

              context.read<NewSettingsBloc>().add(
                    NewSettingsUpdateConnectionAddress(
                      primaryConnection: primary,
                      connectionAddress: controller.text,
                      server: server,
                    ),
                  );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
