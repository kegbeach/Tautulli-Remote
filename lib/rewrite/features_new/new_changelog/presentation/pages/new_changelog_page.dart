import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/datasource/changelog_data_source.dart';
import '../widgets/new_changelog_item.dart';

class NewChangelogPage extends StatelessWidget {
  const NewChangelogPage({Key? key}) : super(key: key);

  static const routeName = '/new_changelog';

  @override
  Widget build(BuildContext context) {
    return const NewChangelogView();
  }
}

class NewChangelogView extends StatelessWidget {
  const NewChangelogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changelog'),
        actions: [
          TextButton.icon(
            onPressed: () {
              //TODO: Donate link
              // Navigator.of(context).pushNamed(DonatePage.routeName);
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
              size: 18,
            ),
            label: const Text('Donate'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: changelog['data'].map<Widget>(
              (release) {
                return NewChangelogItem(release);
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
