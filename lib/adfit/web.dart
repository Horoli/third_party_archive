import 'package:third_party_archive/adfit/interface.dart' as INTF;
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class KakaoAdfit extends INTF.KakaoAdfit {
  static KakaoAdfit? _instance;

  factory KakaoAdfit.getInstance() => _instance ??= KakaoAdfit._internal();
  KakaoAdfit._internal();

  html.DivElement setBanner() {
    return html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..appendHtml(
        banner,
        validator: html.NodeValidatorBuilder()
          ..allowHtml5()
          ..allowElement('ins', attributes: [
            'class',
            'style',
            'data-ad-unit',
            'data-ad-width',
            'data-ad-height'
          ])
          ..allowElement('script', attributes: ['type', 'src', 'async'])
          ..allowImages(),
      );
  }

  @override
  Future<void> registry() async {
    ui_web.platformViewRegistry.registerViewFactory(
      tag,
      (int viewId) => setBanner(),
    );
  }
}
