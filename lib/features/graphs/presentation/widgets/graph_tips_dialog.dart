import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../translations/locale_keys.g.dart';

class GraphTipsDialog extends StatelessWidget {
  const GraphTipsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LocaleKeys.tips_title).tr(),
      content: const Text(LocaleKeys.graphs_tips_dialog_content).tr(),
      actions: [
        TextButton(
          child: const Text(LocaleKeys.close_button).tr(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
