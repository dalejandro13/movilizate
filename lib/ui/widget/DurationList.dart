import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';

class DurationList extends StatefulWidget {

  GetDataOfRoutes routes;

  DurationList(BuildContext context){
    routes = GetDataOfRoutes(context);
  }

  @override
  _DurationListState createState() => _DurationListState();
}

class _DurationListState extends State<DurationList> {

  // double sizeIcon = 35.0;

  // ListTile cardInfoRoute(int index, IconList icon, BuildContext context, bool enable){
  //   return ListTile(
  //       title: Padding(
  //       padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
  //       child: Container(
  //         height: 140.0,
  //         width: 70.0,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8.0),
  //           color: Colors.white,
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [

  //                 Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     icon.timeArrived,
  //                     style: TextStyle(
  //                       fontFamily: "AurulentSans-Bold",
  //                       color: Color.fromRGBO(105, 190, 50, 1.0),
  //                       fontSize: 20.0,
  //                     ),
  //                   ),
  //                 ),

  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.0),
  //                   child: Text(
  //                     "Duration",
  //                     style: TextStyle(
  //                       fontFamily: "AurulentSans-Bold",
  //                       color: Color.fromRGBO(105, 190, 50, 1.0),
  //                       fontSize: 20.0,
  //                     ),
  //                   ),
  //                 ),

  //               ],
  //             ),

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [

  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
  //                   child: Container(
  //                     height: 50.0,
  //                     width: 160.0,
  //                     decoration: BoxDecoration(
  //                       color: Colors.transparent,
  //                     ),
  //                     child: ListView.builder(
  //                       scrollDirection: Axis.horizontal,
  //                       itemBuilder: (BuildContext context, int index){
  //                         return Row(
  //                           children: [
  //                             getIcon(icon)[index],
  //                           ],
  //                         );
  //                       }
  //                     ),
  //                   ),
  //                 ),

  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.0, bottom: 10.0),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         icon.timeDuration,
  //                         style: TextStyle(
  //                           fontFamily: "AurulentSans-Bold",
  //                           color: Color.fromRGBO(105, 190, 50, 1.0),
  //                           fontSize: 35.0,
  //                         ),
  //                       ),

  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(""),

  //                           Text(
  //                             "min",
  //                             style: TextStyle(
  //                               fontFamily: "AurulentSans-Bold",
  //                               color: Color.fromRGBO(105, 190, 50, 1.0),
  //                             ),
  //                           )
  //                         ],
  //                       )

  //                     ],
  //                   ),
  //                 ),

  //               ],
  //             ),

  //           ],
  //         ),
  //       ),
  //     ),
  //     onTap: enable ? (){
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index, context)));
  //     }:
  //     null,
  //   );
  // }

  // List<Widget> getIcon(IconList icon){

  //   List<Widget> tile = null;
  //   tile = [];

  //   for(int j = 0; j < icon.legs.length; j++){
  //     if(icon.legs[j].subway == "SUBWAY"){
  //       tile.add(
  //         Icon(
  //           Icons.directions_subway,
  //           size: sizeIcon,
  //           color: Colors.black,
  //         )
  //       );
  //       tile.add(
  //         Icon(
  //           Icons.chevron_right,
  //           size: sizeIcon,
  //           color: Color.fromRGBO(105, 190, 50, 1.0),
  //         )
  //       );
  //     }
  //     else{
  //       if(icon.legs[j].bus == "BUS"){
  //         tile.add(
  //           Icon(
  //             Icons.directions_bus,
  //             size: sizeIcon,
  //             color: Colors.black,
  //           ),
  //         );
  //         tile.add(
  //           Icon(
  //             Icons.chevron_right,
  //             size: sizeIcon,
  //             color: Color.fromRGBO(105, 190, 50, 1.0),
  //           )
  //         );

  //       }
  //       else{
  //         if(icon.legs[j].bike == "BIKE"){
  //           tile.add(
  //           Icon(
  //             Icons.directions_bike,
  //             size: sizeIcon,
  //             color: Colors.black,
  //           ),
  //           );
  //           tile.add(
  //             Icon(
  //               Icons.chevron_right,
  //               size: sizeIcon,
  //               color: Color.fromRGBO(105, 190, 50, 1.0),
  //             )
  //           );
  //         }
  //         else{
  //           if(icon.legs[j].walk == "WALK"){
  //             tile.add(
  //               Icon(
  //                 Icons.directions_walk,
  //                 size: sizeIcon,
  //                 color: Colors.black,
  //               ),
  //             );
  //             tile.add(
  //               Icon(
  //                 Icons.chevron_right,
  //                 size: sizeIcon,
  //                 color: Color.fromRGBO(105, 190, 50, 1.0),
  //               )
  //             );
  //           }
  //         }
  //       }
  //     }
  //   }
  //   tile.removeLast();

  //   return tile;

  //   // return ListTile(
  //   //   title: tile,
  //   //   onTap: null,
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.routes.infoCard.listOfInfo, //widget.dataLegs.ic.listOfTransport,
      builder: (BuildContext context, dynamic value, Widget child){
        return ListView.separated(
          separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
          itemCount: widget.routes.infoCard.listOfInfo.value.length, //widget.dataLegs.ic.listOfTransport.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: CardInfoRoute(index, widget.routes.infoCard.listOfInfo.value[index], context, true), //cardInfoRoute(index, widget.routes.infoCard.listOfInfo.value[index], context, true),
            );
          }
        );
      }
    );
  }
}

