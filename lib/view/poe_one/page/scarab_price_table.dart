part of third_party_archive;

class PageScarabPriceTable extends StatefulWidget {
  const PageScarabPriceTable({super.key});

  @override
  PageScarabPriceTableState createState() => PageScarabPriceTableState();
}

class PageScarabPriceTableState extends State<PageScarabPriceTable> {
  final GetScarabTable getScarab = Get.put(GetScarabTable());
  final GetDashboard getCtrlDashboard = Get.find<GetDashboard>();

  String imageUrl = isLocal
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  List<PoeNinjaItem> get data => getScarab.result.value.data['filteredData'];
  List<PoeNinjaItem> selectableItems = [];

  Map<int, PoeNinjaItem> scarabLocation = SCARAB_LOCATION.MAP;
  Map<int, dynamic> chaosValueMap = {};

  int selectedGridIndex = -1;

  // debugmode일땐 editing list 표시

  int sheetColumnQuantity = 17;
  int sheetRowQuantity = 19;

  bool alreadyShowSnackBar = false;

  // 필터링 버튼을 만들기 위한 리스트
  List<double> scarabConditionList = [40, 20, 10, 4];

  List<PoeNinjaItem> overFortyScarabItems = [];
  List<PoeNinjaItem> overTwentyScarabItems = [];
  List<PoeNinjaItem> overTenScarabItems = [];
  List<PoeNinjaItem> overFourScarabItems = [];

  int chaosValueFirst = 40;
  int chaosValueSecond = 20;
  int chaosValueThird = 10;
  int chaosValueFourth = 4;

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
              children: [
                ...List.generate(scarabConditionList.length, (index) {
                  return buildCopyButton(scarabConditionList[index]).expand();
                }),
              ],
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

