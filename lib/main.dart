import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    await createUUID();
    GPlatform = CONSTANTS.PLATFORM_WEB;
    return;
  }

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      GUuid = info.id;
      // type : SP1A.210812.016
      GPlatform = CONSTANTS.PLATFORM_ANDROID;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
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
