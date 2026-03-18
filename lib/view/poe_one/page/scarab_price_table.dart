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

  Map<int, PoeNinjaItem> scarabLocation = SCARAB_LOCATION.MAP;

  // 선택된 갑충석들의 ID를 저장하는 Set
  Set<int> selectedScarabIds = {};

  int selectedGridIndex = -1;

  int sheetColumnQuantity = 17;
  int sheetRowQuantity = 19;

  bool alreadyShowSnackBar = false;

  // Tier 1~4 고정 조건
  List<double> scarabConditionList = [40, 20, 10, 4];

  @override
  Widget build(BuildContext context) {
    return GetX<GetScarabTable>(
      builder: (_) {
        if (getScarab.result.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Obx(() {
          final isKr = getCtrlDashboard.isKorean.value;
          return Column(
            children: [
              if (isDebugMode) buildManagementPrintButton(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                color: Colors.black26,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // --- 추가된 커스텀 선택 기능 버튼 ---
                      if (selectedScarabIds.isNotEmpty) ...[
                        SizedBox(
                          width: 140,
                          child: buildCustomCopyButton(isKr),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                          tooltip: isKr ? '선택 초기화' : 'Clear Selection',
                          onPressed: () => setState(() => selectedScarabIds.clear()),
                        ),
                        const VerticalDivider(color: Colors.white24, width: 20),
                      ],
                      // ------------------------------

                      // Tier 1 ~ Tier 4 버튼
                      ...scarabConditionList.map((value) => SizedBox(
                            width: 140,
                            child: buildCopyButton(
                              chaosValue: value,
                              items: getScarabItemsWithChaosValue(value),
                              label: '${value.toInt()}c↑',
                              isKr: isKr,
                            ),
                          )),
                      // Tier 5 (1c 미만) 분할 버튼
                      ...List.generate(getScarab.underOneScarabChunks.length, (index) {
                        final chunk = getScarab.underOneScarabChunks[index];
                        return SizedBox(
                          width: 140,
                          child: buildCopyButton(
                            chaosValue: 0.1, // Tier 5 색상 유도
                            items: chunk,
                            label: '1c↓ #${index + 1}',
                            isKr: isKr,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  buildSheet(isKr).expand(flex: 3),
                  if (isDebugMode) buildManagementList().expand(),
                ],
              ).expand(),
            ],
          );
        });
      },
    );
  }

  // 선택된 갑충석들만 복사하는 커스텀 버튼
  Widget buildCustomCopyButton(bool isKr) {
    // 현재 필터링된 모든 갑충석 데이터에서 선택된 ID와 일치하는 아이템들 추출
    List<PoeNinjaItem> selectedItems = [];
    final allScarabs = getScarab.result.value.data['filteredData'] as List<PoeNinjaItem>;
    for (var item in allScarabs) {
      if (selectedScarabIds.contains(item.id)) {
        selectedItems.add(item);
      }
    }

    return buildCopyButton(
      chaosValue: 100, // 강조를 위해 Tier 1 색상 빌림 (또는 별도 색상 지정 가능)
      items: selectedItems,
      label: isKr ? '선택 복사' : 'Copy Selected',
      isKr: isKr,
    );
  }

  Widget buildCopyButton({
    required double chaosValue,
    required List<PoeNinjaItem> items,
    required String label,
    required bool isKr,
  }) {
    Color backgroundColor = getBackgroundColor(chaosValue);
    Color textColor = getTextColor(chaosValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            String finalText = '';
            for (int i = 0; i < items.length; i++) {
              String addText = getRegexForItem(items[i], isKr);
              finalText += (i == 0 ? '' : '|') + addText;
            }

            if (finalText.isEmpty) return;
            if (!isKr) finalText = 'scarab $finalText';

            await Clipboard.setData(ClipboardData(text: finalText));
            showCenterSnackBar('${isKr ? MSG.COPY_TO_CLIPBOARD : MSG.COPY_TO_CLIPBOARD_EN} : $finalText');
          },
          child: Tooltip(
            message: isKr ? MSG.CLICK_TO_COPY_REG : MSG.CLICK_TO_COPY_REG_EN,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: textColor.withAlpha(50), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.content_copy_rounded, size: 14, color: textColor.withAlpha(180)),
                  const SizedBox(width: 6),
                  Text(
                    '$label [${items.length}]',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 개별 아이템의 정규식 생성 로직 (코드 중복 방지를 위해 분리)
  String getRegexForItem(PoeNinjaItem item, bool isKr) {
    final dynamic scarabI18n = I18N.SCARAB[item.name];
    if (isKr) {
      if (scarabI18n != null && scarabI18n is Map && scarabI18n['regexKr'] != null) {
        return scarabI18n['regexKr'].toString();
      } else {
        String localizedName = scarabI18nString(item.name, isKr);
        List<String> scarabSplit = localizedName.split(' ');
        if (scarabSplit.length >= 2 && scarabSplit[0].isNotEmpty && scarabSplit[1].isNotEmpty) {
          String part1 = scarabSplit[0].length >= 2 ? scarabSplit[0].substring(scarabSplit[0].length - 2) : scarabSplit[0];
          String part2 = scarabSplit[1].substring(0, 1);
          return '$part1.$part2';
        }
        return localizedName;
      }
    } else {
      if (scarabI18n != null && scarabI18n is Map && scarabI18n['regexEn'] != null) {
        return scarabI18n['regexEn'].toString();
      } else {
        String name = item.name.toLowerCase();
        List<String> words = name.split(' ');
        if (words.contains('of') && words.first.isNotEmpty && words.last.isNotEmpty) {
          return '${words[0][0]}.of.${words.last.substring(0, math.min(3, words.last.length))}';
        } else if (words.isNotEmpty && words[0].isNotEmpty) {
          return words[0].substring(0, math.min(3, words[0].length));
        }
        return name;
      }
    }
  }

  void showCenterSnackBar(String message) {
    if (alreadyShowSnackBar) return;
    alreadyShowSnackBar = true;
    final OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Material(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                  child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ));
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 800), () {
      alreadyShowSnackBar = false;
      overlayEntry.remove();
    });
  }

  Widget buildSheet(bool isKr) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 17,
        childAspectRatio: 1.75,
      ),
      itemCount: sheetColumnQuantity * sheetRowQuantity,
      itemBuilder: (context, int index) {
        PoeNinjaItem? getScarabItem = scarabLocation[index];
        if (isDebugMode) {
          return TextButton(
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(getScarabItem == null ? Colors.white : Colors.amber)),
            child: Text(getScarabItem?.name ?? index.toString()),
            onPressed: () {
              if (getScarab.selectableItems.isEmpty) return;
              setState(() {
                scarabLocation[index] = getScarab.selectableItems[0];
                getScarab.selectableItems.removeAt(0);
              });
            },
            onLongPress: () {
              setState(() {
                getScarab.selectableItems.add(getScarabItem!);
                getScarab.selectableItems.sort((a, b) => a.name.compareTo(b.name));
                scarabLocation.remove(index);
              });
            },
          );
        }
        return !scarabLocation.containsKey(index) ? Container() : buildScarabTooltip(item: getScarabItem, isKr: isKr);
      },
    );
  }

  Widget buildScarabTooltip({PoeNinjaItem? item, required bool isKr}) {
    if (item == null) return Container();
    double getChaosValue = getScarab.chaosValueMap[item.id] ?? 0.1;
    Color backgroundColor = getBackgroundColor(getChaosValue);
    Color textColor = getTextColor(getChaosValue);

    // 현재 아이템이 선택되었는지 여부
    bool isSelected = selectedScarabIds.contains(item.id);

    return Tooltip(
      message: "${scarabI18nString(item.name, isKr)}\n${isKr ? '클릭하여 선택/해제' : 'Click to Select/Deselect'}",
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedScarabIds.remove(item.id);
            } else {
              selectedScarabIds.add(item.id);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.white : Colors.grey.withAlpha(50),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Container(color: backgroundColor),
              Positioned(
                top: 1,
                right: 2,
                child: Text(
                  scarabClass(item.name, isKr),
                  style: TextStyle(color: getChaosValue >= 4 ? textColor.withAlpha(150) : COLOR.SUBTITLE, fontSize: 9, fontWeight: FontWeight.w500),
                ),
              ),
              Opacity(
                opacity: isSelected ? 1.0 : (getChaosValue >= 4 ? 1 : 0.6),
                child: Image.network('$imageUrl/${item.icon}', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error, size: 10)),
              ),
              // 선택 시 체크 표시
              if (isSelected)
                const Positioned(
                  left: 2,
                  top: 2,
                  child: Icon(Icons.check_circle, size: 12, color: Colors.white),
                ),
              Positioned(
                right: 2,
                bottom: 1,
                child: Text(
                  formatPrice(getChaosValue),
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              // 기존 URL 링크 버튼은 주석 처리
              /*
              TextButton(
                child: Container(),
                onPressed: () async {
                  String domain = isKr ? 'poe.game.daum.net' : 'www.pathofexile.com';
                  await launchUrl(Uri.parse('https://$domain/trade/search/$currentLeague?q={"query":{"status":{"option":"available"},"type":"${scarabI18nString(item.name, isKr)}","stats":[{"type":"and","filters":[]}]},"sort":{"price":"asc"}}'));
                },
              )
              */
            ],
          ),
        ),
      ),
    );
  }

  String formatPrice(double value) {
    if (value == 0) return '0';
    if (value < 4) {
      String result = value.toStringAsFixed(1);
      return result.endsWith('.0') ? result.substring(0, result.length - 2) : result;
    } else {
      return value.round().toString();
    }
  }

  Widget buildManagementList() {
    return ListView.builder(
      itemCount: getScarab.selectableItems.length,
      itemBuilder: (context, int index) {
        PoeNinjaItem item = getScarab.selectableItems[index];
        return ListTile(
          leading: Image.network('$imageUrl/${item.icon}'),
          title: Text(item.name, style: TextStyle(color: index == 0 ? Colors.amber : Colors.white, fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(formatPrice(item.chaosValue)),
        );
      },
    );
  }

  Widget buildManagementPrintButton() {
    return TextButton(
      onPressed: () {
        Map<String, dynamic> showScarabLocationData = scarabLocation.map((key, value) => MapEntry<String, dynamic>(key.toString(), value.map));
        print(jsonEncode(showScarabLocationData));
      },
      child: const Text('print'),
    );
  }

  @override
  void initState() {
    super.initState();
    getScarab.get();
  }

  String scarabI18nString(String scarabLabel, bool isKr) {
    final scarabData = I18N.SCARAB[scarabLabel];
    if (scarabData == null) return scarabLabel;
    return isKr ? (scarabData['label'] ?? scarabLabel) : (scarabData['value'] ?? scarabLabel);
  }

  String scarabClass(String scarabLabel, bool isKr) {
    final scarabData = I18N.SCARAB[scarabLabel];
    if (scarabData == null) return isKr ? '기본' : 'Base';
    return isKr ? (scarabData['class'] ?? '기본') : (scarabData['classEn'] ?? 'Base');
  }

  List<PoeNinjaItem> getScarabItemsWithChaosValue(double chaosValue) {
    if (chaosValue >= 40) return getScarab.overFortyScarabItems;
    if (chaosValue >= 20) return getScarab.overTwentyScarabItems;
    if (chaosValue >= 10) return getScarab.overTenScarabItems;
    if (chaosValue >= 4) return getScarab.overFourScarabItems;
    return [];
  }

  Color getBackgroundColor(double chaosValue) {
    if (chaosValue >= 40) return COLOR.TIER_1_BG;
    if (chaosValue >= 20) return COLOR.TIER_2_BG;
    if (chaosValue >= 10) return COLOR.TIER_3_BG;
    if (chaosValue >= 4) return COLOR.TIER_4_BG;
    return COLOR.TIER_5_BG;
  }

  Color getTextColor(double chaosValue) {
    if (chaosValue >= 40) return COLOR.TIER_1_TEXT;
    if (chaosValue >= 20) return COLOR.TIER_2_TEXT;
    if (chaosValue >= 10) return COLOR.TIER_3_TEXT;
    if (chaosValue >= 4) return COLOR.TIER_4_TEXT;
    return COLOR.TIER_5_TEXT;
  }
}
