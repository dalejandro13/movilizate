import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:movilizate/ui/widget/MessageDialog.dart';
import 'package:tuple/tuple.dart';

class ConsultServer{

  // BuildContext context;
  
  // ConsultServer(BuildContext context){
  //   this.context = context;
  // }

  String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
  String urlUbication = "country=colombia;state=antioquia&q=";
  String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";
  List<DataOfPlace> place;
  //List<InfoRouteServer> place2;
  List<LegsInfo> legs;
  bool enter = true;
  List<Widget> wid;
  List<Widget> cardListWidget;
  double lonOrig, latOrig, lonDest, latDest; 

  // Future<void> getPreviousInfo() async {
  //   //info = Provider.of<ProcessData>(context);
  //   place = null;
  //   place = [];
    
  //   String completeUrl = "$urlBase$urlUbication"+"santafe"+"$apiKey";
  //   try{
  //     var resp = await http.get(completeUrl, headers: {'Content-Type': 'application/json'});
  //     if(resp.statusCode == 200){
  //       var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
  //       for(var vv in jsonResp["items"]){
  //         place.add(
  //           DataOfPlace(
  //             title: vv["title"],
  //             lat: vv["position"]["lat"],
  //             lon: vv["position"]["lng"],
  //           )
  //         );
  //       }
  //       //print(info.infoPlace);
  //     }
  //     else{
  //       print("Error en la consulta, intentalo nuevamente");
  //     }
  //   }
  //   catch(e){
  //     print("Error: $e");
  //   }
  // }

  Future<void> getUbication(BuildContext context) async {
    place = null;
    place = [];
    try{
      var info2 = Provider.of<DataOfPlace>(context, listen: false);
      var info = Provider.of<ProcessData>(context, listen: false);
      String completeUrl = "$urlBase$urlUbication"+"medellin"+"$apiKey";
      var resp = await http.get(completeUrl, headers: {'Content-Type': 'application/json'});
      if(resp.statusCode == 200){
        var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
        for(var vv in jsonResp["items"]){
          place.add(
            DataOfPlace(
              title: vv["title"],
              lat: vv["position"]["lat"],
              lon: vv["position"]["lng"],
            )
          );
        }
        info2.initialPlace = place;
        if(info2.initialPlace.length > 0){
          for(var vv in info2.initialPlace){
            // print(vv.title);
            // print(vv.lat);
            // print(vv.lon);
            info.getLatitudeOrigin = vv.lat;
            info.getLongitudeOrigin = vv.lon;
            info.dataOrigin.text = vv.title;
          }
        }
      }
      else{
        print("Error en la consulta, intentalo nuevamente");
      }
    }
    catch(e){
      print("Error: $e");
    }
  }

