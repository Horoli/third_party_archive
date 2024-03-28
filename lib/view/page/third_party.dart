part of third_party_archive;

class PageThirdParty extends StatefulWidget {
  String tag;
  PageThirdParty({
    required this.tag,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => PageThirdPartyState();
}

class PageThirdPartyState extends State<PageThirdParty> {
  GetThirdParty controller = Get.put(GetThirdParty());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetThirdParty>(
        builder: (_) {
          if (controller.result.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          List<ThirdParty> thirdParties = controller.result.data;

          return ListView.builder(
            itemCount: thirdParties.length,
            itemBuilder: (context, index) {
              return TileThirdParty(thirdParty: thirdParties[index]);
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  Future<void> get() async {
    await controller.get(
      tag: widget.tag,
      id: GUuid,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
