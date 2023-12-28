import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/LangTile.dart';
import 'package:grzesbank_app/util_views/ThemeTile.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/authd_views/AuthdPassChangeView.dart';
import 'package:grzesbank_app/widgets/authd_views/CcView.dart';
import 'package:grzesbank_app/widgets/authd_views/HistoryView.dart';
import 'package:grzesbank_app/widgets/authd_views/ProfileView.dart';
import 'package:grzesbank_app/widgets/authd_views/SendTransferView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/BankLocationView.dart';
import 'package:provider/provider.dart';

class AuthdDrawer extends StatelessWidget {
  const AuthdDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 72,
                  ),
                  Text(
                      "${appState.userBasicData?.firstName ?? ""} ${appState.userBasicData?.surname ?? ""}"),
                  Text(
                    appState.userBasicData?.email ?? "",
                    style: TextStyle(fontSize: 12),
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
          ListTile(
              title: Text(Tprovider.get('drawer_history')),
              leading: Icon(Icons.history),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryView(),
                    ));
              }),
          ListTile(
              title: Text(Tprovider.get('drawer_send_trans')),
              leading: Icon(Icons.send),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendTransferView(),
                    ));
              }),
          ListTile(
              title: Text(Tprovider.get('drawer_cards')),
              leading: Icon(Icons.credit_card),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CcView(),
                    ));
              }),
          Divider(),
          ListTile(
              title: Text(Tprovider.get('drawer_profile')),
              leading: Icon(Icons.person),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileView(),
                    ));
              }),
          ListTile(
              title: Text(Tprovider.get('drawer_pass')),
              leading: Icon(Icons.password),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthdPassChangeView(),
                    ));
              }),
          Divider(),
          ListTile(
            title: Text(Tprovider.get('drawer_logout')),
            leading: Icon(Icons.logout),
            onTap: () async {
              try {
                await ApiService.instance.sendLogoutRequest();
              } finally {}
              Provider.of<AppState>(context, listen: false).setStatelogout();
            },
          ),
          Divider(),
          ListTile(
            title: Text(Tprovider.get('bank_locations_drawer')),
            leading: Icon(Icons.map),
            onTap: () async => await Navigator.push(
                context, MaterialPageRoute(builder: (_) => BankLocationView())),
          ),
          Divider(),
          LangTile(),
          ThemeTile()
        ],
      ),
    );
  }
}
