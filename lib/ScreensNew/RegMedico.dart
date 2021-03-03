

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/RegTools/DBReg.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Settings.dart';
import 'package:myfarm_app/ScreensNew/ConsTratamiento.dart';
import 'package:myfarm_app/ScreensNew/crearTratamiento.dart';
import 'package:myfarm_app/SearchIDTools/HealthTrip.dart';
import 'package:myfarm_app/SearchIDTools/SearchCardTrat.dart';
import 'package:path/path.dart';

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
  DateTime selectedIniDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime selectedFinDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  List<String> _companies = ["Rango Fecha Inicio de Tratamiento","Rango Fecha Fin de Tratamiento"];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedCompany;
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot registros;
  DBReg objReg = new DBReg();


  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
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
  List<DropdownMenuItem<String>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<String>> items = List();
    for (String company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(String selectedCompany) {
    //_resultsList=[];
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
  getUsersPastTripsStreamSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    if(_selectedCompany=="Rango Fecha Inicio de Tratamiento"){
      var data = await Firestore.instance
          .collection('DBReg').document(widget.currentUser).collection(widget.data)
          .where("fechaIni",isGreaterThanOrEqualTo: selectedIniDate)
          .where("fechaIni",isLessThanOrEqualTo: selectedFinDate)
          .getDocuments();
      setState(() {
        _allResults = data.documents;
      });
      searchResultsList();
      return "complete";
    }else{
      var data = await Firestore.instance
          .collection('DBReg').document(widget.currentUser).collection(widget.data)
          .where("fechaFin",isGreaterThanOrEqualTo: selectedIniDate)
          .where("fechaFin",isLessThanOrEqualTo: selectedFinDate)
          .getDocuments();
      setState(() {
        _allResults = data.documents;
      });
      searchResultsList();
      return "complete";
    }
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
      body:WillPopScope(
        onWillPop: (){
          return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Home(data: widget.data,currentUser: widget.currentUser,),
            ),
                (route) => false,
          );
        },
        child:  new Column(
          children: [
            SizedBox(height:10.0),
            Text("Seleccione un modo de Búsqueda",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.orange,width: 5.0)
              ),
              child: DropdownButton(
                value: _selectedCompany,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem,
                dropdownColor: Colors.orangeAccent[100],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                width:MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text("Desde: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Padding(
                          child: Container(
                            width: MediaQuery.of(context).size.width/2-70,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    )
                                )
                            ),
                            child: Text(selectedIniDate.toString().substring(0,10)),
                          ),
                          padding: EdgeInsets.only(left: 20.0),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height:46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectIniDate(context);
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text("Hasta:",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width/2-70,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      )
                                  )
                              ),
                              child: Text(selectedFinDate.toString().substring(0,10))
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.orange, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: SizedBox(width: 46, height: 46, child: Icon(Icons.calendar_today_outlined,)),
                          onTap: () {
                            _selectFinDate(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  getUsersPastTripsStreamSnapshots();
                },
                elevation: 4.0,
                splashColor:  Colors.blue[400],
                child: Text(
                  'BUSCAR',
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                ),

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildTripCardTrat(context, _resultsList[index]),
              ),
            ),
            /*TextField(
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
            ),*/
          ],

        ),
      ),
      );
  }
  Future<void> _selectIniDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedIniDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedIniDate)
      setState(() {
        selectedIniDate = picked;
      });
  }
  Future<void> _selectFinDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFinDate,
        firstDate: DateTime(1930, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFinDate)
      setState(() {
        selectedFinDate = picked;
      });
  }
}