/*
 * Copyright (C) 2019-2020 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'dart:io';
import 'dart:math';
//import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:here_sdk/gestures.dart';
//import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart' as material;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class RoutingExample {
  BuildContext _context;
  // ignore: avoid_init_to_null
  HereMapController _hereMapController = null;
  // ignore: avoid_init_to_null
  List<MapPolyline> _mapPolylines = null;
  // ignore: avoid_init_to_null
  RoutingEngine _routingEngine = null;
  // ignore: avoid_init_to_null
  MapMarker _marker = null;

  List<double> coorList = null;
  bool waitData = true;
  ProcessData info;
  
  RoutingExample(BuildContext context, HereMapController hereMapController) {
    _context = context;
    _hereMapController = hereMapController;
    _mapPolylines = [];

    _routingEngine = new RoutingEngine();
    info = Provider.of<ProcessData>(_context, listen: false);
    //_setLongPressGestureHandler();
    _setTapGestureHandler();
  }

  Future<void> putMarker(double latitude, double longitude, bool enter) async {
    try{
      ByteData imageData = null;
      await rootBundle.load("images/markerBlack.png").then((value){
        imageData = value;
      });

      if(enter){
        if(imageData != null){
          _marker = MapMarker(GeoCoordinates(latitude, longitude), MapImage.withImageData(imageData.buffer.asUint8List()));
          _hereMapController
            ..camera.lookAtPointWithDistance(GeoCoordinates(latitude, longitude), 2000)
            ..mapScene.addMapMarker(_marker);
        }
      }
      else{
        print("ubicacion no disponible");
      }
    }
    catch(e){
      print("Error $e");
    }
  }

  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener = TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      _toList(_hereMapController.viewToGeoCoordinates(touchPoint));
      try{
        if(waitData){
          waitData = false;
          if(coorList.length >= 2){ //condicion si se tiene dos elementos en la lista
            clearMarkerOfMap();
            putMarker(coorList[0], coorList[1], true);
          }
          showModalBottomSheet(
            isDismissible: true,
            context: _context,
            builder: (ctx) => _buildInfoBottom(ctx),
          );
          waitData = true;
        }
      }
      catch(e){
        print("Error $e");
        waitData = true;
      }
    });
  }

  void _setLongPressGestureHandler() async {
    _hereMapController.gestures.longPressListener = LongPressListener.fromLambdas(lambda_onLongPress: (GestureState gestureState, Point2D touchPoint) {
      _toList(_hereMapController.viewToGeoCoordinates(touchPoint));
      if (gestureState == GestureState.begin) {
        waitData = true;
        Future.delayed(Duration(seconds: 1));
      }

      if (gestureState == GestureState.update) {
        try{
          Future.delayed(Duration(seconds: 1));
          if(waitData){
            waitData = false;
            if(coorList.length >= 2){ //condicion si se tiene dos elementos en la lista
              
              putMarker(coorList[0], coorList[1], true);
            }
            showModalBottomSheet(
              context: _context,
              builder: (context) => _buildInfoBottom(context)
            );
          }
          Future.delayed(Duration(seconds: 1));
        }
        catch(e){
          print("Error $e");
        }
      }

      if (gestureState == GestureState.end) {
        waitData = true;
        Future.delayed(Duration(seconds: 1));
      }
    });
  }

  _buildInfoBottom(BuildContext context){
    return Container(
      height: 200,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: material.Color.fromRGBO(105, 190, 50, 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: [
          ListTile(
            title: Center(
              child: Text(
                "${coorList[0].toStringAsFixed(6)} , ${coorList[1].toStringAsFixed(6)}", //"aqui van las coordenadas",
                style: TextStyle(
                  fontFamily: "AurulentSans-Bold",
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Expanded(
                flex: 1,
                child: SizedBox(),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  height: 60.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: material.Color.fromRGBO(87, 114, 26, 1.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      try{
                        final result = await InternetAddress.lookup("google.com");
                        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                          info.getLatitudeOrigin = coorList[0];
                          info.getLongitudeOrigin = coorList[1];
                          info.dataOrigin.text = "${coorList[0]} , ${coorList[1]}";
                          Navigator.of(_context).pop();
                          Navigator.of(_context).pop();
                        }
                      }
                      catch(e){
                        Fluttertoast.showToast(
                          msg: "Sin conexion a internet, conectate a internet e intentalo nuevamente",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        "Origen",
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  height: 60.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: material.Color.fromRGBO(87, 114, 26, 1.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      try{
                        final result = await InternetAddress.lookup("google.com");
                        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                          info.getLatitudeDestiny = coorList[0];
                          info.getLongitudeDestiny = coorList[1];
                          info.dataDestiny.text = "${coorList[0]} , ${coorList[1]}";
                          Navigator.of(_context).pop();
                          Navigator.of(_context).pop();
                        }
                      }
                      catch(e){
                        Fluttertoast.showToast(
                          msg: "Sin conexion a internet, conectate a internet e intentalo nuevamente",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        "Destino",
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(),
              ),

            ],
          ),
        ],
      ),
    );
  }

  // conv(GeoCoordinates geoCoordinates) async {
  //   print("se ha convertido");
  //   return Tuple2(geoCoordinates.latitude, geoCoordinates.longitude);
  // }

  List<double> _toList(GeoCoordinates geoCoordinates) {
    coorList = null;
    coorList = [];
    coorList.add(geoCoordinates.latitude);
    coorList.add(geoCoordinates.longitude);
    return coorList;
  }

  Future<void> addRoute() async {
    var startGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var destinationGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);

    List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
        (RoutingError routingError, List<here.Route> routeList) async {
      if (routingError == null) {
        here.Route route = routeList.first;
        _showRouteDetails(route);
        _showRouteOnMap(route);
      } 
      else {
        var error = routingError.toString();
        _showDialog('Error', 'Error while calculating a route: $error');
      }
    });
  }

  void clearMarkerOfMap(){
    if(_marker != null){
      _hereMapController.mapScene.removeMapMarker(_marker);
    }
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  void _showRouteDetails(here.Route route) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;

    String routeDetails = 'Travel Time: ' +
        _formatTime(estimatedTravelTimeInSeconds) +
        ', Length: ' +
        _formatLength(lengthInMeters);

    _showDialog('Route Details', '$routeDetails');
  }

  String _formatTime(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    return '$hours:$minutes min';
  }

  String _formatLength(int meters) {
    int kilometers = meters ~/ 1000;
    int remainingMeters = meters % 1000;

    return '$kilometers.$remainingMeters km';
  }

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);

    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.withAlpha(0, 144, 138, 160));

    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  GeoCoordinates _createRandomGeoCoordinatesInViewport() {
    GeoBox geoBox = _hereMapController.camera.boundingBox;
    if (geoBox == null) {
      // Happens only when map is not fully covering the viewport.
      return GeoCoordinates(6.246209, -75.599195);
    }

    GeoCoordinates northEast = geoBox.northEastCorner;
    GeoCoordinates southWest = geoBox.southWestCorner;

    double minLat = southWest.latitude;
    double maxLat = northEast.latitude;
    double lat = _getRandom(minLat, maxLat);

    double minLon = southWest.longitude;
    double maxLon = northEast.longitude;
    double lon = _getRandom(minLon, maxLon);

    return new GeoCoordinates(lat, lon);
  }

  double _getRandom(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
