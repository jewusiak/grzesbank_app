import 'package:flutter/material.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';

class SuccessDialog {
  static show(context, String message, {Future<dynamic> Function()? onOk}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Tprovider.get('success')),
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
