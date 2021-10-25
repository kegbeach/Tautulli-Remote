import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_health_bloc.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_privacy_bloc.dart';
import '../../../new_onesignal/presentation/bloc/new_onesignal_subscription_bloc.dart';
import '../widgets/new_permission_setting_dialog.dart';
import '../widgets/onesignal_data_privacy_text.dart';

class NewPrivacyPage extends StatelessWidget {
  final bool showConsentSwitch;

  const NewPrivacyPage({
    Key? key,
    this.showConsentSwitch = true,
  }) : super(key: key);

  static const routeName = '/new_privacy';

  @override
  Widget build(BuildContext context) {
    return PrivacyPageView(showConsentSwitch);
  }
}

class PrivacyPageView extends StatelessWidget {
  final bool showConsentSwitch;

  const PrivacyPageView(
    this.showConsentSwitch, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onesignalPrivacyBloc = context.read<NewOnesignalPrivacyBloc>();
    final onesignalSubscriptionBloc =
        context.read<NewOnesignalSubscriptionBloc>();
    final onesignalHealthBloc = context.read<NewOnesignalHealthBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('OneSignal Data Privacy'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: OnesignalDataPrivacyText(),
          ),
          if (showConsentSwitch)
            BlocBuilder<NewOnesignalPrivacyBloc, NewOnesignalPrivacyState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SwitchListTile(
                    title: const Text(
                      'Consent to OneSignal data privacy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TautulliColorPalette.not_white,
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: TautulliColorPalette.not_white,
                            ),
                          ),
                          if (state is NewOnesignalPrivacyFailure)
                            const TextSpan(
                              text: 'Not Accepted X',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.red,
                              ),
                            ),
                          if (state is NewOnesignalPrivacySuccess)
                            const TextSpan(
                              text: 'Accepted ✓',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                    value: state is NewOnesignalPrivacySuccess ? true : false,
                    onChanged: (_) async {
                      if (state is NewOnesignalPrivacyFailure) {
                        if (Platform.isIOS) {
                          if (await Permission.notification
                              .request()
                              .isGranted) {
                            onesignalPrivacyBloc.add(
                              NewOnesignalPrivacyGrant(),
                            );
                            await Future.delayed(const Duration(seconds: 2),
                                () {
                              onesignalSubscriptionBloc.add(
                                NewOnesignalSubscriptionCheck(),
                              );
                            });
                            onesignalHealthBloc.add(NewOnesignalHealthCheck());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const NewPermissionSettingDialog(
                                title: 'Notification Permission Disabled',
                                content:
                                    'The notification permission is required to receive notifications.',
                              ),
                            );
                          }
                        } else {
                          onesignalPrivacyBloc.add(NewOnesignalPrivacyGrant());
                          await Future.delayed(const Duration(seconds: 2), () {
                            onesignalSubscriptionBloc.add(
                              NewOnesignalSubscriptionCheck(),
                            );
                          });
                          onesignalHealthBloc.add(NewOnesignalHealthCheck());
                        }
                      }
                      if (state is NewOnesignalPrivacySuccess) {
                        onesignalPrivacyBloc.add(NewOnesignalPrivacyRevoke());
                        onesignalSubscriptionBloc.add(
                          NewOnesignalSubscriptionCheck(),
                        );
                        onesignalHealthBloc.add(NewOnesignalHealthCheck());
                      }
                    },
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
