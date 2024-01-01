import 'package:flutter/material.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/api/responses/dtos/TransactionDto.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/utils/Tprovider.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  int _page = 0;
  late Future _future;

  void assignFuture() {
    _future = Future(() async =>
        await ApiService.instance.getTransactionHistory(page: _page, size: 7));
  }

  @override
  void initState() {
    super.initState();
    assignFuture();
  }

  /*= Future(() async =>
  await ApiService.instance.getTransactionHistory(page: page));
*/

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    return AppScaffold(
      title: Text(Tprovider.get('drawer_history')),
      body: Center(
          child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasData &&
                  [ConnectionState.waiting, ConnectionState.active]
                      .contains(snapshot.connectionState)) {
            return CircularProgressIndicator();
          }
          var content = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              padding:
                  EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Tprovider.get('drawer_history'),
                    style: TextStyle(fontSize: 36),
                  ),
                  Text(
                    "${Tprovider.get('summary_for_acc')} ${appState.userBasicData?.formattedAccountNumber ?? "n/a"}",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    itemCount: content.numberOfElements ?? 0,
                    itemBuilder: (context, index) =>
                        TransactionCard(content.content![index]),
                    shrinkWrap: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: content.first ?? true ? null : goToFirstPage,
                        icon: Icon(Icons.first_page),
                      ),
                      IconButton(
                          onPressed:
                              content.first ?? true ? null : goToPreviousPage,
                          icon: Icon(Icons.keyboard_arrow_left)),
                      Text(
                          "${(content.number ?? 0) + 1} / ${content.totalPages ?? "?"}"),
                      IconButton(
                          onPressed: content.last ?? true ? null : goToNextPage,
                          icon: Icon(Icons.keyboard_arrow_right)),
                      IconButton(
                          onPressed: content.last ?? true
                              ? null
                              : () => goToLastPage(content.totalPages),
                          icon: Icon(Icons.last_page)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  void goToNextPage() {
    setState(() {
      ++_page;
      assignFuture();
    });
  }

  void goToPreviousPage() {
    setState(() {
      --_page;
      assignFuture();
    });
  }

  void goToFirstPage() {
    setState(() {
      _page = 0;
      assignFuture();
    });
  }

  void goToLastPage(int? pagesLength) {
    if (pagesLength == null) return;
    setState(() {
      _page = pagesLength - 1;
      assignFuture();
    });
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard(this.item, {super.key});

  final TransactionDto item;

  @override
  Widget build(BuildContext context) {
    bool isReceived = (item.amount ?? 0) >= 0 ? true : false;
    return Card(
      child: ListTile(
        leading: Icon(isReceived ? Icons.call_received : Icons.call_made,
            color: isReceived ? Colors.green.shade800 : Colors.red.shade800),
        title: Text("${item.title ?? ""}"),
        subtitle: Text(
            "${isReceived ? Tprovider.get('from') : Tprovider.get('to')} ${item.contraSideName ?? "n/a"}\n"
            "${item.formattedDate}"),
        trailing: Text(
          "${item.formattedAmount} PLN",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
