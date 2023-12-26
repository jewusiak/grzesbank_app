import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/PasswordCombinationResponse.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailInputController = TextEditingController();
  LoginState loginState = LoginState.AWAITING_EMAIL;
  PasswordCombinationResponse? passwordCombinationResponse;
  List<TextEditingController> passwordControllers = genTecs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Logowanie do Grzesbank24"),
      ),
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailInputController,
                onFieldSubmitted: (value) async => await loginButtonPressed(),
                decoration: InputDecoration(hintText: "Twój email"),
                enabled: loginState == LoginState.AWAITING_EMAIL,
              ),
              SizedBox(
                height: 20,
              ),
              (loginState != LoginState.AWAITING_EMAIL
                  ? Text("Podaj odpowiednie znaki hasła:")
                  : Container()),
              SizedBox(
                height: loginState != LoginState.AWAITING_EMAIL ? 12 : 0,
              ),
              Wrap(children: generatePasswordBoxes()),
              SizedBox(
                height: loginState != LoginState.AWAITING_EMAIL ? 20 : 0,
              ),
              ElevatedButton(
                  onPressed: () async => await loginButtonPressed(),
                  child: Text("Zaloguj się")),
            ],
          ),
        ),
      ),
    );
  }

  Future loginButtonPressed() async {
    WaitingDialog.show(context);
    if (loginState == LoginState.AWAITING_EMAIL) {
      passwordCombinationResponse = await ApiService.instance
          .requestPasswordCombinations(emailInputController.text);
      setState(() {
        loginState = LoginState.AWAITING_PASS;
      });
      Navigator.pop(context);
      FocusScope.of(NavigationContext.mainNavKey.currentContext!).nextFocus();
    } else if (loginState == LoginState.AWAITING_PASS) {
      setState(() {
        loginState = LoginState.AWAITING_RESPONSE;
      });
      var password = passwordControllers.fold(
          "", (previousValue, element) => previousValue + element.text);
      var result = await ApiService.instance.authenticate(
          passwordCombinationResponse!.pcid!,
          emailInputController.text,
          password);
      Navigator.pop(context);
      print(result);
      if(result != null) {
        Provider.of<AppState>(context, listen: false).setStateLogin(result);
        Navigator.pop(context);
      } else {
        setState(() {
          loginState = LoginState.AWAITING_EMAIL;
          passwordControllers = genTecs();
          emailInputController.clear();
        });
        ErrorDialog.show(context, "Nieprawidłowe dane logowania. Spróbuj ponownie. Po kilku nieudanych próbach, konto może zostać zablokowane.");
      }
    }
  }

  List<Widget> generatePasswordBoxes() {
    if (loginState == LoginState.AWAITING_EMAIL ||
        passwordCombinationResponse == null) return [];
    var indices = passwordCombinationResponse!.indices!;
    var widgets = <Widget>[];
    int tecId = 0;
    for (int i = 0; i <= indices.last; i++) {
      widgets.add(SizedBox(
        width: 30,
        child: TextFormField(
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          decoration: InputDecoration(
              hintText: (i + 1).toString(),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(5, 0, 2, 0)),
          enabled: indices.contains(i),
          controller: indices.contains(i) ? passwordControllers[tecId++] : null,
          obscureText: true,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else
              FocusScope.of(context).previousFocus();
          },
        ),
      ));
    }
    return widgets;
  }

  static List<TextEditingController> genTecs() {
    return [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];
  }
}

enum LoginState { AWAITING_EMAIL, AWAITING_PASS, AWAITING_RESPONSE }
