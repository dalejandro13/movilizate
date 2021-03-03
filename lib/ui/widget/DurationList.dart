import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/model/iconList.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/screen/ScreenRoutesInfo.dart';
import 'package:movilizate/ui/widget/ListOfLegs.dart';
import 'package:provider/provider.dart';

class DurationList extends StatefulWidget {
  //GetDataOfRoutes routes;
  //GetIconsInfoCard infoCard;

  DurationList(BuildContext context) {

    //routes = GetDataOfRoutes(context);
    //infoCard = GetIconsInfoCard(context);
  }

  @override
  _DurationListState createState() => _DurationListState();
}

class _DurationListState extends State<DurationList> {
  double sizeIcon = 35.0;

  @override
  Widget build(BuildContext context) {
    //final routes = Provider.of<GetDataOfRoutes>(context); //GetDataOfRoutes(context);
    var info3 = Provider.of<InfoRouteServer>(context);

    return ListView.separated(
      separatorBuilder: (_, __) => Divider(height: 10.0, color: Colors.transparent),
      itemCount: info3.listOfInfo.length, //widget.infoCard.listOfInfo.value.length,
      itemBuilder: (BuildContext context, int index) {
        return //(info3.listOfInfo.length == 1) ?  
          Container(
            height: 170.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: CardInfoRoute(index, context, true), //cardInfoRoute(index, widget.routes.infoCard.listOfInfo.value[index], context, true),
          );
        // (info3.listOfInfo.length > 1 && info3.tileList[index].length == 1 && info3.listOfInfo[index].legs[0].walk == "WALK") ? 
        //   SizedBox.shrink() :  //hay solo una ruta a pie
        //   Container(
        //     height: 170.0,
        //     width: MediaQuery.of(context).size.width,
        //     decoration: BoxDecoration(
        //       color: Colors.transparent,
        //     ),
        //     child: CardInfoRoute(index, context, true), //cardInfoRoute(index, widget.routes.infoCard.listOfInfo.value[index], context, true),
        //);
      },
    );

    // return ValueListenableBuilder(
    //   valueListenable: widget.routes.infoCard.listOfInfo, //widget.dataLegs.ic.listOfTransport,
    //   builder: (BuildContext context, dynamic value, Widget child){
    //     return ListView.separated(
    //       separatorBuilder: (_,__) => Divider(height: 10.0, color: Colors.transparent,),
    //       itemCount: widget.routes.infoCard.listOfInfo.value.length, //widget.dataLegs.ic.listOfTransport.value.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Container(
    //           height: 170.0,
    //           width: MediaQuery.of(context).size.width,
    //           decoration: BoxDecoration(
    //             color: Colors.transparent,
    //           ),
    //           child: CardInfoRoute(index, context, true),
    //         );
    //       }
    //     );
    //   }
    // );


  }
}
