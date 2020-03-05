import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/provider/main_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  final User user;

  RequestForm(this.user);

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  @override
  Widget build(BuildContext context) {
    return Provider<RequestModel>(
      create: (BuildContext context) {
        RequestModel model = RequestModel();
        model.user = widget.user;
        return model;
      },

//      child: ,
    );
  }
}
