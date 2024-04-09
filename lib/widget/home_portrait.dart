part of third_party_archive;

class WidgetHomePortrait extends WidgetHome {
  WidgetHomePortrait({
    super.key,
  });

  @override
  WidgetHomePortraitState createState() => WidgetHomePortraitState();
}

class WidgetHomePortraitState extends WidgetHomeState<WidgetHomePortrait> {
  @override
  Widget buildContents(AsyncSnapshot<List<String>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<GetTag>(
          builder: (_) => Text(getController.selectedTag.value),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: GetX<GetTag>(builder: (_) {
          return Column(
            children: [
              ListView(
                children: [
                  const DrawerHeader(
                    child: Text(LABEL.APP_TITLE),
                  ),
                  ...List.generate(
                    tags.length,
                    (index) {
                      return buildNavigationButton(
                        selected:
                            tags[index] == getController.selectedTag.value,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: pages.values.toList(),
        ),
      ),
    );
  }

  @override
  Future<List<String>> fetchTags() async {
    await getController.get();
    return getController.result.data;
  }

  @override
  Widget buildFooter() {
    return Column(
      children: [
        buildCopyrightText(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGithubIconButton(),
            buildGmailIconButton(),
          ],
        ).expand()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      buildShowModalBottomSheet();
    });
  }

  Future<void> buildShowModalBottomSheet() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    int oneDay = now + 1000 * 60 * 60 * 24;
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return buildBottomSheet(context).sizedBox(height: height / 2.2);
      },
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: Text('다시보지 않기'),
                onPressed: () {
                  // localStorage에 마지막으로 본 날짜를 저장
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ).sizedBox(height: kToolbarHeight),
          Padding(padding: EdgeInsets.all(4)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
          ).sizedBox(width: double.infinity).expand(),
        ],
      ),
    );
  }
}
