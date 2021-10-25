import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tautulli_remote/rewrite/features_new/new_cache/presentation/bloc/new_cache_bloc.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/presentation/widgets/new_clear_cache_dialog.dart';
import 'package:tautulli_remote/rewrite/features_new/new_settings/presentation/widgets/new_language_dialog.dart';
import '../../../../../dependency_injection.dart' as di;

import '../../../../core_new/helpers/new_translation_helper.dart';
import '../../../../core_new/widgets/new_list_header.dart';
import '../../../../core_new/widgets/settings_not_loaded.dart';
import '../bloc/new_settings_bloc.dart';

class NewAdvancedSettingsPage extends StatelessWidget {
  const NewAdvancedSettingsPage({Key? key}) : super(key: key);

  static const routeName = '/new_advanced_settings';

  @override
  Widget build(BuildContext context) {
    return const AdvancedSettingsView();
  }
}

class AdvancedSettingsView extends StatelessWidget {
  const AdvancedSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
      ),
      body: BlocBuilder<NewSettingsBloc, NewSettingsState>(
        builder: (context, state) {
          if (state is NewSettingsSuccess) {
            return ListView(
              children: [
                const NewListHeader(
                  headingText: 'App Settings',
                  topPadding: 8,
                ),
                //* Double Tap to Exit
                if (Platform.isAndroid)
                  CheckboxListTile(
                    title: const Text('Double Tap To Exit'),
                    subtitle: const Text('Tap back twice to exit'),
                    value: state.doubleTapToExit,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<NewSettingsBloc>().add(
                              NewSettingsUpdateDoubleTapToExit(value),
                            );
                      }
                    },
                  ),
                //* Mask Sensitive Info
                CheckboxListTile(
                  title: const Text('Mask Sensitive Info'),
                  subtitle: const Text('Hides usernames and IP addresses'),
                  value: state.maskSensitiveInfo,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<NewSettingsBloc>().add(
                            NewSettingsUpdateMaskSensitiveInfo(value),
                          );
                    }
                  },
                ),
                //* Language
                ListTile(
                  title: const Text('Language'),
                  subtitle: Text(
                    NewTranslationHelper.localeToString(context.locale),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => NewLanguageDialog(
                        initialValue: context.locale,
                      ),
                    );
                  },
                ),
                const NewListHeader(
                  headingText: 'Operations',
                ),
                //* Clear Image Cache
                ListTile(
                  title: const Text('Clear Image Cache'),
                  subtitle: const Text('Delete cached posters and artwork'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                        create: (context) => di.sl<NewCacheBloc>(),
                        child: const NewClearCacheDialog(),
                      ),
                    );
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
