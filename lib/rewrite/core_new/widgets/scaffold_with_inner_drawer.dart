import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features_new/new_activity/presentation/pages/new_activity_page.dart';
import '../../features_new/new_settings/presentation/pages/new_settings_page.dart';
import '../helpers/new_color_palette_helper.dart';

class ScaffoldWithInnerDrawer extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;

  const ScaffoldWithInnerDrawer({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> _innerDrawerKey =
        GlobalKey<InnerDrawerState>();
    final double screenAspect = MediaQuery.of(context).size.aspectRatio;

    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      swipeChild: true,
      offset: IDOffset.horizontal(
        screenAspect > 1.2 && screenAspect < 1.5
            ? -0.5
            : screenAspect > 1
                ? -0.2
                : screenAspect > 0.85
                    ? -0.1
                    : screenAspect > 0.70
                        ? -0.3
                        : screenAspect < 0.43
                            ? 0.6
                            : 0.4,
      ),
      leftChild: const _AppDrawer(),
      scaffold: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _innerDrawerKey.currentState?.open();
            },
          ),
          title: title,
          actions: actions,
        ),
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    return Drawer(
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const FaIcon(
                            FontAwesomeIcons.tv,
                            size: 20,
                            color: TautulliColorPalette.not_white,
                          ),
                          title: const Text('Activity'),
                          onTap: () {
                            if (route?.settings.name !=
                                    NewActivityPage.routeName &&
                                route?.settings.name != '/') {
                              Navigator.of(context).pushReplacementNamed(
                                  NewActivityPage.routeName);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.cogs,
                      size: 20,
                      color: TautulliColorPalette.not_white,
                    ),
                    title: const Text('Settings'),
                    onTap: () {
                      if (route?.settings.name != NewSettingsPage.routeName) {
                        Navigator.of(context)
                            .pushReplacementNamed(NewSettingsPage.routeName);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const Divider(
                    color: PlexColorPalette.raven,
                  ),
                  ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.star,
                      size: 20,
                      color: TautulliColorPalette.not_white,
                    ),
                    title: const Text('Old App'),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/activity');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.001,
            ),
          ],
        ),
      ),
    );
  }
}
