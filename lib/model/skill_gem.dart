part of third_party_archive;

class SkillGem {
  String name;
  List<String> gemTags;
  String primaryAttribute;
  SkillGem({
    required this.name,
    required this.gemTags,
    required this.primaryAttribute,
  });

  factory SkillGem.fromMap({required Map item}) {
    return SkillGem(
      name: item['name'],
      gemTags: List.from(item['gem tags']),
      primaryAttribute: item['primary attribute'] ?? 'WHITE',
    );
  }
}
