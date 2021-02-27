

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/RegTools/DBReg.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/ScreensNew/ConsTratamiento.dart';
import 'package:myfarm_app/ScreensNew/crearTratamiento.dart';
import 'package:myfarm_app/SearchIDTools/HealthTrip.dart';
import 'package:myfarm_app/SearchIDTools/SearchCardTrat.dart';

class RegMedico extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _RegMedicoState createState() => _RegMedicoState();
  RegMedico({
    this.data,
    this.currentUser
  });
}

class _RegMedicoState extends State<RegMedico>{
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  TextEditingController _searchController = TextEditingController();
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedOption;
  QuerySnapshot registros;
  DBReg objReg = new DBReg();


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

  }
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }
  _onSearchChanged() {
    searchResultsList();
  }
  getUsersPastTripsStreamSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
        .collection('DBReg')
        .where('currentUser',isEqualTo: widget.currentUser,)
        .where('codigo',isEqualTo: widget.data,)
        .getDocuments();
    setState(() {
      _allResults = data.documents;
    });
    searchResultsList();
    return "complete";
  }
  searchResultsList() {
    var showResults = [];

    if(_searchController.text != "") {
      for(var tripSnapshot in _allResults){
        var medicamento = HealthTrip.fromSnapshot(tripSnapshot).medicamento.toLowerCase();

        if(medicamento.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }

    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Tratamientos",style: TextStyle(color: Colors.black),),
          leading:
              IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Home(currentUser: widget.currentUser,data: widget.data,),
              ),
                  (route) => false,
            );
          }),
      actions: [
        ClipOval(
          child: Material(
            color: Colors.lightGreen, // button color
            child: InkWell(
              splashColor: Colors.red,
              // inkwell color
              child: SizedBox(width: 56, height: 56, child: Icon(Icons.add,)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateReg(currentUser: widget.currentUser,data: widget.data,),
                  ),
                      (route) => false,
                );
              },
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white,
    ),
      body:  new Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search)
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCardTrat(context, _resultsList[index]),
            ),
          ),
        ],

      ),
      );
  }



  /*Widget _RegList(){
    if (registros != null) {
      bool carflag = false;
      List<int> location = [];
      for(var y = 0; y < registros.documents.length; y++){
        if(registros.documents[y].data['currentUser'] == widget.currentUser&&registros.documents[y].data['codigo'] == widget.data){
          carflag = true;
          location.add(y);
        }
      }

      if(carflag == true){
        return SingleChildScrollView(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: location.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i){
                return new Dismissible(
                    key: new Key(UniqueKey().toString()),
                    onDismissed: (direction){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => QRFront(currentUser: currentUid),
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
                        height: 110,
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
                                  child: Image(image: AssetImage('assets/images/vacaTrat.png'),height: 50,)),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        registros.documents[location[i]].data['fechaFin'].toDate().difference(DateTime.now()).inDays<=0&&registros.documents[location[i]].data['fechaFin'].toDate().difference(DateTime.now()).inHours<=12
                                            ?"COMPLETADO":"EN CURSO",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                                      ),

                                    ],
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.watch_later_sharp,
                                          color: Colors.orangeAccent,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text("Fecha Inicio: ${registros.documents[location[i]].data['fechaIni'].toDate().toString().substring(0,10)}",
                                            /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text("Fecha Fin: ${registros.documents[location[i]].data['fechaFin'].toDate().toString().substring(0,10)}",
                                            /* style: TextStyle(
                                                color: primary, fontSize: 18, letterSpacing: .3)*/),
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
                        _nextpage(context,location[i]);
                      },
                    )
                );
              }
          ),
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
                      Container(
                        margin: const EdgeInsets.only(top: 60.0),
                        child: new Text("* Para ingresar un nuevo Tratamiento, pulse aquí:",style: new TextStyle(fontSize: 24,color: Colors.black),textAlign: TextAlign.center,),
                      ),
                      Center(
                          child: Container(
                            width: 150.0,
                            height: 80.0,
                            margin: const EdgeInsets.only(top: 75.0),
                            /*child: new IconButton(
                      icon: Icon(Icons.camera_alt,size: 70,),

                      //child: new Text("SCANNER",style: TextStyle(fontSize: 25),),*/
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreateReg(currentUser: widget.currentUser,data: widget.data,),
                                  ),
                                      (route) => false,
                                );
                              },
                              color: Colors.orange,
                              padding: EdgeInsets.all(10.0),
                              child: Column( // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.add,size: 60,),
                                ],
                              ),
                            ),

                          )
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
  }*/


  _nextpage(BuildContext context, int i) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => TratDetails(currentUser: widget.currentUser,data: widget.data,indice: i),
        ),
            (route) => false);
  }

}