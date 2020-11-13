import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';

class ProcessData with ChangeNotifier{

  TextEditingController dataTextInput = TextEditingController();

  TextEditingController autocompleteOrigin = TextEditingController();
  TextEditingController autocompleteDestiny = TextEditingController();

  // TextEditingController autocompleteOrigin2 = TextEditingController();
  // TextEditingController autocompleteDestiny2 = TextEditingController();

  String time = "";

  double latitude = 0.0, longitude = 0.0, latitudeOrigin = 0.0, longitudeOrigin = 0.0, latitudeDestiny = 0.0, longitudeDestiny = 0.0;
  HereMapController hereMapController = null;
  List<Widget> widgetList = List<Widget>();
  List<CardInfoRoutes> infoRoutes = List<CardInfoRoutes>();

  FocusNode focusOri = FocusNode();
  FocusNode focusDes = FocusNode();

  FocusNode focusOri2 = FocusNode();
  FocusNode focusDes2 = FocusNode();

  int change = 0;

  List<ListTile> listTransport = [];
  List<ListTile> listTransport2 = [];
  

  get dataText{
    return dataTextInput;
  }
  set dataText(TextEditingController data){
    dataTextInput = data;
    notifyListeners();
  }

  get dataOrigin{
    return autocompleteOrigin;
  }
  set dataOrigin(TextEditingController data){
    autocompleteOrigin = data;
    notifyListeners();
  }

  get dataDestiny{
    return autocompleteDestiny;
  }
  set dataDestiny(TextEditingController data){
    autocompleteDestiny = data;
    notifyListeners();
  }

  // get dataOrigin2{
  //   return autocompleteOrigin2;
  // }
  // set dataOrigin2(TextEditingController data){
  //   autocompleteOrigin2 = data;
  //   notifyListeners();
  // }

  // get dataDestiny2{
  //   return autocompleteDestiny2;
  // }
  // set dataDestiny2(TextEditingController data){
  //   autocompleteDestiny2 = data;
  //   notifyListeners();
  // }



  get latitudeData{
    return latitude;
  }
  set latitudeData(double value){
    latitude = value;
    notifyListeners();
  }

  get longitudeData{
    return longitude;
  }
  set longitudeData(double value){
    longitude = value;
    notifyListeners();
  }

  get mapController{
    return hereMapController;
  }
  set mapController(HereMapController ctrl){
    hereMapController = ctrl;
    notifyListeners();
  }

  get listW{
    return widgetList;
  }
  set listW(List<Widget> ltw){
    widgetList = ltw;
    notifyListeners();
  }

  get infoRoutList{
    return infoRoutes;
  }
  set infoRoutList(List<CardInfoRoutes> list){
    infoRoutes = list;
    notifyListeners();
  }

  // get focusActive{
  //   return focus;
  // }
  // set focusActive(bool val){
  //   focus = val;
  //   notifyListeners();
  // }

  get focusOrigin{
    return focusOri;
  }
  set focusOrigin(FocusNode val){
    focusOri = val;
    notifyListeners();
  }
  get focusDestiny{
    return focusDes;
  }
  set focusDestiny(FocusNode val){
    focusDes = val;
    notifyListeners();
  }


  get focusOrigin2{
    return focusOri2;
  }
  set focusOrigin2(FocusNode val){
    focusOri2 = val;
    notifyListeners();
  }
  get focusDestiny2{
    return focusDes2;
  }
  set focusDestiny2(FocusNode val){
    focusDes2 = val;
    notifyListeners();
  }


  get getLatitudeOrigin{
    return latitudeOrigin;
  }
  set getLatitudeOrigin(double val){
    latitudeOrigin = val;
    notifyListeners();
  }

  get getLongitudeOrigin{
    return longitudeOrigin;
  }
  set getLongitudeOrigin(double val){
    longitudeOrigin = val;
    notifyListeners();
  }

  get getLatitudeDestiny{
    return latitudeDestiny;
  }
  set getLatitudeDestiny(double val){
    latitudeDestiny = val;
    notifyListeners();
  }

  get getLongitudeDestiny{
    return longitudeDestiny;
  }
  set getLongitudeDestiny(double val){
    longitudeDestiny = val;
    notifyListeners();
  }

  get getTimeEstimated => time;
  set getTimeEstimated(String val){
    time = val;
    notifyListeners();
  }

  // get changeOfTransport => change;
  // set changeOfTransport(int val){
  //   change = val;
  //   notifyListeners();
  // }

  get listOfTransport => listTransport;
  set listOfTransport(List<ListTile> val){
    listTransport = val;
    notifyListeners();
  }

  get listOfTransport2 => listTransport2;
  set listOfTransport2(List<ListTile> val){
    listTransport2 = val;
    notifyListeners();
  }



}

class DataOfPlace with ChangeNotifier{

  List<DataOfPlace> listDataPlace = [];
  List<DataOfPlace> initialUbication = [];

  String title;
  double lat, lon;
  DataOfPlace({
    this.title,
    this.lat,
    this.lon,
  });

  get infoPlace => listDataPlace;
  set infoPlace(List<DataOfPlace> data){
    listDataPlace = data;
    notifyListeners();
  }

  get initialPlace => initialUbication;
  set initialPlace(List<DataOfPlace> data){
    initialUbication = data;
    notifyListeners();
  }
}

class InfoRouteServer with ChangeNotifier{

  List<InfoRouteServer> infoWalk = [];
  List<Widget> listCanceled = [];

  int duration;
  int startTime;
  int endTime;
  int walkTime;
  int waitingTime;
  double walkDistance;
  List<LegsInfo> legs;
  // List<double> latOrigin;
  // List<double> lonOrigin;
  // List<double> latDestiny;
  // List<double> lonDestiny;

  InfoRouteServer({
    this.duration,
    this.startTime,
    this.endTime,
    this.walkTime,
    this.waitingTime,
    this.walkDistance,
    this.legs,
  });

  get infoWalkList => infoWalk;
  set infoWalkList(List<InfoRouteServer> val){
    infoWalk = val;
    notifyListeners();
  }

  get onTapCanceledList => listCanceled;
  set onTapCanceledList(List<Widget> val){
    listCanceled = val;
  }

}

class LegsInfo{
  String mode;
  String route;
  String routeColor;
  String routeTextColor;
  double lonOrig, latOrig, lonDest, latDest; //List<double> lonOrig, latOrig, lonDest, latDest;

  LegsInfo({
    this.mode,
    this.lonOrig, 
    this.latOrig, 
    this.lonDest, 
    this.latDest,
    this.route,
    this.routeColor,
    this.routeTextColor,
  });
}

class CardInfoRoutes {
  String hourStart;
  Widget iconTransportMedium;
  String hourEnds;
  String nameTrasportMedium;
  String placeStartIn;
  String placeEndsIn;
  Widget infoOfDistance;
  String time;
  CardInfoRoutes({
    this.hourStart,
    this.iconTransportMedium,
    this.hourEnds,
    this.nameTrasportMedium,
    this.placeStartIn,
    this.placeEndsIn,
    this.infoOfDistance,
    this.time,
  });
}