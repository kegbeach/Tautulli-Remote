import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core_new/helpers/new_data_unit_helper.dart';

class NewBandwidthHeader extends StatelessWidget {
  final Map<String, int> bandwidthMap;

  const NewBandwidthHeader({
    Key? key,
    required this.bandwidthMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int wan = bandwidthMap["wan"]!;
    final int lan = bandwidthMap["lan"]!;

    final wanBandwidth = NewDataUnitHelper.bitrate(wan, fractionDigits: 1);
    final lanBandwidth = NewDataUnitHelper.bitrate(lan, fractionDigits: 1);
    final totalBandwidth =
        NewDataUnitHelper.bitrate(wan + lan, fractionDigits: 1);

    if (lan > 0 || wan > 0) {
      return Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.networkWired,
            color: Colors.grey,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$totalBandwidth (${lan > 0 ? "LAN: $lanBandwidth" : ""}${lan > 0 && wan > 0 ? ', ' : ''}${wan > 0 ? "WAN: $wanBandwidth" : ""})',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
