import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:http/http.dart' as http;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/widget/ShowDialog.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'dart:ui' as ui;
import 'package:geodesy/geodesy.dart';

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
    return Tuple4(red, green, blue, alpha);
  }

  Future<void> putMarker(double latitude, double longitude, bool enter, String transport) async {
    try{
      MapImage imgUint = null;
      if(transport == "CABLE_CAR"){
        try{
          ByteData fileData = await rootBundle.load("images/iconTrain.png"); //TODO: cambiar icono por metroCable
          var uint = Uint8List.view(fileData.buffer);
          imgUint = MapImage.withPixelDataAndImageFormat(uint, ImageFormat.png);
        }
        catch(e){
          print("Error $e");
        }
      }
      else  if(transport == "SUBWAY"){
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
      else{ //DESTINO
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

  // Future<void> testOfDrawLine() async {
  //   //REFERENCIA
  //   List<GeoCoordinates> coord = [];
  //   // ignore: avoid_init_to_null
  //   MapPolyline routeMapPolyline = null;
  //   // ignore: avoid_init_to_null
  //   GeoPolyline routeGeoPolyline = null;
  //   double widthInPixels = 10.0;
  //   var lati = [6.241739, 6.240716, 6.239006, 6.239050, 6.239197, 6.237553, 6.235148, 6.235114,];
  //   var long = [-75.596937, -75.596916, -75.596723, -75.594121, -75.590048, -75.591693, -75.591615, -75.593773];
  //   for(int i = 0; i < lati.length - 1; i++){
  //     var originCoordinates = GeoCoordinates(lati[i], long[i]);
  //     var destinyCoordinates = GeoCoordinates(lati[i + 1], long[i + 1]);
  //     coord = [originCoordinates, destinyCoordinates];
  //     routeGeoPolyline = GeoPolyline(coord);
  //     routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
  //     _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
  //     _mapPolylines.add(routeMapPolyline);
  //   }
  // }

  // Future<void> drawLineWalk(List<GeoCoordinates> coord) async {
  //   double widthInPixels = 10.0;
  //   GeoPolyline routeGeoPolyline = null;
  //   MapPolyline routeMapPolyline = null;
  //   routeGeoPolyline = GeoPolyline(coord);
  //   routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
  //   _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
  //   _mapPolylines.add(routeMapPolyline);
  // }

  // Future<void> drawLineBus(List<GeoCoordinates> coord, Tuple4<int, int, int, int> color) async {
  //   double widthInPixels = 10.0;
  //   GeoPolyline routeGeoPolyline = null;
  //   MapPolyline routeMapPolyline = null;
  //   routeGeoPolyline = GeoPolyline(coord);
  //   routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(color.item1, color.item2, color.item3, color.item4));
  //   _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
  //   _mapPolylines.add(routeMapPolyline);
  // }

  // Future<void> drawLineSubway(List<GeoCoordinates> coord, Tuple4<int, int, int, int> color) async {
  //   double widthInPixels = 10.0;
  //   GeoPolyline routeGeoPolyline = null;
  //   MapPolyline routeMapPolyline = null;
  //   routeGeoPolyline = GeoPolyline(coord);
  //   routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(color.item1, color.item2, color.item3, color.item4)); //color);
  //   _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
  //   _mapPolylines.add(routeMapPolyline);
  // }

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
        //await drawLineWalk(coord);
        await drawLineForWalk(index, v, info3.infoWalkList[index].legs[v]);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "BIKE"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "BIKE");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        //await drawLineWalk(coord);
        await drawLineForBike(index, v, info3.infoWalkList[index].legs[v], col);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "BUS"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "BUS");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        //await drawLineBus(coord, col);
        await drawLineForBus(index, v, col, info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, info3.infoWalkList[index].legs[v].latDest, info3.infoWalkList[index].legs[v].lonDest);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "SUBWAY"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "SUBWAY");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        //await drawLineSubway(coord, col);
        await drawLineForSubway(index, v, info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, info3.infoWalkList[index].legs[v].latDest, info3.infoWalkList[index].legs[v].lonDest, col);
      }
      else if(info3.infoWalkList[index].legs[v].mode == "CABLE_CAR"){
        if(v != 0){
          await putMarker(info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, true, "CABLE_CAR");
        }
        var col = hexColor(info3.infoWalkList[index].legs[v].routeColor);
        await drawLineForCableCar(index, v, info3.infoWalkList[index].legs[v].latOrig, info3.infoWalkList[index].legs[v].lonOrig, info3.infoWalkList[index].legs[v].latDest, info3.infoWalkList[index].legs[v].lonDest, col);
      }
      ctrl = v;
    }
    await putMarker(info3.infoWalkList[index].legs[ctrl].latDest, info3.infoWalkList[index].legs[ctrl].lonDest, true, "Destino"); //icono de destino
  }

  Future<void> drawLineForWalk(int index, int v, LegsInfo array) async {
    double widthInPixels = 10.0;
    List<GeoCoordinates> coord = [];

    GeoCoordinates originCoordinates = null;
    GeoCoordinates destinyCoordinates = null;
    Waypoint startWaypoint = null;
    Waypoint destinationWaypoint = null;
    List<Waypoint> waypoints = null;
    waypoints = [];

    //_mapPolylines = null;
    //_mapPolylines = [];

    MapPolyline routeMapPolyline = null;
    GeoPolyline routeGeoPolyline = null;

    if((array.ltWalk.length == array.lgWalk.length) && (array.ltWalk.length != 0 && array.lgWalk.length != 0)){
      
      originCoordinates = GeoCoordinates(array.latOrig, array.lonOrig);
      destinyCoordinates = GeoCoordinates(array.latDest, array.lonDest);
      startWaypoint = Waypoint.withDefaults(originCoordinates);
      destinationWaypoint = Waypoint.withDefaults(destinyCoordinates);
      waypoints = [startWaypoint, destinationWaypoint];
      await walkingRoute(waypoints);


      // NO BORRAR, GENERA RUTAS TRAZANDO LINEAS ENTRE COORDENADAS
      // for(int i = 0; i < array.ltWalk.length - 1; i++){
      //   var originCoordinates = GeoCoordinates(array.ltWalk[i], array.lgWalk[i]);
      //   var destinyCoordinates = GeoCoordinates(array.ltWalk[i + 1], array.lgWalk[i + 1]);
      //   coord = [originCoordinates, destinyCoordinates];
      //   routeGeoPolyline = GeoPolyline(coord);
      //   routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
      //   _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
      //   _mapPolylines.add(routeMapPolyline);
      //   //TODO: mostrar resultados con print, verificar que los datos sean consistentes
      // }

      
      
    }
  }

  Future<void> drawLineForBike(int index, int v, LegsInfo array, Tuple4<int, int, int, int> col) async {
    //TODO: graficar las rutas en bicicleta
    // double widthInPixels = 10.0;
    // List<GeoCoordinates> coord = [];

    // GeoCoordinates originCoordinates = null;
    // GeoCoordinates destinyCoordinates = null;
    // Waypoint startWaypoint = null;
    // Waypoint destinationWaypoint = null;
    // List<Waypoint> waypoints = null;
    // waypoints = [];

    // if((array.ltWalk.length == array.lgWalk.length) && (array.ltWalk.length != 0 && array.lgWalk.length != 0)){
    //   originCoordinates = GeoCoordinates(array.latOrig, array.lonOrig);
    //   destinyCoordinates = GeoCoordinates(array.latDest, array.lonDest);
    //   startWaypoint = Waypoint.withDefaults(originCoordinates);
    //   destinationWaypoint = Waypoint.withDefaults(destinyCoordinates);
    //   waypoints = [startWaypoint, destinationWaypoint];
    //   await bikeRoute(waypoints);
    // }
  }

  Future<void> drawLineForBus(int index, int v, Tuple4<int, int, int, int> col, double latOrigin, double lonOrigin, double latDest, double lonDest) async {
    double widthInPixels = 10.0;
    List<GeoCoordinates> coord = null;
    _mapPolylines = null;
    _mapPolylines = [];
    coord = [];
    MapPolyline routeMapPolyline = null;
    GeoPolyline routeGeoPolyline = null;
    String acum = null, acum2 = null;
    String trip = null, rId = null, orientation = null;
    
    GeoCoordinates originCoordinates = null;
    GeoCoordinates destinyCoordinates = null;
    acum = ""; 
    acum2 = "";
    trip ="";
    rId = "";
    orientation = "";
    int ctrlGetData = 0;

    //obtener la orientacion de la rutas de linea 1 y linea 2 del metroPlus
    trip = info3.infoWalkList[index].legs[v].tripId;
    for(int x = 2; x < trip.length - 5; x++){
      if(trip[x] == "-"){
        ctrlGetData++;
      }
      if(ctrlGetData < 3){
        acum += trip[x];
      }
    }

    if(info3.infoWalkList[index].legs[v].route == "1" || info3.infoWalkList[index].legs[v].route == "2"){ //linea 1 y 2 del metroPlus
      if(acum != ""){
        //acum = "ENV-LMDCB_0";
        String urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/$acum";
        Tuple4<int, int, bool, dynamic> value = await getThePointOrigin(urlConsult, latOrigin, lonOrigin);
        if(value.item3){
          Tuple3<List<double>, List<double>, List<int>> value2 = await getThePointDestiny(value.item2, value.item4, latDest, lonDest);
          if(value2.item1 != null && value2.item2 != null){
            if(value2.item1.length == value2.item2.length){
              //diagrama de las coordenadas
              for(int i = 0; i < value2.item1.length - 1; i++){
                originCoordinates = GeoCoordinates(value2.item1[i], value2.item2[i]);
                destinyCoordinates = GeoCoordinates(value2.item1[i + 1], value2.item2[i + 1]);
                coord = [originCoordinates, destinyCoordinates];
                routeGeoPolyline = GeoPolyline(coord);
                routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(col.item1, col.item2, col.item3, col.item4));
                _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
                _mapPolylines.add(routeMapPolyline);
              }
            }
          }
        }
      }
    }
    else{ //otras rutas de bus
      rId = info3.infoWalkList[index].legs[v].routeId;
      orientation = rId[0];
      for(int x = 2; x < rId.length; x++){
        acum2 += rId[x];
      }
      List<String> info = null;
      info = []; //almacena la informacion de las rutas de envigado
      
      if(acum2 != ""){
        // ignore: avoid_init_to_null
        dynamic jsonResp = null;
        //acum2 = "ENV_TEST_0"; //nueva linea de codigo
        //acum2 = "ENV001"; //SOLO PARA PRUEBAS, LUEGO SE BORRA
        String urlGetData = "http://192.168.1.200:8888/Api/GetSearchOptions/GetData/$acum2";
        print("URL DE DATOS BUS1: $urlGetData");
        dynamic resp = await http.get(urlGetData, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
        if(resp.statusCode == 200){
          jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
          if(jsonResp.length == 1){
            if(jsonResp["0"][0].length != 0){
              info.add(jsonResp["0"][0]);
            }
          }
          else if(jsonResp.length > 1){
            for(int x = 0; x < jsonResp.length; x++){
              if(jsonResp[x.toString()].length != 0){
                //String name = jsonResp[x.toString()][0];
                //if(name[name.length - 1] == orientation){
                //  print(name);
                info.add(jsonResp[x.toString()][0]);
                //}
              }
            }
          }
          else if(jsonResp.length == 0){
            print("No se puede consultar la informacion, intentalo nuevamente");
            showAlertDialog(_context, "No se puede consultar la informacion, intentalo nuevamente");
          }
        }
        
        if(info.length != 0){
          for(int j = 0; j < info.length; j++){
            try{
              String urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/${info[j]}";
              //String urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/ENV-DMA_1";
              print("URL DE DATOS BUS2: $urlConsult");
              Tuple4<int, int, bool, dynamic> value = await getThePointOrigin(urlConsult, latOrigin, lonOrigin);
              if(value.item3){

                //await grafica(value.item4);

                Tuple3<List<double>, List<double>, List<int>> value2 = await getThePointDestiny(value.item2, value.item4, latDest, lonDest);

                if(value2.item1 != null && value2.item2 != null){
                  if(value2.item1.length == value2.item2.length){
                    //diagrama de las coordenadas
                    for(int i = 0; i < value2.item1.length - 1; i++){
                      originCoordinates = GeoCoordinates(value2.item1[i], value2.item2[i]);
                      destinyCoordinates = GeoCoordinates(value2.item1[i + 1], value2.item2[i + 1]);
                      coord = [originCoordinates, destinyCoordinates];
                      routeGeoPolyline = GeoPolyline(coord);
                      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(col.item1, col.item2, col.item3, col.item4));
                      _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
                      _mapPolylines.add(routeMapPolyline);
                    }
                  }
                }

              }
              else{
                print("No se puede consultar la informacion, intentalo mas tarde");
                showAlertDialog(_context, "No se puede consultar la informacion, intentalo mas tarde");
              }
            }
            catch(e){
              print("Error, intentalo nuevamente");
              showAlertDialog(_context, "Error, intentalo nuevamente");
            }
          }
        }
        else{
          print("Problemas con consultar la informacion, intentalo nuevamente");
          showAlertDialog(_context, "Problemas con consultar la informacion, intentalo nuevamente");
        }
      }
    }
  }

  Future<void> grafica(dynamic jsonResp) async{

    // HereMapController _hereMapController = null;
    // // ignore: avoid_init_to_null
    // List<MapPolyline> _mapPolylines = null;
    // // ignore: avoid_init_to_null
    // RoutingEngine _routingEngine = null;
    // // ignore: avoid_init_to_null
    // MapMarker _marker = null;

    List<GeoCoordinates> coord = null;
    _mapPolylines = null;
    _mapPolylines = [];
    coord = [];
    double widthInPixels = 10.0;
    MapPolyline routeMapPolyline = null;
    GeoPolyline routeGeoPolyline = null;
    String acum = null, acum2 = null;
    String trip = null;
    GeoCoordinates originCoordinates = null;
    GeoCoordinates destinyCoordinates = null;

    for(int i = 0; i < jsonResp.length - 1; i++){

      double ptoLat = double.parse(jsonResp[i]["shape_pt_lat"]);
      double ptoLon = double.parse(jsonResp[i]["shape_pt_lon"]);

      double ptoLat2 = double.parse(jsonResp[i + 1]["shape_pt_lat"]);
      double ptoLon2 = double.parse(jsonResp[i + 1]["shape_pt_lon"]);

      originCoordinates = GeoCoordinates(ptoLat, ptoLon);
      destinyCoordinates = GeoCoordinates(ptoLat2, ptoLon2);
      coord = [originCoordinates, destinyCoordinates];
      routeGeoPolyline = GeoPolyline(coord);
      routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(0, 0, 0, 0));
      _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
      _mapPolylines.add(routeMapPolyline);
    }
  }

  Future<void> drawLineForSubway(int index, int v, double latOrigin, double lonOrigin, double latDest, double lonDest, Tuple4<int, int, int, int> col) async {
    List<GeoCoordinates> coord = null;
    coord = [];
    // ignore: avoid_init_to_null
    MapPolyline routeMapPolyline = null;
    // ignore: avoid_init_to_null
    GeoPolyline routeGeoPolyline = null;
    double widthInPixels = 10.0;
    // ignore: avoid_init_to_null
    String acum = null;
    String trip = null;
    String rtId = null;
    String orientation = null;
    String urlConsult = null;

    GeoCoordinates originCoordinates = null;
    GeoCoordinates destinyCoordinates = null;

    _mapPolylines = null;
    _mapPolylines = [];

    acum = "";
    trip = "";
    rtId = "";
    orientation = "";
    urlConsult = "";

    if(info3.infoWalkList[index].legs[v].route == "A"){
      trip = info3.infoWalkList[index].legs[v].tripId; //obtener la orientacion de la ruta
      int ctrlGetData = 0;
      for(int x = 2; x < trip.length - 5; x++){
        if(trip[x] == "-"){
          ctrlGetData++;
        }
        if(ctrlGetData < 3){
          acum += trip[x];
        }
      }
      urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/$acum";
    }
    else if(info3.infoWalkList[index].legs[v].route == "B"){
      rtId = info3.infoWalkList[index].legs[v].routeId; //obtener la orientacion de la ruta
      for(int x = 0; x < rtId.length; x++){
        if(x == 0){
          orientation = rtId[x];
        }
        if(x >= 2 && x < rtId.length){
          acum += rtId[x];
        }
      }
      urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/${acum}_$orientation";
    }

    if(acum != "" && urlConsult != ""){
      try{
        var value = await getThePointOrigin(urlConsult, latOrigin, lonOrigin);
        if(value.item3){
          var value2 = await getThePointDestiny(value.item2, value.item4, latDest, lonDest);
          if(value2.item1 != null && value2.item2 != null){
            if(value2.item1.length == value2.item2.length){
              for(int i = 0; i < value2.item1.length - 1; i++){
                originCoordinates = GeoCoordinates(value2.item1[i], value2.item2[i]);
                destinyCoordinates = GeoCoordinates(value2.item1[i + 1], value2.item2[i + 1]);
                coord = [originCoordinates, destinyCoordinates];
                routeGeoPolyline = GeoPolyline(coord);
                routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(col.item1, col.item2, col.item3, col.item4));
                _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
                _mapPolylines.add(routeMapPolyline);
              }
            }
          }
        }
      }
      catch(e){
        if(orientation != ""){
          showAlertDialog(_context, "Error en la consulta con la linea B del metro, intentalo nuevamente");
        }
        else{
          showAlertDialog(_context, "Error en la consulta con la linea A del metro, intentalo nuevamente");
        }
      }
    }
    else{
      showAlertDialog(_context, "Error, no se puede consultar la informacion, intentalo nuevamente");
    }
  }

  Future<void> drawLineForCableCar(int index, int v, double latOrigin, double lonOrigin, double latDest, double lonDest, Tuple4<int, int, int, int> col) async {
    double widthInPixels = 10.0;
    List<GeoCoordinates> coord = null;
    _mapPolylines = null;
    _mapPolylines = [];
    coord = [];
    MapPolyline routeMapPolyline = null;
    GeoPolyline routeGeoPolyline = null;
    String acum = null;
    String rtId = null;
    String orientation = null;
    GeoCoordinates originCoordinates = null;
    GeoCoordinates destinyCoordinates = null;
    acum = "";
    rtId = "";
    orientation = "";
    int ctrlGetData = 0;

    rtId = info3.infoWalkList[index].legs[v].routeId;
    for(int x = 0; x < rtId.length; x++){
      if(x == 0){
        orientation = rtId[x];
      }
      if(x >= 2 && x < rtId.length){
        acum += rtId[x];
      }
    }

    if(info3.infoWalkList[index].legs[v].route == "K" || info3.infoWalkList[index].legs[v].route == "L"){
      if(acum != ""){
        try{
          String urlConsult = "http://192.168.1.200:8888/Api/GetSearchOptions/Orientation/${acum}_$orientation";
          var resp = await http.get(urlConsult, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
          if(resp.statusCode == 200){
            dynamic jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
            for(int i = 0; i < jsonResp.length - 1; i++){
              originCoordinates = GeoCoordinates(double.parse(jsonResp[i]["shape_pt_lat"]), double.parse(jsonResp[i]["shape_pt_lon"]));
              destinyCoordinates = GeoCoordinates(double.parse(jsonResp[i + 1]["shape_pt_lat"]), double.parse(jsonResp[i + 1]["shape_pt_lon"]));
              coord = [originCoordinates, destinyCoordinates];
              routeGeoPolyline = GeoPolyline(coord);
              routeMapPolyline = MapPolyline(routeGeoPolyline, widthInPixels, Color.withAlpha(col.item1, col.item2, col.item3, col.item4));
              _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
              _mapPolylines.add(routeMapPolyline);
            }
          }
        }
        catch(e){
          showAlertDialog(_context, "Error en la consulta, intentalo nuevamente");
        }
      }
    }
  }

  Future<Tuple4<int, int, bool, dynamic>> getThePointOrigin(String urlConsult, double latOrigin, double lonOrigin) async {
    try{
      double uppLatitude = latOrigin + 0.002264;
      double bottLatitude = latOrigin - 0.002264;
      double leftLongitude = lonOrigin - 0.002264;
      double rightLongitude = lonOrigin + 0.002264;

      if(urlConsult != null){
        var resp = await http.get(urlConsult, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
        if(resp.statusCode == 200){
          List<CoordInfo> infoList = null;
          infoList = [];
          double ptoLatRef = 0.0;
          double ptoLonRef = 0.0;
          dynamic jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
          for(dynamic rr in jsonResp){
            int secuence = rr["shape_pt_sequence"];
            ptoLatRef = double.parse(rr["shape_pt_lat"]);
            ptoLonRef = double.parse(rr["shape_pt_lon"]);
            if((ptoLatRef <= uppLatitude) && (ptoLatRef >= bottLatitude) && (ptoLonRef >= leftLongitude) && (ptoLonRef <= rightLongitude)){
              //si cumple la condicion, medir la distancia que hay en el punto y almacenar en un arreglo
              int distance = await calculateDistance(latOrigin, lonOrigin, ptoLatRef, ptoLonRef);
              infoList.add(
                CoordInfo(
                  distance: distance,
                  secuence: secuence,
                  latitude: ptoLatRef,
                  longitude: ptoLonRef,
                )
              );
            }
          }
          if(infoList.length != 0){
            infoList.sort((a, b) => a.distance.compareTo(b.distance));
            int smallDistance = infoList[0].distance;
            int secu = infoList[0].secuence;
            return Tuple4(smallDistance, secu, true, jsonResp);
          }
          else{
            return Tuple4(0, 0, false, null);
          }
        }
        else{
          print("no se puede obtener la informacion");
          return Tuple4(0, 0, false, null);
        }
      }
    }
    catch(e){
      showAlertDialog(_context, "Error en la consulta, intentalo nuevamente");
      return Tuple4(0, 0, false, null);
    }
  }

  Future<Tuple3<List<double>, List<double>, List<int>>> getThePointDestiny(int secu, dynamic jsonResp, double latDest, double lonDest) async {
    double uppLatitude = latDest + 0.002264;
    double bottLatitude = latDest - 0.002264;
    double leftLongitude = lonDest - 0.002264;
    double rightLongitude = lonDest + 0.002264;

    List<double> lt = null;
    List<double> lg = null;
    List<int> secuenceList = null;
    List<CoordInfo> infoList = null;
    lt = [];
    lg = [];
    secuenceList = [];
    infoList = [];
    double ptoLatRef = 0.0;
    double ptoLonRef = 0.0;
    for(dynamic result in jsonResp){
      int secuence = result["shape_pt_sequence"];
      ptoLatRef = double.parse(result["shape_pt_lat"]);
      ptoLonRef = double.parse(result["shape_pt_lon"]);
      if((ptoLatRef <= uppLatitude) && (ptoLatRef >= bottLatitude) && (ptoLonRef >= leftLongitude) && (ptoLonRef <= rightLongitude)){
        int distance = await calculateDistance(latDest, lonDest, ptoLatRef, ptoLonRef);
        infoList.add(
          CoordInfo(
            distance: distance,
            secuence: secuence,
            latitude: ptoLatRef,
            longitude: ptoLonRef,
          ),
        );
      }
      else{
        print("Estas por fuera de la geocerca");
      }
    }
    if(infoList.length != 0){
      infoList.sort((a, b) => a.distance.compareTo(b.distance));
      int secu2 = infoList[0].secuence;
      //volver a poner el ciclo for para obtener la informacion mas precisa
      for(dynamic result2 in jsonResp){
        int secuence2 = result2["shape_pt_sequence"];
        double ptoLatRef2 = double.parse(result2["shape_pt_lat"]);
        double ptoLonRef2 = double.parse(result2["shape_pt_lon"]);

        // if(secuence2 >= 1 && secuence2 <= secu){ //SOLO PARA PRUEBAS
        //   lt.add(ptoLatRef2);
        //   lg.add(ptoLonRef2);
        //   secuenceList.add(secuence2);
        // }

        if(secuence2 >= secu && secuence2 <= secu2){ //LINEA DE CODIGO ORIGINAL
          lt.add(ptoLatRef2);
          lg.add(ptoLonRef2);
          secuenceList.add(secuence2);
        }
      }

      if((lt.length == lg.length) && (lt.length != 0 && lg.length != 0)){
        return Tuple3(lt, lg, secuenceList);
      }
      else{
        return Tuple3(null, null, null);
      }
    }
    else{
      return Tuple3(null, null, null);
    }
  }

  Future<int> calculateDistance(double latOrigin, double lonOrigin, double ptoLatRef, double ptoLonRef) async {
    // ignore: avoid_init_to_null
    Geodesy geodesy = null; 
    geodesy = Geodesy();
    LatLng l1 = LatLng(latOrigin, lonOrigin);
    LatLng l2 = LatLng(ptoLatRef, ptoLonRef);
    int distance = (geodesy.distanceBetweenTwoGeoPoints(l1, l2)).toInt();
    return distance;
  }

  Future<List<Waypoint>> originAndDestiny() async {
    GeoCoordinates startGeoCoordinates = GeoCoordinates(info.getLatitudeOrigin, info.getLongitudeOrigin);
    GeoCoordinates destinationGeoCoordinates = GeoCoordinates(info.getLatitudeDestiny, info.getLongitudeDestiny);
    Waypoint originWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    Waypoint destinyWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);
    waypoints = null;
    waypoints = [];
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

  Future<void> bikeRoute(List<Waypoint> waypoints) async {
    try{
      //TODO: generar metodo que dibuje las rutas en bicicleta
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

  Future<void> clearMap() async {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    //_mapPolylines.clear();
    _mapPolylines = null;
    _mapPolylines = [];
  }

  Future<void> _showRouteInfo(here.Route route) async {
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

  void _showRouteOnMap(here.Route route, int selectColor) async {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);
    // ignore: avoid_init_to_null
    MapPolyline routeMapPolyline = null;
    double widthInPixels = 0.0;
    
    if(selectColor == 0){ //caminando
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
