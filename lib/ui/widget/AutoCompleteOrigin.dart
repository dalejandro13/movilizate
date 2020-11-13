import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:movilizate/bloc/ProcessData.dart';
import 'package:movilizate/repository/ConsultServer.dart';
import 'package:provider/provider.dart';

class AutoCompleteOrigin extends StatefulWidget {

  BuildContext context;

  AutoCompleteOrigin(BuildContext context){
    this.context = context;
  }

  @override
  _AutoCompleteOriginState createState() => _AutoCompleteOriginState();
}

class _AutoCompleteOriginState extends State<AutoCompleteOrigin> {

  //GlobalKey<AutoCompleteTextFieldState<DataOfPlace>> key1 = GlobalKey();
  //AutoCompleteTextField searchTextField;
  //List<DataOfPlace> location;
  //FocusNode _focusOrigin = FocusNode();
  //TextEditingController controller = TextEditingController(); 
  ConsultServer consult = ConsultServer();
  // double ubiLatitude = 0.0, ubiLongitude = 0.0;
  //List<DataOfPlace> place = null;
  
  // @override
  // void initState() {
  //   super.initState();
  //   _focusOrigin.addListener(_onFocusChange);
  // }

  // void _onFocusChange(){
  //   debugPrint("Focus Origin: "+_focusOrigin.hasFocus.toString());
  // }
  
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<ProcessData>(context);
    var info2 = Provider.of<DataOfPlace>(context);
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width - 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white
      ),
      child: TextFormField(
        controller: info.dataOrigin,
        focusNode: info.focusOrigin, //_focusOrigin, //info.focusOrigin,
        style: TextStyle(
          fontFamily: "AurulentSans-Bold",
          color: Color.fromRGBO(81, 81, 81, 1.0),
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          hintText: "Origen",
          hintStyle: TextStyle(
            fontFamily: "AurulentSans-Bold",
            color: Color.fromRGBO(81, 81, 81, 1.0),
            fontSize: 20.0,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 15.8, right: 5.0, bottom: 7.0),
          prefixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){},
            iconSize: 20.0,
            color: Color.fromRGBO(81, 81, 81, 1.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              //controller.text = "";
              info.dataOrigin.text = "";
              info2.infoPlace = [];
            },
            iconSize: 20.0,
            color: Color.fromRGBO(81, 81, 81, 1.0),
          ),
        ),
        onChanged: (val) async {
          if(val.length >= 3){
            info.dataText.text = val;
            await consult.getInfoInMaps(info, info2);
          }
          else if(val.length >= 0 && val.length <= 2 ){
            consult.place = null;
            consult.place = [];
            info2.infoPlace = [];
          }
          //setState(() { });
        },
        
      // searchTextField = AutoCompleteTextField<DataOfPlace>(
      //   key: key1,
      //   controller: info.dataOrigin,
      //   clearOnSubmit: false,
      //   suggestions: consult.place, //info.infoPlace, //pl, //consult.place,
      //   style: TextStyle(
      //     fontFamily: "AurulentSans-Bold",
      //     color: Color.fromRGBO(81, 81, 81, 1.0),
      //     fontSize: 20.0,
      //   ),
      //   decoration: InputDecoration(
      //     hintText: "Origen",
      //     hintStyle: TextStyle(
      //       fontFamily: "AurulentSans-Bold",
      //       color: Color.fromRGBO(81, 81, 81, 1.0),
      //       fontSize: 20.0,
      //     ),
      //     border: InputBorder.none,
      //     contentPadding: EdgeInsets.only(left: 15.8, right: 5.0),
      //     prefixIcon: IconButton(
      //       icon: Icon(Icons.location_on),
      //       onPressed: (){},
      //       iconSize: 20.0,
      //       color: Color.fromRGBO(81, 81, 81, 1.0),
      //     ),
      //     suffixIcon: IconButton(
      //       icon: Icon(Icons.close),
      //       onPressed: (){
      //         //controller.text = "";
      //         info.dataOrigin.text = "";
      //       },
      //       iconSize: 20.0,
      //       color: Color.fromRGBO(81, 81, 81, 1.0),
      //     ),
      //   ),
        
      //   itemBuilder: (context, item){
      //     return Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Text(
      //           item.title,
      //           style: TextStyle(
      //             fontSize: 16.0
      //           ),
      //         ),
      //         Padding(
      //           padding: EdgeInsets.all(15.0),
      //         ),
      //         // Text(
      //         //   item.lat.toString(),
      //         // ),
      //       ],
      //     );
      //   },
      //   //controller: searchTextField,
      //   //textInputAction: TextInputAction.go,
      //   // textSubmitted: (value) async {
      //   //   await getInfoInMaps(info,info2);
      //   // },
        
      //   textChanged: (val) async {
      //     if(val.length >= 3){
      //       info.dataText.text = val;
      //       await consult.getInfoInMaps(info, info2);
      //     }
      //     if(val.length >= 0 && val.length <= 2 ){
      //       consult.place = null;
      //       consult.place = [];
      //       info2.infoPlace = [];
      //     }
      //   },

      //   itemFilter: (item, query){
      //     return item.title.toLowerCase().startsWith(query.toLowerCase());
      //   },
      //   itemSorter: (a, b){
      //     return a.title.compareTo(b.title);
      //   },
      //   itemSubmitted: (item){
      //     setState((){
      //       info.dataText.text = item.title;
      //       searchTextField.textField.controller.text = item.title;
      //     });
      //   }, 
      // ),
      ),
    );
  }
}