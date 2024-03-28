part of third_party_archive;

class TileThirdParty extends StatelessWidget {
  final ThirdParty thirdParty;
  const TileThirdParty({
    required this.thirdParty,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Column(
            children: [
              Image.memory(
                base64Decode(thirdParty.images['thumbnail']!),
              ).expand(),
              Text(thirdParty.label),
            ],
          ).expand(),
          Column(
            children: [
              Text(thirdParty.description['main']!).expand(),
              Text(thirdParty.description['sub']!).expand(),
            ],
          ).expand(flex: 3),
          ElevatedButton(
            child: const Text('open'),
            onPressed: () async {
              await launchUrl(Uri.parse(
                thirdParty.url['main']!,
              ));
              await postUserAction(
                id: GUuid,
                label: thirdParty.label,
                url: thirdParty.url['main']!,
              );
            },
          )
        ],
      ),
    ).sizedBox(height: kToolbarHeight * 2);
  }

  Future<void> postUserAction({
    required String id,
    required String label,
    required String url,
  }) async {
    Uri uri = URL.IS_LOCAL
        ? Uri.http(URL.LOCAL_URL, '${URL.USER_ACTION}/$id')
        : Uri.https(URL.FORIEGN_URL, '${URL.USER_ACTION}/$id');
    Map<String, String> headers = {"Content-Type": "application/json"};
    String jsonBody = jsonEncode({
      "label": label,
      "url": url,
    });

    http.post(uri, headers: headers, body: jsonBody).then((rep) {
      Map rawData = jsonDecode(rep.body);
    });
  }
}
