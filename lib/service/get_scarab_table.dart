part of third_party_archive;

class GetScarabTable extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  // 가공된 데이터 리스트들을 컨트롤러에서 관리
  List<PoeNinjaItem> selectableItems = [];
  List<PoeNinjaItem> overFortyScarabItems = [];
  List<PoeNinjaItem> overTwentyScarabItems = [];
  List<PoeNinjaItem> overTenScarabItems = [];
  List<PoeNinjaItem> overFourScarabItems = [];
  Map<int, dynamic> chaosValueMap = {};

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
    
    // 백엔드 데이터 필터링 여부 확인을 위한 로그
    if (kDebugMode) {
      print('--- POE Ninja Scarab API Response Keys ---');
      print('Root keys: ${rawData.keys}');
      if (rawData['data'] != null) {
        print('Data keys: ${rawData['data'].keys}');
        print('FilteredData length: ${rawData['data']['filteredData']?.length}');
        if (rawData['data']['lines'] != null) {
          print('Lines length: ${rawData['data']['lines']?.length}');
        }
      }
    }

    List<PoeNinjaItem> scarabs = List.from(rawData['data']['filteredData'] ?? [])
        .map((item) => PoeNinjaItem.fromMap(item: item))
        .toList();

    // 파싱된 데이터 전체 출력 (디버깅용)
    if (kDebugMode) {
      print('=== Parsed Scarab Data (Total: ${scarabs.length}) ===');
      for (var s in scarabs) {
        print('Item: ${s.name} | Price: ${s.chaosValue}');
      }
      print('====================================================');
    }

    // 데이터 가공 로직 수행
    _processScarabData(scarabs);

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

  void _processScarabData(List<PoeNinjaItem> convertData) {
    overFortyScarabItems = [];
    overTwentyScarabItems = [];
    overTenScarabItems = [];
    overFourScarabItems = [];
    chaosValueMap = {};

    final mappedNames = SCARAB_LOCATION.MAP.values.map((e) => e.name).toSet();

    selectableItems = convertData.where((se) {
      return !mappedNames.contains(se.name);
    }).toList();

    for (PoeNinjaItem item in convertData) {
      chaosValueMap[item.id] = item.chaosValue;

      if (item.chaosValue >= 40) {
        overFortyScarabItems.add(item);
      } else if (item.chaosValue >= 20) {
        overTwentyScarabItems.add(item);
      } else if (item.chaosValue >= 10) {
        overTenScarabItems.add(item);
      } else if (item.chaosValue >= 4) {
        overFourScarabItems.add(item);
      }
    }

    selectableItems.sort((a, b) => a.name.compareTo(b.name));
  }
}
