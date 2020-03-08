import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:doraclaqua/model/mock_value.dart';
import 'package:doraclaqua/model/request.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/provider/request_model.dart';
import 'package:doraclaqua/view/widgets/radio_button_group.dart';
import 'package:doraclaqua/view/widgets/smooth_bkg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  final User user;

  RequestForm(this.user);

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _requestKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  City city;
  String state;
  DateTime _dueDate;
  String _pickedHour;
  double topForm = 50;
  bool i = false;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  onMessageReceive(BuildContext context, RequestModel historyModel) {
    historyModel.message.listen((event) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestModel>(
      create: (BuildContext context) {
        RequestModel model = RequestModel();
        model.user = widget.user;
        onMessageReceive(context, model);
        return model;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
//        appBar: AppBar(
//          leading: BackButton(),
//        ),
        resizeToAvoidBottomPadding: false,
        body: Consumer<RequestModel>(
          builder: (BuildContext context, request, Widget child) => Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                color: Color.fromRGBO(255, 255, 255, 1),
              )),
              WaveBackground(),
              AnimatedAlign(
                alignment: Alignment.lerp(
                    Alignment.topCenter, null, _keyboardIsVisible(i) ? -3 : 1),
                duration: Duration(milliseconds: 200),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 11 * 10,
                  width: MediaQuery.of(context).size.width / 11 * 10,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                          key: _requestKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Title(
                                color: Colors.black,
                                child: Text("Đăng ký đổi rác tại nhà"),
                              ),
                              TextFormField(
                                onTap: () {
                                  i = false;
                                },
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
//                                  icon: Icon(Icons.person),
                                    hintText: "Họ và tên"),
                                onChanged: (value) {
                                  request.changeRequest(name: value);
                                },
                                initialValue: request.request.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền tên đăng nhập";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                onTap: () {
                                  i = false;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
//                                  icon: Icon(Icons.person),
                                    hintText: "Số điện thoại"),
                                onChanged: (value) {
                                  request.changeRequest(phone: value);
                                },
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                initialValue: request.request.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền số điện thoại";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                onTap: () {
                                  i = false;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
//                                  icon: Icon(Icons.person),
                                    hintText: "E-mail"),
                                onChanged: (value) {
//                                  request.changeRequest(: value);
                                },
                                initialValue: request.request.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền địa chỉ email";
                                  }
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Địa chỉ e-mail của bạn không hợp lệ";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Bạn sống ở thành phố nào",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              DropdownButtonFormField<City>(
                                value: city,
                                onChanged: (value) {
                                  request.changeRequest(city: value.name);
                                  setState(() {
                                    city = value;
                                  });
                                },
                                items: cities
                                    .map((e) => DropdownMenuItem<City>(
                                        value: e, child: Text(e.name)))
                                    .toList(),
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(gapPadding: 10.0),
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                              ),
//                              DropdownButtonFormField<String>(
//                                value: state,
//                                onChanged: (String value) {
//                                  setState(() {
//                                    state = value;
//                                  });
//                                },
//                                items: city == null ?[]: city.states
//                                    .map((e) => DropdownMenuItem<String>(
//                                        value: e, child: Text(e)))
//                                    .toList(),
//                              ),
                              TextFormField(
                                onTap: () {
                                  setState(() {
                                    i = false;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
//                                  icon: Icon(Icons.person),
                                    hintText:
                                        "Địa chỉ cụ thể (Ví dụ: số 99 Trần Não"),
                                onChanged: (value) {
                                  request.changeRequest(address: value);
                                },
                                initialValue: request.request.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền địa chỉ cụ thể";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text("Thời gian đổi rác")),
                              DateTimeField(
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
//                                    final time = await showTimePicker(
//                                      context: context,
//                                      initialTime: TimeOfDay.fromDateTime(
//                                          currentValue ?? DateTime.now()),
//                                    );
//                                    _dueDate = DateTimeField.combine(date, time);
//                                    return DateTimeField.combine(date, time);
                                    _dueDate = date;
                                    return date;
                                  } else {
                                    _dueDate = currentValue;
                                    return currentValue;
                                  }
                                },
                                initialValue: _dueDate,
                                format: DateFormat(
                                    "dd-MM-yyyy" /*'at' h:mma","vi" */),
                                decoration: InputDecoration(
                                    labelText: 'Date/Time',
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
                                    hasFloatingPlaceholder: false),
                                validator: (dateTime) {
                                  if (dateTime == null) {
                                    return "You must select a due date time for the favor";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _dueDate = value;
                                    request.changeRequest(time: _dueDate);
                                  });
                                },
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text("Khung giờ đổi rác")),
                              RadioButtonGroup(
                                onChange: (label, index) {
                                  request.changeRequest(fixed_time: label);
                                },
                                isHasDifferentChoice: true,
                                orientation:
                                    GroupedButtonsOrientation.HORIZONTAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (String selected) => setState(() {
                                  _pickedHour = selected;
                                }),
                                labels: <String>[
                                  "8:00 AM",
                                  "5:00 PM",
                                ],
                                picked: _pickedHour,
                                itemBuilder: (Radio rb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      rb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text("Mô tả về \"Rác của bạn"
                                      "\"")),
                              TextFormField(
                                onTap: () {
                                  setState(() {
                                    i = true;
                                  });
                                },
//                                  focusNode: _focusNode,
                                decoration: InputDecoration(
                                    labelText: 'Mô tả',
                                    alignLabelWithHint: true,
                                    border:
                                        OutlineInputBorder(gapPadding: 10.0),
                                    contentPadding: EdgeInsets.all(10.0),
                                    hasFloatingPlaceholder: false),
                                maxLines: 5,
                                initialValue: request.request.description,
                                onChanged: (value) {
                                  request.changeRequest(description: value);
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(200)
                                ],
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "You must detail the favor";
                                  }
                                  return null;
                                },
                              ),

                              request.isLoading
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      onPressed: () async {
                                        if (_requestKey.currentState
                                            .validate()) {
                                          _request(context);
                                        }
                                      },
                                      child: Text("Gửi đăng ký"))
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _request(BuildContext context) async {
    bool isSuccess = await Provider.of<RequestModel>(context, listen: false)
        .requestDoralaqua();
    if (isSuccess) Navigator.of(context).pop();
  }

  bool _keyboardIsVisible(bool i) {
    return MediaQuery.of(context).viewInsets.bottom > 0 && i;
  }
}
