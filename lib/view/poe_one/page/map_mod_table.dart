part of third_party_archive;

class PageMapModTable extends StatefulWidget {
  const PageMapModTable({super.key});

  @override
  PageMapModTableState createState() => PageMapModTableState();
}

class PageMapModTableState extends State<PageMapModTable> {
  final GetDashboard getCtrlDashboard = Get.find<GetDashboard>();

  List<Map<String, dynamic>> allMods = [];
  List<Map<String, dynamic>> normalMods = [];
  List<Map<String, dynamic>> nightmareMods = [];

  Set<int> selectedModIndices = {};

  bool isLoaded = false;
  bool alreadyShowSnackBar = false;

  bool isNormalExpanded = true;
  bool isNightmareExpanded = true;

  bool require8Mods = true;
  bool requireMirage = true;
  bool requirePrimordial = false;
  bool requireTier16 = true;
  bool requireNightmare = false;

  final TextEditingController iiqController = TextEditingController(text: '110');
  final TextEditingController iirController = TextEditingController();
  final TextEditingController packSizeController = TextEditingController();

  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  final TextEditingController regexInputController = TextEditingController();

  final GlobalKey<WidgetMapModBookmarkState> bookmarkKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadMappingData();
  }

  Future<void> loadMappingData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/mapping_completed.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    allMods = jsonList.cast<Map<String, dynamic>>();
    normalMods =
        allMods.where((mod) => mod['kind'] == 'normal').toList();
    nightmareMods =
        allMods.where((mod) => mod['kind'] == 'nightmare').toList();

    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Obx(() {
      final isKr = getCtrlDashboard.isKorean.value;
      return Column(
        children: [
          // 상단: 체크박스/입력 + 선택정보/버튼 + regex 미리보기
          buildControlBar(isKr),
          const Divider(height: 1, color: Colors.white24),
          // 하단: 좌측 패널(즐겨찾기+히스토리) | 우측(검색+리스트)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 좌측 패널
              SizedBox(
                width: 250,
                child: WidgetMapModBookmark(
                  key: bookmarkKey,
                  normalMods: normalMods,
                  nightmareMods: nightmareMods,
                  buildSaveData: selectedModIndices.isNotEmpty
                      ? () => buildFavoriteData()
                      : null,
                  onFavoriteTap: (json) {
                    loadFavorite(json);
                  },
                  onHistoryTap: (json) => loadFavorite(json),
                ),
              ),
              const VerticalDivider(width: 1, color: Colors.white24),
              // 우측: 검색 + 옵션 리스트
              Expanded(
                child: Column(
                  children: [
                    buildSearchBar(isKr),
                    buildModList(isKr).expand(),
                  ],
                ),
              ),
            ],
          ).expand(),
        ],
      );
    });
  }

  Widget buildControlBar(bool isKr) {
    final selectedMods = getSelectedMods();
    final regex = buildCombinedRegex(selectedMods, isKr);
    final charCount = regex.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 지도 옵션
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(isKr ? '지도 옵션' : 'Map Options'),
                  const SizedBox(height: 4),
                  buildQueryNumberInput(
                    hint: isKr ? '아이템 수량' : 'IIQ',
                    controller: iiqController,
                  ),
                  const SizedBox(height: 4),
                  buildQueryNumberInput(
                    hint: isKr ? '아이템 희귀도' : 'IIR',
                    controller: iirController,
                  ),
                  const SizedBox(height: 4),
                  buildQueryNumberInput(
                    hint: isKr ? '무리 규모' : 'Pack Size',
                    controller: packSizeController,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // 지도 구분
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(isKr ? '지도 구분' : 'Map Type'),
                  const SizedBox(height: 4),
                  buildToggleButtons(
                    labels: ['16T', isKr ? '악몽' : 'Nightmare'],
                    selectedIndex: requireNightmare ? 1 : (requireTier16 ? 0 : -1),
                    onSelected: (index) {
                      setState(() {
                        if (index == 0) {
                          requireTier16 = true;
                          requireNightmare = false;
                        } else {
                          requireTier16 = true;
                          requireNightmare = true;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // 속성부여
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(isKr ? '속성부여' : 'Modifiers'),
                  const SizedBox(height: 4),
                  buildQueryCheckbox(
                    label: isKr ? '8모드' : '8 Mods',
                    value: require8Mods,
                    onChanged: (v) =>
                        setState(() => require8Mods = v ?? true),
                  ),
                  const SizedBox(height: 4),
                  buildQueryCheckbox(
                    label: isKr ? '허상' : 'Mirage',
                    value: requireMirage,
                    onChanged: (v) =>
                        setState(() => requireMirage = v ?? true),
                  ),
                  const SizedBox(height: 4),
                  buildQueryCheckbox(
                    label: isKr ? '태초자' : 'Primordial',
                    value: requirePrimordial,
                    onChanged: (v) =>
                        setState(() => requirePrimordial = v ?? false),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // TODO: Regex 입력 기능 테스트 후 주석 해제
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       _sectionLabel('Regex'),
              //       const SizedBox(height: 4),
              //       SizedBox(
              //         height: 38,
              //         child: TextField(
              //           controller: regexInputController,
              //           style: _inputTextStyle,
              //           decoration: _inputDecoration(
              //             hintText: isKr
              //                 ? 'Regex 입력 후 Enter'
              //                 : 'Enter regex, press Enter',
              //             suffixIcon: IconButton(
              //               icon: const Icon(Icons.search,
              //                   color: Colors.white54, size: 18),
              //               onPressed: () => applyRegexInput(isKr),
              //             ),
              //           ),
              //           onSubmitted: (_) => applyRegexInput(isKr),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          // 2행: 선택 정보 + 액션 버튼
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                isKr
                    ? '선택: ${selectedModIndices.length}개'
                    : 'Selected: ${selectedModIndices.length}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Text(
                '$charCount / 255',
                style: TextStyle(
                  color:
                      charCount > 255 ? Colors.redAccent : Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Opacity(
                opacity: selectedModIndices.isEmpty ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: selectedModIndices.isEmpty,
                  child: SizedBox(
                    width: 100,
                    child: buildCopyRegexButton(isKr, selectedMods),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Opacity(
                opacity: selectedModIndices.isEmpty ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: selectedModIndices.isEmpty,
                  child: SizedBox(
                    width: 120,
                    child: buildTradeButton(isKr, selectedMods),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.white70, size: 20),
                tooltip: isKr ? '선택 초기화' : 'Clear Selection',
                onPressed: () => resetAll(),
              ),
            ],
          ),
          // 선택된 Regex 미리보기
          const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: charCount > 255
                      ? Colors.redAccent.withAlpha(150)
                      : Colors.white.withAlpha(30),
                ),
              ),
              child: SelectableText(
                '"!$regex"',
                style: TextStyle(
                  color: charCount > 255 ? Colors.redAccent : Colors.amber,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }

  void resetAll() {
    setState(() {
      selectedModIndices.clear();
      require8Mods = true;
      requireMirage = true;
      requirePrimordial = false;
      requireTier16 = true;
      requireNightmare = false;
      iiqController.text = '110';
      iirController.clear();
      packSizeController.clear();
    });
  }

  Map<String, dynamic> buildFavoriteData() {
    final isKr = getCtrlDashboard.isKorean.value;
    final selectedMods = getSelectedMods();
    final regex = buildCombinedRegex(selectedMods, isKr);

    // explicitCodes 추출 (거래소 쿼리용, mod 데이터 없이도 사용 가능)
    List<String> explicitCodes = [];
    for (var mod in selectedMods) {
      final code = mod['explicitCode']?.toString() ?? '';
      if (code.isNotEmpty) explicitCodes.add(code);
    }

    return {
      'selectedIndices': selectedModIndices.toList(),
      'require8Mods': require8Mods,
      'requireMirage': requireMirage,
      'requirePrimordial': requirePrimordial,
      'requireTier16': requireTier16,
      'requireNightmare': requireNightmare,
      'iiq': iiqController.text.trim(),
      'iir': iirController.text.trim(),
      'packSize': packSizeController.text.trim(),
      'regex': regex,
      'explicitCodes': explicitCodes,
    };
  }

  void loadFavorite(String json) {
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      if (data['selectedIndices'] == null) return;
      setState(() {
        selectedModIndices =
            Set<int>.from((data['selectedIndices'] as List).cast<int>());
        require8Mods = data['require8Mods'] ?? true;
        requireMirage = data['requireMirage'] ?? true;
        requirePrimordial = data['requirePrimordial'] ?? false;
        requireTier16 = data['requireTier16'] ?? true;
        requireNightmare = data['requireNightmare'] ?? false;
        iiqController.text = data['iiq'] ?? '110';
        iirController.text = data['iir'] ?? '';
        packSizeController.text = data['packSize'] ?? '';
      });
    } catch (_) {}
  }

  /// 입력된 regex를 파싱하여 매칭되는 옵션을 자동 선택
  void applyRegexInput(bool isKr) {
    String pastedText = regexInputController.text.trim();
    if (pastedText.isEmpty) return;

    // "!regex" 또는 "regex" 형태에서 본문만 추출
    if (pastedText.startsWith('"') && pastedText.endsWith('"')) {
      pastedText = pastedText.substring(1, pastedText.length - 1);
    }
    if (pastedText.startsWith('!')) {
      pastedText = pastedText.substring(1);
    }

    // 괄호 깊이를 고려하여 최상위 | 기준으로 분리
    final List<String> regexTokens = splitTopLevelPipe(pastedText);
    if (regexTokens.isEmpty) return;

    final Set<String> tokenSet = Set.from(regexTokens);
    final Set<int> newSelected = {};

    // normal mods 매칭
    for (int i = 0; i < normalMods.length; i++) {
      final String modRegex = isKr
          ? (normalMods[i]['regexKr'] ?? '').toString()
          : (normalMods[i]['regexEn'] ?? '').toString();
      if (modRegex.isNotEmpty && tokenSet.contains(modRegex)) {
        newSelected.add(i);
      }
    }

    // nightmare mods 매칭
    for (int i = 0; i < nightmareMods.length; i++) {
      final String modRegex = isKr
          ? (nightmareMods[i]['regexKr'] ?? '').toString()
          : (nightmareMods[i]['regexEn'] ?? '').toString();
      if (modRegex.isNotEmpty && tokenSet.contains(modRegex)) {
        newSelected.add(normalMods.length + i);
      }
    }

    setState(() => selectedModIndices = newSelected);

    final matchCount = newSelected.length;
    showCenterSnackBar(isKr
        ? '$matchCount개 옵션 매칭됨 (${regexTokens.length}개 토큰 중)'
        : '$matchCount mods matched (from ${regexTokens.length} tokens)');
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold));
  }

  Widget buildToggleButtons({
    required List<String> labels,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(labels.length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < labels.length - 1 ? 4 : 0),
          child: WidgetToggleButton(
            label: labels[i],
            isSelected: i == selectedIndex,
            onTap: () => onSelected(i),
          ),
        );
      }),
    );
  }

  Widget buildQueryCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.amber,
            side: const BorderSide(color: Colors.white38),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  InputDecoration _inputDecoration(
      {String? hintText, String? labelText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 11),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      filled: true,
      fillColor: Colors.black45,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.white.withAlpha(30)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.white.withAlpha(30)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.amber),
      ),
      suffixIcon: suffixIcon,
    );
  }

  static const TextStyle _inputTextStyle = TextStyle(
      color: Colors.white, fontSize: 12, fontFamily: 'monospace');

  Widget buildQueryNumberInput({
    required String hint,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 110,
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: _inputTextStyle,
        decoration: _inputDecoration(labelText: hint),
      ),
    );
  }

  /// 괄호 내부의 |는 무시하고 최상위 | 기준으로만 분리
  List<String> splitTopLevelPipe(String input) {
    List<String> result = [];
    int depth = 0;
    StringBuffer current = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      final ch = input[i];
      if (ch == '(' || ch == '[') {
        depth++;
        current.write(ch);
      } else if (ch == ')' || ch == ']') {
        depth--;
        current.write(ch);
      } else if (ch == '|' && depth == 0) {
        if (current.isNotEmpty) result.add(current.toString());
        current.clear();
      } else {
        current.write(ch);
      }
    }
    if (current.isNotEmpty) result.add(current.toString());
    return result;
  }

  Widget buildCopyRegexButton(
      bool isKr, List<Map<String, dynamic>> selectedMods) {
    return Material(
      color: COLOR.TIER_4_BG,
      borderRadius: BorderRadius.circular(4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          if (selectedMods.isEmpty) return;

          final regex = buildCombinedRegex(selectedMods, isKr);
          if (regex.length > 255) {
            showCenterSnackBar(isKr
                ? '255자 초과! 선택을 줄여주세요 (${regex.length}자)'
                : 'Over 255 chars! Reduce selection (${regex.length})');
            return;
          }

          await Clipboard.setData(ClipboardData(text: '"!$regex"'));
          bookmarkKey.currentState?.saveHistory(buildFavoriteData());
          showCenterSnackBar(
              '${isKr ? MSG.COPY_TO_CLIPBOARD : MSG.COPY_TO_CLIPBOARD_EN} : "!$regex"');
        },
        child: Tooltip(
          message: isKr ? MSG.CLICK_TO_COPY_REG : MSG.CLICK_TO_COPY_REG_EN,
          child: Container(
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withAlpha(50), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isKr ? 'Regex 복사' : 'Copy Regex',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTradeButton(
      bool isKr, List<Map<String, dynamic>> selectedMods) {
    return Material(
      color: const Color(0xFF8B4513),
      borderRadius: BorderRadius.circular(4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          if (selectedMods.isEmpty) return;

          // "not" 필터에 넣을 stat ID 목록
          List<Map<String, dynamic>> notFilters = selectedMods
              .where((mod) =>
                  mod['explicitCode'] != null &&
                  mod['explicitCode'].toString().isNotEmpty)
              .map((mod) => {"id": mod['explicitCode']})
              .toList();

          if (notFilters.isEmpty) return;

          // 거래소 쿼리 생성
          Map<String, dynamic> query = {
            "query": {
              "status": {"option": "securable"},
              if (requireNightmare)
                "type": isKr ? "악몽 지도" : "Nightmare Map"
              else if (requireTier16)
                "type": {
                  "option": isKr ? "지도" : "Map",
                  "discriminator": "map"
                },
              "filters": {
                "map_filters": {
                  "disabled": false,
                  "filters": {
                    if (requireTier16)
                      "map_tier": {"min": 16, "max": 16},
                    if (iiqController.text.trim().isNotEmpty)
                      "map_iiq": {
                        "min": int.tryParse(iiqController.text.trim()),
                        "max": null
                      },
                    if (iirController.text.trim().isNotEmpty)
                      "map_iir": {
                        "min": int.tryParse(iirController.text.trim())
                      },
                    if (packSizeController.text.trim().isNotEmpty)
                      "map_packsize": {
                        "min": int.tryParse(packSizeController.text.trim())
                      },
                  }
                },
                "type_filters": {
                  "filters": {
                    "rarity": {"option": "nonunique"}
                  }
                }
              },
              "stats": [
                {
                  "type": "and",
                  "filters": [
                    if (requireMirage)
                      {"id": "enchant.stat_2436559047"},
                    if (require8Mods)
                      {
                        "id": "pseudo.pseudo_number_of_affix_mods",
                        "value": {"min": 8},
                        "disabled": false
                      },
                    if (requirePrimordial)
                      {"id": "implicit.stat_2696470877"},
                  ],
                  "disabled": false
                },
                {
                  "type": "not",
                  "filters": notFilters,
                }
              ]
            },
            "sort": {"price": "asc"}
          };

          String domain =
              isKr ? 'poe.game.daum.net' : 'www.pathofexile.com';
          String jsonQuery = jsonEncode(query);
          String tradeUrl =
              'https://$domain/trade/search/$currentLeague?q=$jsonQuery';

          // 로컬 스토리지에 캐시 저장 (최대 10개, 라운드로빈)
          bookmarkKey.currentState?.saveHistory(buildFavoriteData());
          setState(() {});

          await launchUrl(Uri.parse(tradeUrl));
        },
        child: Tooltip(
          message: isKr ? MSG.CLICK_TO_GO_TRADE : MSG.CLICK_TO_GO_TRADE_EN,
          child: Container(
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withAlpha(50), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.open_in_new, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  isKr ? '거래소 이동' : 'Trade',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar(bool isKr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.black12,
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: isKr ? '옵션 검색...' : 'Search mods...',
          hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
          prefixIcon:
              const Icon(Icons.search, color: Colors.white38, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchQuery = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          filled: true,
          fillColor: Colors.black26,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => setState(() => searchQuery = value.trim()),
      ),
    );
  }

  /// 검색어에 맞는 mod만 필터링 (globalIndex 유지)
  List<MapEntry<int, Map<String, dynamic>>> filterMods(
      List<Map<String, dynamic>> mods, int indexOffset, bool isKr) {
    if (searchQuery.isEmpty) {
      return List.generate(
          mods.length, (i) => MapEntry(indexOffset + i, mods[i]));
    }
    final query = searchQuery.toLowerCase();
    List<MapEntry<int, Map<String, dynamic>>> result = [];
    for (int i = 0; i < mods.length; i++) {
      final kr = (mods[i]['contentKr'] ?? '').toString().toLowerCase();
      final en = (mods[i]['contentEn'] ?? '').toString().toLowerCase();
      if (kr.contains(query) || en.contains(query)) {
        result.add(MapEntry(indexOffset + i, mods[i]));
      }
    }
    return result;
  }

  Widget buildModList(bool isKr) {
    final filteredNormal = filterMods(normalMods, 0, isKr);
    final filteredNightmare =
        filterMods(nightmareMods, normalMods.length, isKr);

    return ListView(
      children: [
        // Normal 섹션
        buildSectionHeader(
          title: isKr ? '일반 옵션' : 'Normal Mods',
          count: filteredNormal.length,
          selectedCount: countSelectedInRange(0, normalMods.length),
          isExpanded: isNormalExpanded,
          onToggle: () => setState(() => isNormalExpanded = !isNormalExpanded),
          isKr: isKr,
        ),
        if (isNormalExpanded)
          ...buildFilteredModRows(filteredNormal, isKr),
        // Nightmare 섹션
        buildSectionHeader(
          title: isKr ? '악몽 옵션' : 'Nightmare Mods',
          count: filteredNightmare.length,
          selectedCount: countSelectedInRange(
              normalMods.length, normalMods.length + nightmareMods.length),
          isExpanded: isNightmareExpanded,
          onToggle: () =>
              setState(() => isNightmareExpanded = !isNightmareExpanded),
          isKr: isKr,
        ),
        if (isNightmareExpanded)
          ...buildFilteredModRows(filteredNightmare, isKr),
      ],
    );
  }

  List<Widget> buildFilteredModRows(
      List<MapEntry<int, Map<String, dynamic>>> entries, bool isKr) {
    List<Widget> rows = [];
    for (int i = 0; i < entries.length; i += 2) {
      rows.add(Row(
        children: [
          Expanded(
              child: buildModTile(
                  entries[i].value, entries[i].key, isKr)),
          if (i + 1 < entries.length)
            Expanded(
                child: buildModTile(
                    entries[i + 1].value, entries[i + 1].key, isKr))
          else
            const Expanded(child: SizedBox()),
        ],
      ));
    }
    return rows;
  }

  /// 2개씩 Row로 묶어서 반환
  List<Widget> buildModRows(
      List<Map<String, dynamic>> mods, int indexOffset, bool isKr) {
    List<Widget> rows = [];
    for (int i = 0; i < mods.length; i += 2) {
      rows.add(Row(
        children: [
          Expanded(
              child: buildModTile(mods[i], indexOffset + i, isKr)),
          if (i + 1 < mods.length)
            Expanded(
                child: buildModTile(mods[i + 1], indexOffset + i + 1, isKr))
          else
            const Expanded(child: SizedBox()),
        ],
      ));
    }
    return rows;
  }

  int countSelectedInRange(int start, int end) {
    return selectedModIndices.where((i) => i >= start && i < end).length;
  }

  Widget buildSectionHeader({
    required String title,
    required int count,
    required int selectedCount,
    required bool isExpanded,
    required VoidCallback onToggle,
    required bool isKr,
  }) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.black45,
        child: Row(
          children: [
            Icon(
              isExpanded ? Icons.expand_more : Icons.chevron_right,
              color: Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '$title($count)',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            if (selectedCount > 0) ...[
              const SizedBox(width: 12),
              Text(
                isKr ? '$selectedCount개 선택' : '$selectedCount selected',
                style: const TextStyle(color: Colors.amber, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildModTile(
      Map<String, dynamic> mod, int globalIndex, bool isKr) {
    final bool isSelected = selectedModIndices.contains(globalIndex);
    final String content =
        isKr ? (mod['contentKr'] ?? '') : (mod['contentEn'] ?? '');
    final String regex =
        isKr ? (mod['regexKr'] ?? '') : (mod['regexEn'] ?? '');
    final bool isNightmare = mod['kind'] == 'nightmare';

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedModIndices.remove(globalIndex);
          } else {
            selectedModIndices.add(globalIndex);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withAlpha(25)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.white.withAlpha(20)),
            left: isSelected
                ? const BorderSide(color: Colors.amber, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // 체크 표시
            Icon(
              isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: isSelected ? Colors.amber : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 8),
            // Nightmare 뱃지
            if (isNightmare)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withAlpha(150),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  '악몽',
                  style: TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ),
            // 옵션 내용
            Expanded(
              child: Text(
                content,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            // Regex 미리보기
            if (regex.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  regex,
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getSelectedMods() {
    List<Map<String, dynamic>> selected = [];
    for (int index in selectedModIndices) {
      if (index < normalMods.length) {
        selected.add(normalMods[index]);
      } else {
        selected.add(nightmareMods[index - normalMods.length]);
      }
    }
    return selected;
  }

  String buildCombinedRegex(
      List<Map<String, dynamic>> mods, bool isKr) {
    List<String> regexParts = [];
    for (var mod in mods) {
      String regex = isKr
          ? (mod['regexKr'] ?? '').toString()
          : (mod['regexEn'] ?? '').toString();
      if (regex.isNotEmpty) {
        regexParts.add(regex);
      }
    }
    return regexParts.join('|');
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
}
