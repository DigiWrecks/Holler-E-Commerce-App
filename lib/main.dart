import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suckless/screens/home.dart';
import 'package:suckless/screens/login.dart';
import 'package:suckless/screens/thank-you.dart';

void main(){
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String email;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    print(email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xffFD52DC),
        unselectedWidgetColor: Colors.black,
        fontFamily: 'GoogleSans'
      ),
      home: email==null?LogIn():Home(),
      //home: LogIn(),
    );
  }
}
