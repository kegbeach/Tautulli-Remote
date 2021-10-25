import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../dependency_injection.dart' as di;
import '../../../../core_new/helpers/new_color_palette_helper.dart';
import '../../../../core_new/pages/status_page.dart';
import '../bloc/logging_export_bloc.dart';
import '../bloc/new_logging_bloc.dart';
import '../widgets/clear_logging_dialog.dart';
import '../widgets/new_logging_table.dart';

class NewLoggingPage extends StatelessWidget {
  const NewLoggingPage({Key? key}) : super(key: key);

  static const routeName = '/logging';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<NewLoggingBloc>()..add(NewLoggingLoad()),
        ),
        BlocProvider(
          create: (context) => di.sl<LoggingExportBloc>(),
        ),
      ],
      child: const LoggingView(),
    );
  }
}

class LoggingView extends StatefulWidget {
  const LoggingView({Key? key}) : super(key: key);

  @override
  State<LoggingView> createState() => _LoggingViewState();
}

class _LoggingViewState extends State<LoggingView> {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tautulli Remote Logs'),
        actions: _appbarActions(),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          context.read<NewLoggingBloc>().add(NewLoggingLoad());

          return _refreshCompleter.future;
        },
        child: BlocListener<LoggingExportBloc, LoggingExportState>(
          listener: (context, state) {
            if (state is LoggingExportSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: const Text('Logs exported'),
                  action: SnackBarAction(
                    label: 'HOW TO ACCESS LOGS',
                    onPressed: () async {
                      await launch(
                        'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#logs',
                      );
                    },
                    textColor: TautulliColorPalette.not_white,
                  ),
                ),
              );
            }
          },
          child: BlocConsumer<NewLoggingBloc, NewLoggingState>(
            listener: (context, state) {
              if (state is NewLoggingSuccess) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
              }
            },
            builder: (context, state) {
              if (state is NewLoggingFailure) {
                return const StatusPage(
                  scrollable: true,
                  message: 'Failed to load logs.',
                );
              }
              if (state is NewLoggingSuccess) {
                if (state.logs.isEmpty) {
                  return const StatusPage(
                    scrollable: true,
                    message: 'No logs found.',
                  );
                } else {
                  List<Log> filteredLogs = _filterLogs(
                    level: state.level,
                    logs: state.logs,
                  );

                  return NewLoggingTable(filteredLogs);
                }
              }
              return const SizedBox(height: 0, width: 0);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _appbarActions() {
    return [
      BlocBuilder<NewLoggingBloc, NewLoggingState>(
        builder: (context, state) {
          if (state is NewLoggingSuccess) {
            return PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.filter,
                color: state.level != LogLevel.ALL
                    ? Theme.of(context).accentColor
                    : TautulliColorPalette.not_white,
              ),
              onSelected: (LogLevel value) {
                context.read<NewLoggingBloc>().add(
                      NewLoggingSetLevel(value),
                    );
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: state.level == LogLevel.ALL
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: LogLevel.ALL,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Debug',
                      style: TextStyle(
                        color: state.level == LogLevel.DEBUG
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: LogLevel.DEBUG,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Info',
                      style: TextStyle(
                        color: state.level == LogLevel.INFO
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: LogLevel.INFO,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Warning',
                      style: TextStyle(
                        color: state.level == LogLevel.WARNING
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: LogLevel.WARNING,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Error',
                      style: TextStyle(
                        color: state.level == LogLevel.ERROR
                            ? Theme.of(context).accentColor
                            : TautulliColorPalette.not_white,
                      ),
                    ),
                    value: LogLevel.ERROR,
                  ),
                ];
              },
            );
          }
          return const IconButton(
            icon: FaIcon(
              FontAwesomeIcons.filter,
            ),
            onPressed: null,
          );
        },
      ),
      PopupMenuButton(
        onSelected: (value) async {
          final loggingBloc = context.read<NewLoggingBloc>();

          if (value == 'export') {
            if (await Permission.storage.request().isGranted) {
              context.read<LoggingExportBloc>().add(
                    LoggingExportStart(loggingBloc),
                  );
            }
          }
          if (value == 'clear') {
            showDialog(
              context: context,
              builder: (context) => ClearLoggingDialog(loggingBloc),
            );
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            child: Text('Export logs'),
            value: 'export',
          ),
          const PopupMenuItem(
            child: Text('Clear logs'),
            value: 'clear',
          ),
        ],
      ),
    ];
  }

  List<Log> _filterLogs({
    required LogLevel level,
    required List<Log> logs,
  }) {
    List<Log> filteredLogs = [];

    for (Log log in logs) {
      // Always display error, severe, or fatal
      if ([
        LogLevel.ERROR,
        LogLevel.SEVERE,
        LogLevel.FATAL,
      ].contains(log.logLevel)) {
        filteredLogs.add(log);
      }
      // If level is warning then also display warning log level
      else if (level == LogLevel.WARNING && log.logLevel == LogLevel.WARNING) {
        filteredLogs.add(log);
      }
      // If level is info then also display info and warning
      else if (level == LogLevel.INFO &&
          [
            LogLevel.INFO,
            LogLevel.WARNING,
          ].contains(log.logLevel)) {
        filteredLogs.add(log);
      }
      // If level is debug then also display debug, info, and warning
      else if (level == LogLevel.DEBUG &&
          [
            LogLevel.DEBUG,
            LogLevel.INFO,
            LogLevel.WARNING,
          ].contains(log.logLevel)) {
        filteredLogs.add(log);
      } else if (level == LogLevel.ALL) {
        filteredLogs.add(log);
      }
    }

    return filteredLogs;
  }
}
