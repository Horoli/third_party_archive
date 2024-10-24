part of third_party_archive;

class GetScarabTable extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  Future<RestfulResult> get() async {
    Uri uri = isLocal
        ? Uri.http(URL.LOCAL_URL, URL.POE_NINJA_SCARAB)
        : Uri.https(URL.FORIEGN_URL, URL.POE_NINJA_SCARAB);
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    List<PoeNinjaItem> scarabs = List.from(rawData['data']['filteredData'])
        .map((item) => PoeNinjaItem.fromMap(item: item))
        .toList();

    result.value = RestfulResult(
      statusCode: rawData['statusCode'] ?? '',
      message: rawData['message'] ?? '',
      data: {
        'updateDate': rawData['data']['date'],
        'filteredData': scarabs,
      },
    );

    update();
    return result.value;
  }
}
