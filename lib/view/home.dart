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
          return Scaffold(
            // appBar: AppBar(
            //   bottom: TabBar(
            //     controller: _tabController,
            //     tabs: snapshot.data!.map((tag) => Tab(text: tag)).toList(),
            //   ),
            // ),
            body: isPort ? buildPortait(tags) : buildLandscape(tags),
          );
        }
      },
    );
  }

  Widget buildNavigationButton({
    required String label,
    required int index,
  }) {
    return TextButton(
      child: Text(label),
      onPressed: () {
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

  Widget buildPortait(List<String> tags) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        width: 150,
        child: ListView.builder(
          itemCount: tags.length,
          itemBuilder: (BuildContext context, int index) =>
              buildNavigationButton(label: tags[index], index: index),
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

  Widget buildLandscape(List<String> tags) {
    return Scaffold(
      body: Column(
        children: [
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
              // TODO : 공백(광고)
              Container(color: Colors.blue).sizedBox(width: 200)
            ],
          ).expand(),
          Container(color: Colors.blue[100]).sizedBox(height: kToolbarHeight)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
