part of third_party_archive;

class GetScarabTable extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  Future<RestfulResult> get() async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, URL.POE_NINJA_SCARAB)
        : Uri.https(URL.FORIEGN_URL, URL.POE_NINJA_SCARAB);
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    // List<PoeNinjaItem> scarabs = List.from(rawData['data'])
    //     .map((item) => PoeNinjaItem.fromMap(item: item))
    //     .toList();

    Map<String, List<PoeNinjaItem>> mapOfScarab = {};

    for (var data in List.from(rawData['data'])) {
      PoeNinjaItem scarab = PoeNinjaItem.fromMap(item: data);
      bool found = false; // 추가여부를 체크하기 위한 변수

      // TODO : 갑충석 순서에 맞춰서 array를 만들어야 함.
      // 어떻게 할지 확인 후 조치
      // SCARAB_DIVISION별로 추가

      for (String division in LABEL.SCARAB_DIVISION) {
        if (scarab.name.contains(division)) {
          if (mapOfScarab[division] == null) {
            mapOfScarab[division] = [];
          }
          mapOfScarab[division]!.add(scarab);
          found = true; // 추가되었다면 true로 변경
          break;
        }
      }

      // 위에서 추가되지 않은 항목들은 'etc에 추가
      if (!found) {
        if (mapOfScarab[LABEL.ETC] == null) {
          mapOfScarab[LABEL.ETC] = [];
        }
        mapOfScarab[LABEL.ETC]!.add(scarab);
      }
    }

    result.value = RestfulResult(
      statusCode: rawData['statusCode'] ?? '',
      message: rawData['message'] ?? '',
      data: mapOfScarab,
    );

    update();
    return result.value;
  }
}
