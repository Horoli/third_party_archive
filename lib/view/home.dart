part of third_party_archive;

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome>
    with SingleTickerProviderStateMixin {
  final GetTag controller = Get.put(GetTag());
  late final TabController ctrlTab;
  late final Map<String, Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetTag>(builder: (_) {
        if (controller.result.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        List<String> data = controller.result.data;
        return Row(
          children: [
            ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildNavigationButton(label: data[index], index: index),
            ).expand(),
            TabBarView(
              controller: ctrlTab,
              children: pages.values.toList(),
            ).expand()
          ],
        );
      }),
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
      },
    );
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  Future<void> get() async {
    await controller.get();

    // Future.delayed(const Duration(milliseconds: 500), () {
    // print('aaaa ${controller.result.data}');

    // List<String> asd = controller.result.data;

    // pages = asd.map((e) => {e: Text(e)});

    // });
    pages = {
      'craft': Container(color: Colors.blue),
      'trade': Container(color: Colors.red)
    };

    ctrlTab = TabController(
      initialIndex: 0,
      length: pages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
