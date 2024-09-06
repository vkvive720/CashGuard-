class FakeModel {
  String? uid;
  String? fullname;
  String? email;
  String? notenumber;
  String? currency;
  String? Datetime;

  //constructor function
  FakeModel(
      {this.uid, this.fullname, this.email, this.notenumber, this.currency});

  //creating function from map to recive the values from firebase(deseralisation)
  FakeModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    notenumber = map["notenumber"];
    currency = map["currency"];
    Datetime = map["datetime"];
  }

  //funtion to generate map  for sending data to firebase (serealisation)
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "notenumber": notenumber,
      "currency": currency,
      "datetime": DateTime.now().toString(),
    };
  }
}
