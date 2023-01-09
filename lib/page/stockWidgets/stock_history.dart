import 'dart:convert';

import '../../utils/outGoingStock.dart';
import '../../utils/service.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StockHistoryPage extends StatefulWidget {
  const StockHistoryPage({ Key? key }) : super(key: key);

  @override
  State<StockHistoryPage> createState() => _StockHistoryPageState();
}

class _StockHistoryPageState extends State<StockHistoryPage> {
  late bool load = true;
  late DateFormat dateFormat;
  List<OutGoingStock> stocks = [];
  List<OutGoingStock> showStocks = [];

@override
  void initState() {
    initializeDateFormatting(); 
    dateFormat = new DateFormat.yMMMMEEEEd('fr');
    getData();
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
          /* actions: <Widget>[ IconButton(icon: const Icon(Icons.local_florist_outlined),onPressed: () {})], */
        )),
      body: Container( child: load ? Center(child: SpinnerWidget()) : layout(),
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),)
    );
  }

    Widget layout(){
    return ListView(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "recherche compte"),
            onChanged: (pattern) => filterItem(pattern),),),
            itemList(),
        ],
    );
  }

/*   Widget layout(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Nom du produit"),
            onChanged: (value) => filterItem(value)),
        ),
        itemList()
      ],
    );
  } */

  Widget itemList(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 7.5),  scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6,),borderRadius: BorderRadius.all(Radius.circular(15))),
          dataTextStyle: TextStyle(color: Colors.white),
          headingTextStyle: TextStyle(color: Colors.green),
          columns: [
            DataColumn(label: Text('Produit',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Quantité',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Date',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Origine',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Auteur',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),))
          ],
          rows: showStocks.map((stock) => DataRow(cells: [
            DataCell(Text(stock.product, style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),)),
            DataCell(Text(stock.quantity.toString())),
            DataCell(Text(formatDate(stock.date))),
            DataCell(Text(stock.comesFrom)),
            DataCell(Text(stock.user.name))
          ])).toList(),
        ),),
    );
  }

  void filterItem(pattern){
    setState(() {
      showStocks = stocks.where((element) => element.product.startsWith(pattern)).toList();
    });
  }

  Future<void> getData() async {
    var res = await CallApi().getData("/api/v1/stock/byMe");
    var body = jsonDecode(utf8.decode(res.bodyBytes));
    if(body['success']){
      for(var json in body['object']){
        stocks.add(OutGoingStock.fromJson(json));
      }
      showStocks = stocks;
      setState(() {
        load = false;
      });
    }
  }

  String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime);
    return formattedDate;
  }
}