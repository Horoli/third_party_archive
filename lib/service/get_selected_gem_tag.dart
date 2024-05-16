part of third_party_archive;

class GetSelectedGemTag extends GetxController {
  RxList<String> selectedGemTags = <String>[].obs;
  RxList<String> gemTagList = [
    "Attack",
    "Melee",
    "Strike",
    "Slam",
    "Spell",
    "Arcane",
    "Brand",
    "Orb",
    "Nova",
    "Physical",
    "Fire",
    "Cold",
    "Lightning",
    "Chaos",
    "Bow",
    "Projectile",
    "Chaining",
    "Mine",
    "Trap",
    "Totem",
    "Golem",
    "Minion",
    "Hex",
    "AoE",
    "Critical",
    "Duration",
    "Trigger"
  ].obs;

  List<String> updateSelectedTag(String tag) {
    selectedGemTags.add(tag);
    update();
    return selectedGemTags;
  }

  List<String> removeSelectedTag(String tag) {
    selectedGemTags.remove(tag);
    update();
    return selectedGemTags;
  }

  List<String> clearSelectedTag() {
    selectedGemTags.clear();
    update();
    return selectedGemTags;
  }
}
