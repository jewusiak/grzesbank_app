import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/LangTile.dart';
import 'package:grzesbank_app/util_views/ThemeTile.dart';
import 'package:grzesbank_app/utils/Constants.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/authd_views/AuthdPassChangeView.dart';
import 'package:grzesbank_app/widgets/authd_views/CcView.dart';
import 'package:grzesbank_app/widgets/authd_views/HistoryView.dart';
import 'package:grzesbank_app/widgets/authd_views/ProfileView.dart';
import 'package:grzesbank_app/widgets/authd_views/SendTransferView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/LoginView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/RegisterView.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends StatelessWidget {
  const DrawerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, value, child) {
        return value.isAuthenticated ? LoggedinDrawer() : LoggedoutDrawer();
      },
    );
  }
}

class LoggedinDrawer extends StatelessWidget {
  const LoggedinDrawer({super.key});

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
          LangTile(),
          ThemeTile()
        ],
      ),
    );
  }
}

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
          LangTile(),
          ThemeTile()
        ],
      ),
    );
  }
}
