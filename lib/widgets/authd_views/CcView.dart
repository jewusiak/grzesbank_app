import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/CcDataResponse.dart';
import 'package:grzesbank_app/utils/Formatters.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
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
      title: Text(Tprovider.get('credit_card')),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Container(
                width: 500,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Tprovider.get('credit_card'),
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
                                    ? "  ${Tprovider.get('reveal_data')}"
                                    : "  ${Tprovider.get('hide_data')}"),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
          children: [
            Image.asset(
              "assets/card_template.jpeg",
            ),
            Positioned(
              top: 170*constraints.maxWidth/500,
              left: 50*constraints.maxWidth/500,
              child: Text(
                Formatters.formatCcNumber(hidden ? null : data?.cardNumber),
                style: TextStyle(
                    fontFamily: "OCRA", color: Colors.white, fontSize: 24),
              ),
            ),
            Positioned(
              top: 225*constraints.maxWidth/500,
              left: 240*constraints.maxWidth/500,
              child: Text(
                (data?.validity==null || hidden) ? "??/??" : data!.validity!,
                style: TextStyle(
                    fontFamily: "OCRA", color: Colors.white, fontSize: 20),
              ),
            ),
            Positioned(
              top: 130*constraints.maxWidth/500,
              left: 433*constraints.maxWidth/500,
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
        );
        },
      ),
    );
  }
}
