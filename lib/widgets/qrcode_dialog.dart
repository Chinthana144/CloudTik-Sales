import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeDialog extends StatelessWidget{
  final String qrData;
  final String? title;

  const QrcodeDialog({
    required this.qrData,
    this.title
  });

@override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: title != null ? Text(title!) : Text('QR Code'),
      content: SizedBox(
        width: double.maxFinite,
        height: 250,
        child :  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Scan this QR code'),
            SizedBox(height: 16),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
        child: Text('Close'),
        )],
    );
  }
}//class