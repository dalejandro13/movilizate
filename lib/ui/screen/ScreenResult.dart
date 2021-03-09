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

  ScreenResult(ConsultServer consult, BuildContext context){
    this.consult = consult;
  }

  @override
  _ScreenResultState createState() => _ScreenResultState();
}

class _ScreenResultState extends State<ScreenResult> {

  Color color1 = Color.fromRGBO(81, 81, 81, 1.0);
  Color color2 = Color.fromRGBO(105, 190, 50, 1.0);
  bool passOne = true;

  @override
  Widget build(BuildContext context){
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    Future<bool> _willPopCallBack() async {
      info2.infoPlace = null;
      info2.infoPlace = [];
      return true;
    }

    return WillPopScope(
      onWillPop: _willPopCallBack,
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
                            child: TextOriginDestiny("Origen", widget.consult, color1, info.dataOrigin, info.focusOrigin, false, true)//AutoCompleteOrigin2(widget.consult),
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

                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                          Expanded(
                            flex: 8,
                            child: TextOriginDestiny("Destino", widget.consult, color2, info.dataDestiny, info.focusDestiny, false, true), //AutoCompleteDestiny2(widget.consult),
                          ),
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
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                          Expanded(
                            flex: 8,
                            child: /*Icon(Icons.directions_bus, size: 60.0, color: Colors.white)*/ 
                              ButtonsModesOfTransport(context, passOne),
                          ),
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