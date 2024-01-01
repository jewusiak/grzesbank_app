import 'package:flutter/material.dart';
import 'package:grzesbank_app/util_views/LangTile.dart';
import 'package:grzesbank_app/util_views/ThemeTile.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/unauthd_views/LoginView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/RegisterView.dart';

class LoggedoutDrawer extends StatelessWidget {
  const LoggedoutDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                children: [
                  Text(Tprovider.get('drawer_login')),
                  Text("${Tprovider.get('to')} Grzesbank24")
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
          ListTile(
            title: Text(Tprovider.get('drawer_login')),
            leading: Icon(Icons.login),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ));
            },
          ),
          ListTile(
            title: Text(Tprovider.get('drawer_register')),
            leading: Icon(Icons.edit),
            onTap: () async => await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterView(),
              ),
            ),
          ),
          Divider(),
          LangTile(),
          ThemeTile()
        ],
      ),
    );
  }
}
