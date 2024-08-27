part of third_party_archive;

class PageSmallChangeCalculator extends StatefulWidget {
  const PageSmallChangeCalculator({super.key});

  @override
  State<PageSmallChangeCalculator> createState() =>
      PageSmallChangeCalculatorState();
}

class PageSmallChangeCalculatorState extends State<PageSmallChangeCalculator> {
  final GetPoeNinja getPoeNinja = Get.put(GetPoeNinja());

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
            Row(
              children: [
                Image.asset(
                  IMAGE.DIVINE_ORB,
                  scale: 3,
                ),
                const Text('1'),
                const Icon(Icons.arrow_right_alt),
                Image.asset(
                  IMAGE.CHAOS_ORB,
                  scale: 3,
                ),
                Text('${data.divineOrb}'),
              ],
            ),
            Row(
              children: [
                TilePoeItem<PoeNinjaCurrency>(
                  items: data.currency,
                ).expand(),
                TilePoeItem<PoeNinjaFragment>(items: data.fragment).expand(),
                TilePoeItem<PoeNinjaItem>(items: data.scarab).expand(),
              ],
            ).expand(),
            Text('data from poe.ninja updated at : ${data.date}'),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Map<String, dynamic> cal({
    required double standard,
    required double price,
    int quantity = 1,
  }) {
    // 총 금액 계산
    double totalAmount = standard * price * quantity;
    print(totalAmount);
    // 소수점 이하 부분 계산
    double fractionalPart = (price * quantity) % 1;
    double getSmallChange = (fractionalPart * 10).roundToDouble();
    // 소수점 이하의 가격이 0.1 단위인 경우를 처리
    double oneTenthOfStandard = standard / 10;
    // 각종 금액 계산
    int integerPartOfPrice = (price * quantity).floor();
    double fractionalAmount = oneTenthOfStandard * getSmallChange;
    return {
      "integerPartOfPrice": integerPartOfPrice,
      "fractionalAmount": fractionalAmount.toInt(),
      "roundedTotalAmount": totalAmount.round()
    };
  }

  Future<RestfulResult> fetch() async {
    return await getPoeNinja.get();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
