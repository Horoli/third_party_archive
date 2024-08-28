part of third_party_archive;

class PoeNinjaInvitation extends PoeNinja {
  final double chaosValue;
  PoeNinjaInvitation({
    required this.chaosValue,
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PoeNinjaInvitation.fromMap({required Map item}) {
    return PoeNinjaInvitation(
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
