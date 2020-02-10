import 'dart:math';

import 'package:flutter/material.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';
import 'Objects.dart';


class MarkedPinListView extends State {
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  List<int> marked;
  MarkedPinListView(this.sets, this.pins, this._drawer);
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Wish List", style: Theme.of(context).textTheme.title,),

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
    marked = new List();
    _getMarked();

  }

  void _getMarked()async{
    DatabaseHelper.instance.getList(1).then((m){marked = m; setState(() {

    });});
  }

  Widget _buildPins(){
    return ListView(
      children: <Widget>[
        GridView.count(crossAxisCount: 4,
            shrinkWrap: true,
            controller: ScrollController(),children:
            List.generate(marked.length, (index){
              return _pinBox(marked[index]);
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
          _getMarked();
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
     _pinPopUp(index);
    }
  }
  Future<void> _pinPopUp(int i) async {
    switch (await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Color(0xFFEEEEEE),contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            children: <Widget>[
              Text(pins[i].toString()),
              Container(decoration: BoxDecoration(border: Border.all(width: 2, color: Theme.of(context).primaryColor)),
                child: SimpleDialogOption(
                  onPressed: () { Navigator.pop(context,1 ); },
                  child: Text('Remove from wish list', style: TextStyle(color: Theme.of(context).primaryColor),),
                ),
              ),
              Container(height: 8,),
              Container(decoration: BoxDecoration(border: Border.all(width: 2, color: Theme.of(context).primaryColor)),
                child: SimpleDialogOption(
                  onPressed: () { Navigator.pop(context,2 ); },
                  child: Text('Add to collection and\n remove from list', style: TextStyle(color: Theme.of(context).primaryColor),),
                ),
              ),

            ],
          );
        }
    )) {
      case 1:
        pins[i].isMarked = false;
        pins[i].marked = 0;
        dbHelper.update({"ID": (i+1), "Marked": 0});
        break;
      case 2:
        pins[i].isMarked = false;
        pins[i].marked = 0;
        pins[i].qty = 1;
        pins[i].has = true;
        DatabaseHelper.instance.update({"ID":pins[i].id, "Qty":1, "Marked":0});
        break;
    }
    _getMarked();
  }
}

class MarkedPinList extends StatefulWidget{
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  MarkedPinList(this.sets, this.pins, this._drawer);

  @override
  MarkedPinListView createState() => MarkedPinListView(this.sets, this.pins, this._drawer);
}