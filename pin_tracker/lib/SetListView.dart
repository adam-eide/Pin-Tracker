import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_tracker/SetDetailsView.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';


class SetListView extends State {
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  SetListView(this.sets, this.pins, this._drawer);
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Sets", style: Theme.of(context).textTheme.title,),

      ),
      drawer: _drawer,
      backgroundColor: Colors.white,
      body: _buildSetList(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Widget _buildSetList(){
    return ListView.builder(
        padding: EdgeInsets.zero,
        //controller: _scrollController,
        itemCount: sets.length,
        itemBuilder: (context, i) {
          return _buildSetTile(i);
        }
    );
  }

  Widget _buildSetTile(int i){
    int total = 0;
    for (int x = 0; x <sets[i].size; x++) {
      total += pins[sets[i].startId - 1 + x].qty;
    }
    int pinindex = sets[i].startId - 1;
      return Container(
        color: Color(0xFFBBBBBB),
        width: MediaQuery.of(context).size.width,

      height: 70,
      child: GestureDetector(child: Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Container(color: Colors.white,),
              flex: 1,
            ),
            Expanded(
              child: Container(color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(child: Text(sets[i].year.toString(), style: TextStyle(fontSize: 18)), alignment: Alignment.centerLeft,),
                    Container(child: Text(total.toString() + "/" + sets[i].size.toString(), style: TextStyle(fontSize: 14),),
                        alignment: Alignment.centerLeft)
                  ],
                ),

              ),
              flex: 6,
            ),
            Expanded(
              child: Container(color: Colors.white,child: ((sets[i].size<4)?(Container()):(Image.asset('assets/${sets[i].year}/${pins[pinindex++].img}')))),
              flex: 6,
            ),
            Expanded(
              child: Container(color: Colors.white,child: Image.asset('assets/${sets[i].year}/${pins[pinindex++].img}'),),
              flex: 6,
            ),
            Expanded(
              child: Container(color: Colors.white,child: Image.asset('assets/${sets[i].year}/${pins[pinindex++].img}'),),
              flex: 6,
            ),
            Expanded(
              child: Container(color: Colors.white,child: Image.asset('assets/${sets[i].year}/${pins[pinindex++].img}'),),
              flex: 6,
            ),

          ],



        ),
      ),
        onTap: (){
          _selectSet(i);
        },
      ),
    );
  }

  void _selectSet(int setIndex)async{
    List<int> tempList = await DatabaseHelper.instance.checkForRelevantPins(sets[setIndex].startId);
    List<int> firstList = new List<int>();
    int pinStart = sets[setIndex].startId - 1;
    int series = pins[pinStart].series;
    while (pins[pinStart].series == series && (pinStart < pins.length-1)){
      firstList.add(pinStart++);
    }
    if (tempList.length > 0) {
      firstList.add(-1);
      firstList.addAll(tempList);
    }
    print(firstList);
    Navigator.push(context, MaterialPageRoute(builder: (context)
    {
      return SetDetails(sets, pins, firstList);
    }));
  }

}

class SetList extends StatefulWidget{
  List<PinSet> sets;
  List<Pin> pins;
  Drawer _drawer;
  SetList(this.sets, this.pins, this._drawer);

  @override
  SetListView createState() => SetListView(this.sets, this.pins, this._drawer);
}