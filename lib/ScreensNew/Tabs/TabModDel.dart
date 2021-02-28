import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/RegTools/DBProduLeche.dart';
import 'package:myfarm_app/ScreensNew/Tabs/SearchDelMod.dart';
import 'package:myfarm_app/ScreensNew/Tabs/SearchDelModCards.dart';

class TabModDel extends StatefulWidget{
  final String data;
  final String currentUser;
  @override
  _TabModDelState createState() => _TabModDelState();
  TabModDel({
    this.data,
    this.currentUser
  });
}

class _TabModDelState extends State<TabModDel> {
  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  TextEditingController _searchController = TextEditingController();
  QuerySnapshot registroLeche;
  DBProduLeche objRegLeche = new DBProduLeche();


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
    resultsLoaded = getRegLecheSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  getRegLecheSnapshots() async {
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await Firestore.instance
        .collection('DBProduLeche')
        .where('currentUser', isEqualTo: widget.currentUser,)
        .where('codigo', isEqualTo: widget.data,)
        .getDocuments();
    setState(() {
      _allResults = data.documents;
    });
    searchResultsList();
    return "complete";
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var regID = SearchDelMod
            .fromSnapshot(tripSnapshot)
            .RegID
            .toLowerCase();

        if (regID.contains(_searchController.text.toLowerCase())) {
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
                 buildSearchDelModCards(context, _resultsList[index]),
            ),
          ),
        ],

      ),
    );
  }

}