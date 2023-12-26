import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/SensitiveDataResponse.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/util_views/WaitingDialog.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _hidden = true;

  final _emptyFuture = Future(() => null);

  Future _future = Future(() => null);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text("Twój profil"),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            var resp = snapshot.hasData &&
                snapshot.connectionState ==
                    ConnectionState.done
                ? (snapshot.data as SensitiveDataResponse?)
                : null;
            
            return SingleChildScrollView(
              child: Container(
                width: 500,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Dane wrażliwe - profil", style: TextStyle(fontSize: 36),),
                    SizedBox(height: 15,),
                    ElevatedButton(
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
                        if(!_hidden){
                          setState(() {
                            _hidden = true;
                            _future = _emptyFuture;
                          });
                        } else {
                          WaitingDialog.show(context);
                          setState(() {
                            _future = Future(() async {
                              var res = await ApiService.instance.getSensitiveData();
                              setState(() {
                                _hidden = false;
                              });
                              Navigator.pop(NavigationContext.mainNavKey.currentContext!);
                              return res;
                            });
                          });
                        }
                      },
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nr pesel: "),
                        Text(snapshot.hasData && !_hidden ? resp?.pesel??"n/a" :"XXXXXXXXXXX")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nr dowodu osobistego: "),
                        Text(snapshot.hasData && !_hidden ? resp?.documentNumber??"n/a" :"XXX XXXXXX")
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
