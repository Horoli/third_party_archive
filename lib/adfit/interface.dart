abstract class KakaoAdfit {
  KakaoAdfit();

  factory KakaoAdfit.getInstance() =>
      throw ('KaKaoAdfit is not supported on this platform');

  final String tag = 'KakaoAdfit';

  final String banner = """
  <ins class="kakao_ad_area" style="display:none;"
data-ad-unit = "DAN-wWXnZLGfKToohs0h"
data-ad-width = "160"
data-ad-height = "600"></ins>
<script type="text/javascript" src="//t1.daumcdn.net/kas/static/ba.min.js" async></script>
""";

  Future<void> registry() async {}
}
