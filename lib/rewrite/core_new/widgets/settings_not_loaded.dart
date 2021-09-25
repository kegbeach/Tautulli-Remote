import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features_new/new_settings/presentation/bloc/new_settings_bloc.dart';
import '../pages/status_page.dart';

class SettingsNotLoaded extends StatelessWidget {
  const SettingsNotLoaded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSettingsBloc, NewSettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: _buildSettingsNotLoadedBody(state),
        );
      },
    );
  }
}

//TODO: Clean up these settings widgets
Widget _buildSettingsNotLoadedBody(NewSettingsState state) {
  if (state is NewSettingsInProgress) {
    return const StatusPage(
      message: 'Settings are loading.',
      action: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
  if (state is NewSettingsFailure) {
    return StatusPage(
      message: 'Settings failed to load.',
      action: ElevatedButton(
        onPressed: () {
          //TODO: Link to support page.
        },
        child: const Text('CONTACT SUPPORT'),
      ),
    );
  }
  return StatusPage(
    message: 'Unknown error with settings.',
    action: ElevatedButton(
      onPressed: () {
        //TODO: Link to support page.
      },
      child: const Text('CONTACT SUPPORT'),
    ),
  );
}
