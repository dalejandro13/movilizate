import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class ConsultServer{
  String testUrlBase = "http://192.168.1.200:8888/Api/GetSearchOptions/"; //192.168.1.200 //localhost
  String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
  String urlUbication = "country=colombia;state=antioquia;city=Envigado&q=";
  String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";
  List<DataOfPlace> place;
  //List<InfoRouteServer> place2;
  List<LegsInfo> legs;
  List<double> ltWalk, lgWalk; 
  bool enter = true;
  List<Widget> wid;
  List<Widget> cardListWidget;
  double lonOrig, latOrig, lonDest, latDest; 

  Future<void> getUbication(BuildContext context) async {
    place = null;
    place = [];
    try{
      var info2 = Provider.of<DataOfPlace>(context, listen: false);
      var info = Provider.of<ProcessData>(context, listen: false);
      //String completeUrl = "$urlBase$urlUbication"+"estacion envigado"+"$apiKey";
      //var resp = await http.get(completeUrl, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
      //if(resp.statusCode == 200){
        //var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
        //for(var vv in jsonResp["items"]){
        place.add(
          DataOfPlace(
            title: "Estacion metro envigado", //vv["title"],
            lat: 6.174508, //vv["position"]["lat"],
            lon: -75.595364, //vv["position"]["lng"],
          )
        );
        //}
        info2.initialPlace = place;
        if(info2.initialPlace.length > 0){
          for(dynamic vv in info2.initialPlace){
            info.getLatitudeOrigin = double.parse(vv.lat.toStringAsFixed(6));
            info.getLongitudeOrigin = double.parse(vv.lon.toStringAsFixed(6));
            info.dataOrigin.text = vv.title;
          }
        }
      // }
      // else{
      //   print("Error en la consulta, intentalo nuevamente");
      // }
    }
    catch(e){
      print("Error: $e");
    }
  }

  Future<void> getInfoInSearch(ProcessData info, DataOfPlace info2, List<DataOfPlace> place1) async {
    //https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=country=colombia;state=antioquia&q=san jose&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w

    // String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
    // String urlUbication = "country=colombia;state=antioquia&q=";
    // String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";

    // String urlBase1 = "https://discover.search.hereapi.com/v1/discover?languages=es&limit=20&qq=";
    // String urlAt = "&at=6.268053,-75.580138";
    // String urlUbication1 = "country=colombia;state=antioquia&q=";
    // String apiKey1 = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";

    //String completeUrl = "$urlBase$urlUbication${info.dataText.text}$apiKey"; //NO OLVIDAR DESCOMENTAR ESTO, LINEA ORIGINAL


    String completeUrl1 = "$testUrlBase${info.dataText.text}";
    print("URL DE CONSULTA CON DB: $completeUrl1");
    bool ready1 = false, ready2 = false;
    try{
      if(enter){
        enter = false;
        if(info.dataText.text.toLowerCase() == "alcaldia" || info.dataText.text.toLowerCase() == "alcaldía" || info.dataText.text.toLowerCase() == "parque de " || info.dataText.text.toLowerCase() == "socoda" || info.dataText.text.toLowerCase() == "calle 38 sur" || info.dataText.text.toLowerCase() == "point 16" || info.dataText.text.toLowerCase() == "Drogueria santa ana envigado"){ //NUEVA CONDICION
          var resp = await http.get(completeUrl1, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
          if(resp.statusCode == 200){
            var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));

            for(var vv in jsonResp["hereItems"]["items"]){
              if(vv["title"] != "Envigado, Colombia"){ //condicional para no tomar el dato si aparece este mensaje
                place1.add(
                  DataOfPlace(
                    title: vv["title"],
                    lat: vv["position"]["lat"],
                    lon: vv["position"]["lng"],
                  ),
                );
              }
              else if(vv["title"] == "Envigado, Colombia" && (info.dataText.text.toLowerCase() == "envigado" || info.dataText.text.toLowerCase() == "envigado")){
                place1.add(
                  DataOfPlace(
                    title: vv["title"],
                    lat: vv["position"]["lat"],
                    lon: vv["position"]["lng"],
                  ),
                );
              }
              ready1 = true;
            }

            if(jsonResp["gtfsItems"] != null){ //condicional por si el dato es nulo
              if(ready1){

                if(place1.length != 0){
                  place1.clear(); //elimina la informacion repetida de HereMaps
                }

                for(var jj in jsonResp["gtfsItems"]["items"]){
                  place1.add(
                    DataOfPlace(
                      title: jj["title"],
                      lat: jj["position"]["lat"],
                      lon: jj["position"]["lng"],
                    ),
                  );
                  ready2 = true;
                }

              }
            }
            else{
              ready2 = true;
            }
            
            if(ready1 && ready2){
              ready1 = false;
              ready2 = false;
              if(place1.length > 0){
                //elimino la informacion repetida de la lista
                Map<String, DataOfPlace> mp = {};
                for(var item in place1){
                  mp[item.title] = item;
                }
                info2.infoPlace = mp.values.toList();
              }
            }
            
          }
          else{
            print("Error en la consulta, intentalo nuevamente");
          }
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
      ltWalk = null;
      lgWalk = null;
      info3.infoWalkList = null;
      info3.infoWalkList = [];
      legs = [];
      ltWalk = [];
      lgWalk = [];
      
      dynamic duration = null, startTime = null, endTime = null, walkTime = null, waitingTime = null, walkDistance = null, startTimeInitial = null, endTimeFinal = null, mode = null, route = null, routeColor = null, routeId = null, tripId = null, routeTextColor = null, nameFrom = null, nameTo = null, distance = null, durationTransport = null, stopIdFrom = null, stopIdTo = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;

      var resp = await http.get(urlComplete, headers: {'Content-Type': 'application/json'}).timeout(Duration(seconds: 7));
      if(resp.statusCode == 200){
        var jsonResp = jsonDecode(utf8.decode(resp.bodyBytes));
        if(jsonResp["error"] == null){          
          for(var vv in jsonResp["plan"]["itineraries"]){
            legs = null;
            ltWalk = null;
            lgWalk = null;
            legs = [];
            ltWalk = [];
            lgWalk = [];
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
              routeId = ss["routeId"]; //nuevo
              routeTextColor = ss["routeTextColor"];
              tripId = ss["tripId"]; //nuevo
              nameFrom = ss["from"]["name"];
              stopIdFrom = ss["from"]["stopId"]; //nuevo
              lonOrig = ss["from"]["lon"];
              latOrig = ss["from"]["lat"];
              nameTo = ss["to"]["name"];
              stopIdTo = ss["to"]["stopId"]; //nuevo
              lonDest = ss["to"]["lon"];
              latDest = ss["to"]["lat"];
              durationTransport = ss["duration"];

              if(mode == "WALK"){ //nuevo
                if(ss["steps"] != []){
                  if(ss["steps"] != null){
                    for(var xx in ss["steps"]){
                      ltWalk.add(xx["lat"]);
                      lgWalk.add(xx["lon"]);
                    }
                  }
                }
              }
              
              legs.add(
                LegsInfo(
                  distance: distance,
                  startTime: startTimeInitial,
                  endTime: endTimeFinal,
                  mode: mode,
                  route: route,
                  routeColor: routeColor,
                  routeId: routeId, //nuevo
                  routeTextColor: routeTextColor,
                  tripId: tripId, //nuevo
                  nameFrom: nameFrom,
                  stopIdFrom: stopIdFrom, //nuevo
                  lonOrig: lonOrig,
                  latOrig: latOrig,
                  nameTo: nameTo,
                  stopIdTo: stopIdTo, //nuevo
                  lonDest: lonDest,
                  latDest: latDest,
                  durationTransport: durationTransport,
                  ltWalk: ltWalk, //nuevo
                  lgWalk: lgWalk, //nuevo
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
        }
        else{
          print("Error: ${jsonResp["error"]["id"]}");
          print("${jsonResp["error"]["msg"]}");
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
  }

  Future<void> getIconsInfo(BuildContext context) async {
    info3.listOfInfo = null;
    info3.listOfInfo = [];
    legs = null;
    legs = [];
    String timeArrived = null, timeDuration = null, cableCar = null, subway = null, bus = null, bike = null, walk = null;
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

          if(info3.infoWalkList[i].legs[y].mode == "CABLE_CAR"){
            cableCar = info3.infoWalkList[i].legs[y].mode; //"CABLE_CAR";
            subway = "";
            bus = "";
            bike = "";
            walk = "";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          else if(info3.infoWalkList[i].legs[y].mode == "SUBWAY"){
            cableCar = "";
            subway = info3.infoWalkList[i].legs[y].mode; //"SUBWAY";
            bus = "";
            bike = "";
            walk = "";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          else if(info3.infoWalkList[i].legs[y].mode == "BUS"){
            cableCar = "";
            subway = "";
            bus = info3.infoWalkList[i].legs[y].mode; //"BUS";
            bike = "";
            walk = "";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          else if(info3.infoWalkList[i].legs[y].mode == "BIKE"){
            cableCar = "";
            subway = "";
            bus = "";
            bike = info3.infoWalkList[i].legs[y].mode; //"BIKE";
            walk = "";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          else if(info3.infoWalkList[i].legs[y].mode == "WALK"){
            cableCar = "";
            subway = "";
            bus = "";
            bike = "";
            walk = info3.infoWalkList[i].legs[y].mode; //"WALK";
            route = info3.infoWalkList[i].legs[y].route;
            routeColor = info3.infoWalkList[i].legs[y].routeColor;
            routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          }
          
          // if(info3.infoWalkList[i].legs[y].mode == "SUBWAY"){
          //   subway = "SUBWAY";
          //   bus = "";
          //   bike = "";
          //   walk = "";
          //   route = info3.infoWalkList[i].legs[y].route;
          //   routeColor = info3.infoWalkList[i].legs[y].routeColor;
          //   routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          // }
          // else{
          //   if(info3.infoWalkList[i].legs[y].mode == "BUS"){
          //     subway = "";
          //     bus = "BUS";
          //     bike = "";
          //     walk = "";
          //     route = info3.infoWalkList[i].legs[y].route;
          //     routeColor = info3.infoWalkList[i].legs[y].routeColor;
          //     routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          //   }
          //   else{
          //     if(info3.infoWalkList[i].legs[y].mode == "BIKE"){
          //       subway = "";
          //       bus = "";
          //       bike = "BIKE";
          //       walk = "";
          //       route = info3.infoWalkList[i].legs[y].route;
          //       routeColor = info3.infoWalkList[i].legs[y].routeColor;
          //       routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          //     }
          //     else{
          //       if(info3.infoWalkList[i].legs[y].mode == "WALK"){
          //         subway = "";
          //         bus = "";
          //         bike = "";
          //         walk = "WALK";
          //         route = info3.infoWalkList[i].legs[y].route;
          //         routeColor = info3.infoWalkList[i].legs[y].routeColor;
          //         routeTextColor = info3.infoWalkList[i].legs[y].routeTextColor;
          //       }
          //     }
          //   }
          // }
          
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
  }
}

class InnerIconsInfo extends ChangeNotifier{
  double sizeIcon = 35.0;
  InfoRouteServer route; 
  List<Widget> element = List<Widget>();

  InnerIconsInfo(BuildContext context){
    route = Provider.of<InfoRouteServer>(context);
  }

  Future<Color> hexColor(String hexString) async {
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
        if(route.infoWalkList[i].legs[j].mode == "CABLE_CAR"){
          element.add(
            Icon(
              Icons.directions_train,
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
                  color: await hexColor(route.infoWalkList[i].legs[j].routeColor),
                ),
                child: Center(
                  child: Text(
                    route.infoWalkList[i].legs[j].route,
                    style: TextStyle(
                      fontFamily: "AurulentSans-Bold",
                      color: await hexColor(route.infoWalkList[i].legs[j].routeTextColor),
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
                    color: await hexColor(route.infoWalkList[i].legs[j].routeColor),
                  ),
                  child: Center(
                    child: Text(
                      route.infoWalkList[i].legs[j].route,
                      style: TextStyle(
                        fontFamily: "AurulentSans-Bold",
                        color: await hexColor(route.infoWalkList[i].legs[j].routeTextColor),
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
                      color: await hexColor(route.infoWalkList[i].legs[j].routeColor),
                    ),
                    child: Center(
                      child: Text(
                        route.infoWalkList[i].legs[j].route,
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          color: await hexColor(route.infoWalkList[i].legs[j].routeTextColor),
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
      }
      element.removeLast();
      route.tileList.add(element);
    }
  }
}

class GetDataTrasnport{

  BuildContext context;
  InfoRouteServer info3;
  bool subway = false, bus = false, bike = false, walk = false;

  GetDataTrasnport(BuildContext context){
    this.context = context;
    info3 = Provider.of<InfoRouteServer>(context);
  }

  Future<void> iconsOfTransport() async {
    info3.listOfTransport = null;
    info3.listOfTransport = [false, false, false, false, false];
    for(int i = 0; i < info3.infoWalkList.length; i++){      
      for(int j = 0; j < info3.infoWalkList[i].legs.length; j++){
        if(info3.infoWalkList[i].legs[j].mode == "CABLE_CAR"){
          if(info3.listOfTransport[0] == false){
            info3.listOfTransport[0] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "SUBWAY"){
          if(info3.listOfTransport[1] == false){
            info3.listOfTransport[1] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BUS"){
          if(info3.listOfTransport[2] == false){
            info3.listOfTransport[2] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "BIKE"){
          if(info3.listOfTransport[3] == false){
            info3.listOfTransport[3] = true;
          }
        }
        else if(info3.infoWalkList[i].legs[j].mode == "WALK"){
          if(info3.listOfTransport[4] == false){
            info3.listOfTransport[4] = true;
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
  }

  getInfoIcon(){
    data2 = null;
    data2 = [];
    data2 = null;
    data2 = [];
    for(int y = 0; y < info3.infoWalkList[indexC.value].legs.length; y++){
      data = null;
      data = [];
      if(info3.infoWalkList[indexC.value].legs[y].mode == "CABLE_CAR"){
        data.add(info3.infoWalkList[indexC.value].legs[y].mode); //tipo de transporte
        data.add(info3.infoWalkList[indexC.value].legs[y].route); //nombre de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeColor); //color de ruta
        data.add(info3.infoWalkList[indexC.value].legs[y].routeTextColor); //color de letra de la ruta
      }
      else if(info3.infoWalkList[indexC.value].legs[y].mode == "SUBWAY"){
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
      listIcon.value.add(data);
    }
    listIcon.notifyListeners();
    indexC.notifyListeners();
  }

}

class FillInInformation{

  List<CardInfoRoutes> cardInfo = null;

  Color hexColor(String hexString){
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> getDataToShow(ProcessData info, InfoRouteServer info3) async {
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
        if(transport == "cable_car"){
          lineRoute = Container(
            height: 70.0,
            width: 7.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: hexColor(info3.infoWalkList[x].legs[y].routeColor),
            ),
          );

          currentIcon = Icon(
            Icons.directions_train, 
            color: Color.fromRGBO(0, 0, 0, 1.0),
          );

          distance = Row(
            children: [
              Icon(
                Icons.directions_train,
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
            Icons.directions_train,
            size: 35.0,
            color: Colors.grey,
          );
        }
        else if(transport == "subway"){
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
            color: Color.fromRGBO(0, 0, 0, 1.0),
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
        
        dynamic sTime = info3.infoWalkList[x].legs[y].startTime;
        Tuple4<int, int, int, int> result1 = await convertSecToDay(sTime);
        String valueStartTime = "${result1.item2}:${result1.item3}";
        DateTime date1 = DateFormat("HH:mm").parse(valueStartTime);
        String startTime = DateFormat("hh:mma").format(date1);
        startTime = startTime.toLowerCase();

        dynamic eTime = info3.infoWalkList[x].legs[y].endTime;
        Tuple4<int, int, int, int> result2 = await convertSecToDay(eTime);
        String valueEndTime = "${result2.item2}:${result2.item3}";
        DateTime date2 = DateFormat("HH:mm").parse(valueEndTime);
        String endTime = DateFormat("hh:mma").format(date2);
        endTime = endTime.toLowerCase();

        dynamic startsIn = info3.infoWalkList[x].legs[y].nameFrom; //lugar de origen
        dynamic endsIn = info3.infoWalkList[x].legs[y].nameTo; //lugar de destino

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
                Container( //TODO: falta poner la informacion (distance) en la opcion de bike
                  height: 20.0,
                  width: 20.0,
                  color: Colors.yellow,
                ): 
                distance, //informacion para walking
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
