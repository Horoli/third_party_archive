part of third_party_archive;

class PoeNinjaSet {
  final String date;
  final double divineOrb;
  final List currency;
  final List fragment;
  final List scarab;
  final List invitaion;
  final List map;
  PoeNinjaSet({
    required this.date,
    required this.divineOrb,
    required this.currency,
    required this.fragment,
    required this.scarab,
    required this.invitaion,
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
      divineOrb: data['divineOrb'],
      currency: List.from(data['currency'])
          .map((item) => PoeNinjaCurrency.fromMap(item: item))
          .toList(),
      fragment: List.from(data['fragment'])
          .map((item) => PoeNinjaFragment.fromMap(item: item))
          .toList(),
      invitaion: List.from(data['invitation'])
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
