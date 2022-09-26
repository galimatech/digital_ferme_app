import '../utils/categoryCompte.dart';
import '../utils/compte.dart';

class Operation{

  late num id;

  late String label;

  late String comment;

  late int amount;

  late String date;

  late Compte compte;

  late CategoryCompte? category;

  late String createdOn;

  late String updatedOn;

  Operation.fromJson(Map<String,dynamic> json):
    id = json['id'],
    label = json['label'],
    comment = json['comment'] == null ? "Non décrit" : json['comment'],
    amount = json['amount'],
    date = json['date'],
    compte = Compte.fromJson(json['compte']),
    category = json['category'] == null ? null : CategoryCompte.fromJson(json['category']),
    updatedOn = json['updatedOn'] == null ? null : json['updatedOn'] ,
    createdOn = json['createdOn'] == null ? null : json['createdOn'];

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = new Map<String,dynamic>();

    map['id'] = id;
    map['label'] = label;
    map['comment'] = comment;
    map['amount'] = amount;
    map['date'] = date;
    map['compte'] = compte.toMap();
    map['category'] = category!.toMap();
    map['createdOn'] = createdOn;
    map['updatedOn'] = updatedOn;

    return map;
  }
}