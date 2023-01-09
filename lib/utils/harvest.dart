import '../utils/speculation.dart';
import '../utils/user.dart';

class Harvest{

  late num id;

  late String date;

  late int quantity;

  late User user;

  late Speculation speculation;

  Harvest.fromJson(Map<String,dynamic> json):
    id = json['id'],
    date = json['date'],
    quantity = json['quantity'],
    user = User.fromJson(json['user']),
    speculation = Speculation.fromJson(json['speculation']);
  

}