part of third_party_archive;

class PoeNinjaMap extends PoeNinja {
  final double chaosValue;
  PoeNinjaMap({
    required this.chaosValue,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaMap.fromMap({required Map item}) {
    return PoeNinjaMap(
      chaosValue: double.parse(item['chaosValue'].toString()),
      id: item['id'].toString(),
      name: item['name'],
      icon: item['icon'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'chaosValue': chaosValue,
        'id': id,
        'name': name,
        'icon': icon,
      };
}
