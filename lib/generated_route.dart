import 'package:flutter/material.dart';
import 'package:socket_io/home.dart';
import 'package:socket_io/input_name.dart';
import 'package:socket_io/state_handler.dart';

class GeneratedRoutes {
  static Route<dynamic> onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/home":
        if (settings.arguments is String) {
          return MaterialPageRoute(builder: (context) => Home(nickname: settings.arguments.toString()));
        } else {
          return onUnknownRote();
        }
      case "/input-nickname":
        return MaterialPageRoute(builder: (context) => InputNamePage());
      case "/state-handler":
        return MaterialPageRoute(builder: (context) => const StateHandler());
      default:
        return onUnknownRote();
    }
  }

  static Route<dynamic> onUnknownRote() {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Center(
                child: Text("Unkown Route"),
              ),
            ));
  }
}
