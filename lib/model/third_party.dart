part of third_party_archive;

class ThirdParty {
  int type;
  String label;
  Map<String, String> description;
  Map<String, dynamic> images;
  Map<String, String> url;
  List<String> tags;
  Map<String, dynamic> userAction;
  ThirdParty({
    required this.type,
    required this.label,
    required this.description,
    required this.images,
    required this.url,
    required this.tags,
    required this.userAction,
  });

  factory ThirdParty.fromMap({required Map item}) {
    return ThirdParty(
      type: item['type'],
      label: item['label'],
      description: Map<String, String>.from(item['description']),
      images: Map<String, dynamic>.from(item['images']),
      url: Map<String, String>.from(item['url']),
      tags: List<String>.from(item['tags']),
      userAction: Map.from(item['userAction']),
    );
  }
}
