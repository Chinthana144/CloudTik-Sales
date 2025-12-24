import 'package:flutter/material.dart';

class StatusDialog extends StatelessWidget {
  final bool success; // true = success, false = failure
  final String message;

  const StatusDialog({
    super.key,
    required this.success,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Success or ❌ Failed GIF
            Image.asset(
              success
                  ? 'assets/gifs/success.gif' //success GIF path
                  : 'assets/gifs/failed.gif',    //failure GIF path
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 16),

            // Message text
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: success ? Colors.green[800] : Colors.red[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Close button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: success ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
