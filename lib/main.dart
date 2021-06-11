import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gulstan/composit_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final screenToShow = await CompositionRoot.start();
  runApp(MyApp(screenToShow!));
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp( this.startPage) ;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gulstan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Color.fromARGB(255, 255, 80, 255),
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: startPage,
    );
  }
}
