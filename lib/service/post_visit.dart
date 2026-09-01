part of third_party_archive;

Future<void> postVisit() async {
  final uri = isLocal
      ? Uri.http(URL.LOCAL_URL, URL.VISIT)
      : Uri.https(URL.FORIEGN_URL, URL.VISIT);
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'id': GUuid,
      'platform': GPlatform,
    }),
  );

  if (response.statusCode >= 400) {
    throw Exception('Visit request failed: ${response.statusCode}');
  }
}
