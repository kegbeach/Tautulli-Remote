import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../widgets/translate_heading.dart';

class NewTranslatePage extends StatelessWidget {
  const NewTranslatePage({Key? key}) : super(key: key);

  static const routeName = '/new_translate';

  @override
  Widget build(BuildContext context) {
    return const TranslatePageView();
  }
}

class TranslatePageView extends StatelessWidget {
  const TranslatePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Translate'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TranslateHeading(),
            ListTile(
              title: const Text('Translate Tautulli Remote'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://hosted.weblate.org/engage/tautulli-remote/',
                );
              },
            ),
            ListTile(
              title: const Text('Request a new language'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/issues/new/choose',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
