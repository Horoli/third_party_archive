part of third_party_archive;

class PoeNinjaItem extends PoeNinja {
  final double chaosValue;
  PoeNinjaItem({
    required this.chaosValue,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaItem.fromMap({required Map item}) {
    return PoeNinjaItem(
      chaosValue: item['chaosValue'],
      id: item['id'],
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
