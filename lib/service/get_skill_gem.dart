part of third_party_archive;

class GetSkillGem extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  Future<void> get({
    required List<String> tags,
    String? attribute,
  }) async {
    Map<String, dynamic> queryParameters = attribute != ''
        ? {
            "tags": jsonEncode(tags),
            "attribute": attribute,
          }
        : {
            "tags": jsonEncode(tags),
          };

    Map<String, String> headers = {};

    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.BUILD}/', queryParameters)
        : Uri.https(URL.FORIEGN_URL, '${URL.BUILD}/', queryParameters);

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    if (rawData['statusCode'] == 200) {
      List datas = List.from(rawData['data']);

      List<SkillGem> getSkillGems =
          datas.map((item) => SkillGem.fromMap(item: item)).toList();

      result = RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'] ?? '',
        data: getSkillGems,
      );

      update();
    }
  }
}
