import '../utils/user.dart';

class IncomingStock{

  late num id;

  late int quantity;

  late String type;

  late String product;

  late int value;

  late String unitValue;

  late int volume;

  late String unitVolume;

  late String date;

  late User user;

  IncomingStock.fromJson(Map<String,dynamic> json):
    id = json['id'],
    quantity = json['quantity'],
    type = json['type'],
    product = json['product'],
    value = json['value'],
    unitValue = json['unitValue'],
    volume = json['volume'],
    unitVolume = json['unitVolume'],
    date = json['date'],
    user = User.fromJson(json['user']);
}