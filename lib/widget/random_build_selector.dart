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
  List<String> get gemTagList => getSkillGem.gemTagList.value;
  List<String> get selectedTags => getSkillGem.selectedGemTags.value;
  RestfulResult get info => getSkillGem.info.value;

  @override
  Widget build(context) {
    return FutureBuilder(
      future: fetchBuilds(),
      builder: (context, AsyncSnapshot<List<SkillGem>> snapshot) {
        if (snapshot.data != null) {
          return GetX<GetSkillGem>(
            builder: (_) {
              return Column(
                children: [
                  buildExceptionGemTags(gemTagList).expand(),
                  Text('${selectedTags.length}'),
                  Text('${getSkillGem.result.value.data.length}'),
                  buildRandomSkillGem(getSkillGem.result.value.data),
                  if (info.data != null)
                    Row(
                      children: [
                        Text('${info.data.lcText}').expand(),
                        Image.memory(base64Decode(info.data.base64Image))
                            .expand(),
                      ],
                    ).expand(),

                  // Row(
                  //   children: [
                  //     Image.memory(base64Decode(info.base64Image)).expand(),
                  // ListView.builder(
                  //   itemCount: result.keys.length,
                  //   itemBuilder: (context, index) {
                  //     String key = result.keys.toList()[index];
                  //     print(key);
                  //     return Text('${result[key]}');
                  //   },
                  // ).expand(),
                  //     ],
                  //   ),
                ],
              );
            },
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
            onPressed: () async {
              List<String> remove = getSkillGem.clearSelectedTag();
              await fetchBuilds(selectedGemTags: remove);
            },
          );
        }

        return ElevatedButton(
          child: Text(selectedTag),
          style: ButtonStyle(
            backgroundColor: selectedTags.contains(selectedTag)
                ? MaterialStateProperty.all(Colors.red)
                : null,
          ),
          onPressed: () async {
            if (selectedTags.contains(selectedTag)) {
              List<String> remove = getSkillGem.removeSelectedTag(selectedTag);
              print('selectedTag ${selectedTags}');
              await fetchBuilds(selectedGemTags: remove);
              return;
            }
            List<String> get = getSkillGem.updateSelectedTag(selectedTag);
            print('selectedTag ${selectedTags}');

            await fetchBuilds(selectedGemTags: get);
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
          // print('tags $selectedGemTags');
          // await getSkillGem.getImage(name: skillGems[randomInt].name);
          await getSkillGem.getInfo(name: resultSkillGem);
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

  Future<List<SkillGem>> fetchBuilds({List<String>? selectedGemTags}) async {
    await getSkillGem.get(tags: selectedGemTags ?? [], attribute: '');
    return getSkillGem.result.value.data;
  }

  @override
  void dispose() {
    getSkillGem.clearSelectedTag();
    super.dispose();
  }
}
