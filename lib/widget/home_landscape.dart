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
  Widget buildContents(AsyncSnapshot<List<String>> snapshot) {
    return Scrollbar(
      thumbVisibility: false,
      controller: ctrlScroll,
      child: SingleChildScrollView(
        controller: ctrlScroll,
        child: Center(
          child: SizedBox(
            height: height * 1.1,
            child: Column(
              children: [
                // header
                Container().sizedBox(height: height / 10),
                const Divider(),
                // contents
                Row(
                  children: [
                    GetBuilder<GetTag>(
                      builder: (_) => ListView.builder(
                        itemCount: tags.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return buildNavigationButton(
                            selected:
                                tags[index] == getController.selectedTag.value,
                            label: tags[index],
                            index: index,
                          );
                        },
                      ),
                    ).sizedBox(width: 200),
                    const VerticalDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: pages.values.toList(),
                      ),
                    ).expand(flex: 5),
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

  @override
  Future<List<String>> fetchTags() async {
    await getController.get();
    return getController.result.data;
  }

  // TODO : empty place(for ad)
  Widget buildAdPlace() {
    return Container();
  }
}
