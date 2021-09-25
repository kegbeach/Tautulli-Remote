import 'package:flutter/material.dart';

import '../../../../core_new/helpers/new_time_helper.dart';

class NewTimeTotal extends StatelessWidget {
  final int viewOffset;
  final int duration;

  const NewTimeTotal({
    Key? key,
    required this.viewOffset,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${NewTimeHelper.hourMinSec(Duration(milliseconds: viewOffset))}/${NewTimeHelper.hourMinSec(Duration(milliseconds: duration))}',
    );
  }
}