  Future<void> getInfoInMaps(ProcessData info, DataOfPlace info2) async {
    String completeUrl = "$urlBase$urlUbication${info.dataText.text}$apiKey";
    try{
      if(enter){
        enter = false;
        if(place.length >= 100){
          place = null;
          place = [];
          info2.infoPlace = null;
          info2.infoPlace = [];
        }
        var resp = await http.get(completeUrl, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 10));
        if(resp.statusCode == 200){
          var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
          for(var vv in jsonResp["items"]){
            place.add(
              DataOfPlace(
                title: vv["title"],
                lat: vv["position"]["lat"],
                lon: vv["position"]["lng"],
              )
            );
          }
          
          if(place.length > 0){
            //elimino la informacion repetida de la lista
            Map<String, DataOfPlace> mp = {};
            for(var item in place){
              mp[item.title] = item;
            }
            info2.infoPlace = mp.values.toList();
          }
          
        }
        else{
          print("Error en la consulta, intentalo nuevamente");
        }
        enter = true;
      }
      else{
        enter = true;
      }
    }
    catch(e){
      print("Error: $e");
      enter = true;
    }
  }

  Future<void> getInfoFromServer(String urlComplete, InfoRouteServer info3) async {
    try{
      legs = null;
      info3.infoWalkList = null;
      info3.infoWalkList = [];
      legs = [];
      
      dynamic duration = null, startTime = null, endTime = null, walkTime = null, waitingTime = null, walkDistance = null, startTimeInitial = null, endTimeFinal = null, mode = null, route = null, routeColor = null, routeTextColor = null, nameFrom = null, nameTo = null, distance = null, durationTransport = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;

      var resp = await http.get(urlComplete, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
      if(resp.statusCode == 200){
        var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
        if(jsonResp["error"] == null){
          //dynamic date = jsonResp["plan"]["date"];
          // var from = jsonResp["plan"]["from"];
          // var name1 = from["name"];
          // var lonOrigin = from["lon"];
          // var latOrigin = from["lat"];
          // var orig1 = from["orig"];
          // var vertexType1 = from["vertexType"];
          
          for(var vv in jsonResp["plan"]["itineraries"]){
            legs = null;
            legs = [];
            duration = vv["duration"]; 
            startTime = vv["startTime"]; 
            endTime = vv["endTime"]; 
            walkTime = vv["walkTime"];
            waitingTime = vv["waitingTime"];
            walkDistance = vv["walkDistance"];
            for(var ss in vv["legs"]){ 
              distance = ss["distance"]; 
              startTimeInitial = ss["startTime"];
              endTimeFinal = ss["endTime"];
              mode = ss["mode"];
              route = ss["route"];
              routeColor = ss["routeColor"];
              routeTextColor = ss["routeTextColor"];
              lonOrig = ss["from"]["lon"];
              latOrig = ss["from"]["lat"];
              nameFrom = ss["from"]["name"];
              lonDest = ss["to"]["lon"];
              latDest = ss["to"]["lat"];
              nameTo = ss["to"]["name"];
              durationTransport = ss["duration"];

              legs.add(
                LegsInfo(
                  distance: distance,
                  startTime: startTimeInitial,
                  endTime: endTimeFinal,
                  mode: mode,
                  route: route,
                  routeColor: routeColor,
                  routeTextColor: routeTextColor,
                  lonOrig: lonOrig,
                  latOrig: latOrig,
                  nameFrom: nameFrom,
                  lonDest: lonDest,
                  latDest: latDest,
                  nameTo: nameTo,
                  durationTransport: durationTransport,
                ),
              );
            }

            info3.infoWalkList.add(
              InfoRouteServ(
                duration: duration,
                startTime: startTime,
                endTime: endTime,
                walkTime: walkTime,
                waitingTime: waitingTime,
                walkDistance: walkDistance,
                legs: legs,
              ),
            );
          }

          // for(int x = 0; x < info3.infoWalkList.length; x++){
          //   for(int y = 0; y < info3.infoWalkList[x].legs.length; y++){
          //     print(info3.infoWalkList[x].legs[y].mode);
          //     print(info3.infoWalkList[x].legs[y].route);
          //   }
          // }

        }
        else{
          print("Error: ${jsonResp["error"]["id"]}");
          print("${jsonResp["error"]["msg"]}");
          //MessageDialog();
        }
      }
      else{
        print("Error en la consulta, intentalo nuevamente");
      }
    }
    catch(e){
      print("Error $e");
    }
  }
}


class GetIconsInfoCard{

  ValueNotifier<List<IconList>> listOfInfo = ValueNotifier([]);
  InfoRouteServer info3;
  List<LegsList> legs;

  GetIconsInfoCard(BuildContext context){
    info3 = Provider.of<InfoRouteServer>(context);
    //getIconsInfo(context);
  }

