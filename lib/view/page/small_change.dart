part of third_party_archive;

class PageSmallChangeCalculator extends StatefulWidget {
  const PageSmallChangeCalculator({super.key});

  @override
  State<PageSmallChangeCalculator> createState() =>
      PageSmallChangeCalculatorState();
}

class PageSmallChangeCalculatorState extends State<PageSmallChangeCalculator> {
  final GetPoeNinja getPoeNinja = Get.put(GetPoeNinja());

  // PoeNinjaSet get data => getPoeNinja.result.value.data;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(),
      builder: (context, AsyncSnapshot<PoeNinjaSet> snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }

        PoeNinjaSet getNinja = snapshot.data!;

        String url = URL.IS_LOCAL
            ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
            : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

        return ListView.builder(
          itemCount: getNinja.currency.length,
          itemBuilder: (context, index) {
            PoeNinjaCurrency currency = getNinja.currency[index];
            return Row(
              children: [
                Image.network('$url/${currency.icon}'),
                Text(currency.name),
                Text('${currency.chaosEquivalent}'),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('a'))
              ],
            );
          },
        ).expand();
      },
    );
    //       return Image.network(
    //           'http://localhost:2017/v1/poe_ninja/image/85a118d847df292126f468bee77a9ecbed1a228f5b7b2532111b3e761f0df353');
    //     });
    // return Scaffold(
    //   body: Center(
    //     child: GetX<GetPoeNinja>(builder: (_) {
    //       return Text('준비 중 : SMALL_CHANGE');
    //     }),
    //     // child: FutureBuilder(
    //     //     future: fetch(),
    //     //     builder: (context, snapshot) {
    //     //       return Image.network(
    //     //           'http://localhost:2017/v1/poe_ninja/image/85a118d847df292126f468bee77a9ecbed1a228f5b7b2532111b3e761f0df353');
    //     //     })
    //     // // child: Text('준비 중 : SMALL_CHANGE'),
    //   ),
  }

  @override
  void initState() {
    super.initState();
  }

  Future<PoeNinjaSet> fetch() async {
    RestfulResult result = await getPoeNinja.get();
    PoeNinjaSet data = result.data;
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
