import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiClient.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';

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
        title: Text("Rejestracja w Grzesbank24 - DEMO"),
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
                              decoration: InputDecoration(labelText: "Imię"),
                              validator: (value) => RegexMatchers.matchPlAlpha(
                                  value,
                                  onFailure: "Pole wypełnione niepoprawnie",
                                  onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Nazwisko"),
                              controller: _surname,
                              validator: (value) => RegexMatchers.matchPlAlpha(
                                  value,
                                  onFailure: "Pole wypełnione niepoprawnie",
                                  onEmpty: "Pole nie może być puste"),
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
                              decoration:
                                  InputDecoration(labelText: "Adres email"),
                              keyboardType: TextInputType.emailAddress,
                              controller: _email1,
                              validator: (value) => RegexMatchers.matchEmail(
                                  value,
                                  onFailure: "Pole wypełnione niepoprawnie",
                                  onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Potwierdź adres email"),
                              keyboardType: TextInputType.emailAddress,
                              controller: _email2,
                              validator: (value) => value == _email1.text
                                  ? null
                                  : "Adresy email musza być takie same",
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
                              decoration:
                                  InputDecoration(labelText: "Hasło"),
                              obscureText: true,
                              controller: _password1,
                              validator: (value) => RegexMatchers.matchPassword(
                                  value,
                                   "Hasło zawiera znaki niedozwolone",
                                   "Hasło musi mieć min. 8 znaków",
                                   8,
                                   "Pole nie może być puste",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Potwierdź hasło"),
                              obscureText: true,
                              controller: _password2,
                              validator: (value) => value == _password1.text
                                  ? null
                                  : "Hasła musza być takie same",
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
                              decoration: InputDecoration(labelText: "PESEL"),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              controller: _pesel,
                              validator: (value) => RegexMatchers.matchNumbers(
                                  value,
                                  desiredLength: 11,
                                  onUndesiredLength:
                                      "PESEL powinien mieć 11 cyfr",
                                  onFailure: "Nieprawidłowo wypełnione pole",
                                  onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Seria i nr dowodu osobistego"),
                              controller: _idNumber,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) => RegexMatchers.matchIdNumber(
                                  value,
                                  onFailure: "Nieprawidłowo wypełnione pole",
                                  onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Ulica i numer"),
                        controller: _street,
                        validator: (value) => RegexMatchers.matchPlTextbox(
                            value,
                            onFailure:
                                "Dozwolone znaki A-z, 0-9, -, _, /, spacja",
                            onEmpty: "Pole nie może być puste"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Kod pocztowy"),
                              controller: _zipCode,
                              validator: (value) =>
                                  RegexMatchers.matchPlZipCode(value,
                                      onFailure:
                                          "Kod pocztowy w formacie XX-XXX",
                                      onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "Miasto"),
                              controller: _city,
                              validator: (value) =>
                                  RegexMatchers.matchPlTextbox(
                                      value,
                                      onFailure:
                                          "Nieprawidłowo wypełnione pole",
                                      onEmpty: "Pole nie może być puste"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Początkowy stan konta ;)"),
                        controller: _startingBalance,
                        validator: (value) => RegexMatchers.matchCcyAmount(
                            value,
                            onFailure: "Podaj kwotę (z kropką) - 20.34",
                            matchBlank: true,
                            trim: true),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async => await registerFlow(),
                        child: Text("Zarejestruj się"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(
              "Informacja dla pentesterów - ten formularz może nie być chroniony (walidacja wprowadzonych danych). Jego istnienie jest jedynie uwarunkowane usprawnieniem procedury zakładania konta.",
            ),
            bottom: 10,
            right: 10,
          ),
        ],
      ),
    );
  }

  Future<void> registerFlow() async {
    if(!_formKey.currentState!.validate()) return;
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
      SuccessDialog.show(context,
          "Rejestracja udana, już możesz zalogować się na konto w Grzesbank24",
          onOk: () async {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }
}
