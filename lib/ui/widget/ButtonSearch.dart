import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/ShowTheRoute.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenResult.dart';
import 'package:movilizate/ui/widget/ShowDialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ButtonSearch extends StatefulWidget {
  ConsultServer consult; 
  BuildContext context;
  GetDataTransport gdt;
  GetIconsInfoCard infoCard;
  InnerIconsInfo iii;
  FocusNode focusOrigin, focusDestiny;

  ButtonSearch(ConsultServer consult, BuildContext context, FocusNode focusOrigin, FocusNode focusDestiny){
    this.consult = consult;
    this.context = context;
    this.focusOrigin = focusOrigin;
    this.focusDestiny = focusDestiny;
    gdt = GetDataTransport(context);
    infoCard = GetIconsInfoCard(context);
    iii = InnerIconsInfo(context);
  }

  @override
  _ButtonSearchState createState() => _ButtonSearchState();
}

class _ButtonSearchState extends State<ButtonSearch> {
  List<int> timeList;
  HereMapController hereMapController;
  ShowTheRoute showInfo;
  String urlBase = "http://190.29.200.53:9780/otp/routers/default/plan?"; //"http://181.140.180.63:9780/otp/routers/default/plan?";  //"http://190.29.195.216:9780/otp/routers/default/plan?"; //"http://181.140.181.103:9780/otp/routers/default/plan?";
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
  bool processingData = false;
  List<InternetAddress> result = null;

  ProcessData info;
  DataOfPlace  info2;
  InfoRouteServer info3;

  Future<void> getOptimalTime() async {
    timeList = null;
    timeList = [];
    for(int x = 0; x < info3.listOfInfo.length; x++){
      timeList.add(int.parse(info3.listOfInfo[x].timeDuration));
    }
    timeList.sort();
    info3.bestTime = timeList.first; //toma el tiempo mas optimo
  }

  Future<void> getUrls() async {
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
    dfd = DateFormat("MM-dd-yyyy");
    dft = DateFormat("hh:mma");
    String actualDate = dfd.format(now);
    String actualTime = dft.format(now);
    actualTime = actualTime.toLowerCase();

    urlOrigin = "fromPlace=${info.getLatitudeOrigin},${info.getLongitudeOrigin}";
    urlDestiny = "&toPlace=${info.getLatitudeDestiny},${info.getLongitudeDestiny}";
    urlTime = "&time=$actualTime";
    urlDate = "&date=$actualDate";
    
    urlMode = "&mode=TRANSIT,WALK";
    urlRest = "&maxWalkDistance=1000.672&arriveBy=false&wheelchair=false&locale=en";
    urlComplete = "$urlBase$urlOrigin$urlDestiny$urlTime$urlDate$urlMode$urlRest";
    print("URL DE CONSULTA: $urlComplete");
    //URL DE CONSULTA: http://181.140.180.63:9780/otp/routers/default/plan?fromPlace=6.246267,-75.599008&toPlace=6.27436,-75.55569&time=10:19am&date=01-19-2021&mode=TRANSIT,WALK&maxWalkDistance=10000.672&arriveBy=false&wheelchair=false&locale=en

    await widget.consult.getInfoFromServer(urlComplete, info3);
    showInfo = ShowTheRoute(context, hereMapController);
    showInfo.originAndDestiny().then((wayPoints) async {
      await showInfo.infoWalkRoute(wayPoints);
      return;
    });
  }

  // showAlertDialog(BuildContext context, String msg) {

  //   // set up the button
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Advertencia"),
  //     content: Text(msg),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ProcessData>(context);
    info2 = Provider.of<DataOfPlace>(context);
    info3 = Provider.of<InfoRouteServer>(context);
    return Material(
      color: Color.fromRGBO(87, 114, 26, 1.0),
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
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
        onTap: () async {
          if(!processingData){
            processingData = true;
            try{
              result = null;
              result = [];
              result = await InternetAddress.lookup('google.com'); //verifica la conexion a internet
              if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                if(info.dataOrigin.text != ""){
                  if(info.dataDestiny.text != ""){
                    if(info.dataOrigin.text != info.dataDestiny.text){
                      if(info.getLatitudeOrigin != 0.0 && info.getLongitudeOrigin != 0.0){
                        if(info.getLatitudeDestiny != 0.0 && info.getLongitudeDestiny != 0.0){
                          //info.focusDestiny.unfocus();
                          //info.focusOrigin.unfocus();
                          await getUrls();
                          await widget.gdt.iconsOfTransport();
                          if(info3.infoWalkList.length > 0){
                            await widget.infoCard.getIconsInfo(context);
                            await widget.iii.getIcon();
                            // for(int b = 0; b < info3.infoWalkList.length; b++){
                            //   print(info3.infoWalkList);
                            // }
                            if(info3.infoWalkList.length > 0 && info3.listOfTransport.length > 0 && info3.listOfInfo.length > 0 && info3.tileList.length > 0){
                              await getOptimalTime();
                              var result1 = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenResult(widget.consult)));
                              //FocusScope.of(this.context).requestFocus(widget.focusOrigin);
                              //FocusScope.of(this.context).requestFocus(widget.focusDestiny);

                              //eliminar el arreglo del listView
                              // if(result1){
                              //   info2.infoPlace.clear();
                              // }

                              processingData = false;
                              if(result1 == "Origen"){
                                widget.focusOrigin.requestFocus();
                              }
                              else if(result1 == "Destino"){
                                widget.focusDestiny.requestFocus();
                              }
                              else{
                                //cuando presiono el boton back, elmina los datos de destino para que el usuario ingrese unos nuevos
                                info.dataDestiny.text = "";
                                info.getLatitudeDestiny = 0.0;
                                info.getLongitudeDestiny = 0.0;
                                //widget.focusDestiny.requestFocus();
                              }
                            }
                            else{
                              FocusScope.of(context).unfocus();
                              Fluttertoast.showToast(
                                msg: "Informacion incompleta, intentalo nuevamente",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 20.0,
                              );
                              info3.infoWalkList.clear();
                              processingData = false;
                            }
                          }
                          else{
                            FocusScope.of(context).unfocus();
                            Fluttertoast.showToast(
                              msg: "Problemas con procesar la informacion, intentalo mas tarde",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 20.0,
                            );
                            info3.infoWalkList.clear();
                            processingData = false;
                          }
                        }
                        else{
                          FocusScope.of(context).unfocus();
                          Fluttertoast.showToast(
                            msg: "Ingresa el destino apropiado",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 20.0,
                          );
                          processingData = false;
                        }
                      }
                    }
                    else{
                      FocusScope.of(context).unfocus();
                      Fluttertoast.showToast(
                        msg: "Tienes el mismo origen y destino, por favor ingresa un origen y destino diferentes",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 20.0,
                      );
                      processingData = false;
                    }
                  }
                  else{
                    FocusScope.of(context).unfocus();
                    Fluttertoast.showToast(
                      msg: "Falta ingresar el destino",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 20.0,
                    );
                    processingData = false;
                  }
                }
                else{
                  FocusScope.of(context).unfocus();
                  Fluttertoast.showToast(
                    msg: "Falta ingresar el origen",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 20.0,
                  );
                  processingData = false;
                }
              }
              else{
                processingData = false;
              }
            }
            catch(e){
              FocusScope.of(context).unfocus();
              Fluttertoast.showToast(
                msg: "No estas conectado a internet, intenta conectarte a una red e intentalo nuevamente",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 20.0,
              );
              processingData = false;
            }
          }
        },
        
      ),
    );
  }
}