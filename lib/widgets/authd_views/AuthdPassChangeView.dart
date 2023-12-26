import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class AuthdPassChangeView extends StatefulWidget {
  const AuthdPassChangeView({super.key});

  @override
  State<AuthdPassChangeView> createState() => _AuthdPassChangeViewState();
}

class _AuthdPassChangeViewState extends State<AuthdPassChangeView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _pass1 = TextEditingController(); 
    final _pass2 = TextEditingController(); 

    return AppScaffold(
      title: Text("Wyślij przelew"),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Zmiana hasła",
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Nowe hasło"),
                    obscureText: true,
                    validator: (value) => RegexMatchers.matchPassword(
                        value,
                        "Pole wypełnione niepoprawnie",
                        "Hasło musi mieć min. 8 znaków",
                        8,
                        "Pole nie może być puste"),
                    controller: _pass1,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Potwierdź nowe hasło"),
                    obscureText: true,
                    validator: (value) {
                      if (value != _pass1.text)
                        return "Hasła musza być takie same";
                      return null;
                    },
                    controller: _pass2,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      WaitingDialog.show(context);
                     var res = await ApiService.instance.changePassword(_pass1.text);
                      Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                      if(res) {
                       SuccessDialog.show(NavigationContext.mainNavKey.currentContext!, "Hasło zmienione poprawnie!", onOk: () async {
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                       });
                     }else {
                       ErrorDialog.show(NavigationContext.mainNavKey.currentContext!, "Hasła nie udało się zmienić. Skontaktuj się z bankiem.", onOk: () async {
                         Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                       });
                     }
                    },
                    child: Text("Zmień hasło"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
