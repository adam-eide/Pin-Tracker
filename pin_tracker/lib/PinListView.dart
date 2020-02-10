import 'dart:math';

import 'package:flutter/material.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';
import 'Objects.dart';


class PinListView extends State {
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  PinListView(this.sets, this.pins, this._drawer);
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("All Pins", style: Theme.of(context).textTheme.title,),

      ),
      drawer: _drawer,
      backgroundColor: Colors.white,
      body: _buildPins(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _buildPins(){
    return ListView(
      children: <Widget>[
        GridView.count(crossAxisCount: 5,
            shrinkWrap: true,
            controller: ScrollController(),children:
          List.generate(pins.length, (index){
            return _pinBox(index);
          })
        )
      ],
    );

  }

  Widget _pinBox(int index){
    if (pins[index].qty > 0){
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Color(0xFF424242), width: 4)),
          foregroundDecoration: BoxDecoration(color: Color(0x88424242), backgroundBlendMode: BlendMode.darken),
          child: Stack(
            children: <Widget>[
              Image.asset('assets/${pins[index].year}/${pins[index].img}'),
              Image.asset('assets/check.png'),
            ],
          ),

        ),
        onDoubleTap: (){
          _activate(index);
          setState(() {

          });
        },
      );
    }
    return GestureDetector(
      child: Container(
        child: Image.asset('assets/${pins[index].year}/${pins[index].img}'),
      ),
      onDoubleTap: (){
        _activate(index);
        setState(() {

        });
      },
    );
  }
  void _activate(int index)async{
    if (pins[index].qty > 0){
      pins[index].qty = 0;
      pins[index].has = false;
      DatabaseHelper.instance.update({"ID":pins[index].id, "Qty":0});
    }
    else{
      pins[index].qty = 1;
      pins[index].has = true;
      DatabaseHelper.instance.update({"ID":pins[index].id, "Qty":1});
    }
  }
}

class PinList extends StatefulWidget{
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  PinList(this.sets, this.pins, this._drawer);

  @override
  PinListView createState() => PinListView(this.sets, this.pins, this._drawer);
}