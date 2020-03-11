import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/provider/location_model.dart';
import 'package:doraclaqua/provider/main_model.dart';
import 'package:doraclaqua/util/share_pref.dart';
import 'package:doraclaqua/view/widgets/wave_animation/config.dart';
import 'package:doraclaqua/view/widgets/wave_animation/wave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history_tab.dart';
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
  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          HistoryModel model = HistoryModel(token: widget.user.token);
          model.user = widget.user;
          onMessageReceive(context, model); // lister to the message
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
          floatingActionButton: _tabController.index != 2
              ? FloatingActionButton(

              onPressed: () async {
                bool isSuccess = await Navigator.pushNamed<bool>(
                  context,
                  "/request",
                );
                if (isSuccess)
                  Provider.of<HistoryModel>(context, listen: false)
                      .getRequestsCount();
              },
              child: Icon(Icons.add))
              : null,
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: TabBar(
            controller: _tabController,
            indicatorColor: Colors.greenAccent,
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.person,
                    color: _tabController.index == 0 ? Colors.green : Colors
                        .black,
                  )),
              Tab(
                  icon: Icon(
                    Icons.history,
                    color: _tabController.index == 1 ? Colors.green : Colors
                        .black,
                  )),
              Tab(
                  icon: Icon(
                    Icons.location_on,
                    color: _tabController.index == 2 ? Colors.green : Colors
                        .black,
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
                    InheritedLocationWidget(
                      _scaffoldKey,
                      child: LocationTab(),
                    ),
                  ]),
            ]),
          )),
    );
  }

  onMessageReceive(BuildContext context, HistoryModel historyModel) {
    historyModel.message.listen((event) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Padding(padding: EdgeInsets.only(bottom: 36.0),
      child: Text(event)) , ));
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
      size: Size(double.infinity, MediaQuery
          .of(context)
          .size
          .height),
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
    HistoryModel historyModel =
    Provider.of<HistoryModel>(context, listen: false);
    historyModel.getRequestsCount();
  }

  onMessageReceive(BuildContext context) {
    HistoryModel historyModel =
    Provider.of<HistoryModel>(context, listen: false);
    historyModel.message.listen((event) {
      widget.scaffoldKey.currentState
          .showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
          content: Text(event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryModel>(
      builder: (BuildContext context, value, Widget child) =>
          Stack(
            key: PageStorageKey("ProfileTab"),
            children: <Widget>[
              value.isLoading ? LinearProgressIndicator() : Container(),
              SafeArea(
                child: Align(
                  alignment: AlignmentDirectional(0, -0.4),
                  child: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3 * 2,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 5 * 4,
                    child:
                    Card(
                      color: Color.fromRGBO(255, 255, 255, 0.92),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      elevation: 5.0,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: AlignmentDirectional.lerp(
                                AlignmentDirectional.topCenter, null, 0.35),
                            child: Text(
                              "Tên:${value.user != null ? value.user
                                  .userName != null
                                  ? value.user.userName
                                  : "NaN" : "NaN"}",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6,
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
                                        Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Container(
                                        height: 16.0,
                                      ),
                                      Text("${value.completedRequest}",
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .headline4)
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
                                        Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Container(
                                        height: 16.0,
                                      ),
                                      Text("${value.waitingRequest}",
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .headline4)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                    alignment: AlignmentDirectional(0, -0.8),
                    child: Card(
                      elevation: 15.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 50,
                        child:Text("${value.user.userName.substring(0,1).toUpperCase()}",style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white),),
                      ),
                    )),
              ),
            ],
          ),
    );
  }

//  void _importImage() async {
//    await _checkPermissions();
//    final image = await ImagePicker.pickImage(source: ImageSource.camera);
//    setState(() {
//      _imageFile = image;
//    });
//    _labelImage();
//  }

  void _signOut() async {
    SharePre.deleteToken();
  }
}
