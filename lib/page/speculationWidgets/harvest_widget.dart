import 'dart:convert';


import '../../utils/harvest.dart';
import '../../utils/service.dart';
import '../../widget/spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HarvestPage extends StatefulWidget {
  const HarvestPage({ Key? key }) : super(key: key);

  @override
  State<HarvestPage> createState() => _HarvestPageState();
}

class _HarvestPageState extends State<HarvestPage> {
  bool load = true;
  List<Harvest> harvests = [];
  List<Harvest> showHarvest = [];
  late DateFormat dateFormat;

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
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/speculation.jpg"),fit: BoxFit.cover,),),
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),)
    );
  }

  Widget layout(){
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
  }

  Widget itemList(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
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
            DataColumn(label: Text('Plantation',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold) )),
            DataColumn(label: Text('Auteur',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),))
          ],
          rows: showHarvest.map((harvest) => DataRow(cells: [
            DataCell(Text(harvest.speculation.seedName, style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),)),
            DataCell(Text(harvest.quantity.toString())),
            DataCell(Text(formatDate(harvest.date))),
            DataCell(Text(harvest.speculation.plantingName)),
            DataCell(Text(harvest.user.name))
          ])).toList(),
        ),),
    );
  }

  Future<void> getData() async {
    var res = await CallApi().getData("/api/v1/harvest");
    var body = jsonDecode(utf8.decode(res.bodyBytes));

     if(body['success']){
      for(var json in body['object'] ){
        harvests.add(Harvest.fromJson(json));
      }
      showHarvest = harvests;
      setState(() {
        load = false;
      });
    } 
  }

  void filterItem(pattern){
    setState(() {
      showHarvest = harvests.where((element) => element.speculation.seed.seedName.startsWith(pattern)).toList();
    });
  }

  String formatDate(String date){
   DateTime _dateTime = DateTime.parse(date);
    String formattedDate = dateFormat.format(_dateTime);
    return formattedDate;
  }
}