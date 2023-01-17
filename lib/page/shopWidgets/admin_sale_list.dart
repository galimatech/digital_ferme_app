import 'dart:convert';

import 'package:flutter/material.dart';

import '../../utils/sale.dart';
import '../../utils/service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../widget/spinner_widget.dart';

class AdminSaleNews extends StatefulWidget {
  const AdminSaleNews({Key? key}) : super(key: key);

  @override
  State<AdminSaleNews> createState() => _AdminSaleNewsState();
}

class _AdminSaleNewsState extends State<AdminSaleNews> {
  String priceTotal = '';
  String advanceTotal = '';
  String accountTotal = '';
  List<Sale> sales = [];
  bool load = true;
  late DateFormat dateFormat;
  late DateFormat timeFormat;

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
    timeFormat = new DateFormat.Hms('fr');
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: ClipRect(child: Image.asset('images/logoFarm.gif',width: 60.0,height: 60.0,)),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height - 62,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/shop.jpg"),fit: BoxFit.cover,),),
          child: load? Center(child: SpinnerWidget()) :layout(),
        ));
  }

  Widget layout(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: itemTotal()),
        Expanded(flex: 5,  child:itemList())
      ],
    );
  }

  Widget itemTotal(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 7.5,vertical: 5.0),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
        dataTextStyle: TextStyle(color: Colors.white),
        headingTextStyle: TextStyle(color: Colors.green),
        columns: const [
          DataColumn(label: Text('Total vente',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
          DataColumn( numeric: true, label: Text('Encaissé',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          DataColumn( numeric: true,label: Text('Dette',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        ],
        rows: [DataRow(cells: [
          DataCell(Text(priceTotal,style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          DataCell(Text(advanceTotal,style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          DataCell(Text(accountTotal,style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        ])],),
    );
  }

  Widget itemList(){
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 7.5),
        scrollDirection: Axis.horizontal,
        child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child : DataTable(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
                dataTextStyle: TextStyle(color: Colors.white),
                headingTextStyle: TextStyle(color: Colors.green),
                //border: TableBorder.all(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
                columns:
                const [
                  DataColumn(label: Text('Produit',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
                  DataColumn( numeric: true, label: Text('Quantité',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataColumn( numeric: true,label: Text('Montant total',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataColumn( numeric: true,label: Text('Montant recu',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataColumn( numeric: true,label: Text('Restant',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Caissier',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Date',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                ],
                rows:sales.map((sale) => DataRow(cells: [
                  DataCell(Text(sale.product,style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),)),
                  DataCell(Text(sale.quantity.toString())),
                  DataCell(Text(sale.price.toString(),style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  DataCell(Text(sale.advance.toString())),
                  DataCell(Text(sale.account.toString())),
                  DataCell(Text(sale.user.toString())),
                  DataCell(Text(formatDate(sale.date))),
                ])).toList())));
  }

  String formatDate(String date){
    DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime)+"   "+timeFormat.format(_dateTime);
    return formattedDate;
  }

  Future<void> getNews() async{
    var res = await CallApi().getData("/api/v1/admin/sales");
    if(res.statusCode == 401){
      CallApi().logOut(context);
    }else{
      var body = jsonDecode(utf8.decode(res.bodyBytes));
      print(body);
      if (body['success']) {
        for (var item in body['object']) {
          sales.add(Sale.fromJson(item));
        }
        if(body['object'].length > 0) {
          setState(() {
            priceTotal = sales
                .map((e) => e.price)
                .toList()
                .reduce((value, element) => value + element)
                .toString();
            accountTotal = sales
                .map((e) => e.account)
                .reduce((value, element) => value + element)
                .toString();
            advanceTotal = sales
                .map((e) => e.advance)
                .reduce((value, element) => value + element)
                .toString();
            load = false;
          });
        }
      }
    }
  }
}
