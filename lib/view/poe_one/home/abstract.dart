part of third_party_archive;

abstract class WidgetOneHome extends StatefulWidget {
  const WidgetOneHome({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => throw UnimplementedError();
}

abstract class WidgetOneHomeState<T extends WidgetOneHome> extends State<T>
    with TickerProviderStateMixin {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;

  final GetDashboard getCtrlDashboard = Get.put(GetDashboard());
  final GetScarabTable getCtrlScarab = Get.put(GetScarabTable());
  final GetPoeNinja getCtrlPoeNinja = Get.put(GetPoeNinja());

  late TabController tabController = TabController(length: 1, vsync: this);
  Map<String, Widget> pages = {};
  List<String> tags = [];
  List<PathOfExileLeague> leagues = [];
  int currentPlayers = 0;
  String appBarLabel = '';
  // String selectedCategory = LABEL.THIRD_PARTY;
  // String selectedCategory = LABEL.NINJA_PRICE;
  // String selectedCategory = LABEL.RANDOM_BUILD;
  String selectedCategory = LABEL.SCARAB_TABLE;

  RestfulResult get result => getCtrlDashboard.result.value;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: isPort ? buildPortraitAppBar : null,
      drawer:
          isPort && selectedCategory == LABEL.THIRD_PARTY ? buildDrawer : null,
      endDrawer: isPort ? buildEndDrawer : null,
      floatingActionButton: buildFloatingLanguageButton(),
      // persistentFooterButtons: [buildFooter()],
      body: GetX<GetDashboard>(
        builder: (_) {
          if (result.data != null) {
            tags = List.from(result.data['tags'] ?? []);
            leagues = result.data['leagues'];
            currentPlayers = result.data['currentPlayers'];

            tags.sort((a, b) {
              return a.compareTo(b);
            });

            // tabController.dispose();
            tabController = TabController(
              length: tags.length,
              vsync: this,
            );

            pages = {
              for (String tag in tags) tag: PageThirdParty(tag: tag),
            };
          }

          return Stack(
            children: [
              buildWallpaper(),
              buildContents(),
            ],
          );
        },
      ),
    );
  }

  Widget buildContents() => throw UnimplementedError();

  PreferredSizeWidget get buildPortraitAppBar => AppBar(
        title: selectedCategory == LABEL.THIRD_PARTY
            ? GetX<GetDashboard>(
                builder: (_) => Text(getCtrlDashboard.selectedTag.value),
              )
            : Obx(() => Text(getLocalizedLabel(selectedCategory))),
      );

