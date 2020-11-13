import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenResult.dart';
import 'package:movilizate/ui/widget/DurationList.dart';
import 'package:provider/provider.dart';

class ModesOfTransport extends StatefulWidget {

  // ConsultServer consult;

  // ModesOfTransport({
  //   this.consult,
  // });

  @override
  _ModesOfTransportState createState() => _ModesOfTransportState();
}

class _ModesOfTransportState extends State<ModesOfTransport> {

  bool bus = true, walk = false, bicycle = false, subway = false;
  int f = 1, count = 0; 
  double width = 150.0, h = 90.0; //antes en 150.0
  bool w = false, b = false, s = false, bc = false; //bc: bicycle, s: subway, b: bus, w: walk
  List<Widget> listElements;
  ProcessData info;

  Future<List<Widget>> getTheWidget() async {
    listElements = null;
    listElements = [];
    for(int i = 0; i < count; i++){
      if(s){
        listElements.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: subway ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      subway = true;
                      bus = false;
                      bicycle = false;
                      walk = false;
                      //info.changeOfTransport = 1;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_subway,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "35 min",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            " ",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        s = false;
      }
      else if(b){
        listElements.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: bus ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
                ),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      subway = false;
                      bus = true;
                      walk = false;
                      bicycle = false;
                      //info.changeOfTransport = 2;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_bus,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "58 min",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            "250Kcal",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        b = false;
      }
      else if(bc){
        listElements.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: bicycle ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
                ),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      subway = false;
                      bus = false;
                      walk = false;
                      bicycle = true;
                      //info.changeOfTransport = 3;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_bike,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "58 min",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            "250Kcal",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        bc = false;
      }
      else if(w){
        listElements.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: h,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: walk ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
                ),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      subway = false;
                      bus = false;
                      walk = true;
                      bicycle = false;
                      // info.listOfTransport[1] = ListTile(
                      //   title: Text("Bienvenido"),
                      // );
                      info.listOfTransport.add(
                        ListTile(
                          title: Container(
                            height: 150.0,
                            width: 300.0,
                            child: Text("Bienvenido")
                          ),
                        )
                      );

                    });

                      // subway = false;
                      // bus = false;
                      // walk = true;
                      // bicycle = false;
                      // //info.widgetList.removeAt(1);
                      // info.listOfTransport[1] = ListTile(
                      //   title: Text("Bienvenido"),
                      // );
                      // for(int i = 0; i < info.listOfTransport.length; i++){
                      //   print("$i: ${info.listOfTransport[i]}");
                      // }
                      //info.changeOfTransport = 4;
                      //info.listOfTransport;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_walk,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "58 min",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            "250Kcal",
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              fontSize: 11.0,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        w = false;
      }
    }
    count = 0;
    return listElements;
  }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ProcessData>(context);
    var info3 = Provider.of<InfoRouteServer>(context);

    //tomar informacion de la lista
    for(int i = 0; i < info3.infoWalkList.length; i++){
      for(int j = 0; j < info3.infoWalkList[i].legs.length; j++){
        if(info3.infoWalkList[i].legs[j].mode == "WALK"){
          w = true;
          count++;
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BUS"){
          b = true;
          count++;
        }
        else if(info3.infoWalkList[i].legs[j].mode == "SUBWAY"){
          s = true;
          count++;
        }
        else{
          print("transporte en bicicleta");
          bc = true;
          count++;
        }
      }
    }

    return Container(
    width: MediaQuery.of(context).size.width - 60.0,
    height: h,
    child: FutureBuilder(
      future: getTheWidget(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot){
        if(snapshot.hasData){
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.0),
                  ),
                  Center(child: snapshot.data[index]),
                  Padding(
                    padding: EdgeInsets.only(right: 50.0),
                  ),
                ],
              );
            }, 
          );
        }
        else{
          return CircularProgressIndicator();
        }
      }
    )

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [

    //     Padding(
    //       padding: EdgeInsets.only(left: 30.0),
    //     ),

    // Expanded(
    //   flex: f,
    //   child: Container(
    //     height: h,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8.0),
    //       color: bus ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
    //     ),
    //     child: InkWell(
    //       onTap: (){
    //         setState(() { 
    //           bus = true;
    //           walk = false;
    //           bicycle = false;
    //         });
    //       },
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(
    //             Icons.directions_bus,
    //             size: 40.0,
    //             color: Colors.white,
    //           ),
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "35 min",
    //                 style: TextStyle(
    //                   fontFamily: "AurulentSans-Bold",
    //                   fontSize: 11.0,
    //                   color: Colors.white
    //                 ),
    //               ),
    //               Text(
    //                 " ",
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ),

    // Padding(
    //   padding: EdgeInsets.only(left: 10.0),
    // ),

    // Expanded(
    //   flex: f,
    //   child: Container(
    //     height: h,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8.0),
    //       color: walk ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
    //     ),
    //     child: InkWell(
    //       onTap: (){
    //         setState(() { 
    //           bus = false;
    //           walk = true;
    //           bicycle = false;
    //         });
    //       },
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(
    //             Icons.directions_walk,
    //             size: 40.0,
    //             color: Colors.white,
    //           ),
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "58 min",
    //                 style: TextStyle(
    //                   fontFamily: "AurulentSans-Bold",
    //                   fontSize: 11.0,
    //                   color: Colors.white
    //                 ),
    //               ),
    //               Text(
    //                 "250Kcal",
    //                 style: TextStyle(
    //                   fontFamily: "AurulentSans-Bold",
    //                   fontSize: 11.0,
    //                   color: Colors.white
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ),

    //     Padding(
    //       padding: EdgeInsets.only(left: 10.0),
    //     ),

    //     Expanded(
    //       flex: f,
    //       child: Container(
    //         height: h,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8.0),
    //           color: bicycle ? Color.fromRGBO(87, 114, 26, 1.0): Colors.transparent,
    //         ),
    //         child: InkWell(
    //           onTap: (){
    //             setState(() { 
    //               bus = false;
    //               walk = false;
    //               bicycle = true;
    //             });
    //           },
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Icon(
    //                 Icons.directions_bike,
    //                 size: 40.0,
    //                 color: Colors.white,
    //               ),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     "  10 min",
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       fontSize: 11.0,
    //                       color: Colors.white
    //                     ),
    //                   ),
    //                   Text(
    //                     "  80Kcal",
    //                     style: TextStyle(
    //                       fontFamily: "AurulentSans-Bold",
    //                       fontSize: 11.0,
    //                       color: Colors.white
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),

    //     Padding(
    //       padding: EdgeInsets.only(left: 30.0),
    //     ),

    //   ],
    // ),


      );
  }
}