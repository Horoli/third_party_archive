part of third_party_archive;

class PoeNinjaCurrency extends PoeNinja {
  final double chaosEquivalent;
  PoeNinjaCurrency({
    required this.chaosEquivalent,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaCurrency.fromMap({required Map item}) {
    print('item[chaosEquivalent] ${item['chaosEquivalent']}');
    print('item[chaosEquivalent] ${item['chaosEquivalent'].runtimeType}');
    return PoeNinjaCurrency(
      chaosEquivalent: double.parse(item['chaosEquivalent'].toString()),
      id: item['id'],
      name: item['name'],
      icon: item['icon'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'chaosEquivalent': chaosEquivalent,
        'id': id,
        'name': name,
        'icon': icon,
      };
}
