import 'page/utilWidgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main()  {
  /*WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Navigation Drawer';

  @override
  Widget build(BuildContext context) {
  
  return 
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          fontFamily: "Crimson Text",
          primarySwatch: Colors.green,canvasColor: Colors.grey[200],
          iconTheme: const IconThemeData(color: Color(0xFF7ED957)),
          appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Color(0xFF7ED957)),)),
          
          home: SplashScreenPage(),
      //)
  );
}
}