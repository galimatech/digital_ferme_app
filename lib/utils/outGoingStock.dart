
import 'package:agri_galimatech/utils/user.dart';

class OutGoingStock{

  late num id;

  late String product;

  late String comesFrom;

   late int quantity;

   late String date;

   late User user;

   OutGoingStock.fromJson(Map<String,dynamic> json):
    id = json['id'],
    product = json['produit'],
    comesFrom = json['comesFrom'].toString(),
    quantity = json['quantity'],
    date = json['createdOn'],
    user = User.fromJson(json['user']);
}