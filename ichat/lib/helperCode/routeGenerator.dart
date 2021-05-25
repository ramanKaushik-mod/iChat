import 'package:flutter/material.dart';
import 'package:ichat/Screens/AuthFiles/verifyNumberScreen.dart';
import 'package:ichat/Screens/AuthFiles/verifySmsScreen.dart';
import 'package:ichat/Screens/imageCapture.dart';
import 'package:ichat/Screens/logoScreen.dart';
import 'package:ichat/Screens/mainScreen.dart';
import 'package:ichat/Screens/messageScreen.dart';
import 'package:ichat/Screens/pages.dart';
import 'package:ichat/Screens/pendingAndRequests.dart';
import 'package:ichat/Screens/profileScreen.dart';
import 'package:ichat/Screens/userProfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LogoScreen());
      case '/checkPurpose':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/pendingScreen':
        return MaterialPageRoute(builder: (_) => PendingScreen());
      case '/requestScreen':
        return MaterialPageRoute(builder: (_) => RequestScreen());
      case '/contactScreen':
        return MaterialPageRoute(builder: (_) => ContactPage());
      case '/messageScreen':
        return MaterialPageRoute(
            builder: (_) => MessageScreen(contactModel: args,));
      case '/userScreen':
        return MaterialPageRoute(builder: (_) => UserProfile(contactNo: args,));
      case '/verifyNumberScreen':
        return MaterialPageRoute(builder: (_) => VerifyNumberScreen());
      case '/verifySmsScreen':
        return MaterialPageRoute(
            builder: (_) => VerifySmsScreen(
                  data: args,
                ));
      case '/profileScreen':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/imageCapture':
        return MaterialPageRoute(
            builder: (_) => ImageCapture(
                  function: args,
                ));
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
