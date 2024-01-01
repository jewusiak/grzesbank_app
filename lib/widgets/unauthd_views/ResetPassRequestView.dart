import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class ResetPassRequestView extends StatelessWidget {
  const ResetPassRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _email = TextEditingController();
    return AppScaffold(
      title: Text(Tprovider.get('forgot_password')),
      body: Center(
        child: Container(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Tprovider.get('forgot_pass_hdg'),
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _email,
                  decoration:
                      InputDecoration(hintText: Tprovider.get('email_address')),
                  validator: (value) => RegexMatchers.matchEmail(value),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  WaitingDialog.show(context);
                  var res = await ApiService.instance
                      .requestPasswordReset(_email.text);
                  Navigator.pop(
                      NavigationContext.mainNavKey.currentContext!);
                  if (res) {
                    SuccessDialog.show(
                        NavigationContext.mainNavKey.currentContext!,
                        Tprovider.get('pass_req_succ'), onOk: () async {
                      Navigator.pop(
                          NavigationContext.mainNavKey.currentContext!);
                      Navigator.pop(
                          NavigationContext.mainNavKey.currentContext!);
                    });
                  } else {
                    ErrorDialog.show(
                        NavigationContext.mainNavKey.currentContext!,
                        Tprovider.get('pass_req_fail'), onOk: () async {
                      Navigator.pop(
                          NavigationContext.mainNavKey.currentContext!);
                      Navigator.pop(
                          NavigationContext.mainNavKey.currentContext!);
                    });
                  }
                },
                child: Text(Tprovider.get('forgot_pass_btn')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
