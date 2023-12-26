import 'package:flutter/material.dart';

class SuccessDialog {
  static show(context, String message, {Future<dynamic> Function()? onOk}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        icon: Icon(Icons.check),
        actions: [
          TextButton(
            onPressed: onOk ?? () => Navigator.pop(context),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}
