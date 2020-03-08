import 'dart:convert';

import 'package:doraclaqua/model/history_request.dart';
import 'package:doraclaqua/model/request.dart';
import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/history_response.dart';
import 'package:doraclaqua/model/respone/item_history_response.dart';
import 'package:doraclaqua/model/respone/request_doralaqua_response.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/repository/respository.dart' as Repository;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

abstract class MainModel extends ChangeNotifier {
  User _user = User();

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Stream<String> get message => messageSubject.stream;

  BehaviorSubject<String> messageSubject = BehaviorSubject<String>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

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
//      request.time = time.hour.toString();
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

class HistoryModel extends MainModel {
  bool _isLoading = false;

  int _completedRequest = 0;

  int _waitingRequest = 0;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int get completedRequest => _completedRequest;

  set completedRequest(int value) {
    _completedRequest = value;
    notifyListeners();
  }

  int get waitingRequest => _waitingRequest;

  set waitingRequest(int value) {
    _waitingRequest = value;
    notifyListeners();
  }

  HistoryModel({@required String token}) {
    getRequestsCount(token);
  }

  getRequestsCount(String token) async {
    isLoading = true;
    try {
      Response response = await Repository.Client.getRequestCount(token);
      if (response.statusCode == 200) {
        CountItemHistoryResponse historyResponse =
            CountItemHistoryResponse.fromJson(json.decode(response.body));
        completedRequest = historyResponse.completedRequest;
        waitingRequest = historyResponse.waitingRequest;
        print(historyResponse);
        return;
      }
      print(response.body);
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      messageSubject.add(errorResponse.message);
    } on Exception catch (e) {
      messageSubject.add(e.toString());
    } finally {
      isLoading = false;
    }
  }
}

class ListRequestModel extends MainModel {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<HistoryRequest> selecteds = <HistoryRequest>[];
  List<HistoryRequest> waitings = <HistoryRequest>[];
  List<HistoryRequest> dones = <HistoryRequest>[];

  changeSelected(int type) {
    switch (type) {
      case 0:
        {
          selecteds.clear();
          selecteds.addAll(waitings);
          selecteds.addAll(dones);
        }
        ;
        break;
      case 1:
        {
          selecteds.clear();
          selecteds.addAll(waitings);
        }
        ;
        break;
      case 2:
        {
          selecteds.clear();
          selecteds.addAll(dones);
        }
        ;
        break;
    }

    notifyListeners();
  }

  getAllRequest() async {
    isLoading = true;
    try {
      Response response = await Repository.Client.getAllRequest(user.token);
      if (response.statusCode == 200) {
        ListRequestResponse historyResponse =
            ListRequestResponse.fromJson(json.decode(response.body));
        print(historyResponse);
        selecteds.clear();
        waitings.clear();
        dones.clear();
        dones.addAll(historyResponse.completedList.map(
            (e) => HistoryRequest(e.createdDate, e.status, e.description)));
        waitings.addAll(historyResponse.waitingList.map(
            (e) => HistoryRequest(e.createdDate, e.status, e.description)));
        selecteds.addAll(dones);
        selecteds.addAll(waitings);
        return;
      }
      print(response.body);
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      messageSubject.add(errorResponse.message);
    } on Exception catch (e) {
      messageSubject.add(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageSubject.close();
  }
}
