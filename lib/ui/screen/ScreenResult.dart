import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:movilizate/ui/widget/ButtonsModesOfTransport.dart';
import 'package:movilizate/ui/widget/DurationList.dart';
import 'package:movilizate/ui/widget/TextOriginDestiny.dart';
import 'package:provider/provider.dart';

class ScreenResult extends StatefulWidget {

  ConsultServer consult;

  ScreenResult(ConsultServer consult){
    this.consult = consult;
  }

  @override
  _ScreenResultState createState() => _ScreenResultState();
}

class _ScreenResultState extends State<ScreenResult> {

  Color color1 = Color.fromRGBO(81, 81, 81, 1.0);
  Color color2 = Color.fromRGBO(105, 190, 50, 1.0);

  @override
  Widget build(BuildContext context){
    var info = Provider.of<ProcessData>(context);
    //var info2 = Provider.of<DataOfPlace>(context);
    //var info3 = Provider.of<InfoRouteServer>(context);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future(() => false);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap:(){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
              //Text(info2.title), //pendiente de borrar
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
                            child: TextOriginDestiny("Origen", widget.consult, color1, info.dataOrigin, info.focusOrigin, false)//AutoCompleteOrigin2(widget.consult),
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
                            child: TextOriginDestiny("Destino", widget.consult, color2, info.dataDestiny, info.focusDestiny, false), //AutoCompleteDestiny2(widget.consult),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                        ],
                      ),
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
                            child: ButtonsModesOfTransport(context)),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    Expanded(
                      flex: 7,
                      child: DurationList(context),
                    ),

                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}