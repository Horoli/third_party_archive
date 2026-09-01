import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:third_party_archive/adfit/adfit.dart';
import 'package:third_party_archive/third_party_archive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:third_party_archive/preset/constants.dart' as CONSTANTS;
import 'package:timezone/data/latest.dart' as TZ;

Future<void> main() async {
  TZ.initializeTimeZones();

  await init();
  await deviceCheck();

  GKakaoAdfit = KakaoAdfit.getInstance();
  runApp(const AppRoot());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  GSharedPreference = await SharedPreferences.getInstance();
}

Future<void> deviceCheck() async {
  await createUUID();

  if (kIsWeb) {
    GPlatform = CONSTANTS.PLATFORM_WEB;
    return;
  }

  GPlatform = Platform.operatingSystem;
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
