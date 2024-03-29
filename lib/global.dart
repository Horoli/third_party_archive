part of third_party_archive;

late final SharedPreferences GSharedPreference;
late String GUuid;
late String GPlatform;

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

Widget buildWallpaper() {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(IMAGE.APPLICTION_WALLPAPER),
        opacity: 0.3,
      ),
    ),
  );
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
