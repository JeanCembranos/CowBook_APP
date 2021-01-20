import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/userModel.dart';
import 'package:myfarm_app/Screens/Home.dart';
import 'package:myfarm_app/Screens/Login.dart';
import 'package:myfarm_app/Screens/ScannerQR.dart';
import 'package:provider/provider.dart';

import 'authModel.dart';
import 'dbStream.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn }

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String currentUid;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current User, set AuthStatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context);
    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = Login();
        break;
      case AuthStatus.notLoggedIn:
        retVal = Login();
        break;
      case AuthStatus.loggedIn:
        retVal = StreamProvider<UserModel>.value(
          value: DBStream().getCurrentUser(currentUid),
          child: LoggedIn(currentUid: currentUid),
        );
        break;
      default:
    }
    return retVal;
  }
}

class LoggedIn extends StatelessWidget {
  final String currentUid;
  LoggedIn({Key key, @required this.currentUid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget retVal;
    retVal = Scanner();
    return retVal;
  }
}
