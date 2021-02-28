import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/auth.dart';
import 'package:myfarm_app/Screens/ScannerQR.dart';
import 'package:myfarm_app/SettingsTools/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Home.dart';
import 'Login.dart';

class SettingsOnePage extends StatefulWidget {
  final String data;
  final String currentUser;
  static final String path = "lib/src/pages/settings/settings1.dart";
  SettingsOnePage({
    this.data,
    this.currentUser
  });

  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  bool _dark;

  @override
  void initState() {
    super.initState();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Ajustes',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  _dark = !_dark;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.house),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(currentUser: widget.currentUser,data: widget.data,),
                  ),
                      (route) => false,
                );
              },
            )
          ],
        ),
        body:WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    const SizedBox(height: 10.0),
                    Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: Colors.orange,
                            ),
                            title: Text("Cambiar Contraseña"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change password
                            },
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              FontAwesomeIcons.language,
                              color: Colors.orange,
                            ),
                            title: Text("Cambiar Idioma"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              //open change language
                            },
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.orange,
                            ),
                            title: Text("Cambiar Código QR"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scanner(currentUser: widget.currentUser,),
                                ),
                                    (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Notificaciones",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SwitchListTile(
                      activeColor: Colors.orange,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Recibir Notificaciones"),
                      onChanged: (val) {},
                    ),
                    SwitchListTile(
                      activeColor: Colors.orange,
                      contentPadding: const EdgeInsets.all(0),
                      value: false,
                      title: Text("Recibir Noticias"),
                      onChanged: null,
                    ),
                    SwitchListTile(
                      activeColor: Colors.orange,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Recibir Notificaciones de Ofertas"),
                      onChanged: (val) {},
                    ),
                    SwitchListTile(
                      activeColor: Colors.orange,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Recibir Actualizaciones de la APP"),
                      onChanged: null,
                    ),
                    const SizedBox(height: 60.0),
                  ],
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 00,
                left: 00,
                child: IconButton(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _signOut(context);
                    //log out
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text('Ajustes')
            )
          ],
        ),
      ),
    );
  }
  void _signOut(BuildContext context) async {
    String _returnString = await Auth().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
            (route) => false,
      );
    }
  }
  void onTabTapped(int index) {
    switch(index){
      case 0: {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(data: widget.data,currentUser: widget.currentUser,),
          ),
              (route) => false,
        );
      }
      break;
      case 1: {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsOnePage(data: widget.data,currentUser: widget.currentUser,),
          ),
              (route) => false,
        );
      }
      break;
    }
  }
  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Home(currentUser: widget.currentUser,data: widget.data,),
      ),
          (route) => false,
    );
  }
}
