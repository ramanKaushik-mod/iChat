import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ichat/helperCode/firebaseFunctions.dart';
import 'package:ichat/helperCode/helperClasses.dart';
import 'package:ichat/helperCode/routeGenerator.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String contactNo;
  int loginStatus;
  HandlingFirebaseDB handlingFirebaseDB;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getContactNo();
  }

  getContactNo() async {
    contactNo = await Utility.getContactFromPreference();
    handlingFirebaseDB = HandlingFirebaseDB(contactID: contactNo);
    loginStatus = await Utility.getLoginStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        if (loginStatus == 0) {
          handlingFirebaseDB.changeContactChatStatus(status: true);
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (loginStatus == 0) {
          handlingFirebaseDB.changeContactChatStatus(status: false);
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetChanges>(
      create: (context) => GetChanges(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        // home: LogoScreen(),
      ),
    );
  }
}
