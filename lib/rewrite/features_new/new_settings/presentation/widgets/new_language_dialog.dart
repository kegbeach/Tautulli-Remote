import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/helpers/new_translation_helper.dart';
import '../../../new_translate/presentation/bloc/new_translate_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class NewLanguageDialog extends StatefulWidget {
  final Locale initialValue;

  const NewLanguageDialog({
    Key? key,
    required this.initialValue,
  }) : super(key: key);

  @override
  _NewLanguageDialogState createState() => _NewLanguageDialogState();
}

class _NewLanguageDialogState extends State<NewLanguageDialog> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Language'),
      children: NewTranslationHelper.supportedLocales()
          .map(
            (locale) => RadioListTile(
              title: Text(
                NewTranslationHelper.localeToString(locale),
              ),
              subtitle: locale.languageCode != 'en'
                  ? Text(
                      NewTranslationHelper.localeToEnglishString(locale),
                    )
                  : null,
              value: locale,
              groupValue: _locale,
              onChanged: (value) {
                setState(() {
                  _locale = value as Locale;
                  context.read<NewTranslateBloc>().add(
                        NewTranslateUpdate(locale),
                      );
                  context.setLocale(value);
                  Navigator.of(context).pop();
                });
              },
            ),
          )
          .toList(),
    );
  }
}
