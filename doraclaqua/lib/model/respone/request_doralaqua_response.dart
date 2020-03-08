class RequestDoralaquaRespone {
  int code;
  String message;

  RequestDoralaquaRespone({this.code, this.message});

  RequestDoralaquaRespone.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}