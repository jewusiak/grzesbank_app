import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _email1 = TextEditingController();
  final TextEditingController _email2 = TextEditingController();
  final TextEditingController _pesel = TextEditingController();
  final TextEditingController _idNumber = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _zipCode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _startingBalance = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${Tprovider.get('registration_in')} Grzesbank24 - DEMO"),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  width: 500,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('firstname')),
                              validator: (value) =>
                                  RegexMatchers.matchPlAlpha(value),
                              
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('lastname')),
                              controller: _surname,
                              validator: (value) =>
                                  RegexMatchers.matchPlAlpha(value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('email_address')),
                              keyboardType: TextInputType.emailAddress,
                              controller: _email1,
                              validator: (value) =>
                                  RegexMatchers.matchEmail(value),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('confirm_email')),
                              keyboardType: TextInputType.emailAddress,
                              controller: _email2,
                              validator: (value) => value == _email1.text
                                  ? null
                                  : Tprovider.get('email_mismatch'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('password')),
                              obscureText: true,
                              controller: _password1,
                              validator: (value) => RegexMatchers.matchPassword(
                                value,
                                Tprovider.get('invalid_chars_pass'),
                                Tprovider.get('password_min8ch'),
                                8,
                                Tprovider.get('field_cannotempty'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('confirm_password')),
                              obscureText: true,
                              controller: _password2,
                              validator: (value) => value == _password1.text
                                  ? null
                                  : Tprovider.get('pass_mismatch'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('pesel')),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              controller: _pesel,
                              validator: (value) => RegexMatchers.matchNumbers(
                                  value,
                                  desiredLength: 11,
                                  onUndesiredLength:
                                      Tprovider.get('pesel_length_err'),
                                  onFailure: Tprovider.get('invalid_textbox'),
                                  onEmpty: Tprovider.get('field_cannotempty')),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('idnumber')),
                              controller: _idNumber,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) =>
                                  RegexMatchers.matchIdNumber(value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: Tprovider.get('street_number')),
                        controller: _street,
                        validator: (value) =>
                            RegexMatchers.matchPlTextbox(value),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('zip_code')),
                              controller: _zipCode,
                              validator: (value) =>
                                  RegexMatchers.matchPlZipCode(value,
                                      onFailure:
                                          Tprovider.get('zip_format_err'),
                                      onEmpty:
                                          Tprovider.get('field_cannotempty')),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: Tprovider.get('city')),
                              controller: _city,
                              validator: (value) =>
                                  RegexMatchers.matchPlTextbox(value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: Tprovider.get('initial_acc_balance')),
                        controller: _startingBalance,
                        validator: (value) => RegexMatchers.matchCcyAmount(
                            value,
                            onFailure: Tprovider.get('amount_err'),
                            matchBlank: true,
                            trim: true),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async => await registerFlow(),
                        child: Text(Tprovider.get('drawer_register')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(
              Tprovider.get('pentest_reg_info'),
            ),
            bottom: 10,
            right: 10,
          ),
        ],
      ),
    );
  }

  Future<void> registerFlow() async {
    if (!_formKey.currentState!.validate()) return;
    WaitingDialog.show(context);
    var res = await ApiService.instance.registerNewUser(
        _name.text,
        _surname.text,
        _email1.text,
        _password1.text,
        _street.text,
        _zipCode.text,
        _city.text,
        _pesel.text,
        _idNumber.text,
        _startingBalance.text);
    Navigator.pop(context);
    if (res) {
      SuccessDialog.show(context, Tprovider.get('reg_succ_alert'),
          onOk: () async {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }
}
