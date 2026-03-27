part of third_party_archive;

// const bool isLocal = true;
// const bool enablePoeTwo = true;

// bool isDebugMode = kDebugMode;
bool isDebugMode = false;
const bool isLocal = false;
const bool enablePoeTwo = false;

Color GSelectedButtonColor = const Color.fromARGB(255, 72, 57, 99);
String currentLeague = '';

final TZ.Location GDetroit = TZ.getLocation('Asia/Seoul');
late final SharedPreferences GSharedPreference;
late String GUuid;
late String GPlatform;
double GDivineOrb = 0;

late final KakaoAdfit GKakaoAdfit;

///
Future<void> postUserAction({
  required String id,
  required String label,
  required String url,
  required String platform,
}) async {
  Uri uri = isLocal
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

Widget get GImageDivineOrb => Image.asset(
      IMAGE.DIVINE_ORB,
      scale: 3,
    );

Widget get GImageChaosOrb => Image.asset(
      IMAGE.CHAOS_ORB,
      scale: 3,
    );
