part of third_party_archive;

class WidgetHomeLandscape extends WidgetHome {
  double height;
  ScrollController ctrlScroll;
  Map<String, Widget> pages;

  WidgetHomeLandscape({
    required this.height,
    required this.ctrlScroll,
    required this.pages,
    required super.isPort,
    required super.tags,
    required super.context,
    required super.tabController,
    required super.getController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double landscapeWidth = 1024 + 512;
    return Scaffold(
      body: Stack(
        children: [
          buildWallpaper(),
          Scrollbar(
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
                                  selected: tags[index] ==
                                      getController.selectedTag.value,
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
                          // TODO : empty place(ad)
                          Container().expand()
                        ],
                      ).sizedBox(width: landscapeWidth).expand(),
                      // footer
                      const Divider(),
                      Container().sizedBox(height: height / 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
