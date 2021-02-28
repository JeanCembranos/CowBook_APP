

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
}