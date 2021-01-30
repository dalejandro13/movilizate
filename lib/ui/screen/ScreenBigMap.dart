import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/RoutingExample.dart';
import 'package:provider/provider.dart';

class ScreenBigMap extends StatefulWidget {

  @override
  _ScreenBigMapState createState() => _ScreenBigMapState();
}

class _ScreenBigMapState extends State<ScreenBigMap> {
  
  ProcessData info;
  RoutingExample routing;
  bool readyToReturn = false;

  @override
  Widget build(BuildContext context) {

    info = Provider.of<ProcessData>(context);

    void onMapCreated(HereMapController hereMapController) async {
      info.mapController = hereMapController;
      routing = RoutingExample(context, hereMapController);
      await Future.delayed(Duration(seconds: 1));
      hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {
        if (error == null) {
          hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(6.170039, -75.587251), 2000);
          Future.delayed(Duration(seconds: 3));
          readyToReturn = true;
        }
        else {
          print("Map scene not loaded. MapError: " + error.toString());
          readyToReturn = true;
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if(readyToReturn){
          Navigator.pop(context);
        }
        return await Future(() => false);
      },
      child: Scaffold(
        body: Stack(
        children: [
            HereMap(
              onMapCreated: onMapCreated,
            ),
          ]
        ),
      ),
    );

  }
}