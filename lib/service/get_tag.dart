part of third_party_archive;

class GetTag extends GetxController {
  RestfulResult result = RestfulResult(statusCode: 0, message: '');

  Future<void> get() async {
    Uri uri = Uri.http(URL.LOCAL_URL, URL.TAG);
    Map<String, String> headers = {};

    http.get(uri, headers: headers).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] == 200) {
        Map<String, dynamic> data = Map.from(rawData['data']);
        List tags = List.from(data['tags']);
        List<String> getTagsLabel =
            tags.map((tagObject) => tagObject['label'].toString()).toList();

        result = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'] ?? '',
          data: getTagsLabel,
        );
        update();
      }
    }).catchError((error) {
      throw error;
    });
  }
}
