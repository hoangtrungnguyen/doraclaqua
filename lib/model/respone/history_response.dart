class CountItemHistoryResponse {
  int completedRequest;
  int waitingRequest;

  CountItemHistoryResponse({this.completedRequest, this.waitingRequest});

  CountItemHistoryResponse.fromJson(Map<String, dynamic> json) {
    completedRequest = json['completedRequest'];
    waitingRequest = json['waitingRequest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completedRequest'] = this.completedRequest;
    data['waitingRequest'] = this.waitingRequest;
    return data;
  }
}