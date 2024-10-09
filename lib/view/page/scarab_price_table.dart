part of third_party_archive;

class PageScarabPriceTable extends StatefulWidget {
  const PageScarabPriceTable({super.key});

  @override
  PageScarabPriceTableState createState() => PageScarabPriceTableState();
}

class PageScarabPriceTableState extends State<PageScarabPriceTable> {
  final GetScarabTable getScarab = Get.put(GetScarabTable());

  String imageUrl = URL.IS_LOCAL
      ? 'http://${URL.LOCAL_URL}/v1/poe_ninja/image'
      : 'https://${URL.FORIEGN_URL}/v1/poe_ninja/image';

  List<PoeNinjaItem> get data => getScarab.result.value.data;
  List<PoeNinjaItem> selectableItems = [];

  Map<int, PoeNinjaItem> scarabLocation = SCARAB_LOCATION.MAP;

  int selectedGridIndex = -1;

  // debugmode일땐 editing list 표시
  bool isDebugMode = kDebugMode;

  int sheetColumnQuantity = 17;
  int sheetRowQuantity = 19;

  @override
  Widget build(BuildContext context) {
    return GetX<GetScarabTable>(
      builder: (_) {
        if (getScarab.result.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            if (isDebugMode) buildManagementPrintButton(),
            Row(
              children: [
                buildSheet().expand(flex: 3),
                if (isDebugMode) buildManagementList().expand(),
              ],
            ).expand(),
          ],
        );
      },
    );
  }

  Widget buildSheet() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sheetColumnQuantity,
      ),
      itemCount: sheetColumnQuantity * sheetRowQuantity,
      itemBuilder: (context, index) {
        // TODO : DebugMode일때 보여주는 tile
        if (isDebugMode) {
          return TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                scarabLocation[index] == null ? Colors.white : Colors.amber,
              ),
            ),
            child: Text(
              scarabLocation[index]?.name ?? index.toString(),
            ),
            onPressed: () {
              setState(() {
                scarabLocation[index] = selectableItems[0];
                selectableItems.removeAt(0);
              });
            },
            onLongPress: () {
              setState(() {
                selectableItems.add(scarabLocation[index]!);
                selectableItems.sort((a, b) => a.name.compareTo(b.name));
                scarabLocation.remove(index);
              });
            },
          );
        }
        // TODO : releaseMode일때 보여주는 tile
        return !scarabLocation.containsKey(index)
            ? Container()
            : Tooltip(
                message:
                    "${scarabI18nString(scarabLocation[index]!.name)}\n누르면 거래소로 이동",
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        '$imageUrl/${scarabLocation[index]?.icon}',
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Text(
                          scarabLocation[index]?.chaosValue.toString() ?? '',
                        ),
                      ),
                      TextButton(
                        child: Container(),
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                              'https://poe.game.daum.net/trade/search/Settlers?q={"query":{"status":{"option":"online"},"type":"${scarabI18nString(scarabLocation[index]!.name)}","stats":[{"type":"and","filters":[]}]},"sort":{"price":"asc"}}',
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget buildManagementList() {
    return ListView.builder(
      itemCount: selectableItems.length,
      itemBuilder: (context, int index) {
        PoeNinjaItem item = selectableItems[index];
        return ListTile(
          leading: Image.network('$imageUrl/${item.icon}'),
          title: Text(item.name,
              style: TextStyle(
                color: index == 0 ? Colors.amber : Colors.white,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
              )),
          subtitle: Text(item.chaosValue.toString()),
        );
      },
    );
  }

  Widget buildManagementPrintButton() {
    return TextButton(
      onPressed: () {
        Map<String, dynamic> showScarabLocationData =
            scarabLocation.map((key, value) {
          return MapEntry<String, dynamic>(key.toString(), value.map);
        });

        print(jsonEncode(showScarabLocationData));
      },
      child: Text('print'),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  String scarabI18nString(String scarabLabel) =>
      I18N.SCARAB[scarabLabel]['label'];

  Future<void> fetch() async {
    RestfulResult getResult = await getScarab.get();
    setState(() {
      selectableItems = getResult.data.where((se) {
        return !SCARAB_LOCATION.MAP.values.any((e) {
          return e.name == se.name;
        });
      }).toList();

      // print(selectableItems.length);

      selectableItems.sort((a, b) => a.name.compareTo(b.name));
    });
  }
}
