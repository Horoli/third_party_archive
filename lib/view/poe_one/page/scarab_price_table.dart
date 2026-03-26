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

  // 버튼 공용 너비
  double buttonWidth = 100;

  // Tier 조건
  List<double> scarabConditionList = [40, 20, 10, 4];

  /// 4c 이상 전체 아이템
  List<PoeNinjaItem> get allOverFourItems => [
        ...getScarab.overFortyScarabItems,
        ...getScarab.overTwentyScarabItems,
        ...getScarab.overTenScarabItems,
        ...getScarab.overFourScarabItems,
      ];

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
                          width: buttonWidth,
                          child: buildCustomCopyButton(isKr),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded,
                              color: Colors.white70),
                          tooltip: isKr ? '선택 초기화' : 'Clear Selection',
                          onPressed: () =>
                              setState(() => selectedScarabIds.clear()),
                        ),
                        const VerticalDivider(color: Colors.white24, width: 20),
                      ],
                      // ------------------------------

                      // 40↑
                      SizedBox(
                        width: buttonWidth,
                        child: buildCopyButton(
                          chaosValue: 40,
                          items: getScarab.overFortyScarabItems,
                          label: '40',
                          isKr: isKr,
                        ),
                      ),
                      // 10↑
                      SizedBox(
                        width: buttonWidth,
                        child: buildCopyButton(
                          chaosValue: 10,
                          items: getScarab.overTenScarabItems,
                          label: '10',
                          isKr: isKr,
                        ),
                      ),
                      // 4↑
                      SizedBox(
                        width: buttonWidth,
                        child: buildCopyButton(
                          chaosValue: 4,
                          items: getScarab.overFourScarabItems,
                          label: '4',
                          isKr: isKr,
                        ),
                      ),
                      // 4~1 분할 버튼
                      ...List.generate(getScarab.oneToFourScarabChunks.length,
                          (index) {
                        final chunk = getScarab.oneToFourScarabChunks[index];
                        return SizedBox(
                          width: buttonWidth,
                          child: buildCopyButton(
                            chaosValue: 2,
                            items: chunk,
                            label: '4~1',
                            isKr: isKr,
                          ),
                        );
                      }),

                      // 1↓
                      SizedBox(
                        width: buttonWidth,
                        child: buildCopyButton(
                          chaosValue: 0.1, // 잡템 강조를 위해 낮은 티어 색상 사용
                          items: getScarab.overOneScarabItems,
                          label: '1↓',
                          isKr: isKr,
                          isExclude: true,
                          overrideCount: getScarab.underOneScarabItems.length,
                        ),
                      ),
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
    final allScarabs =
        getScarab.result.value.data['filteredData'] as List<PoeNinjaItem>;
    for (var item in allScarabs) {
      if (selectedScarabIds.contains(item.id)) {
        selectedItems.add(item);
      }
    }

    return buildCopyButton(
      chaosValue: 100, // 강조를 위해 Tier 1 색상 빌림 (또는 별도 색상 지정 가능)
      items: selectedItems,
      label: isKr ? '선택' : 'Pick', // 텍스트 간소화
      isKr: isKr,
    );
  }

  Widget buildCopyButton({
    required double chaosValue,
    required List<PoeNinjaItem> items,
    required String label,
    required bool isKr,
    bool isExclude = false,
    int? overrideCount,
  }) {
    Color backgroundColor = getBackgroundColor(chaosValue);
    Color textColor = getTextColor(chaosValue);

    // 라벨에서 'c' 제거 (아이콘이 상단에 따로 표시되므로)
    String cleanLabel = label.replaceAll('c', '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            String combinedRegex = '';
            for (int i = 0; i < items.length; i++) {
              String addText = getRegexForItem(items[i], isKr);
              combinedRegex += (i == 0 ? '' : '|') + addText;
            }

            if (combinedRegex.isEmpty && !isExclude) return;

            // [규칙 1] 전체를 큰따옴표로 묶기 (제외 필터인 경우 ! 추가)
            String finalText =
                isExclude ? '"!$combinedRegex"' : '"$combinedRegex"';

            // 클라이언트 언어에 따른 접두사 추가 (국문: 갑충, 영문: scarab)
            finalText = '${isKr ? '갑충' : 'scarab'} $finalText';

            await Clipboard.setData(ClipboardData(text: finalText));
            showCenterSnackBar(
                '${isKr ? MSG.COPY_TO_CLIPBOARD : MSG.COPY_TO_CLIPBOARD_EN} : $finalText');
          },
          child: Tooltip(
            message: isKr ? MSG.CLICK_TO_COPY_REG : MSG.CLICK_TO_COPY_REG_EN,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: textColor.withAlpha(50), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  // 1. 좌측 상단 카오스 오브 아이콘 고정
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Image.asset(
                      IMAGE.CHAOS_ORB,
                      width: 40,
                      height: 40,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                    ),
                  ),
                  // 2. 우측 상단 텍스트 (라벨)
                  Positioned(
                    top: 4,
                    right: 6,
                    child: Text(
                      cleanLabel,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  // 3. 우측 하단 텍스트 (갯수 - 숫자만)
                  Positioned(
                    bottom: 4,
                    right: 6,
                    child: Text(
                      '${overrideCount ?? items.length}',
                      style: TextStyle(
                          color: textColor.withAlpha(200),
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 개별 아이템의 정규식 생성 로직 (request.md 규칙 반영)
  String getRegexForItem(PoeNinjaItem item, bool isKr) {
    final dynamic scarabI18n = I18N.SCARAB[item.name];
    if (scarabI18n == null) return item.name.replaceAll(' ', '.');

    // 1. 이미 i18n.dart에 최적화된 정규식이 있다면 그것을 우선 사용
    if (isKr) {
      if (scarabI18n is Map && scarabI18n['regexKr'] != null) {
        return scarabI18n['regexKr'].toString().replaceAll(' ', '.');
      }
    } else {
      if (scarabI18n is Map && scarabI18n['regexEn'] != null) {
        return scarabI18n['regexEn'].toString().replaceAll(' ', '.');
      }
    }

    // 2. Fallback: 스마트 알고리즘 적용
    String label = isKr
        ? (scarabI18n['label'] ?? item.name)
        : (scarabI18n['value'] ?? item.name);

    // [규칙 4] 기본 갑충석 처리 (변형이 없는 순수 '갑충석' 이름인 경우)
    bool isBaseScarab = false;
    if (isKr) {
      // 한글은 'XX 갑충석' 형태가 기본
      if (label.endsWith('갑충석') && !label.contains('의 ')) {
        isBaseScarab = true;
      }
    } else {
      // 영문은 'XX Scarab' 형태가 기본
      if (label.endsWith('Scarab')) {
        isBaseScarab = true;
      }
    }

    if (isKr) {
      if (isBaseScarab) {
        // [규칙 4] 시작 앵커 활용
        String prefix = label.split(' ')[0];
        return '^$prefix'.replaceAll(' ', '.');
      } else {
        // [규칙 5/1] 중간 생략 및 점 치환
        List<String> parts = label.split(' ');
        if (parts.length >= 2) {
          // '개화의 역병 갑충석' -> '화의.역'
          String part1 = parts[0].length >= 2
              ? parts[0].substring(parts[0].length - 2)
              : parts[0];
          String part2 = parts[1].substring(0, 1);
          return '$part1.$part2';
        }
        return label.replaceAll(' ', '.');
      }
    } else {
      String name = label.toLowerCase();
      if (isBaseScarab) {
        // [규칙 4] 끝 앵커 활용 (예: kalg.*b$)
        List<String> words = name.split(' ');
        return '${words[0].substring(0, math.min(4, words[0].length))}.*b\$';
      } else {
        // [규칙 5] 와일드카드 압축 (예: Abyss Scarab of Multitudes -> yss.*mul)
        List<String> words = name.split(' ');
        if (words.contains('of') && words.length >= 3) {
          String first = words[0];
          String last = words.last;
          String firstPart =
              first.length >= 4 ? first.substring(first.length - 3) : first;
          String lastPart = last.substring(0, math.min(3, last.length));
          return '$firstPart.*$lastPart';
        }
        return name.substring(0, math.min(4, name.length)).replaceAll(' ', '.');
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(message,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
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
          final bool hasItem = getScarabItem != null;
          return Tooltip(
            message: hasItem
                ? '${getScarabItem.name}\n(롱프레스: 제거)'
                : '$index (클릭: 배치)',
            child: InkWell(
              onTap: () {
                if (getScarab.selectableItems.isEmpty) return;
                setState(() {
                  scarabLocation[index] = getScarab.selectableItems[0];
                  getScarab.selectableItems.removeAt(0);
                });
              },
              onLongPress: hasItem
                  ? () {
                      setState(() {
                        getScarab.selectableItems.add(getScarabItem);
                        getScarab.selectableItems
                            .sort((a, b) => a.name.compareTo(b.name));
                        scarabLocation.remove(index);
                      });
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: hasItem ? Colors.amber.withAlpha(40) : Colors.white10,
                  border: Border.all(
                    color: hasItem
                        ? Colors.amber.withAlpha(100)
                        : Colors.white24,
                    width: 1,
                  ),
                ),
                child: hasItem
                    ? Stack(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Image.network(
                              '$imageUrl/${getScarabItem.icon}',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.error, size: 10),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 2,
                            child: Text(
                              formatPrice(getScarabItem.chaosValue),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 9,
                          ),
                        ),
                      ),
              ),
            ),
          );
        }
        return !scarabLocation.containsKey(index)
            ? Container()
            : buildScarabTooltip(item: getScarabItem, isKr: isKr);
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
      message:
          "${scarabI18nString(item.name, isKr)}\n${isKr ? '클릭하여 선택/해제' : 'Click to Select/Deselect'}",
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
                  style: TextStyle(
                      color: getChaosValue >= 4
                          ? textColor.withAlpha(150)
                          : COLOR.SUBTITLE,
                      fontSize: 9,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Opacity(
                opacity: isSelected ? 1.0 : (getChaosValue >= 4 ? 1 : 0.6),
                child: Image.network('$imageUrl/${item.icon}',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.error, size: 10)),
              ),
              // 선택 시 체크 표시
              if (isSelected)
                const Positioned(
                  left: 2,
                  top: 2,
                  child:
                      Icon(Icons.check_circle, size: 12, color: Colors.white),
                ),
              Positioned(
                right: 2,
                bottom: 1,
                child: Text(
                  formatPrice(getChaosValue),
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
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
      return result.endsWith('.0')
          ? result.substring(0, result.length - 2)
          : result;
    } else {
      return value.round().toString();
    }
  }

  Widget buildManagementList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.black26,
          child: Row(
            children: [
              const Icon(Icons.inventory_2_outlined,
                  color: Colors.amber, size: 16),
              const SizedBox(width: 6),
              Text(
                '미배치 (${getScarab.selectableItems.length})',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24, height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: getScarab.selectableItems.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, int index) {
              PoeNinjaItem item = getScarab.selectableItems[index];
              final bool isNext = index == 0;
              return Container(
                color: isNext ? Colors.amber.withAlpha(20) : Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        '$imageUrl/${item.icon}',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.error, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          color: isNext ? Colors.amber : Colors.white70,
                          fontWeight:
                              isNext ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatPrice(item.chaosValue),
                      style: TextStyle(
                        color: isNext ? Colors.amber : Colors.white54,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_back,
                          color: Colors.amber, size: 12),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildManagementPrintButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.black26,
      child: Row(
        children: [
          const Icon(Icons.bug_report, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          const Text(
            'DEBUG',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                Map<String, dynamic> showScarabLocationData =
                    scarabLocation.map((key, value) =>
                        MapEntry<String, dynamic>(
                            key.toString(), value.map));
                final jsonStr = jsonEncode(showScarabLocationData);
                Clipboard.setData(ClipboardData(text: jsonStr));
                showCenterSnackBar('JSON copied to clipboard');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber.withAlpha(100)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Export JSON',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                Map<String, dynamic> showScarabLocationData =
                    scarabLocation.map((key, value) =>
                        MapEntry<String, dynamic>(
                            key.toString(), value.map));
                print(jsonEncode(showScarabLocationData));
                showCenterSnackBar('Printed to console');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.terminal, color: Colors.white54, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Console',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getScarab.get().then((_) {
      _syncScarabLocationWithServer();
    });
  }

  /// 서버에서 받아온 최신 데이터로 scarabLocation의 icon/chaosValue를 동기화
  void _syncScarabLocationWithServer() {
    final serverData =
        getScarab.result.value.data?['filteredData'] as List<PoeNinjaItem>?;
    if (serverData == null) return;

    final Map<String, PoeNinjaItem> serverMap = {
      for (var item in serverData) item.name: item,
    };

    final updatedLocation = <int, PoeNinjaItem>{};
    for (final entry in scarabLocation.entries) {
      final serverItem = serverMap[entry.value.name];
      if (serverItem != null) {
        updatedLocation[entry.key] = serverItem;
      } else {
        updatedLocation[entry.key] = entry.value;
      }
    }

    setState(() {
      scarabLocation = updatedLocation;
    });
  }

  String scarabI18nString(String scarabLabel, bool isKr) {
    final scarabData = I18N.SCARAB[scarabLabel];
    if (scarabData == null) return scarabLabel;
    return isKr
        ? (scarabData['label'] ?? scarabLabel)
        : (scarabData['value'] ?? scarabLabel);
  }

  String scarabClass(String scarabLabel, bool isKr) {
    final scarabData = I18N.SCARAB[scarabLabel];
    if (scarabData == null) return isKr ? '기본' : 'Base';
    return isKr
        ? (scarabData['class'] ?? '기본')
        : (scarabData['classEn'] ?? 'Base');
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
    if (chaosValue >= 10) return COLOR.TIER_2_BG;
    if (chaosValue >= 4) return COLOR.TIER_3_BG;
    if (chaosValue >= 1) return COLOR.TIER_4_BG;
    return COLOR.TIER_5_BG;
  }

  Color getTextColor(double chaosValue) {
    if (chaosValue >= 40) return COLOR.TIER_1_TEXT;
    if (chaosValue >= 10) return COLOR.TIER_2_TEXT;
    if (chaosValue >= 4) return COLOR.TIER_3_TEXT;
    if (chaosValue >= 1) return COLOR.TIER_4_TEXT;
    return COLOR.TIER_5_TEXT;
  }
}
