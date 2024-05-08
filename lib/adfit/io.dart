import 'package:third_party_archive/adfit/interface.dart' as INTF;

class KakaoAdfit extends INTF.KakaoAdfit {
  static KakaoAdfit? _instance;

  factory KakaoAdfit.getInstance() => _instance ??= KakaoAdfit._internal();
  KakaoAdfit._internal();
}
