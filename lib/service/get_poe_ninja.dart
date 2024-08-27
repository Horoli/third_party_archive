part of third_party_archive;

class GetPoeNinja extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  Future<RestfulResult> get() async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.POE_NINJA}/')
        : Uri.https(URL.FORIEGN_URL, '${URL.POE_NINJA}/');
    Map<String, String> headers = {};

    http.Response rep =
        await http.get(uri, headers: headers).catchError((error) {
      throw error;
    });

    Map rawData = jsonDecode(rep.body);

    PoeNinjaSet sets = PoeNinjaSet.fromMap(data: rawData['data']);

    result.value = RestfulResult(
      statusCode: rawData['statusCode'] ?? '',
      message: rawData['message'] ?? '',
      data: sets,
    );

    return result.value;

    // update();
  }

  // Future<void> getImage({required String hash}) async {
  //   Uri uri = URL.IS_LOCAL
  //       ? Uri.http(URL.LOCAL_URL, '${URL.POE_NINJA}/image/${hash}')
  //       : Uri.https(URL.FORIEGN_URL, '${URL.POE_NINJA}/image/${hash}');

  //   print(uri);
  //   Map<String, String> headers = {};

  //   http.Response rep =
  //       await http.get(uri, headers: headers).catchError((error) {
  //     throw error;
  //   });

  //   Map rawData = jsonDecode(rep.body);

  // List<PoeNinjaCurrency> currency = List.from(rawData['currency'])
  //     .map((e) => PoeNinjaCurrency.fromMap(item: e))
  //     .toList();
  // List<PoeNinjaItem> fragument = List.from(rawData['fragument'])
  //     .map((e) => PoeNinjaItem.fromMap(item: e))
  //     .toList();
  // List<PoeNinjaItem> scarab = List.from(rawData['scarab'])
  //     .map((e) => PoeNinjaItem.fromMap(item: e))
  //     .toList();
  // List<PoeNinjaMap> map = List.from(rawData['map'])
  //     .map((e) => PoeNinjaMap.fromMap(item: e))
  //     .toList();
  // }
}
