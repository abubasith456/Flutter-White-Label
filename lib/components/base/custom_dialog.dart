import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class DialogService {
  // Method to show success dialog
  void showSuccessDialog(BuildContext context, String? message) {
    showPlatformDialog(
      context: context,
      builder: (_) {
        return BasicDialogAlert(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              message ?? 'Operation was successful!',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10), // Add margin here
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to show error dialog
  void showErrorDialog(BuildContext context, String? message) {
    showPlatformDialog(
      context: context,
      builder: (_) {
        return BasicDialogAlert(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              message ?? 'An error occurred!',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10), // Add margin here
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to show warning dialog
  void showWarningDialog(BuildContext context, String? message) {
    showPlatformDialog(
      context: context,
      builder: (_) {
        return BasicDialogAlert(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 30),
              SizedBox(width: 10),
              Text(
                'Warning',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              message ?? 'An issue occurred!',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10), // Add margin here
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to show info dialog
  void showInfoDialog(BuildContext context, String message) {
    showPlatformDialog(
      context: context,
      builder: (_) {
        return BasicDialogAlert(
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue, size: 30),
              SizedBox(width: 10),
              Text(
                'Info',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              message,
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(10), // Add margin here
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
