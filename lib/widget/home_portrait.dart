part of third_party_archive;

class WidgetHomePortrait extends WidgetHome {
  const WidgetHomePortrait({
    super.key,
  });

  @override
  WidgetHomePortraitState createState() => WidgetHomePortraitState();
}

class WidgetHomePortraitState extends WidgetHomeState<WidgetHomePortrait> {
  @override
  String selectedCategory = LABEL.THIRD_PARTY;

  @override
  Widget buildContents(AsyncSnapshot<Map> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildMainContents(),
      // child: TabBarView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: tabController,
      //   children: pages.values.toList(),
      // ),
    );
  }

  @override
  Future<Map> fetchDashboard() async {
    await getCtrlDashboard.get();
    return getCtrlDashboard.result.data;
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

  // localStorage에 저장된 시간이 없거나, 현재 시간보다 작은 경우 출력
  Future<void> buildShowModalBottomSheet() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    int afterOneDay = now + 1000 * 60 * 60 * 24;
    int? getDays = GSharedPreference.getInt(
      CONSTANTS.STORAGE_SHOW_AD,
    );

    if (getDays == null || getDays <= now) {
      await showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return buildBottomSheet(context, afterOneDay).sizedBox(
            height: height / 2.2,
          );
        },
      );
    }
  }

  Widget buildBottomSheet(BuildContext context, int afterOneDay) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: const Text(LABEL.BTN_DONT_SEE_AGAIN),
                onPressed: () async {
                  // 현재시간 + 1일을 저장
                  await GSharedPreference.setInt(
                    CONSTANTS.STORAGE_SHOW_AD,
                    afterOneDay,
                  );
                  // localStorage에 마지막으로 본 날짜를 저장
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text(LABEL.BTN_CLOSE),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ).sizedBox(height: kToolbarHeight),
          const Padding(padding: EdgeInsets.all(4)),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(IMAGE.TEST),
              ),
            ),
          ).sizedBox(width: double.infinity).expand(),
        ],
      ),
    );
  }
}