// class DurationList extends StatefulWidget {

//   // int change;
//   // DurationList({
//   //   this.change,
//   // });

//   @override
//   DurationListState createState() => DurationListState();
// }

// class DurationListState extends State<DurationList> {
//   List<String> timeArrived;
//   List<String> timeArrived2;
//   List<ListTile> listCard;
//   List<ListTile> listCard2;
//   ProcessData info;
//   InfoRouteServer info3;
//   List<Widget> linesOf;
//   List<Widget> placesForLine;
//   double sizeIcon = 35.0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   Color hexColor(String hexString) {
//     var buffer = StringBuffer();
//     if (hexString.length == 6 || hexString.length == 7){
//       buffer.write('ff');
//     } 
//     buffer.write(hexString.replaceFirst('#', ''));
//     return Color(int.parse(buffer.toString(), radix: 16));
//   }

//   Widget getTransport(String mode, int i, int y) {
//     Widget dataBus, dataSubway;
//     if(mode == null){
//       return Expanded(flex: 1, child: Container());
//     }
//     else{
//       if(mode == ''){
//         return Expanded(flex: 1, child: Container());
//       }
//       else if(mode == "WALK"){
//         return Expanded(
//           flex: 1, 
//           child: Icon(
//             Icons.directions_walk,
//             size: sizeIcon,
//           )
//         );
//       }
//       else if(mode == "SUBWAY"){
//         if(info3.infoWalkList[i].legs[y].route != null || info3.infoWalkList[i].legs[y].route != ""){
//           dataSubway = Container(
//             height: 50.0,
//             width: 90.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Icon(
//                     Icons.directions_subway,
//                     size: sizeIcon,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: 27.0,
//                     width: 27.0,
//                     decoration: BoxDecoration(
//                       color: hexColor(info3.infoWalkList[i].legs[y].routeColor), //Colors.red,
//                     ),
//                     child: Center(
//                       child: Text(
//                         info3.infoWalkList[i].legs[y].route,
//                         style: TextStyle(
//                           fontFamily: "AurulentSans-Bold",
//                           color: hexColor(info3.infoWalkList[i].legs[y].routeTextColor), //Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         else{
//           dataSubway = Expanded(
//             flex: 2, 
//             child: Icon(
//               Icons.directions_subway,
//               size: sizeIcon,
//             )
//           );
//         }
//         return dataSubway;
//       }
//       else{ // en BUS
//         if(info3.infoWalkList[i].legs[y].route != null || info3.infoWalkList[i].legs[y].route != ""){
//           dataBus = Container(
//             height: 50.0,
//             width: 90.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Icon(
//                     Icons.directions_bus,
//                     size: sizeIcon,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: 27.0,
//                     width: 27.0,
//                     decoration: BoxDecoration(
//                       color: hexColor(info3.infoWalkList[i].legs[y].routeColor), //Colors.red,
//                     ),
//                     child: Center(
//                       child: Text(
//                         info3.infoWalkList[i].legs[y].route,
//                         style: TextStyle(
//                           fontFamily: "AurulentSans-Bold",
//                           color: hexColor(info3.infoWalkList[i].legs[y].routeTextColor), //Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         else{
//           dataBus = Expanded(
//             flex: 2, 
//             child: Icon(
//               Icons.directions_bus,
//               size: sizeIcon,
//             )
//           );
//         }
//         return dataBus; //Expanded(flex: 2, child: Icon(Icons.directions_bus));
//       }
//     }
//   }

//   List<Widget> elementsRow(int i) {
//     linesOf = null;
//     placesForLine = null;
//     linesOf = [];
//     placesForLine = [];
    
//     try{
//       for(int y = 0; y < info3.infoWalkList[i].legs.length; y++){
//         placesForLine.add(
//           getTransport(info3.infoWalkList[i].legs[y].mode, i, y),
//         );
//         placesForLine.add(
//           Expanded(
//             flex: 1, 
//             child: Icon(Icons.chevron_right, color: Color.fromRGBO(105, 190, 50, 1.0)),
//           ),
//         );
//       }

