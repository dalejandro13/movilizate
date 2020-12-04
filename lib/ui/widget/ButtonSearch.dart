import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/ShowTheRoute.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenResult.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:movilizate/ui/widget/TextOriginDestiny.dart';

class ButtonSearch extends StatefulWidget {

  ConsultServer consult; 
  BuildContext context;
  GetDataTrasnport gdt;
  GetIconsInfoCard infoCard;
  InnerIconsInfo iii;
  FocusNode focusOrigin, focusDestiny;

  ButtonSearch(ConsultServer consult, BuildContext context, FocusNode focusOrigin, FocusNode focusDestiny){
    this.consult = consult;
    this.context = context;
    this.focusOrigin = focusOrigin;
    this.focusDestiny = focusDestiny;
    gdt = GetDataTrasnport(context);
    infoCard = GetIconsInfoCard(context);
    iii = InnerIconsInfo(context);
  }

  @override
  _ButtonSearchState createState() => _ButtonSearchState();
}

class _ButtonSearchState extends State<ButtonSearch> {
  //http://181.140.181.103:9780/otp/routers/default/plan?fromPlace=6.260270778808053%2C-75.56984424591064&toPlace=6.263235600898669%2C-75.55920124053955&time=10%3A43am&date=11-06-2020&mode=TRANSIT%2CWALK&maxWalkDistance=804.672&arriveBy=false&wheelchair=false&locale=en
  HereMapController hereMapController;
  ShowTheRoute showInfo;
  String urlBase = "http://181.140.181.103:9780/otp/routers/default/plan?";
  String urlOrigin = null;
  String urlDestiny = null;
  String urlTime = null;
  String urlDate = null;
  String urlMode = "&mode=TRANSIT,WALK";
  String urlRest = "&maxWalkDistance=10000.672&arriveBy=false&wheelchair=false&locale=en";
  String urlComplete = null;
  DateTime now = null;
  DateFormat dfd = null;
  DateFormat dft = null;

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    var info3 = Provider.of<InfoRouteServer>(context);
    
    Future<void> getInfoOfRoutes() async {
      String urlComplete = null;
      urlOrigin = null;
      urlDestiny = null;
      urlTime = null;
      urlDate = null;
      //urlMode = null;
      //urlRest = null;
      now = null;
      dfd = null;
      dft = null;
      showInfo = null;

      now = DateTime.now();
      dfd = DateFormat("dd-MM-yyyy");
      dft = DateFormat("hh:mma");
      String actualDate = dfd.format(now);
      String actualTime = dft.format(now);
      actualTime = actualTime.toLowerCase();

      urlOrigin = "fromPlace=${info.getLatitudeOrigin},${info.getLongitudeOrigin}";
      urlDestiny = "&toPlace=${info.getLatitudeDestiny},${info.getLongitudeDestiny}";
      urlTime = "&time=$actualTime";
      urlDate = "&date=$actualDate";
      //urlMode = "&mode=TRANSIT,WALK";
      //urlRest = "&maxWalkDistance=10000.672&arriveBy=false&wheelchair=false&locale=en";
      //urlComplete = "$urlBase$urlOrigin$urlDestiny$urlTime$urlDate$urlMode$urlRest";

      urlComplete = "http://181.140.181.103:9780/otp/routers/default/plan?fromPlace=6.260270778808053%2C-75.56984424591064&toPlace=6.263235600898669%2C-75.55920124053955&time=10%3A43am&date=11-06-2020&mode=TRANSIT%2CWALK&maxWalkDistance=804.672&arriveBy=false&wheelchair=false&locale=en";

      await widget.consult.getInfoFromServer(urlComplete, info3);
      
      showInfo = ShowTheRoute(context, hereMapController);
      showInfo.originAndDestiny().then((wayPoints) async {
        await showInfo.infoWalkRoute(wayPoints);
        return;
      });
    }

    return Container(
      height: 60.0,
      width: 180.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color.fromRGBO(87, 114, 26, 1.0),
      ),
      child: InkWell(
        onTap: () async {
          try{
            var result = await InternetAddress.lookup('google.com');
            if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              if(info.dataOrigin.text != ""){
                if(info.dataDestiny.text != ""){
                  if(info.getLatitudeOrigin != 0.0 && info.getLongitudeOrigin != 0.0){
                    if(info.getLatitudeDestiny != 0.0 && info.getLongitudeDestiny != 0.0){
                      //info.focusDestiny.unfocus();
                      //info.focusOrigin.unfocus();
                      await getInfoOfRoutes();
                      await widget.gdt.iconsOfTransport();
                      if(info3.infoWalkList.length > 0){
                        await widget.infoCard.getIconsInfo(context);
                        await widget.iii.getIcon();
                        if(info3.infoWalkList.length > 0 && info3.listOfTransport.length > 0 && info3.listOfInfo.length > 0 && info3.tileList.length > 0){
                          var result1 = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenResult(widget.consult, context)));
                          FocusScope.of(this.context).requestFocus(widget.focusOrigin);
                          FocusScope.of(this.context).requestFocus(widget.focusDestiny);
                          if(result1 == "Origen"){
                            widget.focusOrigin.requestFocus();
                          }
                          else{
                            if(result1 == "Destino"){
                              widget.focusDestiny.requestFocus();
                            }
                          }
                        }
                        else{
                          Fluttertoast.showToast(
                            msg: "Informacion incompleta, intentalo nuevamente",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 30.0,
                          );
                          info3.infoWalkList.clear();
                        }
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Problemas con procesar la informacion, intentalo mas tarde",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 30.0,
                        );
                        info3.infoWalkList.clear();
                      }
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: "Ingresa el destino apropiado",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 30.0,
                      );
                    }
                  }
                  // else{ //cuando no se dan los permisos de geolocalizacion
                  //   if(info2.initialPlace.length != 0){
                  //     //for(var jj in info2.initialPlace){
                  //       //print(jj.title);
                  //       //print(jj.lon);
                  //       //print(jj.lat);
                  //       //info.focusDestiny.unfocus();
                  //       //info.focusOrigin.unfocus();
                  //       try {
                  //         var result = await InternetAddress.lookup('google.com');
                  //         if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  //           await getInfoOfRoutes().then((value){
                  //             Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenResult(widget.consult)));
                  //           });
                  //         }
                  //       } 
                  //       catch(e) {
                  //         Fluttertoast.showToast(
                  //           msg: "Sin conexion a internet",
                  //           toastLength: Toast.LENGTH_LONG,
                  //           gravity: ToastGravity.BOTTOM,
                  //           fontSize: 30.0,
                  //         );
                  //       }
                  //     //}
                  //   }
                  //   else{
                  //     Fluttertoast.showToast(
                  //       msg: "Falta Ingresar el origen",
                  //       toastLength: Toast.LENGTH_LONG,
                  //       gravity: ToastGravity.BOTTOM,
                  //       fontSize: 30.0,
                  //     );
                  //   }
                  // }
                }
                else{
                  Fluttertoast.showToast(
                    msg: "Falta ingresar el destino",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 30.0,
                  );
                }
              }
              else{
                Fluttertoast.showToast(
                  msg: "Falta ingresar el origen",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 30.0,
                );
              }
            }
          }
          catch(e){
            Fluttertoast.showToast(
              msg: "No estas conectado a internet",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 30.0,
            );
          }
        },
        child: Center(
          child: Text(
            "Search",
            style: TextStyle(
              fontFamily: "AurulentSans-Bold",
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}