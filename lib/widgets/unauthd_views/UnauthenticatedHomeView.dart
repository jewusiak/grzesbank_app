import 'package:flutter/material.dart';

class UnauthenticatedHomeView extends StatelessWidget {
  const UnauthenticatedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "--- UNAUTH ---",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
