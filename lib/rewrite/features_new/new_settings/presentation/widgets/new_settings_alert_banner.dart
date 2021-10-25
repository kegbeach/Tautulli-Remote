import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_health_bloc.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_privacy_bloc.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_subscription_bloc.dart';
import '../bloc/new_settings_bloc.dart';

class NewSettingsAlertBanner extends StatelessWidget {
  const NewSettingsAlertBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final privacyBloc = context.read<NewOnesignalPrivacyBloc>();
    final settingsBloc = context.read<NewSettingsBloc>();

    return BlocBuilder<NewSettingsBloc, NewSettingsState>(
      builder: (context, settingsState) {
        // Only display banner if SettingsSuccess and banner has not been dismissed
        if (settingsState is NewSettingsSuccess &&
            !settingsState.oneSignalBannerDismissed) {
          return BlocBuilder<NewOnesignalHealthBloc, NewOnesignalHealthState>(
            builder: (context, healthState) {
              return BlocBuilder<NewOnesignalSubscriptionBloc,
                  NewOnesignalSubscriptionState>(
                builder: (context, subscriptionState) {
                  // Display alert banner about consenting to privacy policy
                  if (privacyBloc.state is NewOnesignalPrivacyFailure &&
                      subscriptionState is NewOnesignalSubscriptionFailure) {
                    return _AlertBanner(
                      backgroundColor: Colors.deepOrange[900],
                      title: subscriptionState.title,
                      message: Text(subscriptionState.message),
                      buttonOne: TextButton(
                        child: const Text('DISMISS'),
                        onPressed: () => settingsBloc.add(
                          const NewSettingsUpdateOnesignalBannerDismiss(true),
                        ),
                      ),
                      buttonTwo: TextButton(
                        child: const Text('VIEW PRIVACY PAGE'),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/new_privacy'),
                      ),
                    );
                  }
                  // Display alert banner about failure to connect to onesignal.com
                  if (privacyBloc.state is NewOnesignalPrivacySuccess &&
                      healthState is NewOnesignalHealthFailure) {
                    return _AlertBanner(
                      title: 'Unable to reach OneSignal',
                      message: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('• Notifications will not work.'),
                          Text('• Registration with OneSignal will fail.'),
                        ],
                      ),
                      buttonOne: TextButton(
                        child: const Text('CHECK AGAIN'),
                        onPressed: () =>
                            context.read<NewOnesignalHealthBloc>().add(
                                  NewOnesignalHealthCheck(),
                                ),
                      ),
                    );
                  }
                  // Display alert banner about waiting to subscribe to OneSignal
                  if (privacyBloc.state is NewOnesignalPrivacySuccess &&
                      subscriptionState is NewOnesignalSubscriptionFailure) {
                    return _AlertBanner(
                      backgroundColor: Colors.deepOrange[900],
                      title: subscriptionState.title,
                      message: Text(subscriptionState.message),
                      buttonOne: TextButton(
                        child: const Text('LEARN MORE'),
                        onPressed: () async {
                          await launch(
                            'https://github.com/Tautulli/Tautulli-Remote/wiki/OneSignal#registering',
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox(height: 0, width: 0);
                },
              );
            },
          );
        }
        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final Color? backgroundColor;
  final String title;
  final Widget? message;
  final TextButton? buttonOne;
  final TextButton? buttonTwo;

  const _AlertBanner({
    Key? key,
    this.backgroundColor,
    required this.title,
    this.message,
    this.buttonOne,
    this.buttonTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: backgroundColor ?? Colors.red[900],
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      forceActionsBelow: true,
      leading: const FaIcon(
        FontAwesomeIcons.exclamationCircle,
        color: TautulliColorPalette.not_white,
        size: 30,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (message != null) message!,
        ],
      ),
      actions: [
        if (buttonOne != null) buttonOne!,
        if (buttonTwo != null) buttonTwo!,
      ],
    );
  }
}
