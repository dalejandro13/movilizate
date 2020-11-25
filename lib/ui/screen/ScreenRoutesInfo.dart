import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';
import 'package:movilizate/ShowTheRoute.dart';
import 'package:here_sdk/core.dart';



// class ScreenMap extends StatefulWidget {

//   int index;

//   ScreenMap(int index){
//     this.index = index;
//   }

//   @override
//   _ScreenMapState createState() => _ScreenMapState();
// }

// class _ScreenMapState extends State<ScreenMap> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }



class ScreenMap extends StatefulWidget {

  int index;
  GetDataOfRoutes routes;
  
  ScreenMap(int index, BuildContext context){    
    this.index = index;
    routes = GetDataOfRoutes(context);
  }

  @override
  _ScreenMapState createState() => _ScreenMapState();
}

class _ScreenMapState extends State<ScreenMap> {

  // ignore: avoid_init_to_null
  ProcessData info = null;
  // ignore: avoid_init_to_null
  InfoRouteServer info3 = null;
  // ignore: avoid_init_to_null
  ShowTheRoute routing = null;
  // ignore: avoid_init_to_null
  List<CardInfoRoutes> cardInfo = null;
  //HereMapController mapCtrl;


  // Widget cardInfoRoute(int index, IconList icon, BuildContext context, bool enable){
  //   return ListTile(
  //       title: Padding(
  //       padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
  //       child: Container(
  //         height: 140.0,
  //         width: 70.0,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8.0),
  //           color: Colors.white,
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [

  //                 Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     icon.timeArrived,
  //                     style: TextStyle(
  //                       fontFamily: "AurulentSans-Bold",
  //                       color: material.Color.fromRGBO(105, 190, 50, 1.0),
  //                       fontSize: 20.0,
  //                     ),
  //                   ),
  //                 ),

  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.0),
  //                   child: Text(
  //                     "Duration",
  //                     style: TextStyle(
  //                       fontFamily: "AurulentSans-Bold",
  //                       color: material.Color.fromRGBO(105, 190, 50, 1.0),
  //                       fontSize: 20.0,
  //                     ),
  //                   ),
  //                 ),

  //               ],
  //             ),

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [

  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
  //                   child: Container(
  //                     height: 50.0,
  //                     width: 160.0,
  //                     decoration: BoxDecoration(
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //                 ),

  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.0, bottom: 10.0),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         icon.timeDuration,
  //                         style: TextStyle(
  //                           fontFamily: "AurulentSans-Bold",
  //                           color: material.Color.fromRGBO(105, 190, 50, 1.0),
  //                           fontSize: 35.0,
  //                         ),
  //                       ),

  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(""),

  //                           Text(
  //                             "min",
  //                             style: TextStyle(
  //                               fontFamily: "AurulentSans-Bold",
  //                               color: material.Color.fromRGBO(105, 190, 50, 1.0),
  //                             ),
  //                           )
  //                         ],
  //                       )

  //                     ],
  //                   ),
  //                 ),

  //               ],
  //             ),

  //           ],
  //         ),
  //       ),
  //     ),
  //     onTap: enable ? (){
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index, context)));
  //     }:
  //     null,
  //   );
  // }





  void getDataToShow() async {
    cardInfo = null;
    cardInfo = [];
    print("El indice es: ${widget.index}");

    cardInfo.add(
      CardInfoRoutes(
        hourStart: "10:05 am",
        iconTransportMedium: Icon(Icons.directions_walk),
        hourEnds: "10:09 am",
        placeStartIn: "Ayura Motors",
        placeEndsIn: "Paradero Jumbo Las Vegas",
        nameTrasportMedium: "Walk",
        infoOfDistance: Text("3000m"),
        time: "4 min",
      )
    );

    cardInfo.add(
      CardInfoRoutes(
        hourStart: "10:09 am",
        iconTransportMedium: Icon(Icons.directions_bus),
        hourEnds: "10:40 am",
        placeStartIn: "Paradero Jumbo Las Vegas",
        placeEndsIn: "Paradero Colegio Cumbres",
        nameTrasportMedium: "Use route",
        infoOfDistance: Text("R1 / R3 / R8"),
        time: "31 min",
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataToShow();
  }
  
  void onMapCreated(HereMapController hereMapController) async {
    //info.mapController = hereMapController;
    //mapCtrl = hereMapController;
    routing = ShowTheRoute(context, hereMapController);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {
      if(error == null) {
        hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(6.245560, -75.600020), 2000);
      }
      else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });

    //routing.testOfDrawLine(); //NO BORRAR
    // routing.originAndDestiny().then((waypoints) async {
    //   await routing.carRoute(waypoints);
    //   await routing.walkingRoute(waypoints);
    //   await routing.truckRoute(waypoints);
    // });
    routing.pointOriginDestiny(widget.index);
    
  }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ProcessData>(context);
    info3 = Provider.of<InfoRouteServer>(context);

    info.infoRoutes = null;
    info.infoRoutes = [];
    info.infoRoutes = cardInfo;
    return Scaffold(
      body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: material.Color.fromRGBO(105, 190, 50, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 12.0),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back), 
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: CardInfoRoute(widget.index, widget.routes.infoCard.listOfInfo.value[widget.index], context, true), //cardInfoRoute(widget.index, widget.routes.infoCard.listOfInfo.value[widget.index], context, false)  //info3.onTapCanceledList[widget.index],--- //info.listW[widget.index],
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     color: Colors.transparent,
              //   ),
              // ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),

          Expanded( //mapa
            flex: 4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400.0,
              child: HereMap(
                onMapCreated: onMapCreated,
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.separated(
                separatorBuilder: (_,__) => Container(width: 20.0, height: 20.0,child: Divider(height: 5.0, color: Colors.grey[300])),
                itemCount: info.infoRoutList.length,
                itemBuilder: (BuildContext context, int inx){
                  return Container(
                    height: 180.0,
                    child: ListTile(
                    onTap: (){},
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              ),
                              Text(
                                info.infoRoutes[inx].hourStart,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 10.0,
                                ),
                              ),
                              info.infoRoutes[inx].iconTransportMedium,
                              Text(
                                info.infoRoutes[inx].hourEnds,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 10.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          //VerticalDivider(color: Colors.grey[300]),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                              ),
                              Text(
                                "Starts in: ",
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                info.infoRoutes[inx].nameTrasportMedium,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 13.0,
                                ),
                              ),
                              Text(
                                "Ends in: ",
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 14.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                              ),
                              Text(
                                info.infoRoutes[inx].placeStartIn,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 10.0,
                                ),
                              ),
                              info.infoRoutes[inx].infoOfDistance,
                              Text(
                                info.infoRoutes[inx].placeEndsIn,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 10.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                info.infoRoutes[inx].time,
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded( //zona inferior de la interfaz
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),


        ],
      ),
    ),
    
    );
  }
}