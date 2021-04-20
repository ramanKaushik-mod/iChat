import 'package:flutter/material.dart';
import 'package:ichat/Screens/authScreen.dart';
import 'package:ichat/Screens/logoScreen.dart';



class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    // final args = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>LogoScreen());

      case '/authScreen':
        return MaterialPageRoute(builder: (_)=>AuthScreen());
      default:
        return _errorRoute();

    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}

