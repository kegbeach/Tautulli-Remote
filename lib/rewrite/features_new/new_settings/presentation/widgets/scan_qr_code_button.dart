import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQrCodeButton extends StatelessWidget {
  final TextEditingController primaryConnectionAddressController;
  final TextEditingController deviceTokenController;

  const ScanQrCodeButton({
    Key? key,
    required this.primaryConnectionAddressController,
    required this.deviceTokenController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: const Text('Scan QR Code'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
            ),
            onPressed: () async {
              //TODO: Create intermediate file
              final qrCodeScan = await FlutterBarcodeScanner.scanBarcode(
                '#e5a00d',
                'CANCEL',
                false,
                ScanMode.QR,
              );

              if (qrCodeScan != '-1') {
                try {
                  final List scanResults = qrCodeScan.split('|');

                  primaryConnectionAddressController.text =
                      scanResults[0].trim();
                  deviceTokenController.text = scanResults[1].trim();
                } catch (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: const Text(
                        'Error scanning QR code',
                      ),
                    ),
                  );
                }
              }
            },
          ),
        )
      ],
    );
  }
}
