part of third_party_archive;

class GetThirdParty extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  Future<void> get({
    required String tag,
    required String id,
    required String platform,
  }) async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(
            URL.LOCAL_URL, '${URL.THIRD_PARTY}/$tag/platform/$platform/id/$id')
        : Uri.https(URL.FORIEGN_URL,
            '${URL.THIRD_PARTY}/$tag/platform/$platform/id/$id');
    Map<String, String> headers = {"Content-Type": "application/json"};

    http.get(uri, headers: headers).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] == 200) {
        Map<String, dynamic> data = Map.from(rawData['data']);

        List<ThirdParty> getThirdParties = List.from(data['thirdParties'])
            .map((e) => ThirdParty.fromMap(item: e))
            .toList();

        result = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'] ?? '',
          data: getThirdParties,
        );
        update();
      }
    }).catchError((error) {
      throw error;
    });
  }
}
