import 'package:flutter/material.dart';
import 'package:myfarm_app/LoginTools/root.dart';

import 'package:provider/provider.dart';

import 'auth.dart';
import 'authModel.dart';

class ActiveRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthModel>.value(
        value: Auth().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: OurRoot(),
        )

    );
  }
}
