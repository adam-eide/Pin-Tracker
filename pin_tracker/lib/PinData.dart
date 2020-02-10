import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_tracker/SetDetailsView.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';


class SetListView extends State{
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  int owned;
  int marked;
  DataTable _dataTable;
  SetListView(this.sets,this.pins,this._drawer);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData()async{
    marked = (await DatabaseHelper.instance.getList(1)).length;
    owned = (await DatabaseHelper.instance.getList(2)).length;
    setState(() {
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Data", style: Theme.of(context).textTheme.title,),

      ),
      drawer: _drawer,
      backgroundColor: Colors.white,
      body: _buildData(),
    );
  }
  Widget _buildData(){

    return Container(
      padding: EdgeInsets.all(8),
      //width: MediaQuery.of(context).size.width*.5,
      child: ListView(
        children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("Pins Collected"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(owned.toString()),
                ),
              ],
            ),
          Divider(height: 1,color: Color(0xFF424242),),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("Pins Marked"),
                ),
                Expanded(
                  flex: 1,
                  child: Text(marked.toString()),
                ),
              ],
          ),
          Container(
            height: 80,
          ),
          GestureDetector(
            child: Container(padding: EdgeInsets.all(8),
                color: Colors.red,
                child: Text("Double tap to reset marked pins to none",style: TextStyle(fontSize: 20),)),
            onDoubleTap: (){
              pins.forEach((p){p.isMarked = false;p.marked=0;});
              marked = 0;
              reset("Marked=0");


            },
          ),
          Container(
            height: 30,
          ),
          GestureDetector(
            child: Container(padding: EdgeInsets.all(8),
    color: Colors.red,
    child: Text("Double tap to reset owned pins to none",
        style: TextStyle(fontSize: 20))),
            onDoubleTap: (){
              pins.forEach((p){p.has = false;p.qty=0;});
              owned = 0;
              reset("Qty=0");


            },
          ),
        ],
      ),
    );
  }

  void reset(String s)async{
    DatabaseHelper.instance.database.then((db){db.rawQuery("UPDATE Pins SET ${s}");setState(() {

    });
    });
  }
}



class PinData extends StatefulWidget{
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  PinData(this.sets, this.pins, this._drawer);

  @override
  SetListView createState() => SetListView(this.sets, this.pins, this._drawer);
}