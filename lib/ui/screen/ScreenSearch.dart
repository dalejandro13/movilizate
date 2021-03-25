import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/widget/ButtonSearch.dart';
import 'package:movilizate/ui/widget/ButtonUseTheMap.dart';
import 'package:movilizate/ui/widget/MatchList.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/ui/widget/TextOriginDestiny.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:async/async.dart';

class ScreenSearch extends StatefulWidget {

  @override
  _ScreenSearchState createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {

  ConsultServer consult = ConsultServer();
  double ubiLatitude = null, ubiLongitude = null;
  Location location = Location();
  bool _serviceEnabled = true;
  PermissionStatus _permissionGranted = null;
  LocationData _locationData = null;
  //AsyncMemoizer _memoizer = AsyncMemoizer();
  bool permission = true;
  dynamic color1 = null, color2 = null;
  ProcessData info;
  FocusNode focusOrigin = FocusNode();
  FocusNode focusDestiny = FocusNode();
  double opacityLevel = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  getPermission() async {
    color1 = Color.fromRGBO(81, 81, 81, 1.0);
    color2 = Color.fromRGBO(105, 190, 40, 1.0);

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        await consult.getUbication(context); //await getLocationGps(context); ///----
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        await consult.getUbication(context);
        return null;
      }
    }

    await getLocationGps(context);
    return null;
  }

  Future<void> getLocationGps(BuildContext context) async {
    
    info = Provider.of<ProcessData>(context, listen: false);
    _locationData = await location.getLocation();
    info.getLatitudeOrigin = null;
    info.getLongitudeOrigin = null;
    info.dataOrigin.text = null;
    
    info.getLatitudeOrigin = double.parse(_locationData.latitude.toStringAsFixed(6));
    info.getLongitudeOrigin = double.parse(_locationData.longitude.toStringAsFixed(6));
    info.dataOrigin.text = "${info.getLatitudeOrigin}, ${info.getLongitudeOrigin}";
  }

  @override
  Widget build(BuildContext context) {
    info = Provider.of<ProcessData>(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.bottom
    ]);

    return Scaffold(
      body:GestureDetector(
        onTap:(){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(105, 190, 50, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:40.0),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                      Expanded(
                        flex: 8,
                        child: AnimatedOpacity(
                          duration: Duration(seconds: 3),
                          curve: Curves.elasticOut,
                          opacity: info.opacityLevelOrigin,
                          child: TextOriginDestiny("Origen", consult, color1, info.dataOrigin, focusOrigin/*info.focusOrigin*/, true, false)), //AutoCompleteOrigin(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:15.0),
                ),

                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                      Expanded(
                        flex: 8,
                        child: AnimatedOpacity(
                          duration: Duration(seconds: 3),
                          curve: Curves.elasticOut,
                          opacity: info.opacityLevelDestiny, //opacityLevel,
                          child: TextOriginDestiny("Destino", consult, color2, info.dataDestiny, focusDestiny/*info.focusDestiny*/, true, false)), //AutoCompleteDestiny(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:10.0),
                ),

                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),

                      Expanded(
                        flex: 2,
                        child: ButtonSearch(consult, context, focusOrigin, focusDestiny),
                      ),

                      Expanded(
                        flex: 2,
                        child: Theme(
                          data: ThemeData(splashColor: Colors.white),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.0),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  Icons.swap_vert
                                ),
                                color: Colors.white,
                                iconSize: 300.0,
                                onPressed: () async {
                                  if(info.dataOrigin != null){
                                    if(info.dataDestiny != null){
                                      if(info.dataOrigin.text != ""){
                                        if(info.dataDestiny.text != ""){
                                          if(info.dataOrigin != null && info.dataDestiny != null){
                                            //intercambio valores de TextField de origen con el destino
                                            var aux1 =  info.dataOrigin.text;
                                            info.dataOrigin.text = info.dataDestiny.text;
                                            info.dataDestiny.text = aux1;
                                            
                                            //intercambio coordenas de latitud de origen con el destino
                                            var aux2 = info.getLatitudeOrigin;
                                            info.getLatitudeOrigin = info.getLatitudeDestiny;
                                            info.getLatitudeDestiny = aux2;

                                            //intercambio coordenadas de longitud de origen con el destino
                                            var aux3 = info.getLongitudeOrigin;
                                            info.getLongitudeOrigin = info.getLongitudeDestiny;
                                            info.getLongitudeDestiny = aux3;

                                            //animacion
                                            info.opacityLevelOrigin = info.opacityLevelOrigin == 1.0 ? 0.5 : 1.0;
                                            info.opacityLevelDestiny = info.opacityLevelDestiny == 1.0 ? 0.5 : 1.0;
                                            await Future.delayed(Duration(milliseconds: 200));                                   
                                            info.opacityLevelOrigin = info.opacityLevelOrigin == 1.0 ? 1.0 : 1.0;
                                            info.opacityLevelDestiny = info.opacityLevelDestiny == 1.0 ? 1.0 : 1.0;
                                                                
                                          }
                                          else{
                                            Fluttertoast.showToast(
                                              msg: "Falta ingresar datos de origen ó el destino",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.grey,
                                              textColor: Colors.white,
                                              fontSize: 20.0,
                                            );
                                          }
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                            msg: "Falta ingresar el destino",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 20.0,
                                          );
                                        }
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                          msg: "Falta ingresar el origen",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 20.0,
                                        );
                                      }
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                        msg: "Falta ingresar el destino",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey,
                                        textColor: Colors.white,
                                        fontSize: 20.0,
                                      );
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      msg: "Falta ingresar el origen",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 20.0,
                                    );
                                  }
                                },
                                
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:20.0),
                ),

                Expanded(
                  flex: 2,
                  child: UseTheMap(),
                ),

                Padding(
                  padding: EdgeInsets.only(top:10.0),
                ),

                Expanded(
                  flex: 6,
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 100),
                    crossFadeState: info.animationStart,
                    firstChild: info.progressIndicatorShow ? 
                      Container(
                        height: 100.0,
                        width: 100.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: 20.0),
                            CircularProgressIndicator(),
                          ],
                        )
                      ) : 
                      Container(
                        color: Colors.transparent
                      ),
                    secondChild: MatchList(focusOrigin, focusDestiny),
                  ),
                ),
              ],
            ),
          ),

          ]
        ),
      ),
    );
  }
}