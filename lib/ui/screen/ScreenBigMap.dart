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

  @override
  Widget build(BuildContext context) {

    info = Provider.of<ProcessData>(context);

    void onMapCreated(HereMapController hereMapController) {
      info.mapController = hereMapController;
      routing = RoutingExample(context, hereMapController);
      hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError error) {
        if (error == null) {
          hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(6.245560, -75.600020), 2000);
        } 
        else {
          print("Map scene not loaded. MapError: " + error.toString());
        }
      });
    }

    return Scaffold(
      body: Stack(
      children: [ 
        HereMap(
          onMapCreated: onMapCreated,
        ),
        ]
      ),
    );

  }
}