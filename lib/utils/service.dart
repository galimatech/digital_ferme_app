import 'dart:convert';
import '../page/utilWidgets/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CallApi{
    //final String api ='http://192.168.31.96:8080'; //actu
    //final String api = 'http://172.20.10.3:8080'; 
    //final String api ='http://127.0.0.1:8080';
    //final String api ='http://51.178.140.26:8080/digitalFerme';
    final String api ='http://51.178.140.26:8080/digitalFermeV2';
    late String token;

    postData(data, way) async {
    this.token = await getToken();
    var url = Uri.parse(api + way);
    return await http.post(
        url,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

    getData(way) async {
    this.token = await getToken();
    var url = Uri.parse(api + way);
    return await http.get(
        url,
        headers: _setHeaders()
    );
  }

  auth(data) async {
    var url = Uri.parse('$api/authenticate');
    return  await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }
    );
  }

    _setHeaders() =>
      {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization' : 'Bearer $token',
      };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString( 'token' );
    return token;
  }

  logOut(BuildContext context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil<void>(context,MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage(),
      ),ModalRoute.withName("/"));
  }
}