  Future<void> getIconsInfo(BuildContext context) async {
    //listOfInfo = null;
    //listOfInfo = ValueNotifier([]);
    info3.listOfInfo = null;
    info3.listOfInfo = [];
    legs = null;
    legs = [];
    String timeArrived = null, timeDuration = null, subway = null, bus = null, bike = null, walk = null;
    String route = null, routeColor = null, routeTextColor = null;
    for(int i = 0; i < info3.infoWalkList.length; i++){
      try{
        int minutes = (info3.infoWalkList[i].waitingTime / 60).truncate(); //convertir de segundos a minutos para arrived
        timeArrived = "Arrived: ${minutes.toString()} min";

        int minutesDuration = (info3.infoWalkList[i].duration / 60).truncate(); //convertir de segundos a minutos para duration
        timeDuration = "${minutesDuration.toString()}";

        legs = null;
        legs = [];

        for(int y = 0; y < info3.infoWalkList[i].legs.length; y++){
          
          if(info3.infoWalkList[i].legs[y].mode == "SUBWAY"){
            subway = "SUBWAY";
            bus = "";
            bike = "";
            walk = "";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          else{
            if(info3.infoWalkList[i].legs[y].mode == "BUS"){
              subway = "";
              bus = "BUS";
              bike = "";
              walk = "";
              route = info3.infoWalkList[i].legs[y].route;
              routeColor = info3.infoWalkList[i].legs[y].routeColor;
              routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
            }
            else{
              if(info3.infoWalkList[i].legs[y].mode == "BIKE"){
                subway = "";
                bus = "";
                bike = "BIKE";
                walk = "";
                route = info3.infoWalkList[i].legs[y].route;
                routeColor = info3.infoWalkList[i].legs[y].routeColor;
                routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
              }
              else{
                if(info3.infoWalkList[i].legs[y].mode == "WALK"){
                  subway = "";
                  bus = "";
                  bike = "";
                  walk = "WALK";
                  route = info3.infoWalkList[i].legs[y].route;
                  routeColor = info3.infoWalkList[i].legs[y].routeColor;
                  routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
                }
              }
            }
          }
          
          legs.add(
            LegsList(
              subway: subway,
              bus: bus,
              bike: bike,
              walk: walk,
              route: route,
              routeColor: routeColor,
              routeTextColor: routeTextColor,
            )
          );
        }
        
        info3.listOfInfo.add(
          IconList(
            timeArrived: timeArrived,
            timeDuration: timeDuration,
            legs: legs,
          )
        );

      }
      catch(e){
        print("Error $e");
      }
    }
    //listOfInfo.notifyListeners();
  }
}


class InnerIconsInfo extends ChangeNotifier{
  //ValueNotifier<List<List<Widget>>> tile = ValueNotifier([]);
  //ValueNotifier<List<List<Widget>>> listOfInfo = ValueNotifier([]);
  double sizeIcon = 35.0;
  InfoRouteServer route; 
  List<Widget> element = List<Widget>();
  //GetDataOfRoutes ii;
  //InfoRouteServer ic;

  InnerIconsInfo(BuildContext context/*, int index*/){
    //ii = Provider.of<GetDataOfRoutes>(context);
    route = Provider.of<InfoRouteServer>(context);
    //ic = Provider.of<InfoRouteServer>(context);

    //tile.value = null;
    //tile.value = [];

    //getIcon(true);
  }

