import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../bloc/users_bloc.dart';

class UsersList extends StatelessWidget {
  final bool loading;
  final bool displayMessage;
  final List<UserModel> users;

  const UsersList({
    Key? key,
    required this.loading,
    this.displayMessage = true,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageBody(
      loading: loading,
      child: users.isEmpty && displayMessage
          ? const StatusPage(
              message: 'No users found.',
            )
          : ThemedRefreshIndicator(
              onRefresh: () {
                final settingsState =
                    context.read<SettingsBloc>().state as SettingsSuccess;

                context.read<UsersBloc>().add(
                      UsersFetch(
                        tautulliId:
                            settingsState.appSettings.activeServer.tautulliId,
                      ),
                    );

                return Future.value(null);
              },
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: users
                    .map(
                      (e) => Text(
                        e.friendlyName ?? e.username!,
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
