part of third_party_archive;

Color buttonColor = const Color.fromARGB(255, 72, 57, 99);
late final String currentLeague;

late final TZ.Location GDetroit = TZ.getLocation('Asia/Seoul');
late final SharedPreferences GSharedPreference;
late String GUuid;
late String GPlatform;

late final KakaoAdfit GKakaoAdfit;

Future<void> postUserAction({
  required String id,
  required String label,
  required String url,
  required String platform,
}) async {
  Uri uri = URL.IS_LOCAL
      ? Uri.http(URL.LOCAL_URL, '${URL.USER_ACTION}/$id')
      : Uri.https(URL.FORIEGN_URL, '${URL.USER_ACTION}/$id');
  Map<String, String> headers = {"Content-Type": "application/json"};
  String jsonBody = jsonEncode({
    "label": label,
    "url": url,
    "platform": platform,
  });

  http.post(uri, headers: headers, body: jsonBody).then((rep) {
    Map rawData = jsonDecode(rep.body);
  });
}


// late ServiceTag GServiceTag;
// final List<String> tags = [
//   LABEL.TAG_PATCHNOTE,
//   LABEL.TAG_BUILD,
//   LABEL.TAG_CRAFT,
//   LABEL.TAG_INFO,
//   LABEL.TAG_TRADE,
//   LABEL.TAG_COMMUNITY,
//   LABEL.TAG_CURRENCY,
//   LABEL.TAG_ITEMFILTER,
// ];
