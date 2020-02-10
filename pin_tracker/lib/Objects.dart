class PinSet{
  int year;
  int series;
  int startId;
  int size;
  String description;
  PinSet(this.year, this.series, this.startId, this.description);

  String toString(){
    return "Year: " + year.toString() + ", series: " + series.toString() + ", desc: " + description;
  }

}

class Pin{
  int id;
  String img;
  int qty;
  int year;
  int series;
  int number;
  int marked;
  String description;
  bool has;
  bool isMarked;
  Pin(this.id, this.img, this.qty, this.year, this.series, this.number, this.marked, this.description){
    if (marked == 0) isMarked = false; else isMarked = true;
    if (qty == 0) has = false; else has = true;
  }
  String toString(){
    String d = description;
    if (d.contains("CMP")){
      d = "Chaser Series";
    }
    return d + "\n" + year.toString() + " Set " + series.toString() + ", " + "Pin " + number.toString();
  }
}


class StatusInfo{
  Map<int, int> year_to_index = {2006: 0, 2007: 76, 2008: 128, 2009: 213, 2010: 288, 2011: 348, 2012: 408, 2013: 500, 2014: 575, 2015: 637, 2016: 699, 2017: 699, 2018: 729, 2019: 800, 2020: 905};
  List<int> markedPins;
  List<int> ownedPins;
  StatusInfo(this.markedPins, this.ownedPins);


}