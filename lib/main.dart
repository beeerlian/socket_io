import 'package:flutter/material.dart';
import 'package:socket_io/generated_route.dart';
import 'package:socket_io/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/input-nickname",
      onGenerateRoute:(settings) {
        GeneratedRoutes.onGeneratedRoutes(settings);
      },
      onUnknownRoute: (_){
        GeneratedRoutes.onUnknownRote();
      },
    );
  }
}