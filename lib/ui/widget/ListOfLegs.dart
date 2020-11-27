import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:provider/provider.dart';

class CardInfoRoute extends StatelessWidget {

  int index;
  //IconList icon; 
  BuildContext context; 
  bool enable;
  GetInnerIconsInfo gii;
  GetDataOfRoutes routes;

  CardInfoRoute(int index, /*IconList icon,*/ BuildContext context, bool enable){
    this.index = index;
    //this.icon = icon;
    this.enable = enable;
    gii = GetInnerIconsInfo(context);
    routes = GetDataOfRoutes(context);
  }

  @override
  Widget build(BuildContext context) {
    //gii = Provider.of<GetInnerIconsInfo>(context);
    //routes = Provider.of<GetDataOfRoutes>(context);
    return ValueListenableBuilder<List<IconList>>(
      valueListenable: routes.infoCard.listOfInfo, //gii.infoInner.tile,
      builder: (BuildContext context, dynamic value, Widget child){
        return ListTile(
          title: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Container(
            height: 140.0,
            width: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        routes.infoCard.listOfInfo.value[index].timeArrived, //icon.timeArrived,
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
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: Container(
                        height: 50.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),

                        child: ValueListenableBuilder(
                          valueListenable: gii.infoInner.tile, //routes.infoCard.listOfInfo,
                          builder: (BuildContext context, dynamic value, Widget child){
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: gii.infoInner.tile.value[index].length,
                              itemBuilder: (BuildContext context, int ind){
                                return Row(
                                  children: [
                                    gii.infoInner.tile.value[index][ind], /*GetInnerIconsInfo(context, index),*/ //gii.infoInner.tile.value[index], //getIcon(icon, context)[index], //obtengo los iconos internos
                                  ],
                                );
                              }
                            );
                          }
                        ),


                        // child: ListView.builder(
                        //   scrollDirection: Axis.horizontal,
                        //   itemCount: routes.infoCard.listOfInfo.value.length,
                        //   itemBuilder: (BuildContext context, int ind){
                        //     return ValueListenableBuilder(
                        //       valueListenable: gii.infoInner.tile, //routes.infoCard.listOfInfo,
                        //       builder: (BuildContext context, dynamic value, Widget child){
                        //         return Row(
                        //           children: [
                        //             gii.infoInner.tile.value[index][ind], /*GetInnerIconsInfo(context, index),*/ //gii.infoInner.tile.value[index], //getIcon(icon, context)[index], //obtengo los iconos internos
                        //           ],
                        //         );
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
                            routes.infoCard.listOfInfo.value[index].timeDuration, //icon.timeDuration, 
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
                          )

                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
        onTap: enable ? (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenMap(index, context)));
        }:
        (){ },
      );

      },
          
    );
  }
}