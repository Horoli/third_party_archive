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

  final GetTag getController = Get.put(GetTag());
  late TabController tabController = TabController(length: 1, vsync: this);
  Map<String, Widget> pages = {};
  List<String> tags = [];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: isPort ? buildAppBar() : null,
      drawer: isPort ? buildDrawer() : null,
      body: FutureBuilder(
        future: fetchTags(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.data != null) {
            tags = snapshot.data!;

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
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(
                  child: CircularProgressIndicator(),
                ).sizedBox(height: height, width: width),
            ],
          );
        },
      ),
    );
  }

  Widget buildContents(AsyncSnapshot<List<String>> snapshot) =>
      throw UnimplementedError();

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: GetX<GetTag>(
        builder: (_) => Text(getController.selectedTag.value),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      width: 200,
      child: GetX<GetTag>(builder: (_) {
        return Column(
          children: [
            ListView(
              children: [
                const DrawerHeader(
                  child: Column(
                    children: [
                      Text(LABEL.APP_TITLE),
                      LeagueTimer(
                        start: '2024-03-29T19:00:00Z',
                        end: '2024-07-16T21:00:00Z',
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  tags.length,
                  (index) {
                    return buildNavigationButton(
                      selected: tags[index] == getController.selectedTag.value,
                      label: tags[index],
                      index: index,
                    );
                  },
                ).toList(),
              ],
            ).expand(),
            const Divider(),
            buildFooter().sizedBox(height: kToolbarHeight),
          ],
        );
      }),
    );
  }

  Widget buildNavigationButton({
    required bool selected,
    required String label,
    required int index,
  }) {
    Color buttonColor = const Color.fromARGB(255, 72, 57, 99);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: selected
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
              )
            : null,
        onPressed: () async {
          await getController.changeSelectedTag(label);
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

  Future<List<String>> fetchTags() async =>
      throw UnimplementedError('fetchTags unimplemented');
}
