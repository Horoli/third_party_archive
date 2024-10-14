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
  bool isDebugMode = kDebugMode;

  int sheetColumnQuantity = 17;
  int sheetRowQuantity = 19;

  bool alreadyShowSnackBar = false;

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
            Text(
                    textAlign: TextAlign.end,
                    'Data From poe.ninja updatedAt : ${getScarab.result.value.data['updateDate']}')
                .sizedBox(width: double.infinity),
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

  Widget buildCopyButton(double chaosValue) {
    Color backgroundColor = getBackgroundColor(chaosValue);
    List<String> scarabNames = getScarabNamesWithChaosValue(chaosValue);

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        )),
      ),
      onPressed: () async {
        // print('${chaosValue}c 이상');
        // print(scarabNames);

        String finalText = '';
        // TODO : scarabNames를 reg로 변환하여 클립보드에 복사
        Clipboard.setData(ClipboardData(text: '준비 중')).then((_) async {
          for (int i = 0; i < scarabNames.length; i++) {
            List<String> scarabSplit = scarabNames[i].split(' ');
            int firstLength = scarabSplit.first.length;

            String firstWord =
                scarabSplit.first.substring(firstLength - 2, firstLength);
            String secondWord = scarabSplit[1].substring(0, 1);
            String addText = '$firstWord.$secondWord';
            if (i == scarabNames.length - 1) {
              finalText = '$finalText$addText';
              break;
            }
            finalText = '$finalText$addText|';
          }

          Clipboard.setData(ClipboardData(text: finalText));

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     dismissDirection: DismissDirection.up,
          //     behavior: SnackBarBehavior.floating,
          //     duration: Duration(milliseconds: 500),
          //     content: Text("갑충석(kr) reg 복사 기능 준비 중"),
          //   ),
          // );
          // if (alreadyShowSnackBar) return;

          showCenterSnackBar('복사 완료 : ${finalText}');
        });
      },
      child: Tooltip(
        message: '누르면 클립보드에 복사 됩니다',
        child: Row(
          children: [
            Container(color: backgroundColor).expand(),
            Center(child: Text('${chaosValue}c 이상 : ${scarabNames.length}종류'))
                .expand(),
          ],
        ),
      ),
    );
  }

  void showCenterSnackBar(String message) {
    if (alreadyShowSnackBar) return;
    alreadyShowSnackBar = true;
    final OverlayEntry overlayEntry = OverlayEntry(
        canSizeOverlay: true,
        builder: (context) {
          return Material(
            color: Colors.black87.withOpacity(0.5),
            child: Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        });

    Overlay.of(context).insert(overlayEntry);

    // n초 후 초기화
    Future.delayed(const Duration(milliseconds: 500), () {
      alreadyShowSnackBar = false;
      overlayEntry.remove();
      overlayEntry.dispose();
    });
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
