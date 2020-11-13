import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:provider/provider.dart';

class DurationList extends StatefulWidget {

  // int change;

  // DurationList({
  //   this.change,
  // });

  @override
  DurationListState createState() => DurationListState();
}

class DurationListState extends State<DurationList> {
  List<String> timeArrived;
  List<String> timeArrived2;
  List<ListTile> listCard;
  List<ListTile> listCard2;
  ProcessData info;
  InfoRouteServer info3;
  List<Widget> linesOf;
  List<Widget> placesForLine;
  double sizeIcon = 35.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //insertData();
  }

  Color hexColor(String hexString) {
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget getTransport2() {
    return Expanded(
      flex: 1, 
      child: Icon(
        Icons.directions_ferry,
        size: sizeIcon,
      )
    );
  }

  Widget getTransport(String mode, int i, int y) {
    Widget dataBus, dataSubway;
    if(mode == null){
      return Expanded(flex: 1, child: Container());
    }
    else{
      if(mode == ''){
        return Expanded(flex: 1, child: Container());
      }
      else if(mode == "WALK"){
        return Expanded(
          flex: 1, 
          child: Icon(
            Icons.directions_walk,
            size: sizeIcon,
          )
        );
      }
      else if(mode == "SUBWAY"){
        if(info3.infoWalkList[i].legs[y].route != null || info3.infoWalkList[i].legs[y].route != ""){
          dataSubway = Container(
            height: 50.0,
            width: 90.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.directions_subway,
                    size: sizeIcon,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 27.0,
                    width: 27.0,
                    decoration: BoxDecoration(
                      color: hexColor(info3.infoWalkList[i].legs[y].routeColor), //Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        info3.infoWalkList[i].legs[y].route,
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          color: hexColor(info3.infoWalkList[i].legs[y].routeTextColor), //Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          dataSubway = Expanded(
            flex: 2, 
            child: Icon(
              Icons.directions_subway,
              size: sizeIcon,
            )
          );
        }
        return dataSubway;
      }
      else{ //if(mode == "BUS"){
        if(info3.infoWalkList[i].legs[y].route != null || info3.infoWalkList[i].legs[y].route != ""){
          dataBus = Container(
            height: 50.0,
            width: 90.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.directions_bus,
                    size: sizeIcon,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 27.0,
                    width: 27.0,
                    decoration: BoxDecoration(
                      color: hexColor(info3.infoWalkList[i].legs[y].routeColor), //Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        info3.infoWalkList[i].legs[y].route,
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          color: hexColor(info3.infoWalkList[i].legs[y].routeTextColor), //Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          dataBus = Expanded(
            flex: 2, 
            child: Icon(
              Icons.directions_bus,
              size: sizeIcon,
            )
          );
        }
        return dataBus; //Expanded(flex: 2, child: Icon(Icons.directions_bus));
      }
    }
  }

  List<Widget> elementsRow2(int i){
    linesOf = null;
    placesForLine = null;
    linesOf = [];
    placesForLine = [];
    try{
      for(int y = 0; y < info3.infoWalkList[i].legs.length; y++){
        placesForLine.add(
          getTransport2(),
        );
        placesForLine.add(
          Expanded(
            flex: 1, 
            child: Icon(Icons.chevron_right, color: Color.fromRGBO(105, 190, 50, 1.0)),
          ),
        );
      }

      placesForLine.removeLast();

      linesOf.add(
        Container(
          width: 400.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: placesForLine,
          ),
        ),
      );
    }
    catch(e){
      print("Error $e");
    }
    return linesOf;
  }

  List<Widget> elementsRow(int i) {
    linesOf = null;
    placesForLine = null;
    linesOf = [];
    placesForLine = [];
    //CONTINUA ACA: SE TIENE QUE REVISAR TODO ESTE METODO QUE GENERA LA LISTA
    try{
      for(int y = 0; y < info3.infoWalkList[i].legs.length; y++){
        placesForLine.add(
          getTransport(info3.infoWalkList[i].legs[y].mode, i, y),
        );
        placesForLine.add(
          Expanded(
            flex: 1, 
            child: Icon(Icons.chevron_right, color: Color.fromRGBO(105, 190, 50, 1.0)),
          ),
        );
      }

      placesForLine.removeLast();

      linesOf.add(
        Container(
          width: 400.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: placesForLine,
          ),
        ),
      );
    }
    catch(e){
      print("Error $e");
    }
    return linesOf;    
  }

  Future<List<Widget>> insertData() async {
    listCard = null;
    listCard2 = null;
    listCard = [];
    listCard2 = [];

    timeArrived = null;
    timeArrived2 = null;
    timeArrived = [];
    timeArrived2 = [];

    for(int i = 0; i < info3.infoWalkList.length; i++){
      try{
        int minutes = (info3.infoWalkList[i].waitingTime / 60).truncate(); //convertir de segundos a minutos
        timeArrived.add("Arrived: ${minutes.toString()} min");

        int minutesDuration = (info3.infoWalkList[i].duration / 60).truncate(); //convertir de segundos a minutos
        timeArrived2.add("${minutesDuration.toString()}");
      }
      catch(e){
        print("Error $e");
      }
    }

    //if(info.changeOfTransport == 0){ //pone datos por defecto
    for(int i = 0; i < info3.infoWalkList.length; i++){
      listCard2.add(
        ListTile(
          onTap: null,
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeArrived[i],
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Duration",
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: elementsRow(i).length,
                          itemBuilder: (context, index){
                            return elementsRow(i)[index];
                          }
                        )
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeArrived2[i],
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              color: Color.fromRGBO(105, 190, 50, 1.0),
                              fontSize: 35.0,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(""),
                              Text(
                                "min",
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  color: Color.fromRGBO(105, 190, 50, 1.0),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      );

      listCard.add(
        ListTile(
          onTap: (){ 
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index: i)));
          },
          title: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeArrived[i],
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Duration",
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: Color.fromRGBO(105, 190, 50, 1.0),
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: elementsRow(i).length,
                          itemBuilder: (context, index){
                            return elementsRow(i)[index];
                          }
                        )
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeArrived2[i],
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              color: Color.fromRGBO(105, 190, 50, 1.0),
                              fontSize: 35.0,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(""),
                              Text(
                                "min",
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  color: Color.fromRGBO(105, 190, 50, 1.0),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
      
    // }
    // else if(info.changeOfTransport== 1){
      
    // }
    // else if(info.changeOfTransport == 2){

    // }
    // else if(info.changeOfTransport == 3){

    // }
    // else if(info.changeOfTransport == 4){

    //   for(int i = 0; i < 3; i++){
    //     listCard2.add(
    //       ListTile(
    //         onTap: null,
    //         title: Container(
    //           padding: EdgeInsets.all(10.0),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10.0),
    //             color: Colors.white,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     timeArrived[i],
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       color: Color.fromRGBO(105, 190, 50, 1.0),
    //                       fontSize: 20.0,
    //                     ),
    //                   ),
    //                   Text(
    //                     "Duration",
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       color: Color.fromRGBO(105, 190, 50, 1.0),
    //                       fontSize: 20.0,
    //                     ),
    //                   ),
    //                 ],
    //               ),
                  
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     flex: 4,
    //                     child: Container(
    //                       width: 100,
    //                       height: 100,
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: elementsRow2(i).length,
    //                         itemBuilder: (context, index){
    //                           return elementsRow2(i)[index];
    //                         }
    //                       )
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 3,
    //                     child: Padding(
    //                       padding: EdgeInsets.only(left: 10.0),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 3,
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Text(
    //                           timeArrived2[i],
    //                           style: TextStyle(
    //                             fontFamily: "AurulentSans-Bold",
    //                             color: Color.fromRGBO(105, 190, 50, 1.0),
    //                             fontSize: 35.0,
    //                           ),
    //                         ),
    //                         Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(""),
    //                             Text(
    //                               "min",
    //                               style: TextStyle(
    //                                 fontFamily: "AurulentSans-Bold",
    //                                 color: Color.fromRGBO(105, 190, 50, 1.0),
    //                               ),
    //                             )
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       )
    //     );
    //     listCard.add(
    //       ListTile(
    //         onTap: (){ 
    //           Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index: i)));
    //         },
    //         title: Container(
    //           padding: EdgeInsets.all(10.0),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10.0),
    //             color: Colors.white,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     timeArrived[i],
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       color: Color.fromRGBO(105, 190, 50, 1.0),
    //                       fontSize: 20.0,
    //                     ),
    //                   ),
    //                   Text(
    //                     "Duration",
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       color: Color.fromRGBO(105, 190, 50, 1.0),
    //                       fontSize: 20.0,
    //                     ),
    //                   ),
    //                 ],
    //               ),

    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     flex: 4,
    //                     child: Container(
    //                       width: 100,
    //                       height: 100,
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: elementsRow(i).length,
    //                         itemBuilder: (context, index){
    //                           return elementsRow(i)[index];
    //                         }
    //                       )
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 3,
    //                     child: Padding(
    //                       padding: EdgeInsets.only(left: 10.0),
    //                     ),
    //                   ),
    //                   Expanded(
    //                     flex: 3,
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Text(
    //                           timeArrived2[i],
    //                           style: TextStyle(
    //                             fontFamily: "AurulentSans-Bold",
    //                             color: Color.fromRGBO(105, 190, 50, 1.0),
    //                             fontSize: 35.0,
    //                           ),
    //                         ),
    //                         Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(""),
    //                             Text(
    //                               "min",
    //                               style: TextStyle(
    //                                 fontFamily: "AurulentSans-Bold",
    //                                 color: Color.fromRGBO(105, 190, 50, 1.0),
    //                               ),
    //                             )
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   }

    // }

    info3.listCanceled = listCard2;
    return listCard;
  }

  //int state = 2; //0: bus, 1: cicla, 2: a pie

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ProcessData>(context);
    info3 = Provider.of<InfoRouteServer>(context);

    return Container( //info.listOfTransport = Container(
      height: MediaQuery.of(context).size.height - 90.0,
      width: MediaQuery.of(context).size.width - 30.0,
      child: FutureBuilder(
        future: insertData(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
          if(snapshot.hasData){
            info.widgetList = null;
            info.widgetList = [];
            info.widgetList = snapshot.data;
            return ListView.separated(
              separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
              itemCount: timeArrived.length,
              itemBuilder: (BuildContext context, int index){
                return snapshot.data[index];
              }, 
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
      ),
    );

  }
}