import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/widgets/new_list_header.dart';

class NewHelpPage extends StatelessWidget {
  const NewHelpPage({Key? key}) : super(key: key);

  static const routeName = '/new_help';

  @override
  Widget build(BuildContext context) {
    return const NewHelpView();
  }
}

class NewHelpView extends StatelessWidget {
  const NewHelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(
          children: [
            const NewListHeader(headingText: 'Help Topics'),
            ListTile(
              title: const Text('Secondary Connection Address'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#secondary_connection',
                );
              },
            ),
            ListTile(
              title: const Text('Using Basic Authentication'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#basic_authentication',
                );
              },
            ),
            ListTile(
              title: const Text('Terminating a Stream'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#terminating_stream',
                );
              },
            ),
            const SizedBox(height: 15),
            const NewListHeader(headingText: 'Support'),
            ListTile(
              title: const Text('Wiki'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                  'https://github.com/Tautulli/Tautulli-Remote/wiki',
                );
              },
            ),
            ListTile(
              title: const Text('Discord'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch('https://tautulli.com/discord.html');
              },
            ),
            ListTile(
              title: const Text('Reddit'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch('https://www.reddit.com/r/Tautulli/');
              },
            ),
            const SizedBox(height: 15),
            const NewListHeader(headingText: 'Bugs/Feature Requests'),
            ListTile(
              title: const Text('GitHub'),
              trailing: const FaIcon(
                FontAwesomeIcons.externalLinkAlt,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              onTap: () async {
                await launch(
                    'https://github.com/Tautulli/Tautulli-Remote/issues');
              },
            ),
            const SizedBox(height: 15),
            const NewListHeader(headingText: 'Logs'),
            ListTile(
              title: const Text('View Tautulli Remote logs'),
              trailing: const FaIcon(
                FontAwesomeIcons.angleRight,
                color: TautulliColorPalette.smoke,
                size: 20,
              ),
              //TODO: Link to new logs page
              onTap: () => Navigator.of(context).pushNamed('/logging'),
            ),
          ],
        ),
      ),
    );
  }
}
