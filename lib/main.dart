import 'package:flutter/material.dart';
import 'package:weatherapplication/screens/main_dashboard.dart';
import 'api_model/api_auth.dart';

void main(){
  runApp(_home()) ;
}

class _home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Real time weather ",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Weather_dashboard(),
    );
  }

}