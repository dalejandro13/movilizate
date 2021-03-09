import 'package:flutter/material.dart';
//import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:here_sdk/mapview.dart';
import 'package:movilizate/model/iconList.dart';
//import 'package:movilizate/repository/ConsultServer.dart';

class ProcessData with ChangeNotifier{

  TextEditingController dataTextInput = TextEditingController();

  TextEditingController autocompleteOrigin = TextEditingController();
  TextEditingController autocompleteDestiny = TextEditingController();

  String time = "";
  CrossFadeState firstState = CrossFadeState.showFirst;
  bool progressIndicator = false;
  double latitude = 0.0, longitude = 0.0, latitudeOrigin = 0.0, longitudeOrigin = 0.0, latitudeDestiny = 0.0, longitudeDestiny = 0.0;
  double opacityOrigin = 1.0, opacityDestiny = 1.0;
  // ignore: avoid_init_to_null
  HereMapController hereMapController = null;
  List<Widget> widgetList = List<Widget>();
  List<List<CardInfoRoutes>> infoRoutes = List<List<CardInfoRoutes>>();

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
  set infoRoutList(List<List<CardInfoRoutes>> list){
    infoRoutes = list;
    notifyListeners();
  }

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

  get listCard => listTransport;
  set listCard(List<ListTile> val){
    listTransport = val;
    notifyListeners();
  }

  get opacityLevelOrigin => opacityOrigin;
  set opacityLevelOrigin(double val){
    opacityOrigin = val;
    notifyListeners();
  }

  get opacityLevelDestiny => opacityDestiny;
  set opacityLevelDestiny(double val){
    opacityDestiny = val;
    notifyListeners();
  }

  get animationStart => firstState;
  set animationStart(CrossFadeState val){
    firstState = val;
    notifyListeners();
  }

  get progressIndicatorShow => progressIndicator;
  set progressIndicatorShow(bool val){
    progressIndicator = val;
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

  List<InfoRouteServ> infoWalk = [];
  //List<Widget> listCanceled = [];

  List<List<Widget>> iconList = [];

  List<List<Widget>> tile = [];
  List<bool> listTrans = [];

  List<IconList> listInfoIcon = [];

  int index1 = 0, bestT = 0;


  get infoWalkList => infoWalk;
  set infoWalkList(List<InfoRouteServ> val){
    infoWalk = val;
    notifyListeners();
  }

  get iconListInner => iconList;
  set iconListInner( List<List<Widget>> val){
    iconList = val;
    notifyListeners();
  }

  get tileList => tile;
  set tileList(List<List<Widget>> val){
    tile = val;
    notifyListeners();
  }

  get listOfTransport => listTrans;
  set listOfTransport(List<bool> val){
    listTrans = val;
    notifyListeners();
  }

  get listOfInfo => listInfoIcon;
  set listOfInfo(List<IconList> val){
    listInfoIcon = val;
    notifyListeners();
  }

  get bestTime => bestT;
  set bestTime(int val){
    bestT = val;
    notifyListeners();
  }
}