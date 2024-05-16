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
  List<String> get attributeList => getSkillGem.attributeList.value;
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
              return Row(
                children: [
                  Column(
                    children: [
                      const Text('제외할 태그 선택'),
                      buildExceptionGemTags(gemTagList).expand(),
                      Divider(),
                      Text(
                          '액티브 스킬 젬 : ${getSkillGem.result.value.data.length}'),
                      Divider(),
                      buildFortuneBar(getSkillGem.result.value.data),
                      Text('위 막대를 누르면 무작위로 선택됩니다.'),
                      Container().expand()
                    ],
                  ).expand(),
                  VerticalDivider(),
                  info.data == null
                      ? Container().expand()
                      : WidgetSkillGemInfo(info: info.data).expand()
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 3,
        crossAxisSpacing: 2,
        childAspectRatio: 4,
      ),
      itemBuilder: (context, index) {
        String selectedTag = gemTagList[index];
        if (index == 0) {
          return ElevatedButton(
            child: Text('모두 취소'),
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

  // Widget buildExceptionAttribute(List<String> attributes) {
  //   return GridView.builder(
  //       itemCount: attributes.length,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 4,
  //         mainAxisSpacing: 3,
  //         crossAxisSpacing: 3,
  //         childAspectRatio: 3,
  //       ),
  //       itemBuilder: (context, index) {
  //         String selectedAttribute =
  //       return ElevatedButton(
  //         child: Text(selectedTag),
  //         style: ButtonStyle(
  //           backgroundColor: selectedTags.contains(selectedTag)
  //               ? MaterialStateProperty.all(Colors.red)
  //               : null,
  //         ),
  //         onPressed: () async {
  //           if (selectedTags.contains(selectedTag)) {
  //             List<String> remove = getSkillGem.removeSelectedTag(selectedTag);
  //             print('selectedTag ${selectedTags}');
  //             await fetchBuilds(selectedGemTags: remove);
  //             return;
  //           }
  //           List<String> get = getSkillGem.updateSelectedTag(selectedTag);
  //           print('selectedTag ${selectedTags}');

  //           await fetchBuilds(selectedGemTags: get);
  //         },
  //       );
  //       });
  // }

  Widget buildFortuneBar(List<SkillGem> skillGems) {
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
                    child: Center(child: Text(item.name)),
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.red,
                  ),
                );
              }

            case 'dexterity':
              {
                return FortuneItem(
                  child: Container(
                    child: Center(child: Text(item.name)),
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.green,
                  ),
                );
              }
            case 'intelligence':
              {
                return FortuneItem(
                  child: Container(
                    child: Center(child: Text(item.name)),
                    width: double.infinity,
                    height: double.infinity,
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