  Color hexColor(String hexString){
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> getIcon() async { //obtiene los iconos
    route.tileList = null;
    route.tileList = [];
    for(int i = 0; i < route.infoWalkList.length; i++){
      element = null;
      element = [];
      for(int j = 0; j < route.infoWalkList[i].legs.length; j++){
        if(route.infoWalkList[i].legs[j].mode == "SUBWAY"){
          element.add(
            Icon(
              Icons.directions_subway,
              size: sizeIcon,
              color: Colors.black,
            )
          );

          if(route.infoWalkList[i].legs[j].routeColor != null && route.infoWalkList[i].legs[j].routeTextColor != null){
            element.add(
              Container(
                height: 27.0,
                width: 27.0,
                decoration: BoxDecoration(
                  color: hexColor(route.infoWalkList[i].legs[j].routeColor),
                ),
                child: Center(
                  child: Text(
                    route.infoWalkList[i].legs[j].route,
                    style: TextStyle(
                      fontFamily: "AurulentSans-Bold",
                      color: hexColor(route.infoWalkList[i].legs[j].routeTextColor),
                    ),
                  ),
                ),
              ),
            );
          }

          element.add(
            Icon(
              Icons.chevron_right,
              size: sizeIcon,
              color: Color.fromRGBO(105, 190, 50, 1.0),
            )
          );
          
        }
        else{
          if(route.infoWalkList[i].legs[j].mode == "BUS"){
            element.add(
              Icon(
                Icons.directions_bus,
                size: sizeIcon,
                color: Colors.black,
              ),
            );
            if(route.infoWalkList[i].legs[j].routeColor != null && route.infoWalkList[i].legs[j].routeTextColor != null){
              element.add(
                Container(
                  height: 27.0,
                  width: 27.0,
                  decoration: BoxDecoration(
                    color: hexColor(route.infoWalkList[i].legs[j].routeColor),
                  ),
                  child: Center(
                    child: Text(
                      route.infoWalkList[i].legs[j].route,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: hexColor(route.infoWalkList[i].legs[j].routeTextColor),
                      ),
                    ),
                  ),
                ),
              );
            }

            element.add(
              Icon(
                Icons.chevron_right,
                size: sizeIcon,
                color: Color.fromRGBO(105, 190, 50, 1.0),
              )
            );

          }
          else{
            if(route.infoWalkList[i].legs[j].mode == "BIKE"){
                element.add(
                  Icon(
                    Icons.directions_bike,
                    size: sizeIcon,
                    color: Colors.black,
                  )
                );

                element.add(
                  Icon(
                    Icons.chevron_right,
                    size: sizeIcon,
                    color: Color.fromRGBO(105, 190, 50, 1.0),
                  )
                );
                
            }
            else{
              if(route.infoWalkList[i].legs[j].mode == "WALK"){
                element.add(
                  Icon(
                    Icons.directions_walk,
                    size: sizeIcon,
                    color: Colors.black,
                  ),
                );

                element.add(
                  Icon(
                    Icons.chevron_right,
                    size: sizeIcon,
                    color: Color.fromRGBO(105, 190, 50, 1.0),
                  )
                );
              }
            }
          }
        }
      }
      element.removeLast();
      route.tileList.add(element);
    }
  }
}

class GetDataTrasnport{

  BuildContext context;
  InfoRouteServer info3;
  //GetDataLegs dataLegs;
  bool subway = false, bus = false, bike = false, walk = false;

  GetDataTrasnport(BuildContext context){
    this.context = context;
    info3 = Provider.of<InfoRouteServer>(context);
    //dataLegs = GetDataLegs(context);
  }

