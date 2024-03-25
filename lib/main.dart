import 'package:flutter/material.dart';
import 'package:third_party_archive/third_party_archive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initService();

  runApp(const AppRoot());
}

Future<void> _initService() async {
  GServiceTag = ServiceTag.getInstance();
}
