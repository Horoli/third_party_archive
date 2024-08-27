part of third_party_archive;

class PoeNinjaFragment extends PoeNinja {
  final double chaosEquivalent;
  PoeNinjaFragment({
    required this.chaosEquivalent,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaFragment.fromMap({required Map item}) {
    return PoeNinjaFragment(
      chaosEquivalent: item['chaosEquivalent'],
      id: item['id'],
      name: item['name'],
      icon: item['icon'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'chaosValue': chaosEquivalent,
        'id': id,
        'name': name,
        'icon': icon,
      };
}
