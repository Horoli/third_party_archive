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
    return ListView.builder(
      itemCount: items.length,
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
    bool check = chaosValue > GDivineOrb;
    return ListTile(
      leading: Image.network('$imageUrl/$icon'),
      title: Text(name),
      subtitle: Row(
        children: [
          if (divine != 0) GImageDivineOrb,
          if (divine != 0) Text('$divine'),
          if (divine != 0) const VerticalDivider(),
          GImageChaosOrb,
          Text('${check ? divineChaos.round() : chaosValue}'),
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
