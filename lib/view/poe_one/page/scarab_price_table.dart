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
                            chaosValue: 0.1, // Tier 5 색상 유도를 위한 값
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
              String addText = '';
              PoeNinjaItem item = items[i];
              final dynamic scarabI18n = I18N.SCARAB[item.name];

              if (isKr) {
                if (scarabI18n != null && scarabI18n is Map && scarabI18n['regexKr'] != null) {
                  addText = scarabI18n['regexKr'].toString();
                } else {
                  String localizedName = scarabI18nString(item.name, isKr);
                  List<String> scarabSplit = localizedName.split(' ');
                  if (scarabSplit.length >= 2 && scarabSplit[0].isNotEmpty && scarabSplit[1].isNotEmpty) {
                    String part1 = scarabSplit[0].length >= 2 ? scarabSplit[0].substring(scarabSplit[0].length - 2) : scarabSplit[0];
                    String part2 = scarabSplit[1].substring(0, 1);
                    addText = '$part1.$part2';
                  } else {
                    addText = localizedName;
                  }
                }
              } else {
                if (scarabI18n != null && scarabI18n is Map && scarabI18n['regexEn'] != null) {
                  addText = scarabI18n['regexEn'].toString();
                } else {
                  String name = item.name.toLowerCase();
                  List<String> words = name.split(' ');
                  if (words.contains('of') && words.first.isNotEmpty && words.last.isNotEmpty) {
                    addText = '${words[0][0]}.of.${words.last.substring(0, math.min(3, words.last.length))}';
                  } else if (words.isNotEmpty && words[0].isNotEmpty) {
                    addText = words[0].substring(0, math.min(3, words[0].length));
                  } else {
                    addText = name;
                  }
                }
              }
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

    return Tooltip(
      message: "${scarabI18nString(item.name, isKr)}\n${isKr ? MSG.CLICK_TO_GO_TRADE : MSG.CLICK_TO_GO_TRADE_EN}",
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withAlpha(50))),
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
              opacity: getChaosValue >= 4 ? 1 : 0.6,
              child: Image.network('$imageUrl/${item.icon}', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error, size: 10)),
            ),
            Positioned(
              right: 2,
              bottom: 1,
              child: Text(
                formatPrice(getChaosValue),
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
            TextButton(
              child: Container(),
              onPressed: () async {
                String domain = isKr ? 'poe.game.daum.net' : 'www.pathofexile.com';
                await launchUrl(Uri.parse('https://$domain/trade/search/$currentLeague?q={"query":{"status":{"option":"available"},"type":"${scarabI18nString(item.name, isKr)}","stats":[{"type":"and","filters":[]}]},"sort":{"price":"asc"}}'));
              },
            )
          ],
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