//       placesForLine.removeLast();

//       linesOf.add(
//         Container(
//           width: 400.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: placesForLine,
//           ),
//         ),
//       );
//     }
//     catch(e){
//       print("Error $e");
//     }
//     return linesOf;    
//   }

//   Future<List<ListTile>> insertData() async {

//     //listCard = null;
//     listCard2 = null;
//     //listCard = [];
//     listCard2 = [];
//     info.listCard.clear();

//     timeArrived = null;
//     timeArrived2 = null;
//     timeArrived = [];
//     timeArrived2 = [];

//     for(int i = 0; i < info3.infoWalkList.length; i++){
//       try{
//         int minutes = (info3.infoWalkList[i].waitingTime / 60).truncate(); //convertir de segundos a minutos
//         timeArrived.add("Arrived: ${minutes.toString()} min");

//         int minutesDuration = (info3.infoWalkList[i].duration / 60).truncate(); //convertir de segundos a minutos
//         timeArrived2.add("${minutesDuration.toString()}");
//       }
//       catch(e){
//         print("Error $e");
//       }
//     }

//     //if(info.changeOfTransport == 0){ //pone datos por defecto
//     for(int i = 0; i < info3.infoWalkList.length; i++){
//       listCard2.add(
//         ListTile(
//           onTap: null,
//           title: Container(
//             padding: EdgeInsets.all(10.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       timeArrived[i],
//                       style: TextStyle(
//                         fontFamily: "AurulentSans-Bold",
//                         color: Color.fromRGBO(105, 190, 50, 1.0),
//                         fontSize: 20.0,
//                       ),
//                     ),
//                     Text(
//                       "Duration",
//                       style: TextStyle(
//                         fontFamily: "AurulentSans-Bold",
//                         color: Color.fromRGBO(105, 190, 50, 1.0),
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ],
//                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: elementsRow(i).length,
//                           itemBuilder: (context, index){
//                             return elementsRow(i)[index];
//                           }
//                         )
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             timeArrived2[i],
//                             style: TextStyle(
//                               fontFamily: "AurulentSans-Bold",
//                               color: Color.fromRGBO(105, 190, 50, 1.0),
//                               fontSize: 35.0,
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(""),
//                               Text(
//                                 "min",
//                                 style: TextStyle(
//                                   fontFamily: "AurulentSans-Bold",
//                                   color: Color.fromRGBO(105, 190, 50, 1.0),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         )
//       );

//       info.listCard.add(
//         ListTile(
//           onTap: (){ 
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index: i)));
//           },
//           title: Container(
//             padding: EdgeInsets.all(10.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       timeArrived[i],
//                       style: TextStyle(
//                         fontFamily: "AurulentSans-Bold",
//                         color: Color.fromRGBO(105, 190, 50, 1.0),
//                         fontSize: 20.0,
//                       ),
//                     ),
//                     Text(
//                       "Duration",
//                       style: TextStyle(
//                         fontFamily: "AurulentSans-Bold",
//                         color: Color.fromRGBO(105, 190, 50, 1.0),
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ],
//                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: elementsRow(i).length,
//                           itemBuilder: (context, index){
//                             return elementsRow(i)[index];
//                           }
//                         )
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.0),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 3,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             timeArrived2[i],
//                             style: TextStyle(
//                               fontFamily: "AurulentSans-Bold",
//                               color: Color.fromRGBO(105, 190, 50, 1.0),
//                               fontSize: 35.0,
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(""),
//                               Text(
//                                 "min",
//                                 style: TextStyle(
//                                   fontFamily: "AurulentSans-Bold",
//                                   color: Color.fromRGBO(105, 190, 50, 1.0),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
      
//     info3.listCanceled = listCard2;
//     return info.listCard;
//   }

//   //int state = 2; //0: bus, 1: cicla, 2: a pie

//   @override
//   Widget build(BuildContext context) {
//     info = Provider.of<ProcessData>(context);
//     info3 = Provider.of<InfoRouteServer>(context);

//     return Container( //info.listOfTransport = Container(
//       height: MediaQuery.of(context).size.height - 90.0,
//       width: MediaQuery.of(context).size.width - 30.0,
//       child: FutureBuilder(
//         future: insertData(),
//         builder: (BuildContext context, AsyncSnapshot<List<ListTile>> snapshot){
//           if(snapshot.hasData){
//             return ListView.separated(
//               separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
//               itemCount: info.listCard.length,//snapshot.data.length, //timeArrived.length,
//               itemBuilder: (BuildContext context, int index){
//                 return info.listCard[index];
//               }, 
//             );
//           }
//           else{
//             return CircularProgressIndicator();
//           }
//         }
//       ),
//     );

//   }
// }