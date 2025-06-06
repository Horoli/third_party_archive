part of third_party_archive;

class WidgetOneHomeLandscape extends WidgetOneHome {
  const WidgetOneHomeLandscape({
    super.key,
  });

  @override
  WidgetHomeLandscapeState createState() => WidgetHomeLandscapeState();
}

class WidgetHomeLandscapeState
    extends WidgetOneHomeState<WidgetOneHomeLandscape> {
  double landscapeWidth = CONSTANTS.LANDSCAPE_WIDTH;

  final ScrollController ctrlScroll = ScrollController();

  @override
  Widget buildContents() {
    return Scrollbar(
      thumbVisibility: true,
      controller: ctrlScroll,
      child: SingleChildScrollView(
        controller: ctrlScroll,
        child: IntrinsicHeight(
          child: Center(
            child: SizedBox(
              height: height * 1.3,
              child: Column(
                children: [
                  // header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: setLeagues(),
                  ).sizedBox(height: height / 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categorySelectors,
                  ),
                  // buildCategorySelector(),
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
                        child: Column(
                          children: [
                            buildChaosDivineRatio(),
                            // const Divider(),
                            const ChangeCalculator(),
                            // const Divider(),
                            const SizedBox(height: 8),
                            // SingleChildScrollView(
                            // child: buildAdPlace().sizedBox(height: 600),
                            // ).sizedBox(height: 600),
                          ],
                        ),
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
    return getCtrlDashboard.result.value.data;
  }

  // TODO : empty place(for ad)
  Widget buildAdPlace() {
    if (GPlatform == 'web') {
      GKakaoAdfit.registry();
      return HtmlElementView(
        viewType: GKakaoAdfit.tag,
      );
    }
    return Container();
  }
}
