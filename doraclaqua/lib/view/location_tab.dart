import 'package:doraclaqua/model/respone/location_response.dart';
import 'package:doraclaqua/provider/location_model.dart';
import 'package:doraclaqua/util/pair.dart';
import 'package:doraclaqua/view/map_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  LocationTab(this.scaffoldKey);

  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
//  LocationModel locModel;

  @override
  void initState() {
    super.initState();
//    locModel = Provider.of<LocationModel>(context);
//    locModel.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: PageStorageKey("LocationTab"),
      child: Consumer<LocationModel>(
        builder: (BuildContext context, LocationModel value, Widget child) =>
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          value.isLoading ? LinearProgressIndicator() : Container(),
          AppBar(
            title: Text("Địa điểm đổi rác"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                  icon: Icon(Icons.filter),
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
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (_, animation, __) {
                            return MapLocationsDoralaqua();
                          },
                          transitionDuration: Duration(milliseconds: 300),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0.0, 1.0);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);

                            var curve = Curves.fastOutSlowIn;

                            var curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            );

                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          }));
                    },
                    child: Card(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        child: ListTile(
                            isThreeLine: true,
//                          leading: ,
                            title: Text(a.nameAddress),
                            subtitle: Text(
                              a.detailAddress,
                              maxLines: 1,
                            ))),
                  );
                }),
          )
        ]),
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
