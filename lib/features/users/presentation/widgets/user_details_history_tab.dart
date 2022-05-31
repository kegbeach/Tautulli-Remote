import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../history/presentation/widgets/history_card.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';

class UserDetailsHistoryTab extends StatefulWidget {
  final UserModel user;

  const UserDetailsHistoryTab({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailsHistoryTab> createState() => _UserDetailsHistoryTabState();
}

class _UserDetailsHistoryTabState extends State<UserDetailsHistoryTab> {
  late ScrollController _scrollController;
  late IndividualHistoryBloc _individualHistoryBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();
    _individualHistoryBloc = context.read<IndividualHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = PrimaryScrollController.of(context)!;
    _scrollController.addListener(_onScroll);

    return BlocBuilder<IndividualHistoryBloc, IndividualHistoryState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            _individualHistoryBloc.add(
              IndividualHistoryFetched(
                tautulliId: _tautulliId,
                userId: widget.user.userId!,
                settingsBloc: _settingsBloc,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: PageBody(
            loading: state.status == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.status == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount:
                      state.hasReachedMax || state.status == BlocStatus.initial
                          ? state.history.length
                          : state.history.length + 1,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    if (index >= state.history.length) {
                      return BottomLoader(
                        status: state.status,
                        failure: state.failure,
                        message: state.message,
                        suggestion: state.suggestion,
                        onTap: () {
                          _individualHistoryBloc.add(
                            IndividualHistoryFetched(
                              tautulliId: _tautulliId,
                              userId: widget.user.userId!,
                              settingsBloc: _settingsBloc,
                            ),
                          );
                        },
                      );
                    }

                    final history = state.history[index];

                    return HistoryCard(
                      history: history,
                      showUser: false,
                      viewUserEnabled: false,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _individualHistoryBloc.add(
        IndividualHistoryFetched(
          tautulliId: _tautulliId,
          userId: widget.user.userId!,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
