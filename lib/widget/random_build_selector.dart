part of third_party_archive;

class RandomBuildSelector extends StatefulWidget {
  const RandomBuildSelector({
    super.key,
  });

  @override
  RandomBuildSelectorState createState() => RandomBuildSelectorState();
}

class RandomBuildSelectorState extends State<RandomBuildSelector> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final GetSkillGem getSkillGem = Get.put(GetSkillGem());

  StreamController<int> selected = StreamController<int>();

  final List<String> gemTagList = [
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
  ];

  late List<String> selectedGemTags = [];

  @override
  Widget build(context) {
    return FutureBuilder(
      future: fetchBuilds(),
      builder: (context, AsyncSnapshot<List<SkillGem>> snapshot) {
        if (snapshot.data != null) {
          List<SkillGem> skillGems = snapshot.data!;

          return Column(
            children: [
              Container(child: Text('selected except tags')),
              buildExceptionGemTags(gemTagList).expand(),
              Container(child: Text('${skillGems.length}')),
              buildRandomSkill(skillGems).expand(),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget buildExceptionGemTags(List<String> gemTagList) {
    return GridView.builder(
      itemCount: gemTagList.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
      itemBuilder: (context, index) {
        String selectedTag = gemTagList[index];
        if (index == 0) {
          return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedGemTags.clear();
                  fetchBuilds();
                });
              },
              child: Text('Clear'));
        }

        return ElevatedButton(
          child: Text(selectedTag),
          style: ButtonStyle(
              backgroundColor: selectedGemTags.contains(selectedTag)
                  ? MaterialStateProperty.all(Colors.red)
                  : null),
          onPressed: () {
            setState(() {
              if (selectedGemTags.contains(selectedTag)) {
                selectedGemTags.remove(selectedTag);
                return;
              }
              selectedGemTags.add(selectedTag);
              fetchBuilds();
            });
          },
        );
      },
    );
  }

  Widget buildRandomSkill(List<SkillGem> skillGems) {
    return GestureDetector(
      onTap: () {
        selected.add(Fortune.randomInt(0, skillGems.length));
      },
      child: FortuneBar(
        // styleStrategy: AlternatingStyleStrategy(),
        animateFirst: false,
        selected: selected.stream,
        items: skillGems.map((item) {
          switch (item.primaryAttribute) {
            case 'strength':
              {
                return FortuneItem(
                  child: Container(
                    child: Text(item.name),
                    color: Colors.red,
                  ),
                );
              }

            case 'dexterity':
              {
                return FortuneItem(
                  child: Container(
                    child: Text(item.name),
                    color: Colors.green,
                  ),
                );
              }
            case 'intelligence':
              {
                return FortuneItem(
                  child: Container(
                    child: Text(item.name),
                    color: Colors.blue,
                  ),
                );
              }
          }

          return FortuneItem(
            child: Container(
              child: Text(item.name),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<SkillGem>> fetchBuilds() async {
    await getSkillGem.get(tags: selectedGemTags, attribute: '');
    return getSkillGem.result.data;
  }
}
