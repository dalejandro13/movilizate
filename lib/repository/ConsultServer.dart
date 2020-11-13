import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';

class ConsultServer{

  // BuildContext context;
  
  // ConsultServer(BuildContext context){
  //   this.context = context;
  // }

  String urlBase = "https://geocode.search.hereapi.com/v1/geocode?languages=es&limit=50&qq=";
  String urlUbication = "country=colombia;city=";
  String apiKey = "&apiKey=UXMqWoRbB7fHSTkIRgcP9l7BgUSgUEDNx6D5ggQnP9w";
  List<DataOfPlace> place;
  //List<InfoRouteServer> place2;
  List<LegsInfo> legs;
  bool enter = true;
  List<Widget> wid;
  List<Widget> cardListWidget;
  double lonOrig, latOrig, lonDest, latDest; 

  Future<void> getPreviousInfo() async {
    //info = Provider.of<ProcessData>(context);
    place = null;
    place = [];
    
    String completeUrl = "$urlBase$urlUbication"+"santafe"+"$apiKey";
    try{
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
        //print(info.infoPlace);
      }
      else{
        print("Error en la consulta, intentalo nuevamente");
      }
    }
    catch(e){
      print("Error: $e");
    }
  }

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
        if(place.length == 100){
          place = null;
          place = [];
        }
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
            //info.latitudeData = vv["position"]["lat"];
            //info.longitudeData = vv["position"]["lng"];
            //print("latitud: ${info.latitudeData.toString()}");
            //print("longitud: ${info.longitudeData.toString()}");
            //enter = true;
            //await routing.putMarker(info.latitudeData, info.longitudeData, enter);
          }
          place = place.toSet().toList();
          info2.infoPlace = place;
          // if(info.focusOrigin.hasFocus){
          //   print("almacena en origen");
          // }
          // else{
          //   if(info.focusDestiny.hasFocus){
          //     print("almacena en destino");
          //   }
          // }
          // if(info2.infoPlace.length > 0){
          //   for(var jj in info2.infoPlace){
          //     print(jj.title);
          //     print(jj.lat);
          //     print(jj.lon);
          //   }
          // }
          //var nn = place;
          //setState((){ });
          // if(enter){
          //   await routing.putMarker(info.latitudeData, info.longitudeData, enter);
          // }
          // else{
          //   Fluttertoast.showToast(
          //     msg: "Error en la consulta, intentalo nuevamente",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.BOTTOM,
          //   );
          // }
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
      
      dynamic duration = null, startTime = null, endTime = null, walkTime = null, waitingTime = null, walkDistance = null, mode = null, route = null, routeColor = null, routeTextColor = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;
      lonOrig = null; latOrig = null; lonDest = null; latDest = null;

      var resp = await http.get(urlComplete, headers: {'Content-Type': 'application/json'});
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
          // var to = jsonResp["plan"]["to"];
          // var name2 = to["name"];
          // var lonDestiny = to["lon"];
          // var latDestiny = to["lat"];
          // var origin2 = to["orig"];
          // var vertexType2 = to["vertexType"];
          // print(date.toString());
          // print(name1);
          // print(lonOrigin.toString());
          // print(latOrigin.toString());
          // print(orig1);
          // print(vertexType1);
          // print(name2);
          // print(lonDestiny.toString());
          // print(latDestiny.toString());
          // print(origin2);
          // print(vertexType2);
          
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
              mode = ss["mode"];
              route = ss["route"];
              routeColor = ss["routeColor"];
              routeTextColor = ss["routeTextColor"];

              lonOrig = ss["from"]["lon"];
              latOrig = ss["from"]["lat"];
              lonDest = ss["to"]["lon"];
              latDest = ss["to"]["lat"];

              legs.add(
                LegsInfo(
                  mode: mode,
                  route: route,
                  routeColor: routeColor,
                  routeTextColor: routeTextColor,
                  lonOrig: lonOrig,
                  latOrig: latOrig,
                  lonDest: lonDest,
                  latDest: latDest
                ),
              );
            }

            info3.infoWalkList.add(
              InfoRouteServer(
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

  // Future<List<Widget>> obtainAndShowInfo(InfoRouteServer info3) async {
  //   wid = null;
  //   wid = [];
  //   if(info3.infoWalkList.length > 0){
  //     for(var tt in info3.infoWalkList){
  //       // print(tt.duration);
  //       // print(tt.startTime);
  //       // print(tt.endTime);
  //       for(var gg in tt.legs){

  //         // print(gg.mode);
  //         // print(gg.route);
  //         // print(gg.routeColor);
  //         // print(gg.lonOrig);
  //         // print(gg.latOrig);
  //       }
  //     }
  //   }
  //   else{
  //     wid = null;
  //   }
  //   return wid;
  // }


}