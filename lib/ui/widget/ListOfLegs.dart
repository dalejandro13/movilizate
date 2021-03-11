import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:provider/provider.dart';

class CardInfoRoute extends StatelessWidget {
  int index;
  //IconList icon;
  BuildContext context;
  bool enable;
  //InnerIconsInfo gii; //no olvidar descomentar esto
  //GetIconInList giil;
  double sizeIcon = 35.0;
  //GetInnerIconsInfo gii;
  //GetDataOfRoutes routes;
  InfoRouteServer info3;
  ProcessData info;
  FillInInformation fii = FillInInformation(); //nuevo

  CardInfoRoute(int index, BuildContext context, bool enable) {
    this.index = index;
    //this.icon = icon;
    this.enable = enable;
    //gii = InnerIconsInfo(context); //NO OLVIDAR DESCOMENTAR
    
    //gii = GetInnerIconsInfo(context);
    //routes = GetDataOfRoutes(context);
  }

  Color hexColor(String hexString){
    var buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7){
      buffer.write('ff');
    } 
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    info3 = Provider.of<InfoRouteServer>(context);
    info = Provider.of<ProcessData>(context);
        
    return Padding(
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Theme(
        data: ThemeData(splashColor: Colors.grey),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        info3.listOfInfo[index].timeArrived, //routes.infoCard.listOfInfo.value[index].timeArrived, //icon.timeArrived,
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          color: Color.fromRGBO(105, 190, 50, 1.0),
                          fontSize: 20.0,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Duration",
                        style: TextStyle(
                          fontFamily: "AurulentSans-Bold",
                          color: Color.fromRGBO(105, 190, 50, 1.0),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),

                        child: ListView.builder( //mirar si se puede poner un Consumer
                          scrollDirection: Axis.horizontal,
                          itemCount: info3.tileList[index].length, //gii.tile.[index].length,
                          itemBuilder: (BuildContext context, int ind) {
                            print(info3.tileList[index][ind].toString());
                            return Row(
                              children: [
                                info3.tileList[index][ind], //gii.tile.value[index][ind], /*GetInnerIconsInfo(context, index),*/ //gii.infoInner.tile.value[index], //getIcon(icon, context)[index], //obtengo los iconos internos
                              ],
                            );
                          }
                        ),


                        //NO BORRAR ESTAS LINEAS
                        // child: ValueListenableBuilder(
                        //   valueListenable: giil.ic.listIcon,
                        //   builder: (BuildContext context, dynamic val, Widget child){
                        //     return ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: giil.ic.listIcon.value.length,
                        //       itemBuilder: (BuildContext context, int ind){
                                
                        //         //EN METRO
                        //         return giil.ic.listIcon.value[ind][0] == "SUBWAY" ?
                        //           Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.directions_subway,
                        //                 size: sizeIcon,
                        //                 color: Colors.black,
                        //               ),
                        //               Container(
                        //                 height: 27.0,
                        //                 width: 27.0,
                        //                 decoration: BoxDecoration(
                        //                   color: hexColor(giil.ic.listIcon.value[ind][2]),
                        //                 ),
                        //                 child: Center(
                        //                   child: Text(
                        //                     giil.ic.listIcon.value[ind][1],
                        //                     style: TextStyle(
                        //                       fontFamily: "AurulentSans-Bold",
                        //                       color: hexColor(giil.ic.listIcon.value[ind][3]),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Icon(
                        //                 Icons.chevron_right,
                        //                 size: sizeIcon,
                        //                 color: Color.fromRGBO(105, 190, 50, 1.0),
                        //               ),
                        //             ],
                        //           ):

                        //           //EN BUS
                        //           giil.ic.listIcon.value[ind][0] == "BUS" ?
                        //           Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.directions_bus,
                        //                 size: sizeIcon,
                        //                 color: Colors.black,
                        //               ),
                        //               Container(
                        //                 height: 27.0,
                        //                 width: 27.0,
                        //                 decoration: BoxDecoration(
                        //                   color: hexColor(giil.ic.listIcon.value[ind][2]),
                        //                 ),
                        //                 child: Center(
                        //                   child: Text(
                        //                     giil.ic.listIcon.value[ind][1],
                        //                     style: TextStyle(
                        //                       fontFamily: "AurulentSans-Bold",
                        //                       color: hexColor(giil.ic.listIcon.value[ind][3]),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Icon(
                        //                 Icons.chevron_right,
                        //                 size: sizeIcon,
                        //                 color: Color.fromRGBO(105, 190, 50, 1.0),
                        //               ),
                        //             ],
                        //           ):
                                  
                        //           //EN BICICLETA
                        //           giil.ic.listIcon.value[ind][0] == "BIKE" ?
                        //           Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.directions_bike,
                        //                 size: sizeIcon,
                        //                 color: Colors.black,
                        //               ),
                        //               Icon(
                        //                 Icons.chevron_right,
                        //                 size: sizeIcon,
                        //                 color: Color.fromRGBO(105, 190, 50, 1.0),
                        //               )
                        //             ],
                        //           ):

                        //           //CAMINANDO
                        //           Row(
                        //             children: [
                        //               Icon(
                        //                 Icons.directions_walk,
                        //                 size: sizeIcon,
                        //                 color: Colors.black,
                        //               ),
                        //               Icon(
                        //                 Icons.chevron_right,
                        //                 size: sizeIcon,
                        //                 color: Color.fromRGBO(105, 190, 50, 1.0),
                        //               )
                        //             ],
                        //           );
                        //       },
                        //     );
                        //   }
                        // ),

                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 8.0, bottom: 10.0),
                      child: Row(
                        children: [
                          
                          Text(
                            info3.listOfInfo[index].timeDuration, //routes.infoCard.listOfInfo.value[index].timeDuration, //icon.timeDuration,
                            style: TextStyle(
                              fontFamily: "AurulentSans-Bold",
                              color: Color.fromRGBO(105, 190, 50, 1.0),
                              fontSize: 35.0,
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(""),
                              Text(
                                "min",
                                style: TextStyle(
                                  fontFamily: "AurulentSans-Bold",
                                  color: Color.fromRGBO(105, 190, 50, 1.0),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                
              ],
            ),
            onTap: enable ? () async {
              await fii.getDataToShow(info, info3);
              await Future.delayed(Duration(milliseconds: 300));
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index, context)));
            }:
            (){ },
          ),
        ),
      ),
    );
  }
}
