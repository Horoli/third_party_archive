part of third_party_archive;

/// 지도 옵션 필터 즐겨찾기/히스토리 패널 위젯
/// 재사용 가능하도록 콜백 기반으로 동작
class WidgetMapModBookmark extends StatefulWidget {
  /// 즐겨찾기 클릭 시 콜백 (json 데이터 전달)
  final void Function(String json)? onFavoriteTap;

  /// 히스토리 클릭 시 콜백 (json 데이터 전달)
  final void Function(String json)? onHistoryTap;

  /// 현재 선택 데이터가 있을 때 저장할 데이터를 반환하는 콜백
  /// null이면 저장 버튼 숨김
  final Map<String, dynamic> Function()? buildSaveData;

  /// regex 복원용 mod 데이터 (describeFavorite에서 regex 표시용)
  final List<Map<String, dynamic>> normalMods;
  final List<Map<String, dynamic>> nightmareMods;

  /// 즐겨찾기 섹션 타이틀 (null이면 기본값 '즐겨찾기')
  final String? favoriteTitle;
  final String? favoriteTitleEn;

  /// 히스토리 표시 여부
  final bool showHistory;

  const WidgetMapModBookmark({
    super.key,
    this.onFavoriteTap,
    this.onHistoryTap,
    this.buildSaveData,
    this.normalMods = const [],
    this.nightmareMods = const [],
    this.favoriteTitle,
    this.favoriteTitleEn,
    this.showHistory = true,
  });

  @override
  WidgetMapModBookmarkState createState() => WidgetMapModBookmarkState();
}

class WidgetMapModBookmarkState extends State<WidgetMapModBookmark> {
  static const String _favoriteKey = 'map_mod_favorites';
  static const int _favoriteMax = 10;
  static const String _cacheKey = 'map_mod_query_cache';
  static const int _cacheMax = 10;

  /// 모든 인스턴스가 공유하는 변경 카운터 — Obx가 이를 관찰하여 동기화
  static final RxInt _changeNotifier = 0.obs;

  final GetDashboard _dashboard = Get.find<GetDashboard>();

  // --- Storage ---

  List<String> loadFavorites() =>
      GSharedPreference.getStringList(_favoriteKey) ?? [];

  List<String> loadHistory() =>
      GSharedPreference.getStringList(_cacheKey) ?? [];

  bool isFavoriteFull() =>
      (GSharedPreference.getStringList(_favoriteKey) ?? []).length >=
      _favoriteMax;

