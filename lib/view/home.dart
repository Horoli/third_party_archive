part of third_party_archive;

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome> with TickerProviderStateMixin {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;
  // double get width => MediaQuery.of(context).size.width;
  // double get height => MediaQuery.of(context).size.height;
  // final ScrollController ctrlScroll = ScrollController();

  // late TabController _tabController;
  // bool initController = false;
  // late Future<List<String>> futureTags;
  // late Map<String, Widget> pages;

  // late AnimationController? ctrlAnimate;

  // final GetTag getController = Get.put(GetTag());

  @override
  Widget build(BuildContext context) {
    return isPort ? WidgetHomePortrait() : WidgetHomeLandscape();

    // return Scaffold(
    //   body: FutureBuilder<List<String>>(
    //     future: fetchTags(),
    //     builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         // TODO : splash image
    //         return const Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasError) {
    //         return Text('Error: error 404');
    //       } else {
    //         List<String> tags = snapshot.data!;

    //         if (initController) {
    //           _tabController.dispose();
    //         } else {
    //           initController = true;
    //         }
    //         _tabController = TabController(length: tags.length, vsync: this);
    //         pages = {
    //           for (String tag in tags) tag: PageThirdParty(tag: tag),
    //         };

    //         return isPort
    //             ? WidgetHomePortrait(
    //                 pages: pages,
    //                 isPort: isPort,
    //                 tags: tags,
    //                 context: context,
    //                 tabController: _tabController,
    //                 getController: getController,
    //               )
    //             : WidgetHomeLandscape(
    //                 height: height,
    //                 ctrlScroll: ctrlScroll,
    //                 pages: pages,
    //                 isPort: isPort,
    //                 tags: tags,
    //                 context: context,
    //                 tabController: _tabController,
    //                 getController: getController,
    //               );
    //       }
    //     },
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    // ctrlAnimate = AnimationController(
    //   duration: const Duration(milliseconds: 4000),
    //   vsync: this,
    // );
  }

  // Future<List<String>> fetchTags() async {
  //   await getController.get();

  //   await Future.delayed(const Duration(milliseconds: 2000));
  //   return getController.result.data;
  // }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }
}
