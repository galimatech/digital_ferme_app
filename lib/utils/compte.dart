class Compte{

  late num id;

  late String number;

  late String name;

  late Compte? parent;

  Compte.fromJson(Map<String,dynamic> json):
    id = json['id'],
    number = json['number'],
    name = json['name'],
    parent = json['parent'] == null ? null : Compte.fromJson(json['parent']);

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();

    map['id'] = id;
    map['number'] = number;
    map['name'] = name;
    map['parent'] = parent == null ? null: parent!.toMap();

    return map;
  }
}