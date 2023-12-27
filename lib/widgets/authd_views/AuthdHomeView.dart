import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/authd_views/HistoryView.dart';

class AuthdHomeView extends StatefulWidget {
  const AuthdHomeView({super.key});

  @override
  State<AuthdHomeView> createState() => _AuthdHomeViewState();
}

class _AuthdHomeViewState extends State<AuthdHomeView> {
  @override
  Widget build(BuildContext context) {
    var future =
        Future(() async => await ApiService.instance.getAccountSummary());
    return Center(
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var summary = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async { 
              setState(() {
                future = Future(() async => await ApiService.instance.getAccountSummary());
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "${Tprovider.get('welcome')}, ",
                        style: TextStyle(fontSize: 36),
                      ),Text(
                        "${summary.name ?? "n/a"}",
                        style: TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${Tprovider.get('summary_for_acc')} ${summary.formattedAccountNumber}",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 25,
                        width: 25,
                        child: IconButton(
                          iconSize: 15,
                          padding: EdgeInsets.all(5),
                            onPressed: () async {
                              if (summary.accountNumber == null) return;
                              await Clipboard.setData(
                                  ClipboardData(text: summary.accountNumber!));
                              await ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(Tprovider.get('copied_accn'))));
                            },
                            icon: Icon(
                              Icons.copy,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${summary.balance ?? "n/a"} PLN",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: summary.lastTransactions?.length ?? 0,
                    itemBuilder: (context, index) =>
                        TransactionCard(summary.lastTransactions![index]),
                    shrinkWrap: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryView(),
                          )),
                      child: Text("${Tprovider.get('more_history')} >>"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
