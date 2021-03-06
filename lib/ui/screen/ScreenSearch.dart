import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:movilizate/repository/ConsultServer.dart';
//import 'package:movilizate/ui/widget/AutoComplete.dart';
import 'package:movilizate/ui/widget/AutoCompleteDestiny.dart';
import 'package:movilizate/ui/widget/AutoCompleteOrigin.dart';
import 'package:movilizate/ui/widget/ButtonSearch.dart';
import 'package:movilizate/ui/widget/ButtonUseTheMap.dart';
import 'package:movilizate/ui/widget/MatchList.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async/async.dart';

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
  AsyncMemoizer _memoizer = AsyncMemoizer();
  bool permission = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
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
    //var info2 = Provider.of<DataOfPlace>(context);
    var info = Provider.of<ProcessData>(context, listen: false);
    _locationData = await location.getLocation();
    info.getLatitudeOrigin = _locationData.latitude;
    info.getLongitudeOrigin = _locationData.longitude;
    info.dataOrigin.text = "${info.getLatitudeOrigin}, ${info.getLongitudeOrigin}";
  }

  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);

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
                        child: AutoCompleteOrigin(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:5.0),
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
                        child: AutoCompleteDestiny(context),
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
                        flex: 1,
                        child: ButtonSearch(consult),
                      ),

                      Expanded(
                        flex: 2,
                        child: IconButton(
                          color: Colors.white,
                          iconSize: 40.0,
                          onPressed: () {
                            if(info.dataOrigin != null){
                              if(info.dataDestiny != null){
                                if(info.dataOrigin.text != ""){
                                  if(info.dataDestiny.text != ""){
                                    if(info.dataOrigin != null && info.dataDestiny != null){
                                      //setState(() {
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
                                      //});
                                    }
                                    else{
                                        Fluttertoast.showToast(
                                        msg: "Falta ingresar datos de origen ó el destino",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        fontSize: 30.0,
                                      );
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                      msg: "Falta ingresar el destino",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      fontSize: 30.0,
                                    );
                                  }
                                }
                                else{
                                  Fluttertoast.showToast(
                                    msg: "Falta ingresar el origen",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 30.0,
                                  );
                                }
                              }
                              else{
                                Fluttertoast.showToast(
                                  msg: "Falta ingresar el destino",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  fontSize: 30.0,
                                );
                              }
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Falta ingresar el origen",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 30.0,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.swap_vert
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
                  flex: 1,
                  child: UseTheMap(),
                ),

                Padding(
                  padding: EdgeInsets.only(top:10.0),
                ),

                Expanded(
                  flex: 7,
                  child: MatchList(),
                ),
              ],
            ),
          ),


        // AutocompleteWidget(),
        // UseTheMap(),
        // AutoCompleteVisual(),
          ]
        ),
      ),
    );
  }
  
}