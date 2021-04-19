import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'plays_by_day_of_week_graph.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/graph_state.dart';
import '../bloc/play_graphs_bloc.dart';
import 'graph_error_message.dart';
import 'graph_heading.dart';
import 'plays_by_date_graph.dart';

class PlaysByPeriodTab extends StatefulWidget {
  final String tautulliId;
  final int timeRange;
  final String yAxis;

  PlaysByPeriodTab({
    Key key,
    @required this.tautulliId,
    @required this.timeRange,
    @required this.yAxis,
  }) : super(key: key);

  @override
  _PlaysByPeriodTabState createState() => _PlaysByPeriodTabState();
}

class _PlaysByPeriodTabState extends State<PlaysByPeriodTab> {
  Completer<void> _refreshCompleter;
  SettingsBloc _settingsBloc;
  PlayGraphsBloc _playGraphsBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _settingsBloc = context.read<SettingsBloc>();
    _playGraphsBloc = context.read<PlayGraphsBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      _playGraphsBloc.add(
        PlayGraphsFetch(
          tautulliId: widget.tautulliId,
          timeRange: widget.timeRange,
          yAxis: widget.yAxis,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayGraphsBloc, PlayGraphsState>(
      listener: (context, state) {
        if (state is PlayGraphsLoaded) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () {
            _playGraphsBloc.add(
              PlayGraphsFetch(
                tautulliId: widget.tautulliId,
                timeRange: widget.timeRange,
                yAxis: widget.yAxis,
                settingsBloc: _settingsBloc,
              ),
            );
            return _refreshCompleter.future;
          },
          child: Scrollbar(
            child: ListView(
              children: [
                GraphHeading(
                  graphHeading:
                      'Daily Play ${widget.yAxis == 'plays' ? 'Count' : 'Duration'}',
                ),
                (state is PlayGraphsLoaded &&
                        state.playsByDate.graphCurrentState !=
                            GraphCurrentState.failure &&
                        state.playsByDate.graphData != null &&
                        widget.yAxis == state.playsByDate.yAxis)
                    ? PlaysByDateGraph(
                        playsByDate: state.playsByDate,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 275,
                            color: TautulliColorPalette.gunmetal,
                            child: Center(
                              child: state is PlayGraphsLoaded &&
                                      state.playsByDate.graphCurrentState ==
                                          GraphCurrentState.failure
                                  ? GraphErrorMessage(
                                      message: state.playsByDate.failureMessage,
                                      suggestion:
                                          state.playsByDate.failureSuggestion,
                                    )
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 8),
                GraphHeading(
                  graphHeading:
                      'Play ${widget.yAxis == 'plays' ? 'Count' : 'Duration'} By Day Of The Week',
                ),
                (state is PlayGraphsLoaded &&
                        state.playsByDate.graphCurrentState !=
                            GraphCurrentState.failure &&
                        state.playsByDate.graphData != null &&
                        widget.yAxis == state.playsByDate.yAxis)
                    ? PlaysByDayOfWeekGraph(
                        playsByDayOfWeek: state.playsByDayOfWeek,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 275,
                            color: TautulliColorPalette.gunmetal,
                            child: Center(
                              child: state is PlayGraphsLoaded &&
                                      state.playsByDate.graphCurrentState ==
                                          GraphCurrentState.failure
                                  ? GraphErrorMessage(
                                      message: state.playsByDate.failureMessage,
                                      suggestion:
                                          state.playsByDate.failureSuggestion,
                                    )
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
