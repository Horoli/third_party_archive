part of third_party_archive;

class ServiceTag {
  static ServiceTag? _instance;
  factory ServiceTag.getInstance() => _instance ??= ServiceTag._internal();

  ServiceTag._internal();

  Future<RestfulResult> get() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Uri uri = Uri.http(URL.LOCAL_URL, URL.TAG);
    Map<String, String> headers = {};

    http.get(uri, headers: headers).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] == 200) {
        completer.complete(
          RestfulResult(
            statusCode: rawData['statusCode'],
            message: rawData['message'] ?? '',
            data: rawData['data'],
          ),
        );
      }
    }).catchError((error) {
      throw error;
    });

    return completer.future;
  }
}
