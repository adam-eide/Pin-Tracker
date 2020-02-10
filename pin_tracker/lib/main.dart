import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_tracker/MarkedPinView.dart';
import 'package:pin_tracker/PinData.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';
import 'SetListView.dart';
import 'PinListView.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pin Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF424242),
        accentColor: Color(0xFFec407a),
        canvasColor: Color(0x556d6d6d),
        backgroundColor: Color(0x121212),
        textTheme: TextTheme(
        headline: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0xEEe0e0e0)),
        body1: TextStyle(fontSize: 25.0,color: Color(0xFF424242)),
        body2: TextStyle(fontSize: 10.0,color: Color(0xFFe0e0e0)),
        ),
      ),

      home: MyHomePage(title: 'Pin Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

StatusInfo _status;
List<PinSet> sets;
List<Pin> pins;
Drawer _drawer;
class _MyHomePageState extends State<MyHomePage> {

  final dbHelper = DatabaseHelper.instance;



  @override
  void initState() {
    sets = new List<PinSet>();
    pins = new List<Pin>();
    fullPinRead();
    super.initState();
    _drawer = new Drawer(

      elevation: 1,
        child: Container(color: Color(0xFFCCCCCC),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("HEADER"),
                decoration: BoxDecoration(color: Color(0xFF424242)),
              ),
              ListTile(

                title: Text("Pin Sets", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0xFF121212)),),
                onTap: (){

                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) { return SetList(sets, pins, _drawer);}));
                },
              ),
              Container(color: Color(0x77737373),height: 2,),
              ListTile(
                title: Text("All Pins", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0xFF121212))),
                onTap: (){

                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) { return PinList(sets, pins, _drawer);}));
                },
              ),
              Container(color: Color(0x77737373),height: 2,),
              ListTile(
                title: Text("Wish List", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0xFF121212))),
                onTap: (){

                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) { return MarkedPinList(sets, pins, _drawer);}));
                },
              ),
              Container(color: Color(0x77737373),height: 2,),
              ListTile(
                title: Text("Data", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0xFF121212))),
                onTap: (){

                  Navigator.pop(context);
                  Navigator.push(context, new MaterialPageRoute(builder: (context) { return PinData(sets, pins, _drawer);}));
                },
              ),
              Container(color: Color(0x77737373),height: 2,),
              ListTile(
                title: Text("Settings", style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: Color(0x99121212))),
                onTap: (){

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );


    print("init READ DONE");

  }


  void fullPinRead() async {
    List<Map<String, dynamic>> temp = await DatabaseHelper.instance
        .queryAllRows();
    for (var p in temp) {
      pins.add(Pin(
          p["ID"],
          p["Path"],
          p["Qty"],
          p["Year"],
          p["Series"],
          p["Number"],
          p["Marked"],
          p["Description"]));
      if (p["Number"] == 1) {


        sets.add(PinSet(p["Year"], p["Series"], p["ID"], ((p["Description"].toString().startsWith("CMP")) ? ("Completer") : (p["Description"].toString()))));
        sets.last.size = await dbHelper.getSetSize(p["Year"], p["Series"]);

      }
    }
    print("PIN READ DONE");
    Navigator.pop(context);
    Navigator.push(context, new MaterialPageRoute(builder: (context) { return PinData(sets, pins, _drawer);}));
  }


  @override
  Widget build(BuildContext context) {
    print("Starting Build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Pin Tracker"),
      ),
      drawer: _drawer,
      body: _buildHome(),
    );
  }

  Widget _buildHome(){

    return Container(alignment: Alignment.center, child: Text("Loading"),);
  }
}
