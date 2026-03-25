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
  final GetDashboard getCtrlDashboard = Get.find<GetDashboard>();
  bool get isPort => widget.isPort;

  List<String> listType = [
    LABEL.CURRENCY,
    LABEL.FRAGMENT,
    LABEL.SCARAB,
    // LABEL.MAP,
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
              children: _buildPanelsWithDividers(),
            ).expand(),
          ],
        );
      },
    );
  }

  Widget buildTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(listType.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: WidgetToggleButton(
              label: listType[index],
              isSelected: selectedType.contains(listType[index]),
              onTap: () {
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
            ),
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  List<Widget> _buildPanelsWithDividers() {
    final List<Widget> panels = [];
    final Map<String, Widget> typeWidgets = {
      'Currency': TilePoeItem<PoeNinjaCurrency>(items: data.currency),
      'Fragment': TilePoeItem<PoeNinjaFragment>(items: data.fragment),
      'Scarab': TilePoeItem<PoeNinjaItem>(items: data.scarab),
      'Map': TilePoeItem<PoeNinjaMap>(items: data.map),
      'Invitation': TilePoeItem(items: data.invitation),
    };

    for (int i = 0; i < selectedType.length; i++) {
      if (i > 0) {
        panels.add(const VerticalDivider(
            width: 1, color: Colors.white24));
      }
      final widget = typeWidgets[selectedType[i]];
      if (widget != null) panels.add(Expanded(child: widget));
    }
    return panels;
  }

  Future<RestfulResult> fetch() async {
    return await getPoeNinja.get();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
