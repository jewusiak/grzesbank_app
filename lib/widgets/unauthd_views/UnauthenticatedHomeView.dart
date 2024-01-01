import 'package:flutter/material.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';

class UnauthenticatedHomeView extends StatelessWidget {
  const UnauthenticatedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${Tprovider.get('welcome_to')} Grzesbank24",
        style: TextStyle(fontSize: 36),
      ),
    );
  }
}
