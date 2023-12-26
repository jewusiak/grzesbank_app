import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/CcDataResponse.dart';
import 'package:grzesbank_app/utils/Formatters.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class CcView extends StatefulWidget {
  const CcView({super.key});

  @override
  State<CcView> createState() => _CcViewState();
}

class _CcViewState extends State<CcView> {

  bool _hidden = true;

  final _emptyFuture = Future(() => null);
  Future _future = Future(() => null);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text("Karty kredytowe"),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            bool visible = snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done &&
                !_hidden;
            return SingleChildScrollView(
              child: Container(
                width: 500,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Karta kredytowa",
                      style: TextStyle(fontSize: 36),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Stack(
                      children: [
                        CardWidget(
                            hidden: _hidden,
                            isLoading: snapshot.connectionState !=
                                ConnectionState.done,
                            data: snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done
                                ? snapshot.data
                                : null),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh),
                                Text(_hidden
                                    ? "  Odkryj dane"
                                    : "  Ukryj dane"),
                              ],
                            ),
                            onPressed: () async {
                              if (!_hidden) {
                                setState(() {
                                  _hidden = true;
                                  _future = _emptyFuture;
                                });
                              } else {
                                setState(() {
                                  _future = Future(() async {
                                    var res = await ApiService.instance.getCcData();
                                    setState(() {
                                      _hidden = false;
                                    });
                                    return res;
                                  });
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key, required this.hidden, this.data, required this.isLoading});

  final CcDataResponse? data;
  final bool hidden;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.file(
            File("resources/card_template.jpg"),
          ),
          Positioned(
            top: 170,
            left: 50,
            child: Text(
              Formatters.formatCcNumber(hidden ? null : data?.cardNumber),
              style: TextStyle(
                  fontFamily: "OCRA", color: Colors.white, fontSize: 24),
            ),
          ),
          Positioned(
            top: 215,
            left: 225,
            child: Text(
              (data?.validity==null || hidden) ? "??/??" : data!.validity!,
              style: TextStyle(
                  fontFamily: "OCRA", color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            top: 141,
            left: 433,
            child: Text(
              (data?.cvv==null || hidden) ? "???" : data!.cvv!,
              style: TextStyle(
                  fontFamily: "OCRA", color: Colors.white, fontSize: 16),
            ),
          ),
          Positioned(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaY: hidden ? 10 : 0, sigmaX: hidden ? 10 : 0),
              child: Container(),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: isLoading ? CircularProgressIndicator() : Container(),
            ),
          )
        ],
      ),
    );
  }
}
