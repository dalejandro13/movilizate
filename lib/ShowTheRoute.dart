//import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as colour;
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'dart:ui' as ui;

class ShowTheRoute {
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
  List<Waypoint> waypoints = null;
  bool waitData = true;
  ProcessData info = null;
  InfoRouteServer info3 = null;
  
  ShowTheRoute(BuildContext context, HereMapController hereMapController) {
    _context = context;
    _hereMapController = hereMapController;
    _mapPolylines = [];

    _routingEngine = new RoutingEngine();
    info = Provider.of<ProcessData>(_context, listen: false);
    info3 = Provider.of<InfoRouteServer>(_context, listen: false);
    //_setLongPressGestureHandler();
    //_setTapGestureHandler();
  }

  Future<dynamic> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Tuple4<int, int, int, int> hexColor(String hexString) {
    int count = 0;
    String acum = "";
    var r = "", g = "", b = "";
    for(int i = 0; i < hexString.length; i++){
      if(i % 2 != 0){
        acum += hexString[i];
        acum = "0x" + acum;
        if(count == 0){
          r = acum;
          acum = "";
        }
        else if(count == 1){
          g = acum;
          acum = "";
        }
        else if(count ==2){
          b = acum;
          acum = "";
        }
        count++;
      }
      else{
        acum += hexString[i];
      }
    }
    var red = int.parse(r);
    var green = int.parse(g);
    var blue = int.parse(b);
    var alpha = int.parse("0xff");

    //int.parse("0x$hexString");
    //var buffer = StringBuffer();
    // if (hexString.length == 6 || hexString.length == 7){
    //   buffer.write('ff');
    // } 
    //buffer.write(hexString.replaceFirst('#', ''));
    //return Color(int.parse(buffer.toString(), radix: 16));
    return Tuple4(red, green, blue, alpha);
  }