  Widget buildFloatingLanguageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          getCtrlDashboard.isKorean.value;
          // 갑충석 시세표 → scarab 날짜, 시세확인 → ninja 날짜, 그 외 → 가용한 날짜
          String? date;
          if (selectedCategory == LABEL.SCARAB_TABLE) {
            date = getCtrlScarab.result.value.data?['updateDate'];
          } else if (selectedCategory == LABEL.NINJA_PRICE) {
            date = getCtrlPoeNinja.result.value.data?.date;
          }
          // 해당 페이지 전용 날짜가 없으면 가용한 데이터에서 가져옴
          date ??= getCtrlPoeNinja.result.value.data?.date;
          date ??= getCtrlScarab.result.value.data?['updateDate'];
          return WidgetNinjaSyncInfo(rawDate: date);
        }),
        const SizedBox(width: 6),
        Obx(() {
          final isKr = getCtrlDashboard.isKorean.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WidgetToggleButton(
                label: 'KR',
                isSelected: isKr,
                fontSize: 11,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                onTap: () {
                  if (!isKr) getCtrlDashboard.toggleLanguage();
                },
              ),
              const SizedBox(width: 4),
              WidgetToggleButton(
                label: 'EN',
                isSelected: !isKr,
                fontSize: 11,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                onTap: () {
                  if (isKr) getCtrlDashboard.toggleLanguage();
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  String getLocalizedLabel(String label) {
    bool isKr = getCtrlDashboard.isKorean.value;
    switch (label) {
      case LABEL.THIRD_PARTY:
        return isKr ? LABEL.THIRD_PARTY : LABEL.THIRD_PARTY_EN;
      case LABEL.NINJA_PRICE:
        return isKr ? LABEL.NINJA_PRICE : LABEL.NINJA_PRICE_EN;
      case LABEL.RECEIVING_DAMAGE:
        return isKr ? LABEL.RECEIVING_DAMAGE : LABEL.RECEIVING_DAMAGE_EN;
      case LABEL.SCARAB_TABLE:
        return isKr ? LABEL.SCARAB_TABLE : LABEL.SCARAB_TABLE_EN;
      case LABEL.MAP_MOD_TABLE:
        return isKr ? LABEL.MAP_MOD_TABLE : LABEL.MAP_MOD_TABLE_EN;
      default:
        return label;
    }
  }

  // Only for portrait mode : common scaffold를 사용함에 따라 abstarct에 set
  Widget get buildDrawer => Drawer(
        width: 200,
        child: GetX<GetDashboard>(builder: (_) {
          return Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ThirdParty Archive'),
                ),
              ).sizedBox(height: kToolbarHeight),
              const Divider(),
              ListView(
                children: buildTagList(),
              ).expand(),
              const Divider(),
              buildCurrentPlayer(),
              const Divider(),
              buildFooter().sizedBox(height: kToolbarHeight),
            ],
          );
        }),
      );

  Widget get buildEndDrawer => Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: categorySelectors,
        ),
      );

  List<Widget> get categorySelectors => [
        buildSelectCategoryButton(label: LABEL.THIRD_PARTY),
        // if (!isPort) buildSelectCategoryButton(label: LABEL.RANDOM_BUILD),
        buildSelectCategoryButton(label: LABEL.NINJA_PRICE),
        if (!isPort) buildSelectCategoryButton(label: LABEL.SCARAB_TABLE),
        if (!isPort) buildSelectCategoryButton(label: LABEL.MAP_MOD_TABLE),
      ];

  Widget buildSelectCategoryButton({
    required String label,
  }) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: WidgetToggleButton(
            label: getLocalizedLabel(label),
            isSelected: selectedCategory == label,
            onTap: () async {
              if (label == LABEL.THIRD_PARTY) {
                await getCtrlDashboard.changeSelectedTag(LABEL.TAG_ALL);
              }
              setState(() {
                selectedCategory = label;
                if (isPort) {
                  appBarLabel = label;
                  Navigator.pop(context);
                }
              });
            },
          ),
        ));
  }

  List<Widget> buildTagList() {
    return List.generate(
      tags.length,
      (index) {
        return buildNavigationButton(
          selected: tags[index] == getCtrlDashboard.selectedTag.value,
          label: tags[index],
          index: index,
        );
      },
    ).toList();
  }

  Widget buildCurrentPlayer() {
    return Column(
      children: [
        Obx(() => Text(getCtrlDashboard.isKorean.value
            ? '현재 Steam 유저수 : $currentPlayers'
            : 'Current Steam Players : $currentPlayers')),
        TextButton(
          child: Obx(() => Text(getCtrlDashboard.isKorean.value
              ? '시즌별 유저통계 보러가기'
              : 'View seasonal stats')),
          onPressed: () async {
            await launchUrl(Uri.parse(URL.POE_DB_CONCURRENT_PLAYER));
          },
        ),
      ],
    );
  }

  Widget buildMainContents() {
    switch (selectedCategory) {
      case (LABEL.THIRD_PARTY):
        // print('inittttt $tags');
        // return PageT(tags: tags);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: pages.values.toList(),
          ),
        );
      case (LABEL.RANDOM_BUILD):
        return const PageRandomBuildSelector();
      case (LABEL.NINJA_PRICE):
        return PageChangeCalculator(
          isPort: isPort,
        );
      case (LABEL.RECEIVING_DAMAGE):
        return const PageReceivingDamageCalculator();
      case (LABEL.SCARAB_TABLE):
        return const PageScarabPriceTable();
      case (LABEL.MAP_MOD_TABLE):
        return const PageMapModTable();
    }
    return Container();
  }

  Widget buildNavigationButton({
    required bool selected,
    required String label,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WidgetToggleButton(
        label: label,
        isSelected: selected,
        onTap: () async {
          await getCtrlDashboard.changeSelectedTag(label);
          tabController.animateTo(index);
          if (isPort) Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildChaosDivineRatio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GImageDivineOrb,
        const Text('1'),
        const Icon(Icons.arrow_right_alt),
        GImageChaosOrb,
        Text('$GDivineOrb'),
      ],
    );
  }

  Widget buildWallpaper() {
    return Opacity(
      opacity: 0.3,
      child: Image.asset(
        IMAGE.APPLICTION_WALLPAPER,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget buildCopyrightText() {
    return const Text('Copyright © 2024 ~ 2025 Horoli');
  }

  Widget buildGithubIconButton() {
    return IconButton(
      icon: const Icon(SimpleIcons.github),
      onPressed: () async {
        await launchUrl(Uri.parse(URL.GIT_HUB));
      },
    );
  }

  Widget buildGmailIconButton() {
    return IconButton(
      icon: const Icon(SimpleIcons.gmail),
      onPressed: () {
        Clipboard.setData(const ClipboardData(text: URL.GMAIL));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(MSG.COPY_TO_CLIPBOARD)),
        );
      },
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCopyrightText(),
        const Padding(padding: EdgeInsets.all(8)),
        buildGithubIconButton(),
        const Padding(padding: EdgeInsets.all(8)),
        buildGmailIconButton(),
      ],
    );
  }

  Future<Map> fetchDashboard() async =>
      throw UnimplementedError('fetchTags unimplemented');

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  @override
  void dispose() {
    // getCtrlDashboard.dispose();
    super.dispose();
  }
}
