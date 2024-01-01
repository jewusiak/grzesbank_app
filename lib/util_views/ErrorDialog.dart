import 'package:flutter/material.dart';

class ErrorDialog {
  static show(context, String message,
      {Future<dynamic> Function()? onOk}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert"),
        content: Text(message),
        icon: Icon(Icons.error_outline),
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
