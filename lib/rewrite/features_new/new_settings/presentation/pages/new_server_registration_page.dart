import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

import '../../../../../dependency_injection.dart' as di;
import '../../../../core_new/database/data/models/new_custom_header_model.dart';
import '../../../../core_new/error/new_failure.dart';
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/widgets/page_padding.dart';
import '../bloc/new_registration_bloc.dart';
import '../bloc/new_settings_bloc.dart';
import '../bloc/registration_headers_bloc.dart';
import '../widgets/new_certificate_failure_dialog.dart';
import '../widgets/new_header_type_dialog.dart';
import '../widgets/registration_exit_dialog.dart';
import '../widgets/registration_failure_dialog.dart';
import '../widgets/registration_help.dart';
import '../widgets/scan_qr_code_button.dart';

class NewServerRegistrationPage extends StatelessWidget {
  const NewServerRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<NewRegistrationBloc>(),
      child: const ServerRegistrationView(),
    );
  }
}

class ServerRegistrationView extends StatefulWidget {
  const ServerRegistrationView({Key? key}) : super(key: key);

  @override
  State<ServerRegistrationView> createState() => _ServerRegistrationViewState();
}

class _ServerRegistrationViewState extends State<ServerRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _primaryConnectionAddressController =
      TextEditingController();
  final TextEditingController _secondaryConnectionAddressController =
      TextEditingController();
  final TextEditingController _deviceTokenController = TextEditingController();
  List<NewCustomHeaderModel> headerList = [];

  @override
  Widget build(BuildContext context) {
    final registrationBloc = context.read<NewRegistrationBloc>();

    return WillPopScope(
      onWillPop: () async => await showDialog(
        context: context,
        builder: (context) => const RegistrationExitDialog(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register a Tautulli Server'),
        ),
        body: BlocListener<NewRegistrationBloc, NewRegistrationState>(
          listener: (context, state) {
            if (state is NewRegistrationSuccess) {
              Navigator.of(context).pop(true);
            }
            if (state is NewRegistrationFailure) {
              if (state.failure == CertificateVerificationFailure()) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const NewCertificateFailureDialog();
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RegistrationFailureDialog(state.failure);
                  },
                );
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<NewRegistrationBloc, NewRegistrationState>(
                  builder: (context, state) {
                    if (state is NewRegistrationInProgress) {
                      return SizedBox(
                        height: 2,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).accentColor,
                        ),
                      );
                    }
                    return const SizedBox(height: 2, width: 2);
                  },
                ),
                PagePadding(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RegistrationHelp(),
                      const Divider(
                        indent: 2,
                        endIndent: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: 8,
                          right: 8,
                        ),
                        child: ScanQrCodeButton(
                          primaryConnectionAddressController:
                              _primaryConnectionAddressController,
                          deviceTokenController: _deviceTokenController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _primaryConnectionAddressController,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Primary Connection Address',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  bool validUrl = isURL(
                                    value,
                                    protocols: ['http', 'https'],
                                    requireProtocol: true,
                                  );
                                  if (!validUrl) {
                                    return 'Please enter a valid URL format';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller:
                                    _secondaryConnectionAddressController,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Secondary Connection Address',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  bool validUrl = isURL(
                                    value,
                                    protocols: ['http', 'https'],
                                    requireProtocol: true,
                                  );
                                  if (value != '' && !validUrl) {
                                    return 'Please enter a valid URL format';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _deviceTokenController,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Device Token',
                                  labelStyle: TextStyle(
                                    color: TautulliColorPalette.not_white,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: TautulliColorPalette.not_white,
                                ),
                                validator: (value) {
                                  if (value != null && value.length != 32) {
                                    return 'Must be 32 characters long (current: ${value.length.toString()})';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 4),
                              BlocConsumer<RegistrationHeadersBloc,
                                  RegistrationHeadersState>(
                                listener: (context, state) {
                                  if (state is RegistrationHeadersLoaded) {
                                    setState(() {
                                      headerList = state.headers;
                                    });
                                  }
                                },
                                builder: (context, state) {
                                  final List<NewCustomHeaderModel> headers =
                                      state is RegistrationHeadersLoaded &&
                                              state.headers.isNotEmpty
                                          ? state.headers
                                          : [];

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: headers
                                        .map(
                                          (header) => ListTile(
                                            title: Text(header.key),
                                            subtitle: Text(header.value),
                                            trailing: GestureDetector(
                                              child: const FaIcon(
                                                FontAwesomeIcons.trashAlt,
                                                color: TautulliColorPalette
                                                    .not_white,
                                              ),
                                              onTap: () {
                                                context
                                                    .read<
                                                        RegistrationHeadersBloc>()
                                                    .add(
                                                      RegistrationHeadersDelete(
                                                        header.key,
                                                      ),
                                                    );
                                              },
                                            ),
                                            onTap: () {},
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: const Text('ADD HEADER'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NewHeaderTypeDialog(
                                            registerDevice: true,
                                            currentHeaders: headerList,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        child: const Text('CANCEL'),
                                        onPressed: () async {
                                          final exit = await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return const RegistrationExitDialog();
                                            },
                                          );

                                          if (exit) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('REGISTER'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            registrationBloc.add(
                                              NewRegistrationStarted(
                                                primaryConnectionAddress:
                                                    _primaryConnectionAddressController
                                                        .text,
                                                secondaryConnectionAddress:
                                                    _secondaryConnectionAddressController
                                                        .text,
                                                deviceToken:
                                                    _deviceTokenController.text,
                                                headers: headerList,
                                                settingsBloc: context
                                                    .read<NewSettingsBloc>(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
