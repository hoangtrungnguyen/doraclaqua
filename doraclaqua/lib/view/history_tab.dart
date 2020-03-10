import 'package:doraclaqua/model/history_request.dart';
import 'package:doraclaqua/provider/main_model.dart';
import 'package:doraclaqua/util/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';




class HistoryTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  HistoryTab(this.scaffoldKey);

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<ListRequestModel>(context, listen: false).getAllRequest();
  }
  final popUpItems = [
  Pair<String, int>(first: "Tất cả", second: 0),
  Pair<String, int>(first: "Yêu cầu", second: 1),
  Pair<String, int>(first: "Đã đổi", second: 2),
  ];

  @override
  Widget build(BuildContext context) {
    ListRequestModel provider =
        Provider.of<ListRequestModel>(context, listen: false);
    return Consumer<ListRequestModel>(
        builder: (BuildContext context, ListRequestModel value, Widget child) {
      return Stack(
        children: <Widget>[
          value.isLoading ? LinearProgressIndicator() : Container(),
          Column(key: PageStorageKey("HistoryTab"), children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("Lịch sử",),
              centerTitle: true,
              leading: Container(),
              actions: <Widget>[
                PopupMenuButton<Pair>(
                  onSelected:  (it) {
                    value.changeSelected(it.second);
                  },
                    itemBuilder: (context) {
                  return popUpItems.map((choice) {
                    return PopupMenuItem<Pair>(
                      value: choice,
                      child: Text(choice.first),
                    );
                  }).toList();
                })
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7 * 6 * 0.96,
              child: value.selecteds.length > 0 ?
            Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: value.selecteds.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          HistoryRequest request = value.selecteds[index];
                          return Card(
                              color: Color.fromRGBO(255, 255, 255, 0.92),
                            child: ListTile(
                              leading: Text("${request.status}"),
                              title: Text("${request.content}"),
                              trailing: Text("${request.date}"),
                            ),
                          );
                        }),
                  )
                : value.isLoading
                    ? Container()
                    : Center(
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Bạn chưa thực hiện đổi quà lần nào")),
                        ),
                    ),)
          ]),
        ],
      );
    });
  }
}