  Future<void> putMarker(double latitude, double longitude, bool enter, String transport) async {
    try{
      MapImage imgUint = null;

      if(transport == "SUBWAY"){
        try{
          ByteData fileData = await rootBundle.load("images/iconTrain.png");
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else if(transport == "BUS"){
        try{
          ByteData fileData = await rootBundle.load("images/iconBus.png");
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else if(transport == "BIKE"){
        try{
          ByteData fileData = await rootBundle.load("images/iconBike.png");
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else if(transport == "WALK"){
        try{
          ByteData fileData = await rootBundle.load("images/iconWalking.png");
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else if(transport == "Origen"){
        try{
        ByteData fileData = await rootBundle.load("images/markerBlack.png");
        var uint = Uint8List.view(fileData.buffer);
        imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else{
        try{
          ByteData fileData = await rootBundle.load("images/markerGreen.png");
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }

      if(enter){
        if(imgUint != null){
          _marker = MapMarker(GeoCoordinates(latitude, longitude), imgUint);
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

  Future<void> testOfDrawLine() async {
    List<GeoCoordinates> coord = [];
    // ignore: avoid_init_to_null
    MapPolyline routeMapPolyline = null;
    // ignore: avoid_init_to_null
    GeoPolyline routeGeoPolyline = null;
    double widthInPixels = 10.0;
    var lati = [6.241739, 6.240716, 6.239006, 6.239050, 6.239197, 6.237553, 6.235148, 6.235114,];
    var long = [-75.596937, -75.596916, -75.596723, -75.594121, -75.590048, -75.591693, -75.591615, -75.593773];
    for(int i = 0; i < lati.length - 1; i++){
      var originCoordinates = GeoCoordinates(lati[i], long[i]);
      var destinyCoordinates = GeoCoordinates(lati[i + 1], long[i + 1]);
      coord = [originCoordinates, destinyCoordinates];
      routeGeoPolyline = GeoPolyline(coord);
      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
      _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
      _mapPolylines.add(routeMapPolyline);
    }
  }

  Future<void> drawLineWalk(List<GeoCoordinates> coord) async {
    double widthInPixels = 10.0;
    GeoPolyline routeGeoPolyline = null;
    MapPolyline routeMapPolyline = null;
    routeGeoPolyline = GeoPolyline(coord);
    routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<void> drawLineBus(List<GeoCoordinates> coord, Tuple4<int, int, int, int> color) async {
    double widthInPixels = 10.0;
    GeoPolyline routeGeoPolyline = null;
    MapPolyline routeMapPolyline = null;
    routeGeoPolyline = GeoPolyline(coord);
    routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(color.item1, color.item2, color.item3, color.item4));
    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<void> drawLineSubway(List<GeoCoordinates> coord, Tuple4<int, int, int, int> color) async {
    double widthInPixels = 10.0;
    GeoPolyline routeGeoPolyline = null;
    MapPolyline routeMapPolyline = null;
    routeGeoPolyline = GeoPolyline(coord);
    routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(color.item1, color.item2, color.item3, color.item4)); //color);
    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<void> pointOriginDestiny(int index) async {
    double lat1 = 0.0, lon1 = 0.0, lat2 = 0.0, lon2 = 0.0;
    List<GeoCoordinates> coord = [];
    int ctrl = 0;

    for(int v = 0; v < info3.infoWalkList[index].legs.length; v++){

      var startGeoCoordinates = GeoCoordinates(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig);
      var destinationGeoCoordinates = GeoCoordinates(info3.infoWalkList[index].legs[v].latDest, info3.infoWalkList[index].legs[v].lonDest);
      coord = [startGeoCoordinates, destinationGeoCoordinates];

      if(v == 0){
        await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "Origen"); //icono de origen
      }

      if(info3.infoWalkList[index].legs[v].mode == "WALK"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "WALK");
        }
        await drawLineWalk(coord);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "BIKE"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "BIKE");
        }
        await drawLineWalk(coord);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "BUS"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "BUS");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        await drawLineBus(coord, col);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "SUBWAY"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "SUBWAY");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        await drawLineSubway(coord, col);
      }
      ctrl = v;
    }
    await putMarker(info3.infoWalkList[index].legs[ctrl].latDest, info3.infoWalkList[index].legs[ctrl].lonDest, true, "Destino"); //icono de destino
  }

  Future<List<Waypoint>> originAndDestiny() async {
    var startGeoCoordinates = GeoCoordinates(info.getLatitudeOrigin, info.getLongitudeOrigin);
    var destinationGeoCoordinates = GeoCoordinates(info.getLatitudeDestiny, info.getLongitudeDestiny);
    var originWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinyWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);
    waypoints = null;
    waypoints = [originWaypoint, destinyWaypoint];
    return waypoints;
  }

  Future<void> infoWalkRoute(List<Waypoint> waypoints) async {
    await _routingEngine.calculatePedestrianRoute(waypoints, PedestrianOptions.withDefaults(), (RoutingError routingError, List<here.Route> routeList) {
      if (routingError == null) {
        here.Route route = routeList.first;
        _showRouteInfo(route);
      }
      else {
        var error = routingError.toString();
        _showDialog('Error', 'Error while calculating a route: $error');
      }
    });
  }

  Future<void> walkingRoute(List<Waypoint> waypoints) async {
    try{
      await _routingEngine.calculatePedestrianRoute(waypoints, PedestrianOptions.withDefaults(), (RoutingError routingError, List<here.Route> routeList) {
        if (routingError == null) {
          here.Route route = routeList.first;
          //_showRouteDetails(route, 0);
          _showRouteOnMap(route, 0);
        } 
        else {
          var error = routingError.toString();
          _showDialog('Error', 'Error while calculating a route: $error');
        }
      });
    }
    catch(e){
      print("Error $e");
    }
  }

  Future<void> carRoute(List<Waypoint> waypoints) async {
    try{
      await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(), (RoutingError routingError, List<here.Route> routeList) {
        if (routingError == null) {
          here.Route route = routeList.first;
          //_showRouteDetails(route, 1);
          _showRouteOnMap(route, 1);
        } 
        else {
          var error = routingError.toString();
          _showDialog('Error', 'Error while calculating a route: $error');
        }
      });
    }
    catch(e){
      print("Error $e");
    }
  }

  Future<void> truckRoute(waypoints) async {
    try{
      await _routingEngine.calculateTruckRoute(waypoints, TruckOptions.withDefaults(), (RoutingError routingError, List<here.Route> routeList) {
        if (routingError == null) {
          here.Route route = routeList.first;
          //_showRouteDetails(route, 2);
          _showRouteOnMap(route, 2);
        } 
        else {
          var error = routingError.toString();
          _showDialog('Error', 'Error while calculating a route: $error');
        }
      });
    }
    catch(e){
      print("Error $e");
    }
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    //_mapPolylines.clear();
    _mapPolylines = null;
    _mapPolylines = [];
  }

  void _showRouteInfo(here.Route route) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;
    String routeDetails = 'Travel Time: ' + _formatTime(estimatedTravelTimeInSeconds) + ', Length: ' + _formatLength(lengthInMeters);
    
    //poner en este punto la informacion en la tarjeta pero como????
    info.getTimeEstimated = _formatTime(estimatedTravelTimeInSeconds); //pongo la informacion del tiempo estimado de viaje
  }

  void _showRouteDetails(here.Route route, int details) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;
    String routeDetails = 'Travel Time: ' + _formatTime(estimatedTravelTimeInSeconds) + ', Length: ' + _formatLength(lengthInMeters);
    if(details == 0){
      _showDialog('Caminando', '$routeDetails');
    }
    else if(details == 1){
      _showDialog('En Auto', '$routeDetails');
    }
    else if(details == 2){
      _showDialog('En AutoBus', '$routeDetails');
    }
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

  _showRouteOnMap(here.Route route, int selectColor) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);
    // ignore: avoid_init_to_null
    MapPolyline routeMapPolyline = null;
    double widthInPixels = 0.0;
    
    if(selectColor == 0){  //caminando
      widthInPixels = 10.0;
      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
    }
    else if(selectColor == 1){ //en Auto
      widthInPixels = 7.0;
      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(255, 0, 0, 255));
    }
    else if(selectColor == 2){
      widthInPixels = 5.0; //en AutoBus
      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 255, 255));
    }
    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
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
