part of third_party_archive;

class PageRandomBuildSelector extends StatefulWidget {
  const PageRandomBuildSelector({
    super.key,
  });

  @override
  PageRandomBuildSelectorState createState() => PageRandomBuildSelectorState();
}

class PageRandomBuildSelectorState extends State<PageRandomBuildSelector> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final GetSkillGem getSkillGem = Get.put(GetSkillGem());
  final GetSelectedGemTag getSelectedGemTag = Get.put(GetSelectedGemTag());

  String resultSkillGem = '';

  StreamController<int> ctrlRandomResult = StreamController<int>.broadcast();
  RestfulResult get info => getSkillGem.info.value;
  List<String> get gemTagList => getSelectedGemTag.gemTagList.value;

  @override
  Widget build(context) {
    return FutureBuilder(
      future: fetchBuilds(),
      builder: (context, AsyncSnapshot<List<SkillGem>> snapshot) {
        if (snapshot.data != null) {
          return Row(
            children: [
              Column(
                children: [
                  const Text('제외할 태그 선택'),
                  buildExceptionGemTags(gemTagList).expand(),
                  GetX<GetSkillGem>(
                    builder: (_) {
                      return Row(
                        children: [
                          Column(
                            children: [
                              Divider(),
                              Text(
                                  '액티브 스킬 젬 : ${getSkillGem.result.value.data.length}'),
                              Divider(),
                              buildFortuneBar(getSkillGem.result.value.data),
                              Text('위 막대를 누르면 무작위로 선택됩니다.'),
                              // Container().expand()
                            ],
                          ).expand(),
                        ],
                      );
                    },
                  ).expand(),
                ],
              ).expand(),
              VerticalDivider(),
              GetX<GetSkillGem>(
                builder: (_) {
                  return info.data == null
                      ? Container()
                      : WidgetSkillGemInfo(info: info.data);
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
    return GetX<GetSelectedGemTag>(
      builder: (_) {
        List<String> selectedGemTags = getSelectedGemTag.selectedGemTags.value;
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
                  List<String> remove = getSelectedGemTag.clearSelectedTag();
                  await fetchBuilds(selectedGemTags: remove);
                },
              );
            }

            return ElevatedButton(
              child: Text(selectedTag),
              style: ButtonStyle(
                backgroundColor: selectedGemTags.contains(selectedTag)
                    ? WidgetStateProperty.all(Colors.red)
                    : null,
              ),
              onPressed: () async {
                if (selectedGemTags.contains(selectedTag)) {
                  List<String> remove =
                      getSelectedGemTag.removeSelectedTag(selectedTag);
                  print('selectedTag ${selectedGemTags}');
                  await fetchBuilds(selectedGemTags: remove);
                  return;
                }
                List<String> get =
                    getSelectedGemTag.updateSelectedTag(selectedTag);
                print('selectedTag ${selectedGemTags}');

                await fetchBuilds(selectedGemTags: get);
              },
            );
          },
        );
      },
    );
  }

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
                return buildFortuneItem(item.name, Colors.red);
              }
            case 'dexterity':
              {
                return buildFortuneItem(item.name, Colors.green);
              }
            case 'intelligence':
              {
                return buildFortuneItem(item.name, Colors.blue);
              }
          }

          return FortuneItem(
            child: Text(item.name),
          );
        }).toList(),
      ),
    );
  }

  FortuneItem buildFortuneItem(String name, Color backgroundcolor) {
    return FortuneItem(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundcolor,
        child: Center(child: Text(name)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<SkillGem>> fetchBuilds({List<String>? selectedGemTags}) async {
    // getSelectedGemTag.tagRefresh();
    await getSkillGem.get(tags: selectedGemTags ?? [], attribute: '');
    return getSkillGem.result.value.data;
  }

  @override
  void dispose() {
    getSelectedGemTag.clearSelectedTag();
    super.dispose();
  }
}
