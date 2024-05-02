part of third_party_archive;

class GetPoeDBPlayer extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  Future<void> get() async {
    final Map<String, dynamic> queryParameters = {
      'limit': '8',
    };
    Uri uri = Uri.https(URL.POE_DB, URL.POE_DB_PLAYER, queryParameters);

    Map<String, String> headers = {'Access-Control-Allow-Origin': '*'};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);
  }
}
