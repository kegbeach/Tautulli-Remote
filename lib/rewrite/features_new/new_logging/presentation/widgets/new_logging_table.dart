import 'package:f_logs/model/flog/log.dart';
import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_color_palette_helper.dart';
import 'new_logging_table_headers.dart';
import 'new_logging_table_row.dart';

class NewLoggingTable extends StatelessWidget {
  final List<Log> logs;

  const NewLoggingTable(
    this.logs, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NewLoggingTableHeaders(),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return NewLoggingTableRow(
                  logs[index],
                  backgroundColor: (index % 2 == 0)
                      ? TautulliColorPalette.gunmetal
                      : Colors.transparent,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
