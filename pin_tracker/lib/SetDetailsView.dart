import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pin_tracker/db_helper.dart';

class SetDetailsView extends State {
  List<PinSet> sets;
  List<Pin> pins;
  List<int> indexList;
  ScrollController _scrollController;
  SetDetailsView(this.sets, this.pins, this.indexList);
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(keepScrollOffset: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pins[indexList.first].description, style: Theme.of(context).textTheme.title,),

      ),
      backgroundColor: Color(0xFFBBBBBB),
      body: Container(margin: EdgeInsets.symmetric(horizontal: 8),child: _buildDetails()),
    );
  }

  Widget _buildDetails(){
    int split = 0;
    if (indexList.contains(-1)){
      split = indexList.indexOf(-1);
    }
    if (split == 0){
      return ListView(
        scrollDirection: Axis.vertical,
        children:<Widget>[
        GridView.count(crossAxisCount: 2,
          childAspectRatio: .9,
          controller: _scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children:List.generate(indexList.length, (index){
            return _buildDetailTile(index);
          }),
        ),
      ],
      );
    }
    else{
      return ListView(

        children: <Widget>[
          Container(
            child: GridView.count(crossAxisCount: 2,

              childAspectRatio: .9,
              controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children:List.generate(split, (index){
              return _buildDetailTile(index);
            }),
            ),
          ),

          Container(height:40,child: Text("Here are some similar pins")),
          Container(
            child: GridView.count(crossAxisCount: 2,
              childAspectRatio: .9,
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children:List.generate(indexList.length-split-1, (index){
                return _buildDetailTile(split+1+index);
              }),
            ),
          ),
        ],
      );
    }

  }

  Widget _buildDetailTile(int i){
    return Container(
      color: Color(0xFFEEEEEE),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          Expanded(
            flex: 2,
          child: Image.asset('assets/${pins[indexList[i]].year}/${pins[indexList[i]].img}',fit: BoxFit.fitWidth),
          ),
          Expanded(
            //flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                    child: Text(pins[indexList[i]].toString(), style: TextStyle(fontSize: 16),),

                ),
              ],
            ),
          ),
      Expanded(
        flex: 1,
        child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(padding: EdgeInsets.only(left: 6),
                decoration: BoxDecoration(color: Color(0x09000000),border: Border(top: BorderSide(width: 2, color: Colors.black12),right: BorderSide(width: 1, color: Colors.black12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex:1,child: Text("Have", style: TextStyle(fontSize: 16))),
                    Expanded(flex:1,
                      child: Checkbox(
                        activeColor: Colors.pinkAccent,
                        value: pins[indexList[i]].has,
                        onChanged: (v){
                          if (v){
                            pins[indexList[i]].has = true;
                            pins[indexList[i]].qty = 1;
                          }
                          else{
                            pins[indexList[i]].has = false;
                            pins[indexList[i]].qty = 0;
                          }
                          DatabaseHelper.instance.update({
                            "ID":pins[indexList[i]].id,
                            "Qty":pins[indexList[i]].qty
                          });
                          setState(() {

                          });
                        },


                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded( flex: 1,
              child: Container(padding: EdgeInsets.only(left: 6),
                decoration: BoxDecoration(color: Color(0x09000000),border: Border(top: BorderSide(width: 2, color: Colors.black12),left: BorderSide(width: 1, color: Colors.black12))),
                child: Row(
                  children: <Widget>[
                    Expanded(flex:1,child: Text("Mark", style: TextStyle(fontSize: 16))),
                    Expanded(flex:1,
                      child: Checkbox(
                        activeColor: Colors.pinkAccent,
                        value: pins[indexList[i]].isMarked,
                        onChanged: (v){
                          if (v){
                            pins[indexList[i]].isMarked = true;
                            pins[indexList[i]].marked = 1;
                          }
                          else{
                            pins[indexList[i]].isMarked = false;
                            pins[indexList[i]].marked = 0;
                          }
                          DatabaseHelper.instance.update({
                            "ID":pins[indexList[i]].id,
                            "Marked":pins[indexList[i]].marked
                          });
                          setState(() {

                          });
                        },


                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
       ]
      ),

    );

  }

}


class SetDetails extends StatefulWidget{
  List<PinSet> sets;
  List<Pin> pins;
  List<int> indexList;
  SetDetails(this.sets, this.pins, this.indexList);

  @override
  SetDetailsView createState() => SetDetailsView(this.sets, this.pins, this.indexList);
}