  void saveFavorite({String? label}) {
    if (widget.buildSaveData == null) return;
    if (isFavoriteFull()) return;

    final data = widget.buildSaveData!();
    data['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    data['label'] = label ?? '';
    data['timestamp'] = DateTime.now().toIso8601String();

    final List<String> favorites =
        GSharedPreference.getStringList(_favoriteKey) ?? [];
    final jsonData = jsonEncode(data);
    favorites.add(jsonData);
    GSharedPreference.setStringList(_favoriteKey, favorites);

    // 즐겨찾기 저장 시 히스토리에도 기록
    saveHistory(data);
    _changeNotifier.value++;
  }

  void saveHistory(Map<String, dynamic> data) {
    final List<String> cache = GSharedPreference.getStringList(_cacheKey) ?? [];
    cache.add(jsonEncode(data));
    if (cache.length > _cacheMax) cache.removeAt(0);
    GSharedPreference.setStringList(_cacheKey, cache);
    _changeNotifier.value++;
  }

  void deleteFavorite(int index) {
    final List<String> favorites =
        GSharedPreference.getStringList(_favoriteKey) ?? [];
    if (index < favorites.length) {
      favorites.removeAt(index);
      GSharedPreference.setStringList(_favoriteKey, favorites);
      _changeNotifier.value++;
    }
  }

  void renameFavorite(int index, String newLabel) {
    final List<String> favorites =
        GSharedPreference.getStringList(_favoriteKey) ?? [];
    if (index >= favorites.length) return;
    final Map<String, dynamic> data = jsonDecode(favorites[index]);
    data['label'] = newLabel;
    favorites[index] = jsonEncode(data);
    GSharedPreference.setStringList(_favoriteKey, favorites);
    _changeNotifier.value++;
  }

  void showRenameDialog(int index, bool isKr) {
    final favorites = loadFavorites();
    if (index >= favorites.length) return;
    final data = jsonDecode(favorites[index]);
    final controller = TextEditingController(text: data['label'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(isKr ? '즐겨찾기 이름 변경' : 'Rename Favorite',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: isKr ? '이름 입력...' : 'Enter name...',
            hintStyle: const TextStyle(color: Colors.white30),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber)),
          ),
          onSubmitted: (value) {
            renameFavorite(index, value.trim());
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isKr ? '취소' : 'Cancel',
                style: const TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              renameFavorite(index, controller.text.trim());
              Navigator.pop(ctx);
            },
            child: Text(isKr ? '저장' : 'Save',
                style: const TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  // --- Describe ---

  Map<String, String> describeEntry(String json, bool isKr,
      {int? displayIndex}) {
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      if (data['selectedIndices'] == null) {
        return {
          'label': isKr ? '(이전 형식)' : '(legacy)',
          'count': '',
          'tags': '',
          'regex': '',
        };
      }
      final String label = data['label'] ?? '';
      final List indices = data['selectedIndices'] as List;
      final int count = indices.length;

      final List<String> tags = [];
      if (data['require8Mods'] == true) tags.add('8mod');
      if (data['requireMirage'] == true) tags.add(isKr ? '허상' : 'Mirage');
      if (data['requireTier16'] == true) tags.add('T16');
      if (data['requireNightmare'] == true) tags.add(isKr ? '악몽' : 'NM');
      final String iiq = data['iiq'] ?? '';
      final String iir = data['iir'] ?? '';
      final String packSize = data['packSize'] ?? '';
      if (iiq.isNotEmpty) tags.add('${isKr ? '수량' : 'IIQ'}$iiq');
      if (iir.isNotEmpty) tags.add('${isKr ? '레어' : 'IIR'}$iir');
      if (packSize.isNotEmpty) tags.add('${isKr ? '무리' : 'Pack'}$packSize');

      // regex: 저장된 값 우선, 없으면 mod 데이터에서 복원
      String savedRegex = (data['regex'] ?? '').toString();
      if (savedRegex.isEmpty && widget.normalMods.isNotEmpty) {
        List<String> regexParts = [];
        for (var idx in indices) {
          final int i = idx as int;
          final mod = i < widget.normalMods.length
              ? widget.normalMods[i]
              : (i - widget.normalMods.length < widget.nightmareMods.length
                  ? widget.nightmareMods[i - widget.normalMods.length]
                  : null);
          if (mod == null) continue;
          final r = isKr
              ? (mod['regexKr'] ?? '').toString()
              : (mod['regexEn'] ?? '').toString();
          if (r.isNotEmpty) regexParts.add(r);
        }
        if (regexParts.isNotEmpty) savedRegex = regexParts.join('|');
      }

      return {
        'label': label.isNotEmpty
            ? label
            : (displayIndex != null
                ? (isKr ? '$displayIndex번 히스토리' : 'History #$displayIndex')
                : (isKr ? '프리셋' : 'Preset')),
        'count': isKr ? '$count개 제외' : '$count excluded',
        'tags': tags.join(', '),
        'regex': savedRegex.isNotEmpty ? '"!$savedRegex"' : '',
      };
    } catch (_) {
      return {
        'label': isKr ? '(이전 형식)' : '(legacy)',
        'count': '',
        'tags': '',
        'regex': '',
      };
    }
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _changeNotifier.value; // 변경 감지용 구독
      final isKr = _dashboard.isKorean.value;
      final favorites = loadFavorites();
      final history = loadHistory();

      return Column(
        children: [
          // 즐겨찾기 헤더
          _buildSectionHeader(
            icon: Icons.star,
            iconColor: Colors.amber,
            title: isKr
                ? (widget.favoriteTitle ?? '즐겨찾기')
                : (widget.favoriteTitleEn ?? 'Favorites'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${favorites.length}/$_favoriteMax',
                    style: const TextStyle(
                        color: Colors.white30, fontSize: 11)),
                if (widget.buildSaveData != null && !isFavoriteFull()) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => saveFavorite(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(40),
                        borderRadius: BorderRadius.circular(3),
                        border:
                            Border.all(color: Colors.amber.withAlpha(80)),
                      ),
                      child: Text(isKr ? '+ 저장' : '+ Save',
                          style: const TextStyle(
                              color: Colors.amber, fontSize: 11)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 즐겨찾기 리스트
          Expanded(
            child: favorites.isEmpty
                ? Center(
                    child: Text(isKr ? '저장된 즐겨찾기 없음' : 'No favorites',
                        style: const TextStyle(
                            color: Colors.white24, fontSize: 12)),
                  )
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final info = describeEntry(favorites[index], isKr);
                      return _buildItem(
                        info: info,
                        icon: Icons.open_in_new,
                        iconColor: Colors.amber,
                        onTap: () =>
                            widget.onFavoriteTap?.call(favorites[index]),
                        onDelete: () => deleteFavorite(index),
                        onEdit: () => showRenameDialog(index, isKr),
                      );
                    },
                  ),
          ),
          if (widget.showHistory) ...[
            // 히스토리 헤더
            const Divider(height: 1, color: Colors.white24),
            _buildSectionHeader(
              icon: Icons.history,
              iconColor: Colors.white54,
              title: isKr ? '히스토리' : 'History',
              trailing: Text('${history.length}/$_cacheMax',
                  style: const TextStyle(color: Colors.white30, fontSize: 11)),
            ),
            // 히스토리 리스트
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Text(isKr ? '거래소 이동 기록 없음' : 'No history',
                          style: const TextStyle(
                              color: Colors.white24, fontSize: 12)),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final reverseIndex = history.length - 1 - index;
                        final info = describeEntry(history[reverseIndex], isKr,
                            displayIndex: index + 1);
                        return _buildItem(
                          info: info,
                          icon: Icons.restore,
                          iconColor: Colors.white38,
                          onTap: () =>
                              widget.onHistoryTap?.call(history[reverseIndex]),
                        );
                      },
                    ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: Colors.black45,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
          ),
          const SizedBox(width: 4),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildItem({
    required Map<String, String> info,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    VoidCallback? onDelete,
    VoidCallback? onEdit,
  }) {
    final label = info['label'] ?? '';
    final count = info['count'] ?? '';
    final tags = info['tags'] ?? '';
    final regex = info['regex'] ?? '';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withAlpha(15)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label.isNotEmpty)
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  if (count.isNotEmpty)
                    Text(count,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 10)),
                  if (tags.isNotEmpty)
                    Text(tags,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  if (regex.isNotEmpty)
                    Text(regex,
                        style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 9,
                            fontFamily: 'monospace'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                ],
              ),
            ),
            if (onEdit != null)
              InkWell(
                onTap: onEdit,
                child: const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.edit, color: Colors.white24, size: 13),
                ),
              ),
            if (onDelete != null)
              InkWell(
                onTap: onDelete,
                child: const Icon(Icons.close, color: Colors.white24, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}
