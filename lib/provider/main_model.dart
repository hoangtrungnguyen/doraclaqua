import 'dart:convert';

import 'package:doraclaqua/model/history_request.dart';
import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/history_response.dart';
import 'package:doraclaqua/model/respone/item_history_response.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/repository/respository.dart' as Repository;
import 'package:doraclaqua/util/share_pref.dart';
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

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> getToken() async {
    String token = await SharePre.getStringValue(key: userToken);
    if (token.isEmpty) {
      messageSubject.add("Token is empty");
      return null;
    }

    return token;
  }
}

class HistoryModel extends MainModel {
  bool _isLoading = true;

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

  HistoryModel({String token}) {
    getRequestsCount();
  }

  getRequestsCount() async {
    isLoading = true;
    try {
      String token = await getToken();
      if(token.isEmpty) return;
      Response response = await Repository.Client.getRequestCount(token);
      if (response.statusCode == 200) {
        CountItemHistoryResponse historyResponse =
            CountItemHistoryResponse.fromJson(json.decode(response.body));
        completedRequest = historyResponse.completedRequest;
        waitingRequest = historyResponse.waitingRequest;
        return;
      }
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
  ListRequestModel() {
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
      default:
    }

    notifyListeners();
  }

  Future<void> getAllRequest() async {
    isLoading = true;
    try {
      String token = await getToken();
      if(token.isEmpty) return;
      Response response = await Repository.Client.getAllRequest(token);
      if (response.statusCode == 200) {
        ListRequestResponse historyResponse =
            ListRequestResponse.fromJson(json.decode(response.body));
//        dones..addAll(waitings);
//        historyResponse.completedList..addAll(historyResponse.waitingList);
//        if(dones == historyResponse.completedList) return;
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
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      messageSubject.add(errorResponse.message);
    } on Exception catch (e) {
      messageSubject.add(e.toString());
      print(e);
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
