import 'dart:convert';

import 'package:doraclaqua/model/request.dart';
import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/request_doralaqua_response.dart';
import 'package:http/http.dart';
import 'package:doraclaqua/repository/respository.dart' as Repository;

import 'main_model.dart';

class RequestModel extends MainModel {
  RequestDoralaqua request;

  RequestModel() {
    request = RequestDoralaqua();
  }

  changeRequest({
    String name,
    String phone,
    String city,
    String address,
    DateTime time,
    String fixed_time,
    String description,
  }) {
    if (name != null) request.name = name;
    if (phone != null) request.phone = phone;
    if (city != null) request.city = city;
    if (address != null) request.address = address;
    if (fixed_time != null) request.time = fixed_time;
    if (time != null) {
      final weekDays = [
        "Thứ 2",
        "Thứ 3",
        "Thứ 4",
        "Thứ 5",
        "Thứ 6",
        "Thứ 7",
        "Chủ Nhật"
      ];
      int day_of_week = time.weekday;
      request.dayOfWeek = weekDays[day_of_week];
      request.time = time.hour.toString();
    }
    if (description != null) request.description = description;
    print("${request}");
    notifyListeners();
  }

  Future<bool> requestDoralaqua() async {
    isLoading = true;
    try {
      Response response =
      await Repository.Client.requestDoralaqua(request, /*user.token ??*/ "NaN");
      if (response.statusCode == 200) {
        RequestDoralaquaRespone requestResponse =
        RequestDoralaquaRespone.fromJson(json.decode(response.body));
        messageSubject.add(requestResponse.message);
        return true;
      }
      print(response.body);
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