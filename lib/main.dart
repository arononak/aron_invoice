// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:aron_invoice/main_page.dart';

void main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  final fontsReady = systemFontsStream(fontsToLoad: 1).last;
  GoogleFonts.openSans();
  GoogleFonts.inter();
  await fontsReady;

  runApp(const AronInvoiceApp());
}

Stream<int> systemFontsStream({int? fontsToLoad}) {
  late StreamController<int> controller;
  var loadedFonts = 0;

  void onSystemFontsLoaded() {
    loadedFonts++;

    controller.add(loadedFonts);

    if (loadedFonts == fontsToLoad) {
      controller.close();
    }
  }

  void addListener() {
    PaintingBinding.instance.systemFonts.addListener(onSystemFontsLoaded);
  }

  void removeListener() {
    PaintingBinding.instance.systemFonts.removeListener(onSystemFontsLoaded);
  }

  controller = StreamController<int>(
    onListen: addListener,
    onPause: removeListener,
    onResume: addListener,
    onCancel: removeListener,
  );

  return controller.stream;
}

class AronInvoiceApp extends StatelessWidget {
  const AronInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      title: 'Aron Invoice',
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
