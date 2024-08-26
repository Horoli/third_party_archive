part of third_party_archive;

class PageSmallChangeCalculator extends StatefulWidget {
  const PageSmallChangeCalculator({super.key});

  @override
  State<PageSmallChangeCalculator> createState() =>
      PageSmallChangeCalculatorState();
}

class PageSmallChangeCalculatorState extends State<PageSmallChangeCalculator> {
  final GetPoeNinja getPoeNinja = Get.put(GetPoeNinja());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: fetch(),
              builder: (context, snapshot) {
                return Image.network(
                    'http://localhost:2017/v1/poe_ninja/image/85a118d847df292126f468bee77a9ecbed1a228f5b7b2532111b3e761f0df353');
              })
          // child: Text('준비 중 : SMALL_CHANGE'),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetch() async {
    await getPoeNinja.get();
    // await getPoeNinja.getImage(
    //     hash:
    //         "85a118d847df292126f468bee77a9ecbed1a228f5b7b2532111b3e761f0df353");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
