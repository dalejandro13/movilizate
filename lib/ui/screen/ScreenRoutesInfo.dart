import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';
import 'package:movilizate/ShowTheRoute.dart';
import 'package:here_sdk/core.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/widget/CardWithInfo.dart';


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
  //GetDataOfRoutes routes;
  
  ScreenMap(int index, BuildContext context){
    this.index = index;
    //routes = GetDataOfRoutes(context);
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

  FillInInformation fii = null;
  bool readyToReturn = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  Future<void> onMapCreated(HereMapController hereMapController) async {
    //info.mapController = hereMapController;
    //mapCtrl = hereMapController;
    routing = ShowTheRoute(context, hereMapController);
    await Future.delayed(Duration(seconds: 1));
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {
      if(error == null) {
        hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(info3.infoWalkList[0].legs[0].latOrig + 0.001, info3.infoWalkList[0].legs[0].lonOrig + 0.005), 2000);    //6.245560, -75.600020), 100);
        Future.delayed(Duration(seconds: 3));
        readyToReturn = true;
      }
      else {
        print("Map scene not loaded. MapError: " + error.toString());
        readyToReturn = true;
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

    return WillPopScope(
      onWillPop: () async {
        if(readyToReturn){
          Navigator.pop(context, false);
        }
        //return await Future(() => false);
      },
      child: Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: material.Color.fromRGBO(105, 190, 50, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: IconButton(
                        color: Colors.white,
                        iconSize: 35.0,
                        icon: Icon(Icons.arrow_back), 
                        onPressed: (){
                          if(readyToReturn){
                            Navigator.pop(context);
                          }
                        },
                      ),
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
                  child: CardInfoRoute(widget.index, /*widget.routes.infoCard.listOfInfo.value[widget.index],*/ context, false), //cardInfoRoute(widget.index, widget.routes.infoCard.listOfInfo.value[widget.index], context, false)  //info3.onTapCanceledList[widget.index],--- //info.listW[widget.index],
                ),
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

            // Padding(
            //   padding: EdgeInsets.only(top: 20.0),
            // ),

            Expanded( //tarjetas con informacion
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CardWithInfo(context, widget.index), 
              ),
            ),

            // Expanded( //zona inferior de la interfaz
            //   flex: 2,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       color: Colors.transparent,
            //     ),
            //   ),
            // ),


          ],
        ),
      ),
      
      ),
    );
  }
}