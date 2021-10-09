import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/bloc/pages_bloc.dart';
import 'package:socket_io/generated_route.dart';
import 'package:socket_io/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PagesBloc(),
        child: MaterialApp(
          initialRoute: "/state-handler",
          onGenerateRoute: (settings) {
            return GeneratedRoutes.onGeneratedRoutes(settings);
          },
          onUnknownRoute: (_) {
            return GeneratedRoutes.onUnknownRote();
          },
        ));
  }
}
