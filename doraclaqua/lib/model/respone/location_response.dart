class LocationsResponse {
  List<Locations> locations= [];

  LocationsResponse({this.locations});

  LocationsResponse.fromJson(List<dynamic> json) {
    json.forEach((element) { locations.add(Locations.fromJson(element));});
  }

}

class Locations {
  String id;
  String name;
  List<Address> address;

  Locations({this.id, this.name, this.address});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String nameAddress;
  String detailAddress;
  String area;
  String phone;

  Address({this.nameAddress, this.detailAddress, this.area, this.phone});

  Address.fromJson(Map<String, dynamic> json) {
    nameAddress = json['name_address'];
    detailAddress = json['detail_address'];
    area = json['area'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_address'] = this.nameAddress;
    data['detail_address'] = this.detailAddress;
    data['area'] = this.area;
    data['phone'] = this.phone;
    return data;
  }

  @override
  String toString() {
    return 'Address{nameAddress: $nameAddress, detailAddress: $detailAddress, area: $area, phone: $phone}';
  }

}