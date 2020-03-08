class RequestDoralaqua {
  String name;
  String phone;
  String city;
  String address;
  String dayOfWeek;
  String time;
  String description;

  RequestDoralaqua(
      {this.name,
      this.phone,
      this.city,
      this.address,
      this.dayOfWeek,
      this.time,
      this.description});

  @override
  String toString() {
    return 'RequestDoralaqua{name: $name, phone: $phone, city: $city, address: $address, day_of_week: $dayOfWeek, time: $time, description: $description}';
  }


}

class City {
  String name;
  List<String> states = <String>[

  ];

  City(this.name, this.states);


}