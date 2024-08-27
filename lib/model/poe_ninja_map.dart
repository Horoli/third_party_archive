part of third_party_archive;

class PoeNinjaMap extends PoeNinja {
  final double chaosValue;
  final int mapTier;
  PoeNinjaMap({
    required this.chaosValue,
    required this.mapTier,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaMap.fromMap({required Map item}) {
    return PoeNinjaMap(
      chaosValue: item['chaosValue'],
      mapTier: item['mapTier'],
      id: item['id'],
      name: item['name'],
      icon: item['icon'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'chaosValue': chaosValue,
        'mapTier': mapTier,
        'id': id,
        'name': name,
        'icon': icon,
      };
}
