import 'package:doraclaqua/model/respone/location_response.dart';
import 'package:doraclaqua/provider/location_model.dart';
import 'package:doraclaqua/util/open_map.dart';
import 'package:doraclaqua/util/pair.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InheritedLocationWidget extends InheritedWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  InheritedLocationWidget(this.scaffoldKey, {Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static InheritedLocationWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedLocationWidget>();
  }

  call(String phoneNumber) async {
    try {
      String URI = "tel://$phoneNumber";
      await launch(URI);
    } on Exception catch (e) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

class LocationTab extends StatefulWidget {
  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  final GlobalKey<_LocationTabState> _locationPageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Provider.of<LocationModel>(context, listen: false).getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationModel>(
        key: _locationPageKey,
        builder: (BuildContext context, LocationModel value, Widget child) {
          return Stack(children: <Widget>[
            value.isLoading ? LinearProgressIndicator() : Container(),
            Column(
              children: <Widget>[
                AppBar(
                  title: Text("Địa điểm đổi rác"),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.green,
                  actions: [
                    IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          showSearch<Address>(
                              context: context,
                              delegate: LocationSearch(value.locations));
                        })
                  ],
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 7 * 6 * 0.96,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: value.addresses.length,
                      itemBuilder: (context, index) {
                        Address a = value.addresses[index];
//                        return TweenAnimationBuilder(
//                          duration: Duration(milliseconds: 400),
//                          tween: null,
//                          builder: (BuildContext context, value, Widget child) {
//                            return ItemSlide(a);
//                          },
//                        );
                        return ItemSlide(a);
                      },
                    ))
              ],
            ),
          ]);
        });
  }
}

class ItemSlide extends StatefulWidget {
  final Address address;

  ItemSlide(this.address);

  @override
  _ItemSlideState createState() => _ItemSlideState();
}

class _ItemSlideState extends State<ItemSlide> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: 1.0,
      child: InkWell(
        onTap: () {
          MapsLauncher.launchQuery(
              "${widget.address.detailAddress} ${widget.address.area}");
        },
        child: Card(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  title: Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Text(
                        widget.address.nameAddress,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          widget.address.detailAddress,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Text("${widget.address.time}\n${widget.address.noteTime}")
                    ],
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
//                  RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(10))),
//                    color: Colors.green[200],
//                    child: const Text('Đổi quà'),
//                    onPressed: () async {
//
//                    },
//                  ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.green[200],
                      child: const Text('Gọi'),
                      onPressed: () async {
                        InheritedLocationWidget.of(context)
                            .call(widget.address.phone);
                      },
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class LocationSearch extends SearchDelegate<Address> {
  List<Pair<Locations, bool>> _locationsChoice = [];

  LocationSearch(List<Locations> locations) {
    _locationsChoice = locations
        .map((e) => Pair<Locations, bool>(first: e, second: true))
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      color: Colors.black,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Address> results = [];
    if (_locationsChoice.any((element) => element.second)) {
      _locationsChoice.where((element) => element.second).forEach((e) {
        results.addAll(e.first.address);
      });
    }

    results = results
        .where((element) =>
            element.nameAddress.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty)
      return Center(
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.headline3,
                  children: query.isEmpty
                      ? [TextSpan(text: "Enter text to search")]
                      : [
                          TextSpan(text: "No Result for"),
                          TextSpan(text: "\n"),
                          TextSpan(
                              text: "${query}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold))
                        ])));
    return ListView(
        children: results
            .where((element) => element.nameAddress.contains(query))
            .map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                    onTap: () async {
                      close(context, e);
                      MapsLauncher.launchQuery("${e.detailAddress} ${e.area}");
                    },
                    child: ListTile(
                      leading: Icon(Icons.book),
                      title: Text(
                        e.nameAddress,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.subtitle1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Address> suggestions = [];
    if (_locationsChoice.any((element) => element.second)) {
      _locationsChoice.where((element) => element.second).forEach((e) {
        suggestions.addAll(e.first.address);
      });
    }

    suggestions = suggestions
        .where((element) =>
            element.nameAddress.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Builder(
      builder: (BuildContext context) =>
          /*child: */ ListView.builder(
              itemCount: suggestions.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
//            return FlatButton(onPressed: (){
//              showSuggestions(context);}, child: Text("TEst"));
                  return Column(
                    children: <Widget>[
                      _buildCitiesSuggestion(_locationsChoice, context),
                      suggestions.length < 1
                          ? Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: Text(
                                "Không có gợi ý",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
//                  fontFamily: "Ubuntu",
                                        ),
                              )))
                          : Container(),
                    ],
                  );
                }

                Address e = suggestions[index - 1];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                    onTap: () {
                      query = e.nameAddress;
                      showResults(context);
//                      showSuggestions(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.bookmark_border),
                        Flexible(
                          child: Container(
                            width: 300,
                            child: Text(
                              e.nameAddress,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  Widget _buildCitiesSuggestion(
      List<Pair<Locations, bool>> _cities, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _locationsChoice
            .map((e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  onSelected: (b) {
                    for (int i = 0; i < _locationsChoice.length; i++) {
                      Pair<Locations, bool> loc = _locationsChoice[i];
                      if (loc.first == e.first) {
                        _locationsChoice[i].second = b;
                        break;
                      }
                    }
                    query = " ";
                    showSuggestions(context);
                    query = "";
                  },
                  label: Text(e.first.name.substring(3)),
                  labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  selected: e.second,
                )))
            .toList(),
      ),
    );
  }
}