  Future<void> iconsOfTransport() async {
    info3.listOfTransport = null;
    info3.listOfTransport = [false, false, false, false];
    for(int i = 0; i < info3.infoWalkList.length; i++){      
      for(int j = 0; j < info3.infoWalkList[i].legs.length; j++){
        if(info3.infoWalkList[i].legs[j].mode == "SUBWAY"){
          if(info3.listOfTransport[0] == false){
            info3.listOfTransport[0] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BUS"){
          if(info3.listOfTransport[1] == false){
            info3.listOfTransport[1] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BIKE"){
          if(info3.listOfTransport[2] == false){
            info3.listOfTransport[2] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "WALK"){
          if(info3.listOfTransport[3] == false){
            info3.listOfTransport[3] = true;
          }
        }
      }
    }
  }

}

class GetIcons{
  ValueNotifier<List<List<String>>> listIcon = ValueNotifier([]);
  ValueNotifier<int> indexC = ValueNotifier(0);
  List<String> data = List<String>();
  List<List<String>> data2 = List<List<String>>();
  InfoRouteServer info3;

  GetIcons(BuildContext context){
    info3 = Provider.of<InfoRouteServer>(context);
    //getInfoIcon();
  }

  getInfoIcon(){
    data2 = null;
    //listIcon = null;
    data2 = [];
    //listIcon = ValueNotifier([]);
    data2 = null;
    data2 = [];
    for(int y = 0; y < info3.infoWalkList[indexC.value].legs.length; y++){
      data = null;
      data = [];
      if(info3.infoWalkList[indexC.value].legs[y].mode == "SUBWAY"){
        data.add(info3.infoWalkList[indexC.value].legs[y].mode); //tipo de transporte
        data.add(info3.infoWalkList[indexC.value].legs[y].route); //nombre de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeColor); //color de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeTextColor); //color de letra de la ruta
      }
      else if (info3.infoWalkList[indexC.value].legs[y].mode == "BUS"){
        data.add(info3.infoWalkList[indexC.value].legs[y].mode); //tipo de transporte
        data.add(info3.infoWalkList[indexC.value].legs[y].route); //nombre de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeColor); //color de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeTextColor); //color de letra de la ruta
      }
      else if(info3.infoWalkList[indexC.value].legs[y].mode == "BIKE"){
        data.add(info3.infoWalkList[indexC.value].legs[y].mode); //tipo de transporte
        data.add(info3.infoWalkList[indexC.value].legs[y].route); //nombre de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeColor); //color de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeTextColor); //color de letra de la ruta
      }
      else{ //WALK
        data.add(info3.infoWalkList[indexC.value].legs[y].mode); //tipo de transporte
        data.add(info3.infoWalkList[indexC.value].legs[y].route); //nombre de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeColor); //color de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeTextColor); //color de letra de la ruta
      }
      
      //data2.add(data);
      listIcon.value.add(data);
    }
    //listIcon.value.add(data);
    listIcon.notifyListeners();
    indexC.notifyListeners();
  }

}

class FillInInformation{

  List<CardInfoRoutes> cardInfo = null;
  //InfoRouteServer info3;
  //ProcessData info;

  Color hexColor(String hexString){
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> getDataToShow(ProcessData info, InfoRouteServer info3) async {
    //info3.infoWalkList
    //cardInfo = null;
    //cardInfo = [];
    info.infoRoutes = null;
    info.infoRoutes = [];
    double sizeIcon = 35.0;
    dynamic iconTransport = null, distance = null, originIcon = null, currentIcon = null, endIcon = null, lineRoute = null;
    String transport = "";

    for(int x = 0; x < info3.infoWalkList.length; x++){
      cardInfo = null;
      cardInfo = [];

      originIcon = Icon( //icono del punto de origen
        Icons.location_on, 
        color: Color.fromRGBO(0, 0, 0, 1.0),
      );

      endIcon = Icon( //icono del punto de destino
        Icons.location_on, 
        color: Color.fromRGBO(105, 190, 50, 1.0),
      );

      for(int y = 0; y < info3.infoWalkList[x].legs.length; y++){
        int duration = info3.infoWalkList[x].legs[y].durationTransport.toInt();
        duration = (duration / 60).truncate(); //en minutos
        transport = info3.infoWalkList[x].legs[y].mode.toString().toLowerCase(); //nombre del medio de transporte en minuscula
        String transportMedium = "";

        /////////////////////////////
        
        if(transport == "subway"){
          lineRoute = Container(
            height: 70.0,
            width: 7.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
            ),
          );

          currentIcon = Icon(
            Icons.directions_subway, 
            color: Color.fromRGBO(0, 0, 0, 1.0),
          );

          distance = Row(
            children: [
              Icon(
                Icons.directions_subway,
                size: sizeIcon,
                color: Colors.black,
              ),
              Container(
                height: 27.0,
                width: 27.0,
                decoration: BoxDecoration(
                  color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
                ),
                child: Center(
                  child: Text(
                    info3.infoWalkList[x].legs[y].route,
                    style: TextStyle(
                      fontFamily: "AurulentSans-Bold",
                      color: hexColor(info3.infoWalkList[x].legs[y].routeTextColor),
                    ),
                  ),
                ),
              ),
            ],
          );
          transportMedium = "Use route";
          iconTransport = Icon(
            Icons.directions_subway,
            size: 35.0,
            color: Colors.grey,
          );
        }
        else if(transport == "bus"){
          lineRoute = Container(
            height: 70.0,
            width: 7.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
            ),
          );

          currentIcon = Icon(
            Icons.directions_bus, 
            color: Color.fromRGBO(0, 0, 0, 1.0)
          );

          distance = Row(
            children: [
              Icon(
                Icons.directions_bus,
                size: sizeIcon,
                color: Colors.black,
              ),
              Container(
                height: 27.0,
                width: 27.0,
                decoration: BoxDecoration(
                  color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
                ),
                child: Center(
                  child: Text(
                    info3.infoWalkList[x].legs[y].route,
                    style: TextStyle(
                      fontFamily: "AurulentSans-Bold",
                      color: hexColor(info3.infoWalkList[x].legs[y].routeTextColor),
                    ),
                  ),
                ),
              ),
            ],
          );
          transportMedium = "Use route";
          iconTransport = Icon(
            Icons.directions_bus,
            size: 35.0,
            color: Colors.grey,
          );
        }
        else if(transport == "bike"){
          lineRoute = Container(
            height: 70.0,
            width: 7.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
            ),
          );

          currentIcon = Icon(
            Icons.directions_bike, 
            color: Color.fromRGBO(0, 0, 0, 1.0)
          );

          transportMedium = "Use route";
          iconTransport = Icon(
            Icons.directions_bike,
            size: 35.0,
            color: Colors.grey,
          );
        }
        else{ //walk
          distance = Text(
            (info3.infoWalkList[x].legs[y].distance).toInt().toString() + "m",
            style: TextStyle(
              fontFamily: "AurulentSans-Bold",
            ),
          );
          lineRoute = Container(
            height: 70.0,
            width: 7.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromRGBO(0, 0, 0, 1.0),
            ),
          );

          currentIcon = Icon(
            Icons.directions_walk, 
            color: Color.fromRGBO(0, 0, 0, 1.0),
          ); 

          transportMedium = "Walk";
          iconTransport = Icon(
            Icons.directions_walk,
            size: 35.0,
            color: Colors.grey,
          );
        }
        
        var sTime = info3.infoWalkList[x].legs[y].startTime;
        var result1 = await convertSecToDay(sTime);
        String valueStartTime = "${result1.item2}:${result1.item3}";
        DateTime date1 = DateFormat("HH:mm").parse(valueStartTime);
        String startTime = DateFormat("hh:mma").format(date1);
        startTime = startTime.toLowerCase();

        var eTime = info3.infoWalkList[x].legs[y].endTime;
        var result2 = await convertSecToDay(eTime);
        String valueEndTime = "${result2.item2}:${result2.item3}";
        DateTime date2 = DateFormat("HH:mm").parse(valueEndTime);
        String endTime = DateFormat("hh:mma").format(date2);
        endTime = endTime.toLowerCase();

        var startsIn = info3.infoWalkList[x].legs[y].nameFrom; //lugar de origen
        var endsIn = info3.infoWalkList[x].legs[y].nameTo; //lugar de destino

        cardInfo.add(
          CardInfoRoutes(
            hourStart: startTime,
            iconTransportMedium: iconTransport,
            hourEnds: endTime,
            startIcon: originIcon,
            currentIcon: currentIcon,
            lineRoute: lineRoute,
            endIcon: endIcon,
            placeStartIn: startsIn,
            placeEndsIn: endsIn,
            nameTrasportMedium: transportMedium,
            infoOfDistance: 
              transport == "subway" ? 
                distance:
              transport == "bus" ?
                distance:
              transport == "bike" ?
                Container( //TODO: falta poner la informacion (distance) en bike
                  height: 20.0,
                  width: 20.0,
                  color: Colors.yellow,
                ): 
                distance,
            time: "$duration min",
          ),
        );
      }
      info.infoRoutList.add(cardInfo);
    }
  }

  Future<Tuple4<int, int, int, int>>convertSecToDay(int n){
    int day = n ~/ (24 * 3600); 
  
    n = n % (24 * 3600); 
    int hour = n ~/ 3600; 
  
    n %= 3600; 
    int minutes = n ~/ 60; 
  
    n %= 60; 
    int seconds = n;

    return Future.value(Tuple4(day, hour, minutes, seconds));
  }
}
