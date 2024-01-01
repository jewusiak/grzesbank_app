import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/PasswordCombinationResponse.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/unauthd_views/ResetPassRequestView.dart';
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
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            "${Tprovider.get('drawer_login')} ${Tprovider.get('to')} Grzesbank24"),
      ),
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: emailInputController,
                  onFieldSubmitted: (value) async {
                    if (!_formKey.currentState!.validate()) return;
                    await loginButtonPressed();
                  },
                  decoration:
                      InputDecoration(hintText: Tprovider.get('email_address')),
                  enabled: loginState == LoginState.AWAITING_EMAIL,
                  validator: (value) => RegexMatchers.matchEmail(value),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (loginState != LoginState.AWAITING_EMAIL
                  ? Text(Tprovider.get('login_pass'))
                  : Container()),
              SizedBox(
                height: loginState != LoginState.AWAITING_EMAIL ? 12 : 0,
              ),
              Wrap(children: generatePasswordBoxes()),
              SizedBox(
                height: loginState != LoginState.AWAITING_EMAIL ? 20 : 0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  await loginButtonPressed();
                },
                child: Text(Tprovider.get('drawer_login')),
              ),
              SizedBox(height: 20,),
              TextButton(onPressed: ()async {
                Navigator.pop(context);
                await Navigator.push(NavigationContext.mainNavKey.currentContext!, MaterialPageRoute(builder: (context) => ResetPassRequestView(),));
              }, child: Text("${Tprovider.get('forgot_password')} >>"))
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
      if (result != null) {
        Provider.of<AppState>(context, listen: false).setStateLogin(result);
        Navigator.pop(context);
      } else {
        setState(() {
          loginState = LoginState.AWAITING_EMAIL;
          passwordControllers = genTecs();
          emailInputController.clear();
        });
        ErrorDialog.show(context, Tprovider.get('invalidcred_err'));
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
            }
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
