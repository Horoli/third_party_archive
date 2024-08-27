part of third_party_archive;

class TilePoeItem<T> extends StatelessWidget {
  List<T> items;
  TilePoeItem({
    required this.items,
    super.key,
  });

  String imageUrl = URL.IS_LOCAL
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  // TODO : 추가적인 타입 빌더 함수를 여기에 등록합니다.
  late final Map<Type, Widget Function(dynamic)> itemBuilders = {
    PoeNinjaCurrency: (item) => buildCurrencyTile(item),
    PoeNinjaItem: (item) => buildScarabTile(item),
    PoeNinjaFragment: (item) => buildFragmentTile(item),
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

  double divineChaosCal(double chaosValue) {
    double chaosDivine = chaosValue / GDivineOrb;
    double fractionalPart = chaosDivine % 1;
    double changePercentage = (fractionalPart * 10).roundToDouble();
    double finalChange = (GDivineOrb / 10) * changePercentage;
    return finalChange;
  }

  Widget buildCurrencyTile(PoeNinjaCurrency item) {
    if (item.name == "Divine Orb") {
      return Container();
    }
    double divineChaos = divineChaosCal(item.chaosEquivalent);
    int divine = (item.chaosEquivalent / GDivineOrb).floor();
    bool check = item.chaosEquivalent > GDivineOrb;
    return ListTile(
      leading: Image.network('$imageUrl/${item.icon}'),
      title: Text(item.name),
      subtitle: Row(
        children: [
          if (divine != 0)
            Image.asset(
              IMAGE.DIVINE_ORB,
              scale: 3,
            ),
          if (divine != 0) Text('$divine'),
          if (divine != 0) const VerticalDivider(),
          Image.asset(
            IMAGE.CHAOS_ORB,
            scale: 3,
          ),
          Text('${check ? divineChaos.round() : item.chaosEquivalent}'),
          const VerticalDivider(),
          Text('(only C : ${item.chaosEquivalent.floor()})'),
        ],
      ),
    );
  }

  Widget buildFragmentTile(PoeNinjaFragment item) {
    return Row(
      children: [
        Image.network('$imageUrl/${item.icon}'),
        Text(item.name),
        Text('${item.chaosEquivalent}'),
      ],
    );
  }

  Widget buildScarabTile(PoeNinjaItem item) {
    return Row(
      children: [
        Image.network('$imageUrl/${item.icon}'),
        Text(item.name),
        Text('${item.chaosValue}'),
      ],
    );
  }

  Widget buildInvitationTile() {
    return Container();
  }

  Widget buildMapTile() {
    return Container();
  }
}
