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

  String resultSkillGem = '';

  StreamController<int> ctrlRandomResult = StreamController<int>.broadcast();

  // TODO : API로 이동
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
              buildRandomSkillGem(skillGems).expand(),
              GetX<GetSkillGem>(
                builder: (_) {
                  Map result = getSkillGem.selected.value;

                  if (result.isEmpty) {
                    // if (getSkillGem.iconImage.value == '') {
                    return Container();
                  }
                  return Row(
                    children: [
                      Image.memory(
                        base64Decode(result['base64Image']),
                      ).expand(),
                      ListView.builder(
                        itemCount: result.keys.length,
                        itemBuilder: (context, index) {
                          String key = result.keys.toList()[index];
                          return Text('${result[key]}');
                        },
                      ).expand(),
                    ],
                  );
                },
              ).expand()
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
            child: Text('Clear'),
            onPressed: () {
              setState(() {
                selectedGemTags.clear();
              });
            },
          );
        }

        return ElevatedButton(
          child: Text(selectedTag),
          style: ButtonStyle(
            backgroundColor: selectedGemTags.contains(selectedTag)
                ? MaterialStateProperty.all(Colors.red)
                : null,
          ),
          onPressed: () {
            setState(() {
              if (selectedGemTags.contains(selectedTag)) {
                selectedGemTags.remove(selectedTag);
                return;
              }
              selectedGemTags.add(selectedTag);
            });
          },
        );
      },
    );
  }

  Widget buildRandomSkillGem(List<SkillGem> skillGems) {
    return GestureDetector(
      onTap: () {
        int randomInt = Fortune.randomInt(0, skillGems.length);
        resultSkillGem = skillGems[randomInt].name;
        ctrlRandomResult.add(randomInt);
      },
      child: FortuneBar(
        onAnimationEnd: () async {
          /**
           *TODO : onAnimationEnd가 종료된 후에 skillGems.length가
           * 왜 초기값으로 변하는지 확인할 것
           */
          print('skillGems.length ${skillGems.length}');
          print('tags $selectedGemTags');
          // await getSkillGem.getImage(name: skillGems[randomInt].name);
          await getSkillGem.getImage(name: resultSkillGem);
        },
        // styleStrategy: AlternatingStyleStrategy(),
        animateFirst: false,
        selected: ctrlRandomResult.stream,
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
