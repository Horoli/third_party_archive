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
