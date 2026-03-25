part of third_party_archive;

class TilePoeItem<T> extends StatelessWidget {
  List<T> items;
  TilePoeItem({
    required this.items,
    super.key,
  });

  String imageUrl = isLocal
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  // TODO : 추가적인 타입 빌더 함수를 여기에 등록합니다.
  late final Map<Type, Widget Function(dynamic)> itemBuilders = {
    PoeNinjaCurrency: (item) => buildCurrencyTile(item),
    PoeNinjaItem: (item) => buildScarabTile(item),
    PoeNinjaFragment: (item) => buildFragmentTile(item),
    PoeNinjaMap: (item) => buildMapTile(item),
  };

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        T item = items[index];
        return itemBuilders[item.runtimeType]!(item);
      },
    );
  }

  Widget _buildTile({
    required String icon,
    required String name,
    required double chaosValue,
  }) {
    double divineChaos = divineChaosCal(chaosValue);
    int divine = (chaosValue / GDivineOrb).floor();
    bool hasDivine = chaosValue > GDivineOrb;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha(15)),
        ),
      ),
      child: Row(
        children: [
          // 아이콘
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              '$imageUrl/$icon',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.error, size: 20, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 10),
          // 아이템명
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // 가격
          if (hasDivine && divine != 0) ...[
            SizedBox(width: 20, height: 20, child: GImageDivineOrb),
            const SizedBox(width: 2),
            Text(
              '$divine',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 1,
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: Colors.white.withAlpha(30),
            ),
          ],
          SizedBox(width: 20, height: 20, child: GImageChaosOrb),
          const SizedBox(width: 2),
          Text(
            '${hasDivine ? divineChaos.round() : chaosValue.round()}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrencyTile(PoeNinjaCurrency item) {
    if (item.name == "Divine Orb") {
      return Container();
    }
    return _buildTile(
      icon: item.icon,
      name: item.name,
      chaosValue: item.chaosEquivalent,
    );
  }

  Widget buildFragmentTile(PoeNinjaFragment item) {
    return _buildTile(
      icon: item.icon,
      name: item.name,
      chaosValue: item.chaosEquivalent,
    );
  }

  Widget buildScarabTile(PoeNinjaItem item) {
    return _buildTile(
      icon: item.icon,
      name: item.name,
      chaosValue: item.chaosValue,
    );
  }

  Widget buildInvitationTile(PoeNinjaItem item) {
    return _buildTile(
      icon: item.icon,
      name: item.name,
      chaosValue: item.chaosValue,
    );
  }

  Widget buildMapTile(PoeNinjaMap item) {
    return _buildTile(
      icon: item.icon,
      name: item.name,
      chaosValue: item.chaosValue,
    );
  }

  double divineChaosCal(double chaosValue) {
    double chaosDivine = chaosValue / GDivineOrb;
    double fractionalPart = chaosDivine % 1;
    double changePercentage = (fractionalPart * 10).roundToDouble();
    double finalChange = (GDivineOrb / 10) * changePercentage;
    return finalChange;
  }
}
