part of third_party_archive;

class WidgetHomeLandscape extends WidgetHome {
  const WidgetHomeLandscape({
    super.key,
  });

  @override
  WidgetHomeLandscapeState createState() => WidgetHomeLandscapeState();
}

class WidgetHomeLandscapeState extends WidgetHomeState<WidgetHomeLandscape> {
  double landscapeWidth = 1024 + 512;

  final ScrollController ctrlScroll = ScrollController();

  @override
  Widget buildContents(AsyncSnapshot<Map> snapshot) {
    return Scrollbar(
      thumbVisibility: true,
      controller: ctrlScroll,
      child: SingleChildScrollView(
        controller: ctrlScroll,
        child: Center(
          child: SizedBox(
            height: height * 1.1,
            child: Column(
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: setLeagues(),
                ).sizedBox(height: height / 9),
                buildCategorySelect(),
                const Divider(),
                // contents
                Row(
                  children: [
                    GetBuilder<GetDashboard>(
                      builder: (_) => ListView(
                        children: [
                          if (selectedCategory == LABEL.THIRD_PARTY)
                            ...buildTagList(),
                          const Divider(),
                          buildCurrentPlayer(),
                        ],
                      ),
                    ).sizedBox(width: 200),
                    const VerticalDivider(),
                    buildMainContents().expand(flex: 5),
                    const VerticalDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildAdPlace(),
                    ).expand()
                  ],
                ).sizedBox(width: landscapeWidth).expand(),
                // footer
                const Divider(),
                buildFooter().sizedBox(height: height / 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainContents() {
    if (selectedCategory == LABEL.THIRD_PARTY) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: pages.values.toList(),
        ),
      );
    }
    return const Center(
      child: Text('컨텐츠 준비 중입니다'),
    );
  }

  Widget buildCategorySelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(LABEL.THIRD_PARTY),
          style: selectedCategory == LABEL.THIRD_PARTY
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                )
              : null,
          onPressed: () async {
            await getCtrlDashboard.changeSelectedTag(LABEL.TAG_CRAFT);
            setState(() {
              selectedCategory = LABEL.THIRD_PARTY;
            });
          },
        ),
        ElevatedButton(
          child: Text(LABEL.ETC),
          style: selectedCategory == LABEL.ETC
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                )
              : null,
          onPressed: () {
            setState(() {
              selectedCategory = LABEL.ETC;
            });
          },
        ),
      ],
    );
  }

  List<Widget> setLeagues() {
    return leagues.map((league) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: LeagueInformation(
          league: league,
        ),
      );
    }).toList();
  }

  @override
  Future<Map> fetchTags() async {
    await getCtrlDashboard.get();
    return getCtrlDashboard.result.data;
  }

  // TODO : empty place(for ad)
  Widget buildAdPlace() {
    // if (GPlatform == 'web') {
    //   GKakaoAdfit.registry();
    //   return HtmlElementView(
    //     viewType: GKakaoAdfit.tag,
    //   );
    // }
    return Container();
  }
}
