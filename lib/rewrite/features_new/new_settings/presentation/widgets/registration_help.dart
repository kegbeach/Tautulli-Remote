import 'package:flutter/material.dart';

class RegistrationHelp extends StatelessWidget {
  const RegistrationHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 8,
        right: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Use the button below to scan your QR code and auto-fill your server information or enter it manually instead.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Optionally, you can add a Secondary Connection Address. If the Primary Connection Address is unreachable, the app will automatically use the secondary address.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
