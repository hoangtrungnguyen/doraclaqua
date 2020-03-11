class ListRequestResponse {
  List<ItemHistory> _completedList;
  List<ItemHistory> _waitingList;

  ListRequestResponse(
      {List<ItemHistory> completedList, List<ItemHistory> waitingList}) {
    this._completedList = completedList;
    this._waitingList = waitingList;
  }

  List<ItemHistory> get completedList => _completedList;
  set completedList(List<ItemHistory> completedList) =>
      _completedList = completedList;
  List<ItemHistory> get waitingList => _waitingList;
  set waitingList(List<ItemHistory> waitingList) => _waitingList = waitingList;

  ListRequestResponse.fromJson(Map<String, dynamic> json) {
    if (json['completedList'] != null) {
      _completedList = new List<ItemHistory>();
      json['completedList'].forEach((v) {
        _completedList.add(new ItemHistory.fromJson(v));
      });
    }
    if (json['waitingList'] != null) {
      _waitingList = new List<ItemHistory>();
      json['waitingList'].forEach((v) {
        _waitingList.add(new ItemHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._completedList != null) {
      data['completedList'] =
          this._completedList.map((v) => v.toJson()).toList();
    }
    if (this._waitingList != null) {
      data['waitingList'] = this._waitingList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemHistory {
  String _id;
  String _name;
  String _phone;
  String _city;
  String _address;
  String _dayOfWeek;
  String _time;
  String _description;
  String _createdDate;
  String _status;
  String _userId;
  String _collectorId;

  ItemHistory(
      {String id,
        String name,
        String phone,
        String city,
        String address,
        String dayOfWeek,
        String time,
        String description,
        String createdDate,
        String status,
        String userId,
        String collectorId}) {
    this._id = id;
    this._name = name;
    this._phone = phone;
    this._city = city;
    this._address = address;
    this._dayOfWeek = dayOfWeek;
    this._time = time;
    this._description = description;
    this._createdDate = createdDate;
    this._status = status;
    this._userId = userId;
    this._collectorId = collectorId;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;
  String get city => _city;
  set city(String city) => _city = city;
  String get address => _address;
  set address(String address) => _address = address;
  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;
  String get time => _time;
  set time(String time) => _time = time;
  String get description => _description;
  set description(String description) => _description = description;
  String get createdDate => _createdDate;
  set createdDate(String createdDate) => _createdDate = createdDate;
  String get status => _status;
  set status(String status) => _status = status;
  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get collectorId => _collectorId;
  set collectorId(String collectorId) => _collectorId = collectorId;

  ItemHistory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _phone = json['phone'];
    _city = json['city'];
    _address = json['address'];
    _dayOfWeek = json['day_of_week'];
    _time = json['time'];
    _description = json['description'];
    _createdDate = json['created_date'];
    _status = json['status'];
    _userId = json['user_id'];
    _collectorId = json['collector_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['phone'] = this._phone;
    data['city'] = this._city;
    data['address'] = this._address;
    data['day_of_week'] = this._dayOfWeek;
    data['time'] = this._time;
    data['description'] = this._description;
    data['created_date'] = this._createdDate;
    data['status'] = this._status;
    data['user_id'] = this._userId;
    data['collector_id'] = this._collectorId;
    return data;
  }
}
