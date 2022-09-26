class CategoryCompte{

  late num id;

  late String name;

  late bool debitAccount;

  CategoryCompte.fromJson(Map<String,dynamic> json):
    id = json['id'],
    name = json['name'],
    debitAccount = json['debitAccount'];

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = new Map<String,dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['debitAccount'] = debitAccount;

    return map;
  }
}