import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/ErrorDialog.dart';
import 'package:grzesbank_app/util_views/SuccessDialog.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/utils/Formatters.dart';
import 'package:grzesbank_app/utils/RegexMatchers.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class SendTransferView extends StatefulWidget {
  const SendTransferView({super.key});

  @override
  State<SendTransferView> createState() => _SendTransferViewState();
}

class _SendTransferViewState extends State<SendTransferView> {
  final _formKey = GlobalKey<FormState>();
  
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _accn = TextEditingController();
  final _title = TextEditingController();
  final _amount = TextEditingController();

  SendTransferState _state = SendTransferState.ENTRY;

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    String _buttonText = _state == SendTransferState.CONFIRMATION
        ? "Potwierdzasz? Kliknij ponownie"
        : "Wyślij przelew";
    return AppScaffold(
      title: Text("Wyślij przelew"),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Przelew natychmiastowy",
                    style: TextStyle(fontSize: 36),
                  ),
                  Text(
                      "z rachunku nr ${appState.userBasicData!.formattedAccountNumber}"),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Imię i nazwisko odbiorcy"),
                    validator: (value) => RegexMatchers.matchPlTextbox(value,
                        onFailure: "Pole wypełnione niepoprawnie",
                        onEmpty: "Pole nie może być puste"),
                    controller: _name,
                    enabled: _state == SendTransferState.ENTRY,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Adres odbiorcy"),
                    validator: (value) => RegexMatchers.matchPlTextbox(value,
                        onFailure: "Pole wypełnione niepoprawnie",
                        onEmpty: "Pole nie może być puste"),
                    controller: _address,
                    enabled: _state == SendTransferState.ENTRY,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Nr rachunku odbiorcy"),
                    validator: (value) => RegexMatchers.matchAccNumber(value,
                        onFailure: "Pole wypełnione niepoprawnie",
                        onEmpty: "Pole nie może być puste"),
                    inputFormatters: [
                      AccountNumberFormatter(),
                      LengthLimitingTextInputFormatter(32)
                    ],
                    controller: _accn,
                    enabled: _state == SendTransferState.ENTRY,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: "Tytuł przelewu"),
                          validator: (value) => RegexMatchers.matchPlTextbox(
                              value,
                              onFailure: "Pole wypełnione niepoprawnie",
                              onEmpty: "Pole nie może być puste"),
                          controller: _title,
                          enabled: _state == SendTransferState.ENTRY,
                        ),
                        flex: 4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Kwota"),
                          validator: (value) => RegexMatchers.matchCcyAmount(
                            value,
                            onFailure: "Pole wypełnione niepoprawnie",
                            onEmpty: "Pole nie może być puste",
                            trim: true,
                          ),
                          controller: _amount,
                          enabled: _state == SendTransferState.ENTRY,
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "PLN",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(_state == SendTransferState.ENTRY && _formKey.currentState!.validate()){
                        setState(() {
                          _state = SendTransferState.CONFIRMATION;
                        });
                        return;
                      }
                      if(_state == SendTransferState.CONFIRMATION) {
                        // sendFlow
                        WaitingDialog.show(context);
                        var res = await ApiService.instance.sendTransfer(_name.text, _address.text, _accn.text, _amount.text, _title.text);
                        if(res == null) {
                          Navigator.pop(context);
                          SuccessDialog.show(context, "Przelew wysłany pomyślnie.", onOk: () async {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          });
                        } else {
                          Navigator.pop(context);
                          setState(() {
                            _state = SendTransferState.ENTRY;
                          });
                          ErrorDialog.show(context, res);
                        }
                      }
                    },
                    child: Text(_buttonText),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum SendTransferState { ENTRY, CONFIRMATION }
