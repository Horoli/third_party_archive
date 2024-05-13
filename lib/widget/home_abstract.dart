part of third_party_archive;

abstract class WidgetHome extends StatefulWidget {
  const WidgetHome({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => throw UnimplementedError();
}

abstract class WidgetHomeState<T extends WidgetHome> extends State<T>
    with TickerProviderStateMixin {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;

  final GetDashboard getCtrlDashboard = Get.put(GetDashboard());
  late TabController tabController = TabController(length: 1, vsync: this);
  Map<String, Widget> pages = {};
  List<String> tags = [];
  List<PathOfExileLeague> leagues = [];
  int currentPlayers = 0;
  // String selectedCategory = LABEL.THIRD_PARTY;
  String selectedCategory = LABEL.ETC;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: isPort ? buildPortraitAppBar() : null,
      drawer: isPort ? buildDrawer() : null,
      // persistentFooterButtons: [buildFooter()],
      body: FutureBuilder(
        future: fetchDashboard(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.data != null) {
            tags = snapshot.data!['tags'];
            leagues = snapshot.data!['leagues'];
            currentPlayers = snapshot.data!['currentPlayers'];

            tabController.dispose();
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
              buildContents(snapshot),
              // if (snapshot.connectionState == ConnectionState.waiting)
              //   const Center(
              //     child: CircularProgressIndicator(),
              //   ).sizedBox(height: height, width: width),
            ],
          );
        },
      ),
    );
  }

  Widget buildContents(AsyncSnapshot<Map> snapshot) =>
      throw UnimplementedError();

  PreferredSizeWidget buildPortraitAppBar() {
    return AppBar(
      title: GetX<GetDashboard>(
        builder: (_) => Text(getCtrlDashboard.selectedTag.value),
      ),
    );
  }

  // Only for portrait mode : common scaffold를 사용함에 따라 abstarct에 set
  Widget buildDrawer() {
    return Drawer(
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
        Text('현재 Steam 유저수 : $currentPlayers'),
        TextButton(
          child: const Text('시즌별 유저통계 보러가기'),
          onPressed: () async {
            await launchUrl(Uri.parse(URL.POE_DB_CONCURRENT_PLAYER));
          },
        ),
      ],
    );
  }

  Widget buildNavigationButton({
    required bool selected,
    required String label,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: selected
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
              )
            : null,
        onPressed: () async {
          await getCtrlDashboard.changeSelectedTag(label);
          tabController.animateTo(index);
          if (isPort) Navigator.pop(context);
        },
        child: Text(label),
      ),
    );
  }

  Widget buildWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(IMAGE.APPLICTION_WALLPAPER),
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget buildCopyrightText() {
    return const Text('Copyright © 2024 Horoli');
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
  void dispose() {
    getCtrlDashboard.dispose();
    super.dispose();
  }
}
