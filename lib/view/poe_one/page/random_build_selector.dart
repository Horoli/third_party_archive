part of third_party_archive;

class PageRandomBuildSelector extends StatefulWidget {
  const PageRandomBuildSelector({
    super.key,
  });

  @override
  PageRandomBuildSelectorState createState() => PageRandomBuildSelectorState();
}

class PageRandomBuildSelectorState extends State<PageRandomBuildSelector>
    with SingleTickerProviderStateMixin {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final GetSkillGem getSkillGem = Get.put(GetSkillGem());
  final GetSelectedGemTag getSelectedGemTag = Get.put(GetSelectedGemTag());

  // animationController 관련
  late ScrollController ctrlScroll;
  late AnimationController ctrlAnimation;
  late Animation<Color?> colorTween;

  String resultSkillGem = '';

  late StreamController<int> $randomResult;
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
                              const Divider(),
                              Text(
                                  '액티브 스킬 젬 : ${getSkillGem.result.value.data.length}'),
                              const Divider(),
                              buildRandomRoulette(
                                  getSkillGem.result.value.data),
                              const Text('위 막대를 누르면 무작위로 선택됩니다.'),
                            ],
                          ).expand(),
                        ],
                      );
                    },
                  ).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
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
                  await fetchBuilds(selectedGemTags: remove);
                  return;
                }
                List<String> get =
                    getSelectedGemTag.updateSelectedTag(selectedTag);

                await fetchBuilds(selectedGemTags: get);

                ctrlScroll.jumpTo(0);
              },
            );
          },
        );
      },
    );
  }

  // TODO : layoutBuilder로 변경해서 maxWidth/displayItemLength로 itemWidth를 계산하도록 변경
  Widget buildRandomRoulette(List<SkillGem> skillGems) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        int displayItemLength = 5;
        double itemWidth = constraints.maxWidth / displayItemLength;

        return GestureDetector(
          onTap: () async => await randomGestureAction(
            skillGems,
            itemWidth,
          ),
          child: skillGems.isEmpty
              ? const Center(child: Text('포함된 젬이 없습니다'))
              : StreamBuilder(
                  stream: $randomResult.stream,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                      child: ListView.builder(
                        cacheExtent: 2 * itemWidth,
                        controller: ctrlScroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: skillGems.length + displayItemLength - 1,
                        itemBuilder: (context, index) {
                          // 앞뒤로 2개씩 더 추가해서 무한 스크롤처럼 보이게 함
                          // ex : 198, 199, 0, 1, 2, 3, 4, ... 200, 0, 1
                          index = (index - ((displayItemLength - 1) ~/ 2)) %
                              skillGems.length;

                          bool isSelected = snapshot.data == index;

                          return buildSkillGemTile(
                            itemWidth,
                            skillGems[index],
                            isSelected,
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget buildSkillGemTile(
    double width,
    SkillGem skillGem,
    bool isSelected,
  ) {
    Color? gemColor;

    switch (skillGem.primaryAttribute) {
      case 'strength':
        gemColor = Colors.red;
        break;
      case 'dexterity':
        gemColor = Colors.green;
        break;
      case 'intelligence':
        gemColor = Colors.blue;
        break;
    }

    return isSelected
        ? AnimatedBuilder(
            animation: colorTween,
            builder: (BuildContext context, Widget? child) {
              return Container(
                // color: colorTween.value,
                // color: gemColor,
                height: 100,
                width: width,
                decoration: BoxDecoration(
                  color: gemColor,
                  border: Border.all(
                    width: 5,
                    color: colorTween.value!,
                  ),
                ),
                child: Center(
                  child: Text(
                    skillGem.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          )
        : Container(
            color: gemColor,
            height: 100,
            width: width,
            child: Center(
              child: Text(
                skillGem.name,
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    ctrlAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    colorTween = ColorTween(
      begin: Colors.orange[500],
      end: Colors.white,
    ).animate(ctrlAnimation);

    ctrlScroll = ScrollController();
    $randomResult = StreamController<int>.broadcast();
  }

  Future<List<SkillGem>> fetchBuilds({List<String>? selectedGemTags}) async {
    // getSelectedGemTag.tagRefresh();
    await getSkillGem.get(tags: selectedGemTags ?? [], attribute: '');
    return getSkillGem.result.value.data;
  }

  Future<void> randomGestureAction(
    List<SkillGem> skillGems,
    double itemWidth,
  ) async {
    final math.Random random = math.Random();
    int randomInt = random.nextInt(skillGems.length);

    await ctrlScroll.animateTo(
      (skillGems.length - 1).toDouble() * itemWidth,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.easeInOut,
    );

    await ctrlScroll.animateTo(
      (randomInt).toDouble() * itemWidth,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.easeInOut,
    );

    $randomResult.add(randomInt);
    resultSkillGem = skillGems[randomInt].name;
    // selectedSkillGemIndex = randomInt;
    await getSkillGem.getInfo(name: resultSkillGem);
  }

  @override
  void dispose() {
    getSelectedGemTag.clearSelectedTag();
    ctrlAnimation.dispose();
    ctrlScroll.dispose();
    $randomResult.close();
    super.dispose();
  }
}
