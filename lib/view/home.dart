part of third_party_archive;

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome> with TickerProviderStateMixin {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  late TabController _tabController;
  bool initController = false;
  late Future<List<String>> futureTags;
  late Map<String, Widget> pages;

  final GetTag getController = Get.put(GetTag());
  // String selectedTag = ;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureTags,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          // TODO : splash image
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot}');
        } else {
          List<String> tags = snapshot.data!;

          if (initController) {
            _tabController.dispose();
          } else {
            initController = true;
          }
          _tabController = TabController(length: tags.length, vsync: this);
          pages = {
            for (String tag in tags) tag: PageThirdParty(tag: tag),
          };

          return isPort ? buildPortait(tags) : buildLandscape(tags);
        }
      },
    );
  }

  Widget buildPortait(List<String> tags) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<GetTag>(
          builder: (_) => Text(getController.selectedTag.value),
        ),
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        width: 150,
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ...List.generate(
              tags.length,
              (index) {
                return buildNavigationButton(
                  label: tags[index],
                  index: index,
                );
              },
            ).toList()
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: pages.values.toList(),
        ),
      ),
    );
  }

  final ScrollController ctrlScroll = ScrollController();

  Widget buildLandscape(List<String> tags) {
    double landscapeWidth = 1024 + 512;

    return Scaffold(
      body: Scrollbar(
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
                  Container(color: Colors.blue[100])
                      .sizedBox(height: height / 10),
                  // contents
                  Row(
                    children: [
                      Container(
                        color: Colors.grey,
                        child: ListView.builder(
                          itemCount: tags.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildNavigationButton(
                            label: tags[index],
                            index: index,
                          ),
                        ),
                      ).sizedBox(width: 200),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabBarView(
                          controller: _tabController,
                          children: pages.values.toList(),
                        ),
                      ).expand(flex: 5),
                      Container(color: Colors.blue).expand()
                    ],
                  ).sizedBox(width: landscapeWidth).expand(),
                  // footer
                  Container(color: Colors.blue[100])
                      .sizedBox(height: height / 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButton({
    required String label,
    required int index,
  }) {
    return TextButton(
      child: Text(label),
      onPressed: () async {
        await getController.changeSelectedTag(label);
        _tabController.animateTo(index);
        if (isPort) Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureTags = fetchTags();
  }

  Future<List<String>> fetchTags() async {
    await getController.get();
    await Future.delayed(const Duration(milliseconds: 2000));
    return getController.result.data;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
