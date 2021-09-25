import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_time_helper.dart';

class NewTimeEta extends StatelessWidget {
  final int duration;
  final int progressPercent;
  final String? timeFormat;

  const NewTimeEta({
    Key? key,
    required this.duration,
    required this.progressPercent,
    this.timeFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      NewTimeHelper.eta(duration, progressPercent, timeFormat),
    );
  }
}
