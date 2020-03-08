import 'package:doraclaqua/model/history_request.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/provider/location_model.dart';
import 'package:doraclaqua/provider/login_model.dart';
import 'package:doraclaqua/provider/main_model.dart';
import 'package:doraclaqua/view/widgets/wave_animation/config.dart';
import 'package:doraclaqua/view/widgets/wave_animation/wave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'location_tab.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  PageController _pageController;

  int index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = Provider.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          HistoryModel model = HistoryModel(token: loginModel.user.token);
          model.user = widget.user;
          onMessageReceive(context, model); // lister to the message
          print("${widget.user}");
          return model;
        }),
        ChangeNotifierProvider(create: (context) {
          ListRequestModel model = ListRequestModel();
          model.user = widget.user;
          return model;
        }),
        ChangeNotifierProvider(create: (context) {
          LocationModel model = LocationModel();
          model.user = widget.user;
          return model;
        })
      ],
      child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/request",
                    arguments: widget.user);
              },
              child: Icon(Icons.add)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: TabBar(
            controller: _tabController,
            indicatorColor: Colors.greenAccent,
            tabs: [
              Tab(
                  icon: Icon(
                Icons.person,
                color: Colors.black87,
              )),
              Tab(
                  icon: Icon(
                Icons.history,
                color: Colors.black87,
              )),
              Tab(
                  icon: Icon(
                Icons.location_on,
                color: Colors.black87,
              )),
            ],
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(children: [
              _buildWaveAnimation(),
              TabBarView(
                  physics: FixedExtentScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ProfileTab(_scaffoldKey),
                    HistoryTab(_scaffoldKey),
                    LocationTab(_scaffoldKey),
                  ]),
            ]),
          )),
    );
  }

  onMessageReceive(BuildContext context, HistoryModel historyModel) {
    historyModel.message.listen((event) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(event)));
    });
  }

  Widget _buildWaveAnimation() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.1)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.4),
            Color.fromRGBO(255, 255, 255, 0.2)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.7),
            Color.fromRGBO(255, 255, 255, 0.4)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.9),
            Color.fromRGBO(255, 255, 255, 0.8)
          ],
        ],
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.71 - 0.1, 0.72 - 0.1, 0.74 - 0.1, 0.75 - 0.1],
//        blur: MaskFilter.blur(BlurStyle.solid, 10),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 10,
      backgroundColor: Colors.green,
      size: Size(double.infinity, MediaQuery.of(context).size.height),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProfileTab(this.scaffoldKey);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
//    onMessageReceive(context);
  }

  onMessageReceive(BuildContext context) {
    HistoryModel historyModel =
        Provider.of<HistoryModel>(context, listen: false);
    historyModel.message.listen((event) {
      widget.scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: PageStorageKey("ProfileTab"),
      children: <Widget>[
        Consumer<HistoryModel>(builder: (context, history, child) {
          if (history.isLoading) {
            return LinearProgressIndicator();
          } else {
            return Container();
          }
        }),
        SafeArea(
          child: Align(
            alignment: AlignmentDirectional(0, -0.4),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3 * 2,
              width: MediaQuery.of(context).size.width / 5 * 4,
              child: Consumer<HistoryModel>(
                  builder: (BuildContext context, history, Widget child) {
                return Card(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  elevation: 5.0,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.lerp(
                            AlignmentDirectional.topCenter, null, 0.35),
                        child: Text(
                          "Tên:${history.user != null ? history.user.userName != null ? history.user.userName : "NaN" : "NaN"}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Positioned(
                        top: 140,
                        left: 30,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Hoàn thành",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Container(
                                    height: 16.0,
                                  ),
                                  Text("${history.completedRequest}",
                                      style:
                                          Theme.of(context).textTheme.headline4)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 140,
                        right: 30,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Đang chờ",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Container(
                                    height: 16.0,
                                  ),
                                  Text("${history.waitingRequest}",
                                      style:
                                          Theme.of(context).textTheme.headline4)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        Positioned(
          child: Align(
              alignment: AlignmentDirectional(0, -0.8),
              child: Card(
                elevation: 15.0,
                shape: CircleBorder(),
                child: Consumer<LoginModel>(
                  builder: (BuildContext context, value, Widget child) =>
                      CircleAvatar(
                    radius: 50,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    ListRequestModel provider =
        Provider.of<ListRequestModel>(context, listen: false);
    return Column(key: PageStorageKey("HistoryTab"), children: [
      AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Container(),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context) {
            return <Map>[
              {"Tất cả": 0},
              {"Yêu cầu": 1},
              {"Đã đổi": 2},
            ].map((choice) {
              return PopupMenuItem<Map>(
                value: choice,
                child: FlatButton(
                  onPressed: () {
                    provider.changeSelected(choice.values.first);
                  },
                  child: Text(choice.keys.first),
                ),
              );
            }).toList();
          })
        ],
      ),
      Stack(
        children: <Widget>[
          Container(),
          Positioned.fill(
            left: 15,
            top: 70,
            right: 15,
            child: SafeArea(
              child: Consumer<ListRequestModel>(
                builder: (BuildContext context, ListRequestModel value,
                        Widget child) =>
                    value.selecteds.length > 0
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: value.selecteds.length,
                            itemBuilder: (context, index) {
                              HistoryRequest request = value.selecteds[index];
                              return Card(
                                child: ExpansionTile(
                                  leading: Text("${request.status}"),
                                  title: Text("${request.content}"),
                                  trailing: Text("${request.date}"),
                                ),
                              );
                            })
                        : Center(
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      "Bạn chưa thực hiện đổi quà lần nào")),
                            ),
                          ),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}



