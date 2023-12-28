

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/LangTile.dart';
import 'package:grzesbank_app/util_views/ThemeTile.dart';
import 'package:grzesbank_app/utils/Constants.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/unauthd_views/BankLocationView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/LoginView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/RegisterView.dart';
import 'package:provider/provider.dart';

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
          kIsWeb
              ? ListTile(
            title: Text(Tprovider.get('drawer_google')),
            leading: Icon(Icons.g_mobiledata),
            onTap: () async {
              final result = await FlutterWebAuth2.authenticate(
                  url: Uri(
                      host: Constants.apiHost,
                      port: Constants.apiPort,
                      path: Constants.apiOauthEndpoint,
                      scheme: Constants.apiProtocol)
                      .toString(),
                  //todo: http here!
                  callbackUrlScheme: "gb24");
              try {
                if (Uri.parse(result).queryParameters['result'] !=
                    "true") {
                  throw Error();
                }
                var user = await ApiService.instance.getUserBasicData();
                Provider.of<AppState>(
                    NavigationContext.mainNavKey.currentContext!,
                    listen: false)
                    .setStateLogin(user!);
              } catch (e) {
                ErrorDialog.show(
                    NavigationContext.mainNavKey.currentContext!,
                    Tprovider.get('oauth_err'));
              }
            },
          )
              : Container(),
          Divider(),
          ListTile(
            title: Text(Tprovider.get('bank_locations_drawer')),
            leading: Icon(Icons.map),
            onTap: () async => await Navigator.push(context, MaterialPageRoute(builder: (_) => BankLocationView())),
          ),
          Divider(),
          LangTile(),
          ThemeTile()
        ],
      ),
    );
  }
}
