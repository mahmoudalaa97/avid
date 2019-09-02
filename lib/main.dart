import 'package:avid/services/auth.dart';
import 'package:flutter/material.dart';

import 'services/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff333333),
      ),
      home: RootPage(
        auth: Auth(),
      ),
    );
  }
}
