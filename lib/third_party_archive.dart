library third_party_archive;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:horoli_package/horoli_package.dart';
import 'package:horoli_package/model/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_party_archive/adfit/adfit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:timezone/timezone.dart' as TZ;
import 'package:intl/intl.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;

import 'preset/message.dart' as MSG;
import 'preset/constants.dart' as CONSTANTS;
import 'preset/image.dart' as IMAGE;
import 'preset/url.dart' as URL;
import 'preset/path.dart' as PATH;
import 'preset/label.dart' as LABEL;

part 'app_root.dart';
part 'global.dart';

part 'model/third_party.dart';
part 'model/league.dart';
part 'model/skill_gem.dart';

part 'view/page/third_party.dart';
part 'view/home.dart';
part 'view/loading.dart';

part 'service/get_dashboard.dart';
part 'service/get_third_party.dart';
part 'service/get_skill_gem.dart';
part 'service/get_selected_gem_tag.dart';

part 'widget/tile_third_party.dart';
part 'widget/league_information.dart';
part 'widget/home_abstract.dart';
part 'widget/home_portrait.dart';
part 'widget/home_landscape.dart';
part 'view/page/random_build_selector.dart';
part 'widget/skill_gem_info.dart';