  Widget buildLanguageToggleButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
      onPressed: () {
        getCtrlDashboard.toggleLanguage();
        // UI 갱신을 위해 setState 호출
        setState(() {});
      },
      child: Obx(() => Text(getCtrlDashboard.isKorean.value ? 'KO' : 'EN')),
    );
  }

  Widget buildCopyButton(double chaosValue) {
    Color backgroundColor = getBackgroundColor(chaosValue);
    List<PoeNinjaItem> scarabItems = getScarabItemsWithChaosValue(chaosValue);

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        )),
      ),
      onPressed: () async {
        String finalText = '';
        bool isKr = getCtrlDashboard.isKorean.value;

        for (int i = 0; i < scarabItems.length; i++) {
          String addText = '';
          PoeNinjaItem item = scarabItems[i];
          final scarabI18n = I18N.SCARAB[item.name];

          if (isKr) {
            // 1. I18N에 등록된 전용 국문 Regex 우선 사용
            if (scarabI18n != null && scarabI18n['regexKr'] != null) {
              addText = scarabI18n['regexKr'];
            } else {
              // 2. 없으면 기존 국문 알고리즘 사용
              String localizedName = scarabI18nString(item.name);
              List<String> scarabSplit = localizedName.split(' ');
              if (scarabSplit.length >= 2) {
                String firstWordPart = scarabSplit[0];
                String secondWordPart = scarabSplit[1];
                String part1 = firstWordPart.length >= 2
                    ? firstWordPart.substring(firstWordPart.length - 2)
                    : firstWordPart;
                String part2 = secondWordPart.substring(0, 1);
                addText = '$part1.$part2';
              } else {
                addText = localizedName;
              }
            }
          } else {
            // 1. I18N에 등록된 전용 영문 Regex 우선 사용 (예: wak, dlines$, ^scarab of w)
            if (scarabI18n != null && scarabI18n['regexEn'] != null) {
              addText = scarabI18n['regexEn'];
            } else {
              // 2. 없으면 기존 영문 알고리즘 사용 (접두어 없이 순수 키워드만 생성)
              String name = item.name.toLowerCase();
              List<String> words = name.split(' ');

              if (words.contains('of')) {
                String firstChar = words[0][0];
                String lastWord = words.last;
                String suffixPart =
                    lastWord.length >= 3 ? lastWord.substring(0, 3) : lastWord;
                addText = '$firstChar.of.$suffixPart';
              } else if (words.length >= 2) {
                addText =
                    words[0].length >= 3 ? words[0].substring(0, 3) : words[0];
              } else {
                addText = name.length >= 3 ? name.substring(0, 3) : name;
              }
            }
          }

          if (i == scarabItems.length - 1) {
            finalText = '$finalText$addText';
          } else {
            finalText = '$finalText$addText|';
          }
        }

        if (finalText.isEmpty) return;

        // 영문 모드에서만 전체 결과 앞에 'scarab '을 한 번만 추가
        if (!isKr) {
          finalText = 'scarab $finalText';
        }

        Clipboard.setData(ClipboardData(text: finalText)).then((_) {
          showCenterSnackBar(
              '${isKr ? MSG.COPY_TO_CLIPBOARD : MSG.COPY_TO_CLIPBOARD_EN} : $finalText');
        });
      },
      child: Obx(() => Tooltip(
            message: getCtrlDashboard.isKorean.value
                ? MSG.CLICK_TO_COPY_REG
                : MSG.CLICK_TO_COPY_REG_EN,
            child: Row(
              children: [
                Container(color: backgroundColor).expand(),
                Center(
                        child: Text(
                            '${chaosValue.toInt()}c${getCtrlDashboard.isKorean.value ? LABEL.MORE_THAN : LABEL.MORE_THAN_EN} [${scarabItems.length}]'))
                    .expand(),
              ],
            ),
          )),
    );
  }

  void showCenterSnackBar(String message) {
    if (alreadyShowSnackBar) return;
    alreadyShowSnackBar = true;
    final OverlayEntry overlayEntry = OverlayEntry(
        canSizeOverlay: true,
        builder: (context) {
          return Material(
            color: Colors.black87.withAlpha(50),
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
        childAspectRatio: 1.75,
      ),
      itemCount: sheetColumnQuantity * sheetRowQuantity,
      itemBuilder: (context, int index) {
        PoeNinjaItem? getScarabItem = scarabLocation[index];
        // TODO : DebugMode일때 보여주는 tile
        if (isDebugMode) {
          return TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                getScarabItem == null ? Colors.white : Colors.amber,
              ),
            ),
            child: Text(
              getScarabItem?.name ?? index.toString(),
            ),
            onPressed: () {
              if (selectableItems.isEmpty) return;
              setState(() {
                scarabLocation[index] = selectableItems[0];
                selectableItems.removeAt(0);
              });
            },
            onLongPress: () {
              setState(() {
                selectableItems.add(getScarabItem!);
                selectableItems.sort((a, b) => a.name.compareTo(b.name));
                scarabLocation.remove(index);
              });
            },
          );
        }

        // TODO : releaseMode일때 보여주는 tile
        return !scarabLocation.containsKey(index)
            ? Container()
            : buildScarabTooltip(item: getScarabItem);
      },
    );
  }

  Widget buildScarabTooltip({PoeNinjaItem? item}) {
    if (item == null) {
      return Container();
    }
    double getChaosValue = chaosValueMap[item.id] ?? 0.1;

    Color backgroundColor = getBackgroundColor(getChaosValue);
    double opacity = getChaosValue >= 4 ? 1 : 0.5;

    return Obx(() => Tooltip(
          message:
              "${scarabI18nString(item.name)}\n${getCtrlDashboard.isKorean.value ? MSG.CLICK_TO_GO_TRADE : MSG.CLICK_TO_GO_TRADE_EN}",
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Stack(
              children: [
                Container(
                  color: backgroundColor,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    scarabClass(item.name),
                    style: TextStyle(color: COLOR.SUBTITLE),
                  ),
                ),
                Opacity(
                  opacity: opacity,
                  child: Image.network(
                    '$imageUrl/${item.icon}',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Text('${chaosValueMap[item.id] ?? item.chaosValue}'),
                ),
                TextButton(
                  child: Container(),
                  onPressed: () async {
                    String domain = getCtrlDashboard.isKorean.value
                        ? 'poe.game.daum.net'
                        : 'www.pathofexile.com';
                    String league = currentLeague;
                    String itemName = scarabI18nString(item.name);

                    await launchUrl(
                      Uri.parse(
                        'https://$domain/trade/search/$league?q={"query":{"status":{"option":"available"},"type":"$itemName","stats":[{"type":"and","filters":[]}]},"sort":{"price":"asc"}}',
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
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

  String scarabI18nString(String scarabLabel) {
    final scarabData = I18N.SCARAB[scarabLabel];

    if (scarabData == null) {
      print('⚠️ 번역 데이터 누락: $scarabLabel');
      return scarabLabel;
    }

    if (getCtrlDashboard.isKorean.value) {
      return scarabData['label'] ?? scarabLabel;
    }

    return scarabData['value'] ?? scarabLabel;
  }

  String scarabClass(String scarabLabel) {
    final scarabData = I18N.SCARAB[scarabLabel];
    if (scarabData == null) return '기본클래스';

    if (getCtrlDashboard.isKorean.value) {
      return scarabData['class'] ?? '기본클래스';
    }
    return scarabData['classEn'] ?? 'Class';
  }

  List<PoeNinjaItem> getScarabItemsWithChaosValue(double chaosValue) {
    if (chaosValue >= chaosValueFirst) {
      return overFortyScarabItems;
    } else if (chaosValue >= chaosValueSecond) {
      return overTwentyScarabItems;
    } else if (chaosValue >= chaosValueThird) {
      return overTenScarabItems;
    } else if (chaosValue >= chaosValueFourth) {
      return overFourScarabItems;
    } else {
      return [];
    }
  }

  Color getBackgroundColor(double chaosValue) {
    if (chaosValue >= chaosValueFirst) {
      return COLOR.OVER_FORTY;
    } else if (chaosValue >= chaosValueSecond) {
      return COLOR.OVER_TWENTY;
    } else if (chaosValue >= chaosValueThird) {
      return COLOR.OVER_TEN;
    } else if (chaosValue >= chaosValueFourth) {
      return COLOR.OVER_FOUR;
    } else {
      return COLOR.DEFAULT;
    }
  }

  Future<void> fetch() async {
    await getScarab.get();
    updateScarabNamesLists();
  }

  void updateScarabNamesLists() {
    RestfulResult getResult = getScarab.result.value;
    if (getResult.data == null) return;

    List<PoeNinjaItem> convertData = getResult.data['filteredData'].toList();

    setState(() {
      overFortyScarabItems = [];
      overTwentyScarabItems = [];
      overTenScarabItems = [];
      overFourScarabItems = [];

      selectableItems = convertData.where((se) {
        return !SCARAB_LOCATION.MAP.values.any((e) {
          return e.name == se.name;
        });
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
    });
  }
}
