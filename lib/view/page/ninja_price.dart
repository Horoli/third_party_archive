part of third_party_archive;

class PageChangeCalculator extends StatefulWidget {
  const PageChangeCalculator({super.key});

  @override
  State<PageChangeCalculator> createState() => PageChangeCalculatorState();
}

class PageChangeCalculatorState extends State<PageChangeCalculator> {
  final GetPoeNinja getPoeNinja = Get.put(GetPoeNinja());

  List<String> listType = [
    LABEL.CURRENCY,
    LABEL.FRAGMENT,
    LABEL.SCARAB,
    LABEL.MAP,
    // LABEL.INVITATION
  ];

  List<String> selectedType = [
    LABEL.CURRENCY,
    LABEL.FRAGMENT,
    LABEL.SCARAB,
    LABEL.MAP,
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
    // bool isSelectedAll = selectedType.length == listType.length;
    List<Widget> buttons = List.generate(listType.length, (index) {
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
            if (selectedType.contains(listType[index])) {
              selectedType.remove(listType[index]);
              return;
            }
            selectedType.add(listType[index]);
          });
        },
        child: Text(listType[index]),
      );
    });

    // buttons.insert(
    //   0,
    //   ElevatedButton(
    //     onPressed: () {
    //       setState(() {
    //         if (isSelectedAll) {
    //           selectedType = [];
    //           return;
    //         }
    //         selectedType = listType;
    //       });
    //     },
    //     child: isSelectedAll ? const Text('모두 해제') : const Text('모두 선택'),
    //   ),
    // );

    return Row(
      children: buttons,
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  // Map<String, dynamic> cal({
  //   required double standard,
  //   required double price,
  //   int quantity = 1,
  // }) {
  //   // 총 금액 계산
  //   double totalAmount = standard * price * quantity;
  //   print(totalAmount);
  //   // 소수점 이하 부분 계산
  //   double fractionalPart = (price * quantity) % 1;
  //   double getSmallChange = (fractionalPart * 10).roundToDouble();
  //   // 소수점 이하의 가격이 0.1 단위인 경우를 처리
  //   double oneTenthOfStandard = standard / 10;
  //   // 각종 금액 계산
  //   int integerPartOfPrice = (price * quantity).floor();
  //   double fractionalAmount = oneTenthOfStandard * getSmallChange;
  //   return {
  //     "integerPartOfPrice": integerPartOfPrice,
  //     "fractionalAmount": fractionalAmount.toInt(),
  //     "roundedTotalAmount": totalAmount.round()
  //   };
  // }

  Future<RestfulResult> fetch() async {
    return await getPoeNinja.get();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
