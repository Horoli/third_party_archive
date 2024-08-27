part of third_party_archive;

abstract class PoeNinja extends CommonModel {
  final int id;
  final String name;
  final String icon;
  PoeNinja({
    required this.id,
    required this.name,
    required this.icon,
  });
}
