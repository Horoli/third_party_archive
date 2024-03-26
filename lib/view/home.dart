part of third_party_archive;

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome>
    with SingleTickerProviderStateMixin {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  late final TabController ctrlTab = TabController(
    initialIndex: 0,
    length: pages.length,
    vsync: this,
  );
  late final Map<String, Widget> pages = {
    LABEL.TAG_PATCHNOTE: PageThirdParty(tag: LABEL.TAG_PATCHNOTE),
    LABEL.TAG_BUILD: PageThirdParty(tag: LABEL.TAG_BUILD),
    LABEL.TAG_CRAFT: PageThirdParty(tag: LABEL.TAG_CRAFT),
    LABEL.TAG_INFO: PageThirdParty(tag: LABEL.TAG_INFO),
    LABEL.TAG_TRADE: PageThirdParty(tag: LABEL.TAG_TRADE),
    LABEL.TAG_COMMUNITY: PageThirdParty(tag: LABEL.TAG_COMMUNITY),
    LABEL.TAG_CURRENCY: PageThirdParty(tag: LABEL.TAG_CURRENCY),
    LABEL.TAG_ITEMFILTER: PageThirdParty(tag: LABEL.TAG_ITEMFILTER),
  };

  @override
  Widget build(BuildContext context) {
    return isPort ? buildPortait() : buildLandscape();
  }

  Widget buildPortait() {
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
          controller: ctrlTab,
          children: pages.values.toList(),
        ),
      ),
    );
  }

  Widget buildLandscape() {
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
                  controller: ctrlTab,
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

  Widget buildNavigationButton({
    required String label,
    required int index,
  }) {
    return TextButton(
      child: Text(label),
      onPressed: () {
        ctrlTab.animateTo(index);
        if (isPort) Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
