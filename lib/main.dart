import 'package:flutter/material.dart';
import 'package:ai_service_app/pages/home.dart';
import 'package:ai_service_app/pages/loading.dart';
import 'package:ai_service_app/pages/choose_location.dart';
import 'package:ai_service_app/services/ocr_service.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),
      '/AI_Service': (context) => OCR_Service()
    }
));

