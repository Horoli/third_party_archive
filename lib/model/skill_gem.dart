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

class SkillGemInfo extends CommonModel {
  String name;
  String lcText;
  Map statsObject;

  String requirementsText;
  String gemText;
  List<String> explicitMods;
  String qualityHeaderText;
  String qualityModText;
  String defaultText;
  String imageUrl;
  String base64Image;

  SkillGemInfo({
    required this.name,
    required this.lcText,
    required this.statsObject,
    required this.requirementsText,
    required this.gemText,
    required this.explicitMods,
    required this.qualityHeaderText,
    required this.qualityModText,
    required this.defaultText,
    required this.imageUrl,
    required this.base64Image,
  });

  factory SkillGemInfo.fromMap({required Map item}) {
    return SkillGemInfo(
      name: item['name'],
      lcText: item['lcText'],
      statsObject: Map.from(item['statsObject'] ?? ""),
      requirementsText: item['requirementsText'],
      gemText: item['textGemText'],
      explicitMods: List.from(item['explicitMods'] ?? []),
      qualityHeaderText: item['qualityHeaderText'],
      qualityModText: item['qualityModText'],
      defaultText: item['defaultText'],
      imageUrl: item['imageUrl'],
      base64Image: item['base64Image'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'name': name,
        'lcText': lcText,
        'statsObject': statsObject,
        'requirementsText': requirementsText,
        'textGemText': gemText,
        'explicitMods': explicitMods,
        'qualityHeaderText': qualityHeaderText,
        'qualityModText': qualityModText,
        'defaultText': defaultText,
        'imageUrl': imageUrl,
        'base64Image': base64Image,
      };
}
