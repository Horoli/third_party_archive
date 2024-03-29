part of third_party_archive;

class WidgetHomePortrait extends WidgetHome {
  Map<String, Widget> pages;

  WidgetHomePortrait({
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
    return Scaffold(
      appBar: AppBar(
        title: GetX<GetTag>(
          builder: (_) => Text(getController.selectedTag.value),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: GetX<GetTag>(builder: (_) {
          return ListView(
            children: [
              const DrawerHeader(
                child: Text(LABEL.APP_TITLE),
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
              ).toList()
            ],
          );
        }),
      ),
      body: Stack(
        children: [
          buildWallpaper(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: pages.values.toList(),
            ),
          ),
        ],
      ),
    );
  }
}
