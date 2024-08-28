part of third_party_archive;

class GetDashboard extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  RxString selectedTag = 'CRAFT'.obs;

  Future<void> get({int type = CONSTANTS.TAG_TYPE_PATHOFEXILE}) async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.DASHBOARD}/$type')
        : Uri.https(URL.FORIEGN_URL, '${URL.DASHBOARD}/$type');
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    if (rawData['statusCode'] == 200) {
      Map<String, dynamic> data = Map.from(rawData['data']);

      int getCurrentPlayers = data['currentPlayers'];
      double getDivineOrb = data['divineOrb'];
      List getTags = List.from(data['tags']);

      List<PathOfExileLeague> getLeagues = List.from(data['leagues'])
          .map((e) => PathOfExileLeague.fromMap(item: e))
          .toList();

      currentLeague = getLeagues.first.label;

      List<String> getTagsLabel =
          getTags.map((tagObject) => tagObject['label'].toString()).toList();

      result = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'] ?? '',
          // data: getTagsLabel,
          data: {
            'currentPlayers': getCurrentPlayers,
            'tags': getTagsLabel,
            'leagues': getLeagues,
          });

      // global DivineOrb에 값 할당
      GDivineOrb = getDivineOrb;
      update();

      // tags.assignAll(getTagsLabel);
      // response

      // response.then((rep) {
      //   Map rawData = jsonDecode(rep.body);

      //   if (rawData['statusCode'] == 200) {
      //     Map<String, dynamic> data = Map.from(rawData['data']);
      //     List getTags = List.from(data['tags']);
      //     List<String> getTagsLabel =
      //         getTags.map((tagObject) => tagObject['label'].toString()).toList();

      //     // tags.assignAll(getTagsLabel);

      //     result = RestfulResult(
      //       statusCode: rawData['statusCode'],
      //       message: rawData['message'] ?? '',
      //       data: getTagsLabel,
      //     );

      //     update();
      //   }
      // }).catchError((error) {
      //   throw error;
      // });
    }
  }

  Future<void> changeSelectedTag(String tag) async {
    selectedTag.value = tag;
    update();
  }
}
