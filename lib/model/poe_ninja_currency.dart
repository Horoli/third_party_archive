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
    return PoeNinjaCurrency(
      chaosEquivalent: item['chaosEquivalent'],
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
