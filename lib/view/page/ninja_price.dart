part of third_party_archive;

class PageChangeCalculator extends StatefulWidget {
  final bool isPort;
  const PageChangeCalculator({
    required this.isPort,
    super.key,
  });

  @override
  State<PageChangeCalculator> createState() => PageChangeCalculatorState();
}

class PageChangeCalculatorState extends State<PageChangeCalculator> {
  final GetPoeNinja getPoeNinja = Get.put(GetPoeNinja());
  bool get isPort => widget.isPort;

  List<String> listType = [
    LABEL.CURRENCY,
    LABEL.FRAGMENT,
    LABEL.SCARAB,
    LABEL.MAP,
    // LABEL.INVITATION
  ];

  late List<String> selectedType = isPort
      ? [LABEL.CURRENCY]
      : [
          LABEL.CURRENCY,
          LABEL.FRAGMENT,
          LABEL.SCARAB,
          // LABEL.MAP,
        ];

  PoeNinjaSet get data => getPoeNinja.result.value.data;

  @override
  Widget build(BuildContext context) {
    return GetX<GetPoeNinja>(
      builder: (_) {
        if (getPoeNinja.result.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            buildTypeSelector(),
            Row(
              children: [
                if (selectedType.contains('Currency'))
                  TilePoeItem<PoeNinjaCurrency>(
                    items: data.currency,
                  ).expand(),
                if (selectedType.contains('Fragment'))
                  TilePoeItem<PoeNinjaFragment>(items: data.fragment).expand(),
                if (selectedType.contains('Scarab'))
                  TilePoeItem<PoeNinjaItem>(items: data.scarab).expand(),
                if (selectedType.contains('Map'))
                  TilePoeItem<PoeNinjaMap>(items: data.map).expand(),
                if (selectedType.contains('Invitation'))
                  TilePoeItem(items: data.invitation).expand(),
              ],
            ).expand(),
            const Divider(),
            Text('standard Chaos Orb value: ${data.standardChaosValue}'),
            Text('data from poe.ninja. updated at : ${data.date}'),
          ],
        );
      },
    );
  }

  Widget buildTypeSelector() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(listType.length, (index) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (selectedType.contains(listType[index])) {
                  return GSelectedButtonColor;
                }
                return null;
              }),
            ),
            onPressed: () {
              setState(() {
                if (isPort) {
                  selectedType = [listType[index]];
                  return;
                }
                if (selectedType.contains(listType[index])) {
                  selectedType.remove(listType[index]);
                  return;
                }
                selectedType.add(listType[index]);
              });
            },
            child: Text(listType[index]),
          );
        }));
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<RestfulResult> fetch() async {
    return await getPoeNinja.get();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
