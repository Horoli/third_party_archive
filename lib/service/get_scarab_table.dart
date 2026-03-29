part of third_party_archive;

class GetScarabTable extends GetxController {
  RxObjectMixin<RestfulResult> result =
      RestfulResult(statusCode: 0, message: '').obs;

  List<PoeNinjaItem> selectableItems = [];
  List<PoeNinjaItem> overFortyScarabItems = [];
  List<PoeNinjaItem> overTenScarabItems = [];
  List<PoeNinjaItem> overFourScarabItems = [];
  List<PoeNinjaItem> underOneScarabItems = [];
  List<PoeNinjaItem> overOneScarabItems = []; // 1c 이상 전체 리스트 추가
  
  // 1~4c 사이의 데이터를 뭉치(Chunk) 단위로 관리
  List<List<PoeNinjaItem>> oneToFourScarabChunks = []; 
  
  Map<int, dynamic> chaosValueMap = {};

  Future<RestfulResult> get() async {
    Uri uri = isLocal
        ? Uri.http(URL.LOCAL_URL, URL.POE_NINJA_SCARAB)
        : Uri.https(URL.FORIEGN_URL, URL.POE_NINJA_SCARAB);
    
    http.Response rep = await http.get(uri).catchError((error) => throw error);
    Map rawData = jsonDecode(rep.body);
    
    List<PoeNinjaItem> scarabs = List.from(rawData['data']['filteredData'] ?? [])
        .map((item) => PoeNinjaItem.fromMap(item: item))
        .toList();

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
    overTenScarabItems = [];
    overFourScarabItems = [];
    underOneScarabItems = [];
    overOneScarabItems = []; // 초기화 추가
    List<PoeNinjaItem> tempOneToFour = [];
    chaosValueMap = {};

    final mappedNames = SCARAB_LOCATION.MAP.values.map((e) => e.name).toSet();

    selectableItems = convertData.where((se) => !mappedNames.contains(se.name)).toList();

    for (PoeNinjaItem item in convertData) {
      chaosValueMap[item.id] = item.chaosValue;

      if (item.chaosValue >= 1) {
        overOneScarabItems.add(item); // 1c 이상 전체 수집

        if (item.chaosValue >= 40) {
          overFortyScarabItems.add(item);
        } else if (item.chaosValue >= 10) {
          overTenScarabItems.add(item);
        } else if (item.chaosValue >= 4) {
          overFourScarabItems.add(item);
        } else if (item.chaosValue >= 1 && item.chaosValue < 4) {
          tempOneToFour.add(item);
        }
      } else {
        underOneScarabItems.add(item); // 1c 미만 추가
      }
    }

    // 1~4c 아이템들을 35개 단위로 쪼개기 (PoE 255자 제한 대응)
    oneToFourScarabChunks = [];
    for (var i = 0; i < tempOneToFour.length; i += 35) {
      oneToFourScarabChunks.add(
        tempOneToFour.sublist(i, i + 35 > tempOneToFour.length ? tempOneToFour.length : i + 35)
      );
    }

    selectableItems.sort((a, b) => a.name.compareTo(b.name));
  }
}
