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

class _HistoryTabState extends State<HistoryTab> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Tween tween = Tween(begin: 0.0, end: 1.0);
  final requests = <HistoryRequest>[];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  final popUpItems = [
    Pair<String, int>(first: "Tất cả", second: 0),
    Pair<String, int>(first: "Yêu cầu", second: 1),
    Pair<String, int>(first: "Đã đổi", second: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ListRequestModel>(
        builder: (BuildContext context, ListRequestModel value, Widget child) {
      return Stack(
        children: <Widget>[
          value.isLoading ? LinearProgressIndicator() : Container(),
          Column(key: PageStorageKey("HistoryTab"), children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Lịch sử",
              ),
              centerTitle: true,
              leading: Container(),
              actions: <Widget>[
                PopupMenuButton<Pair>(onSelected: (it) {
                  value.changeSelected(it.second);
                }, itemBuilder: (context) {
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
              child: value.selecteds.length > 0
                  ? Expanded(
                      child: AnimatedList(
                          key: _listKey,
                          scrollDirection: Axis.vertical,
                          initialItemCount: requests.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index, animation) {
                            HistoryRequest request = value.selecteds[index];
                            return FadeTransition(
                                child: Card(
                                  color: Color.fromRGBO(255, 255, 255, 0.92),
                                  child: ListTile(
                                    leading: Text("${request.status}"),
                                    title: Text("${request.content}"),
                                    trailing: Text("${request.date}"),
                                  ),
                                ),
                                opacity: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.fastOutSlowIn)
                                    .drive(Tween<double>(
                                  begin: 0,
                                  end: 1,
                                )));
                          }),
                    )
                  : value.isLoading
                      ? Container()
                      : Center(
                          child: Card(
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Text("Bạn chưa thực hiện đổi quà lần nào")),
                          ),
                        ),
            )
          ]),
        ],
      );
    });
  }

   _loadItems() async {
    ListRequestModel model = Provider.of<ListRequestModel>(context, listen: false);
    if(requests == model.selecteds) return;
    await model.getAllRequest();
    var future = Future(() {});
    for (var i = 0; i < model.selecteds .length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 75), () {
          requests.add(model.selecteds[i]);
          _listKey.currentState.insertItem(requests.length - 1);
        });
      });
    }
  }
}
