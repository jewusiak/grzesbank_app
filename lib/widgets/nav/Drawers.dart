import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/utils/Constants.dart';
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
              title: Text("Historia"),
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
              title: Text("Wyślij przelew"),
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
              title: Text("Twoje karty"),
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
              title: Text("Profil"),
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
              title: Text("Zmień hasło"),
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
            title: Text("Wyloguj się"),
            leading: Icon(Icons.logout),
            onTap: () async {
              try {
                await ApiService.instance.sendLogoutRequest();
              } finally {}
              Provider.of<AppState>(context, listen: false).setStatelogout();
            },
          ),
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
                children: [Text("Zaloguj się"), Text("do Grzesbank24")],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
          ListTile(
            title: Text("Log in"),
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
            title: Text("Zarejestruj się"),
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
                  title: Text("Zaloguj się z Google"),
                  leading: Icon(Icons.g_mobiledata),
                  onTap: () async {
                    final result = await FlutterWebAuth2.authenticate(
                        url: Constants.apiOauthEndpoint,
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
                          "Nieudane logowanie OAuth2. Zweryfikuj czy posiadasz konto w banku.");
                    }
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
