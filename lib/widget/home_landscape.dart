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
                          if (selectedCategory == LABEL.THIRD_PARTY)
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

    if (selectedCategory == LABEL.RECEIVING_DAMAGE) {
      return Container(
        child: Text('RECEIVING_DAMAGE'),
      );
    }
    return RandomBuildSelector();
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
          child: Text(LABEL.RANDOM_BUILD),
          style: selectedCategory == LABEL.RANDOM_BUILD
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                )
              : null,
          onPressed: () {
            setState(() {
              selectedCategory = LABEL.RANDOM_BUILD;
            });
          },
        ),
        ElevatedButton(
          child: Text(LABEL.RECEIVING_DAMAGE),
          style: selectedCategory == LABEL.RECEIVING_DAMAGE
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                )
              : null,
          onPressed: () {
            setState(() {
              selectedCategory = LABEL.RECEIVING_DAMAGE;
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
  Future<Map> fetchDashboard() async {
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
