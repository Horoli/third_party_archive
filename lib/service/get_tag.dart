part of third_party_archive;

class GetTag extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  // RxList<String> tags = <String>[].obs;

  Future<RestfulResult> get() async {
    Uri uri = Uri.http(URL.LOCAL_URL, URL.TAG);
    Map<String, String> headers = {};

    http.get(uri, headers: headers).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] == 200) {
        Map<String, dynamic> data = Map.from(rawData['data']);
        List getTags = List.from(data['tags']);
        List<String> getTagsLabel =
            getTags.map((tagObject) => tagObject['label'].toString()).toList();

        // tags.assignAll(getTagsLabel);

        result = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'] ?? '',
          data: getTagsLabel,
        );

        update();
        return result;
      }
    }).catchError((error) {
      throw error;
    });

    return result;
  }
}
