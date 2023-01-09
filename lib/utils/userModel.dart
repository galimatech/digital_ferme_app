/* import 'dart:convert';

import 'package:flutter/material.dart';
import '../../page/utilWidgets/home.dart';
import '../../utils/service.dart';

import 'package:shared_preferences/shared_preferences.dart';



class UserModel extends ChangeNotifier {
  

  bool _isLoading = false;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkedLoad = false;
  bool crypte = false;
  late String role;
  late BuildContext context;

/*   UserModel(TextEditingController mailController,TextEditingController passwordController ){
    mailController=mailController;
    passwordController=passwordController;

  } */

  

  authProvier() async {

    var data = {'username': mailController.text, 'password': passwordController.text};

    var res = await CallApi().auth(data);
    final body = json.decode(res.body);
    notifyListeners();
    
    

    if (body['data']['token'] != null) {
      print('yes');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['data']['token']);
      localStorage.setString('user', body['data']['firstname'] + " " + body['data']['lastname']);
      localStorage.setString('role', body['data']['role']);
      localStorage.setString('username', body['data']['username']); 
      notifyListeners();
         
    /*   Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Provider(create: (context) => this.role, builder: (context, child) => HomePage());
        }),
      ); */
   
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return HomePage();
        }),
      ); 
    }else{
      _showMsg(context, "Login ou mot de passe incorrect");
    } 
    //print(MediaQuery.of(context).size.height);
    //print(MediaQuery.of(context).size.width);
  }

    _showMsg(BuildContext contetxt, msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  
} */