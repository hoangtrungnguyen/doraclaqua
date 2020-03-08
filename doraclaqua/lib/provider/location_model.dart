import 'dart:convert';

import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/location_response.dart';
import 'package:doraclaqua/provider/main_model.dart';
import 'package:doraclaqua/repository/respository.dart' as Repository;
import 'package:http/http.dart';

class LocationModel extends MainModel {
  List<Locations> _locations= [];
  List<Locations> get locations => _locations;

  set locations(List<Locations> value) {
    _locations = value;
    notifyListeners();
  }

  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  set addresses(List<Address> value) {
    _addresses = value;
    notifyListeners();
  }

  LocationModel(){
   getLocations();
  }

  Future<bool> getLocations() async {
    isLoading = true;
    try {
      Response response = await Repository.Client.getLocations(user.token);
      if (response.statusCode == 200) {
        LocationsResponse locResponse = LocationsResponse.fromJson(json.decode(response.body));
        locations = locResponse.locations;
        for(Locations list in locations){
          addresses.addAll(list.address);
        }
        return true;
      }
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      messageSubject.add(errorResponse.message);
      return false;
    } on Exception catch (e) {
      messageSubject.add(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }
}
