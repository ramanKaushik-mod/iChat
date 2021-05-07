import 'package:flutter/material.dart';
import 'package:ichat/Screens/authScreen.dart';
import 'package:ichat/Screens/checkPurpose.dart';
import 'package:ichat/Screens/logoScreen.dart';
import 'package:ichat/Screens/messageScreen.dart';
import 'package:ichat/Screens/pages.dart';
import 'package:ichat/Screens/pendingAndRequests.dart';
import 'package:ichat/Screens/userProfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LogoScreen());

      case '/authScreen':
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case '/checkPurpose':
        return MaterialPageRoute(builder: (_) => CheckPurpose());
      case '/pendingScreen':
        return MaterialPageRoute(builder: (_) => PendingScreen());
      case '/requestScreen':
        return MaterialPageRoute(builder: (_) => RequestScreen());
      case '/contactScreen':
        return MaterialPageRoute(builder: (_) => ContactPage());
      case '/messageScreen':
        return MaterialPageRoute(
            builder: (_) => MessageScreen(contactModel: args));
      case '/userScreen':
        return MaterialPageRoute(builder: (_) => UserProfile(model: args,));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
