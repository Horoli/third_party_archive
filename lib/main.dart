import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:third_party_archive/third_party_archive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  await init();
  await createUUID();
  runApp(const AppRoot());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  GSharedPreference = await SharedPreferences.getInstance();
}

Future<void> createUUID() async {
  String? getLocalUUID = GSharedPreference.getString('id');
  if (getLocalUUID == null) {
    Uuid uuid = const Uuid();
    GUuid = uuid.v1();

    await GSharedPreference.setString('id', GUuid);
    return;
  }

  GUuid = getLocalUUID;
}
