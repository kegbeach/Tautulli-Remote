import 'package:flutter/material.dart';

import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_failure_helper.dart';
import '../../../new_help/presentation/pages/new_help_page.dart';

class RegistrationFailureDialog extends StatelessWidget {
  final NewFailure failure;
  final bool showHelp;

  const RegistrationFailureDialog(
    this.failure, {
    Key? key,
    this.showHelp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(NewFailureHelper.mapFailureToMessage(failure)),
      content: Text(NewFailureHelper.mapFailureToSuggestion(failure)),
      actions: [
        if (showHelp)
          TextButton(
            child: const Text('HELP'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const NewHelpPage(),
                ),
              );
            },
          ),
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
