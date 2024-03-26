part of third_party_archive;

class GetThirdParty extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  Future<void> get({required String tag}) async {
    Uri uri = Uri.http(URL.LOCAL_URL, '${URL.THIRD_PARTY}/$tag');
    Map<String, String> headers = {};

    print(uri);

    http.get(uri, headers: headers).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] == 200) {
        Map<String, dynamic> data = Map.from(rawData['data']);
        print(data);
        List getThirdParties = List.from(data['thirdParties']);

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
