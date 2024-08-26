part of third_party_archive;

class GetPoeNinja extends GetxController {
  Future<void> get() async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.POE_NINJA}/')
        : Uri.https(URL.FORIEGN_URL, '${URL.POE_NINJA}/');
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);
    print(rawData);
  }

  Future<void> getImage({required String hash}) async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.POE_NINJA}/image/${hash}')
        : Uri.https(URL.FORIEGN_URL, '${URL.POE_NINJA}/image/${hash}');

    print(uri);
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);
    print(rawData);
  }
}
