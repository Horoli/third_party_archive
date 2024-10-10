part of third_party_archive;

class PageScarabPriceTable extends StatefulWidget {
  const PageScarabPriceTable({super.key});

  @override
  PageScarabPriceTableState createState() => PageScarabPriceTableState();
}

class PageScarabPriceTableState extends State<PageScarabPriceTable> {
  final GetScarabTable getScarab = Get.put(GetScarabTable());

  String imageUrl = URL.IS_LOCAL
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  List<PoeNinjaItem> get data => getScarab.result.value.data['filteredData'];
  List<PoeNinjaItem> selectableItems = [];

  Map<int, PoeNinjaItem> scarabLocation = SCARAB_LOCATION.MAP;

  int selectedGridIndex = -1;

  // debugmode일땐 editing list 표시
  bool isDebugMode = !kDebugMode;

  int sheetColumnQuantity = 17;
  int sheetRowQuantity = 19;

  // 필터링 버튼을 만들기 위한 리스트
  List<double> scarabConditionList = [40, 20, 10, 4];
  List<String> overFortyScarabNames = [];
  List<String> overTwentyScarabNames = [];
  List<String> overTenScarabNames = [];
  List<String> overFourScarabNames = [];

  @override
  Widget build(BuildContext context) {
    return GetX<GetScarabTable>(
      builder: (_) {
        if (getScarab.result.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            if (isDebugMode) buildManagementPrintButton(),
            Row(
              children: List.generate(scarabConditionList.length, (index) {
                return buildCopyButton(scarabConditionList[index]).expand();
              }),
            ).sizedBox(height: kToolbarHeight),
            Row(
              children: [
                buildSheet().expand(flex: 3),
                if (isDebugMode) buildManagementList().expand(),
              ],
            ).expand(),
          ],
        );
      },
    );
  }

  Widget buildCopyButton(double standardPrice) {
    Color backgroundColor = getBackgroundColor(standardPrice);
    List<String> scarabNames = getScarabNamesWithChaosValue(standardPrice);

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        )),
      ),
      onPressed: () {
        print('${standardPrice}c 이상');
        print(scarabNames);
        Clipboard.setData(ClipboardData(text: '$scarabNames'));
      },
      child: Row(
        children: [
          Container(color: backgroundColor).expand(),
          Text('${standardPrice}c 이상 : ${scarabNames.length}종류').expand(),
        ],
      ),
    );
  }

  Widget buildSheet() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sheetColumnQuantity,
      ),
      itemCount: sheetColumnQuantity * sheetRowQuantity,
      itemBuilder: (context, int index) {
        // TODO : DebugMode일때 보여주는 tile
        if (isDebugMode) {
          return TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                scarabLocation[index] == null ? Colors.white : Colors.amber,
              ),
            ),
            child: Text(
              scarabLocation[index]?.name ?? index.toString(),
            ),
            onPressed: () {
              setState(() {
                scarabLocation[index] = selectableItems[0];
                selectableItems.removeAt(0);
              });
            },
            onLongPress: () {
              setState(() {
                selectableItems.add(scarabLocation[index]!);
                selectableItems.sort((a, b) => a.name.compareTo(b.name));
                scarabLocation.remove(index);
              });
            },
          );
        }

        // TODO : releaseMode일때 보여주는 tile
        return !scarabLocation.containsKey(index)
            ? Container()
            : buildScarabTooltip(item: scarabLocation[index]!);
      },
    );
  }

  Widget buildScarabTooltip({required PoeNinjaItem item}) {
    Color backgroundColor = getBackgroundColor(item.chaosValue);
    AlwaysStoppedAnimation<double> opacity = item.chaosValue >= 4
        ? const AlwaysStoppedAnimation(1.0)
        : const AlwaysStoppedAnimation(0.5);

    return Tooltip(
      message: "${scarabI18nString(item.name)}\n누르면 거래소로 이동",
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Stack(
          children: [
            Container(
              color: backgroundColor,
            ),
            Image.network(
              '$imageUrl/${item.icon}',
              opacity: opacity,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text('${item.chaosValue}'),
            ),
            TextButton(
              child: Container(),
              onPressed: () async {
                await launchUrl(
                  Uri.parse(
                    'https://poe.game.daum.net/trade/search/Settlers?q={"query":{"status":{"option":"online"},"type":"${scarabI18nString(item.name)}","stats":[{"type":"and","filters":[]}]},"sort":{"price":"asc"}}',
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildManagementList() {
    return ListView.builder(
      itemCount: selectableItems.length,
      itemBuilder: (context, int index) {
        PoeNinjaItem item = selectableItems[index];
        return ListTile(
          leading: Image.network('$imageUrl/${item.icon}'),
          title: Text(item.name,
              style: TextStyle(
                color: index == 0 ? Colors.amber : Colors.white,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
              )),
          subtitle: Text(item.chaosValue.toString()),
        );
      },
    );
  }

  Widget buildManagementPrintButton() {
    return TextButton(
      onPressed: () {
        Map<String, dynamic> showScarabLocationData =
            scarabLocation.map((key, value) {
          return MapEntry<String, dynamic>(key.toString(), value.map);
        });

        print(jsonEncode(showScarabLocationData));
      },
      child: Text('print'),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  String scarabI18nString(String scarabLabel) =>
      I18N.SCARAB[scarabLabel]['label'];

  List<String> getScarabNamesWithChaosValue(double chaosValue) {
    switch (chaosValue) {
      case >= 40:
        return overFortyScarabNames;
      case >= 20:
        return overTwentyScarabNames;
      case >= 10:
        return overTenScarabNames;
      case >= 4:
        return overFourScarabNames;
      default:
        return [];
    }
  }

  Color getBackgroundColor(double value) {
    switch (value) {
      case >= 40:
        return COLOR.OVER_FORTY;
      case >= 20:
        return COLOR.OVER_TWENTY;
      case >= 10:
        return COLOR.OVER_TEN;
      case >= 4:
        return COLOR.OVER_FOUR;
      default:
        return COLOR.DEFAULT;
    }
  }

  Future<void> fetch() async {
    RestfulResult getResult = await getScarab.get();
    setState(() {
      selectableItems = getResult.data['filteredData'].where((se) {
        return !SCARAB_LOCATION.MAP.values.any((e) {
          return e.name == se.name;
        });
      }).toList();

      for (PoeNinjaItem e in scarabLocation.values) {
        if (e.chaosValue >= 40) {
          overFortyScarabNames.add(scarabI18nString(e.name));
          continue;
        }
        if (e.chaosValue >= 20) {
          overTwentyScarabNames.add(scarabI18nString(e.name));
          continue;
        }
        if (e.chaosValue >= 10) {
          overTenScarabNames.add(scarabI18nString(e.name));
          continue;
        }
        if (e.chaosValue >= 4) {
          overFourScarabNames.add(scarabI18nString(e.name));
          continue;
        }
      }

      selectableItems.sort((a, b) => a.name.compareTo(b.name));
    });
  }
}
