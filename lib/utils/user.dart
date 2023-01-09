
class User {
  late num id;
  late String lastname;
  late String firstname;
  late String name;
  late String role;


  User.fromJson(Map<String, dynamic> json):
    id = json['id'],
    lastname = json['lastname'],
    firstname = json['firstname'],
    name = json['firstname']+" "+json['lastname'],
    role= json['role']['roleName'];
}