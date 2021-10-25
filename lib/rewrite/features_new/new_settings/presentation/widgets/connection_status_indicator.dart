import 'package:flutter/material.dart';

enum ConnectionStatus {
  active,
  passive,
  disabled,
}

class ConnectionStatusIndicator extends StatelessWidget {
  final ConnectionStatus connectionStatus;

  const ConnectionStatusIndicator(
    this.connectionStatus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusText = connectionStatus == ConnectionStatus.active
        ? 'Active'
        : connectionStatus == ConnectionStatus.passive
            ? 'Passive'
            : 'Disabled';
    final color = connectionStatus == ConnectionStatus.active
        ? Theme.of(context).accentColor
        : Colors.grey[700]!;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: color,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: color,
        ),
      ),
    );
  }
}
