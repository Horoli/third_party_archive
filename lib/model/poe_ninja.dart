part of third_party_archive;

class PoeNinjaSet {
  final String date;
  final int standardChaosValue;
  final double divineOrb;
  final List<PoeNinjaCurrency> currency;
  final List<PoeNinjaFragment> fragment;
  final List<PoeNinjaItem> scarab;
  final List<PoeNinjaItem> invitation;
  final List<PoeNinjaMap> map;
  PoeNinjaSet({
    required this.date,
    required this.standardChaosValue,
    required this.divineOrb,
    required this.currency,
    required this.fragment,
    required this.scarab,
    required this.invitation,
    required this.map,
  });

  factory PoeNinjaSet.fromMap({required Map data}) {
    // print(List.from(data['currency'])
    //     .map((item) => PoeNinjaCurrency.fromMap(item: item))
    //     .toList());
    // print(List.from(data['fragment'])
    //     .map((item) => PoeNinjaFragment.fromMap(item: item))
    //     .toList());
    // print(List.from(data['invitaion'])
    //     .map((item) => PoeNinjaItem.fromMap(item: item))
    //     .toList());
    // print(List.from(data['scarab'])
    //     .map((item) => PoeNinjaItem.fromMap(item: item))
    //     .toList());
    // print(List.from(data['map'])
    //     .map((item) => PoeNinjaMap.fromMap(item: item))
    //     .toList());
    return PoeNinjaSet(
      date: data['date'],
      standardChaosValue: data['standardChaosValue'],
      divineOrb: data['divineOrb'],
      currency: List.from(data['currency'])
          .map((item) => PoeNinjaCurrency.fromMap(item: item))
          .toList(),
      fragment: List.from(data['fragment'])
          .map((item) => PoeNinjaFragment.fromMap(item: item))
          .toList(),
      invitation: List.from(data['invitation'])
          .map((item) => PoeNinjaItem.fromMap(item: item))
          .toList(),
      scarab: List.from(data['scarab'])
          .map((item) => PoeNinjaItem.fromMap(item: item))
          .toList(),
      map: List.from(data['map'])
          .map((item) => PoeNinjaMap.fromMap(item: item))
          .toList(),
    );
  }
}
