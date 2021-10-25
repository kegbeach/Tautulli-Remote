import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/new_registration_bloc.dart';
import '../bloc/new_settings_bloc.dart';

class NewCertificateFailureDialog extends StatelessWidget {
  const NewCertificateFailureDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationBloc = context.read<NewRegistrationBloc>();

    return AlertDialog(
      title: const Text('Certificate Verification Failed'),
      content: const Text(
        'This servers certificate could not be authenticated and may be self-signed. Do you want to trust this certificate?',
      ),
      actions: [
        TextButton(
          child: const Text('NO'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('TRUST'),
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).accentColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            registrationBloc.add(
              NewRegistrationUnverifiedCert(
                context.read<NewSettingsBloc>(),
              ),
            );
          },
        ),
      ],
    );
  }
}
