import 'package:flutter/material.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/widgets/authd_views/AuthdDrawer.dart';
import 'package:grzesbank_app/widgets/authd_views/UnauthdDrawer.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends StatelessWidget {
  const DrawerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, value, child) {
        return value.isAuthenticated ? AuthdDrawer() : LoggedoutDrawer();
      },
    );
  }
}
