import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../bloc/new_settings_bloc.dart';
import '../bloc/registration_headers_bloc.dart';

class NewHeaderConfigDialog extends StatelessWidget {
  final String? tautulliId;
  final bool basicAuth;
  final bool registerDevice;
  final String? existingKey;
  final String? existingValue;
  final List<NewCustomHeaderModel> currentHeaders;

  const NewHeaderConfigDialog({
    Key? key,
    this.tautulliId,
    this.basicAuth = false,
    this.registerDevice = false,
    this.existingKey,
    this.existingValue,
    this.currentHeaders = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _keyController = TextEditingController();
    final _valueController = TextEditingController();
    List<NewCustomHeaderModel> headerValidationList = [];

    if (existingKey != null && existingValue != null) {
      _keyController.text = existingKey!;
      _valueController.text = existingValue!;
    }

    if (currentHeaders.isNotEmpty) {
      headerValidationList = [...currentHeaders];
      headerValidationList.removeWhere(
        (header) => header.key == existingKey,
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            basicAuth
                ? FontAwesomeIcons.solidAddressCard
                : FontAwesomeIcons.addressCard,
            color: TautulliColorPalette.not_white,
          ),
          const SizedBox(width: 8),
          Text(basicAuth ? 'Basic Authentication' : 'Custom'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _keyController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: basicAuth ? 'Username' : 'Header Key',
              ),
              validator: (value) {},
            ),
            TextFormField(
              controller: _valueController,
              obscureText: basicAuth,
              decoration: InputDecoration(
                labelText: basicAuth ? 'Password' : 'Header Value',
              ),
              validator: (value) {},
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            existingKey != null ? 'CLOSE' : 'CANCEL',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('SAVE'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (!registerDevice) {
                context.read<NewSettingsBloc>().add(
                      NewSettingsUpdateCustomHeaders(
                        tautulliId: tautulliId!,
                        key: _keyController.value.text.trim(),
                        value: _valueController.value.text.trim(),
                        basicAuth: basicAuth,
                        previousKey: existingKey,
                      ),
                    );
              } else {
                context.read<RegistrationHeadersBloc>().add(
                      RegistrationHeadersUpdate(
                        key: _keyController.value.text.trim(),
                        value: _valueController.value.text.trim(),
                        basicAuth: basicAuth,
                        previousKey: existingKey,
                      ),
                    );
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
