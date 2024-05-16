part of third_party_archive;

class GetSkillGem extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  RxObjectMixin<RestfulResult> info =
      RestfulResult(statusCode: 0, message: '').obs;

  RxList<String> selectedGemTags = <String>[].obs;

  RxList<String> gemTagList = [
    "Attack",
    "Melee",
    "Strike",
    "Slam",
    "Spell",
    "Arcane",
    "Brand",
    "Orb",
    "Nova",
    "Physical",
    "Fire",
    "Cold",
    "Lightning",
    "Chaos",
    "Bow",
    "Projectile",
    "Chaining",
    "Mine",
    "Trap",
    "Totem",
    "Golem",
    "Minion",
    "Hex",
    "AoE",
    "Critical",
    "Duration",
    "Trigger"
  ].obs;

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

      result.value = RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'] ?? '',
        data: getSkillGems,
      );

      update();
    }
  }

  Future<void> getInfo({required String name}) async {
    Map<String, dynamic> queryParameters = {"name": name};

    Map<String, String> headers = {};

    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.BUILD}/image', queryParameters)
        : Uri.https(URL.FORIEGN_URL, '${URL.BUILD}/image', queryParameters);

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    SkillGemInfo getData = SkillGemInfo.fromMap(item: rawData['data']);

    info.value = RestfulResult(
      statusCode: rawData['statusCode'],
      message: rawData['message'] ?? '',
      data: getData,
    );

    update();
  }

  List<String> updateSelectedTag(String tag) {
    selectedGemTags.add(tag);
    update();
    return selectedGemTags;
  }

  List<String> removeSelectedTag(String tag) {
    selectedGemTags.remove(tag);
    update();
    return selectedGemTags;
  }

  List<String> clearSelectedTag() {
    selectedGemTags.clear();
    update();
    return selectedGemTags;
  }
}
