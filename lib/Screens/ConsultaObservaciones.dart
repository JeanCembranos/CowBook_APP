import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/HistMedicoTools/Colors.dart';
import 'package:myfarm_app/LoginTools/DBRecords.dart';
import 'package:myfarm_app/Screens/HistorialMedicoSeleccion.dart';
import 'package:myfarm_app/Screens/ObservacionesSeleccion.dart';

import 'Home.dart';

class SearchObservaciones extends StatefulWidget{
  String data;
  String currentUser;
  @override
  _SearchObservacionesState createState() => _SearchObservacionesState();
  SearchObservaciones({
    this.data,
    this.currentUser
  });
}

class _SearchObservacionesState extends State<SearchObservaciones> {
  QuerySnapshot record;
  DBRecords objRecord = new DBRecords();

  @override
  void initState(){
    super.initState();
    objRecord.getData().then((results){
      setState(() {
        record = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('FarmAPP'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                ObsSelection(currentUser: widget.currentUser,data: widget.data,)), (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),

      ),
      body: _carList(),
    );
  }

  Widget _carList(){
    if (record != null) {
      bool carflag = false;
      List<int> location = [];
      for(var y = 0; y < record.documents.length; y++){
        if(record.documents[y].data['codigo'] == widget.data&&record.documents[y].data['tipo'] == 'observacion'){
          carflag = true;
          location.add(y);
        }
      }

      if(carflag == true){
        return ListView.builder(
            itemCount: location.length,
            padding: EdgeInsets.all(5.0),
            itemBuilder: (context, i){
              return new Dismissible(
                  key: new Key(UniqueKey().toString()),
                  onDismissed: (direction){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => Scanner(currentUser: currentUid),
                        )
                    );
                    setState(() {

                    });
                  },
                  child: new InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: Colors.yellow,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.only(right: 15),
                                child: Image(image: AssetImage('assets/images/observaciones.jpg'))),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  record.documents[location[i]].data['actividad'],
                                  style: TextStyle(
                                      color: secondary, fontWeight: FontWeight.bold, fontSize: 20),
                                ),


                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                        color: secondary,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        //child: Text(record.documents[location[i]].data['fechaApli'].toDate().toString()),
                                        child:Text('Tiempo Prox. Aplicación: ${(record.documents[location[i]].data['fechaControlProx'].toDate()).difference(DateTime.now()).inDays.toString()} días',style: new TextStyle(fontSize: 20.0),),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ),
                    onTap: (){
                      //_nextpage(context,location[i]);
                    },
                  )
              );
            }
        );
      }////////
      else{
        return new Scaffold(
          body: new Container(
            width: MediaQuery.of(context).size.width,
            child: new Center(
              child: ListView(
                children: [
                  new Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 80.0),
                        child: new Text("NO HAY REGISTROS EXISTENTES",style: new TextStyle(fontSize: 30,color: Colors.pinkAccent),textAlign: TextAlign.center,),
                      ),

                    ],
                  ),
                ],
              ),

            ),
          ),



        );
      }
    }
    else{
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.orangeAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50.0,
                        child: Icon(
                          Icons.local_parking,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "ParkingApp",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "LA MEJOR OPCIÓN",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      );
    }
  }




}