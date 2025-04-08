import 'package:flutter/material.dart';
import 'package:my_app/src/pages/home/home_page.dart';
import 'package:my_app/src/pages/landing/lading_page.dart';

void main() {
  runApp(const ExploreMundoMobile());
}

class ExploreMundoMobile extends StatelessWidget {
  const ExploreMundoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      routes: {
        '/': (context) => LandingPage(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
