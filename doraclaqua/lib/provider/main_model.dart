import 'dart:convert';

import 'package:doraclaqua/model/history_request.dart';
import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/history_response.dart';
import 'package:doraclaqua/model/respone/item_history_response.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/repository/respository.dart' as Repository;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

abstract class MainModel extends ChangeNotifier {
  User _user;

  User get user => _user;

  set user(User value) {
    _user = value;
  }
}

class RequestModel extends MainModel {



}

class HistoryModel extends MainModel {
  bool _isLoading = false;

  int _completedRequest = 0;

  int _waitingRequest = 0;

  Stream<String> get message => _messageSubject.stream;

  final _messageSubject = BehaviorSubject<String>();

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
      _messageSubject.add(errorResponse.message);
    } on Exception catch (e) {
      _messageSubject.add(e.toString());
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

  changeSelected(int type){
    switch(type){
      case 0: {
        selecteds.clear();
        selecteds.addAll(waitings);
        selecteds.addAll(dones);
      };break;
      case 1:{
        selecteds.clear();
        selecteds.addAll(waitings);
      };break;
      case 2:{
        selecteds.clear();
        selecteds.addAll(dones);
      };break;

    }

    notifyListeners();
  }


  Stream<String> get message => _messageSubject.stream;

  final _messageSubject = BehaviorSubject<String>();

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
        dones.addAll( historyResponse.completedList.map((e) => HistoryRequest(e.createdDate, e.status, e.description)));
        waitings.addAll( historyResponse.waitingList.map((e) => HistoryRequest(e.createdDate, e.status, e.description)));
        selecteds.addAll(dones);
        selecteds.addAll(waitings);
        return;
      }
      print(response.body);
      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      _messageSubject.add(errorResponse.message);
    } on Exception catch (e) {
      _messageSubject.add(e.toString());
    } finally {
      isLoading = false;
    }
  }
}

