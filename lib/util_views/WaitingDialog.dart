
import 'package:flutter/material.dart';

class WaitingDialog {
  static show(context) async {
    await showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(),),barrierDismissible: true);
  }
}