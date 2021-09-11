import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_time_helper.dart';

class NewTimeLeft extends StatelessWidget {
  final int duration;
  final int progressPercent;

  const NewTimeLeft({
    Key? key,
    required this.duration,
    required this.progressPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Add translation
    return Text(
      '${NewTimeHelper.timeLeft(duration, progressPercent)} left',
    );
  }
}
