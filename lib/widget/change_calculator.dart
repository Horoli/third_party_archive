part of third_party_archive;

class ChangeCalculator extends StatefulWidget {
  const ChangeCalculator({super.key});

  @override
  ChangeCalculatorState createState() => ChangeCalculatorState();
}

class ChangeCalculatorState extends State<ChangeCalculator> {
  final GetDashboard getCtrlDashboard = Get.find<GetDashboard>();
  String isSell = LABEL.BUY;
  TextEditingController ctrlItemPrice = TextEditingController();
  TextEditingController ctrlPayedDiv = TextEditingController();
  TextEditingController ctrlChangeChaos = TextEditingController();
  FocusNode itemPriceFocus = FocusNode();
  FocusNode payedDivFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isKr = getCtrlDashboard.isKorean.value;
      return Center(
        child: Column(
          children: [
            Text(isKr ? LABEL.CHANGE_CALCULATOR : LABEL.CHANGE_CALCULATOR_EN),
            const Padding(padding: EdgeInsets.all(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTypeSelector(LABEL.BUY),
                const Padding(padding: EdgeInsets.all(4)),
                buildTypeSelector(LABEL.SELL),
              ],
            ),
            Row(
              children: [
                Text('${isKr ? '아이템 가격' : 'Item Price'} :'),
                GImageDivineOrb,
                buildDivineOrbTextField(
                    focusNode: itemPriceFocus,
                    controller: ctrlItemPrice,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isKr ? '값을 입력해주세요' : 'Please enter a value';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (ctrlItemPrice.text == '' || ctrlPayedDiv.text == '') {
                        return;
                      }
                      changeCal();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(payedDivFocus);
                    }).expand()
              ],
            ),
            Row(
              children: [
                Text(isSell != LABEL.BUY
                    ? (isKr ? '받을 돈 : ' : 'Receive : ')
                    : (isKr ? '줄 돈 : ' : 'Pay : ')),
                GImageDivineOrb,
                buildDivineOrbTextField(
                  focusNode: payedDivFocus,
                  controller: ctrlPayedDiv,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return isKr ? '값을 입력해주세요' : 'Please enter a value';
                    }

                    if (value.contains(".")) {
                      return isKr ? '소수점을 포함할 수 없습니다' : 'Cannot include decimals';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    if (ctrlItemPrice.text == '' ||
                        ctrlPayedDiv.text == '' ||
                        value.contains(".")) {
                      return;
                    }
                    changeCal();
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(itemPriceFocus);
                  },
                ).expand(),
              ],
            ),
            Row(
              children: [
                Text('${isKr ? '잔돈' : 'Change'} :'),
                GImageChaosOrb,
                TextField(
                  controller: ctrlChangeChaos,
                  readOnly: true,
                ).expand()
              ],
            )
          ],
        ),
      );
    });
  }

  Widget buildTypeSelector(String type) {
    return Obx(() {
      bool isKr = getCtrlDashboard.isKorean.value;
      String label = type;
      if (type == LABEL.BUY) label = isKr ? LABEL.BUY : LABEL.BUY_EN;
      if (type == LABEL.SELL) label = isKr ? LABEL.SELL : LABEL.SELL_EN;

      return ElevatedButton(
        style: isSell == type
            ? ButtonStyle(
                backgroundColor: WidgetStateProperty.all(GSelectedButtonColor),
              )
            : null,
        onPressed: () {
          setState(() {
            isSell = type;
          });
        },
        child: Text(label),
      );
    });
  }

  Widget buildDivineOrbTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    required Function(String) onChanged,
    VoidCallback? onEditingComplete,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }

  void changeCal() {
    double itemPrice = double.parse(ctrlItemPrice.text);
    int payedDiv = int.parse(ctrlPayedDiv.text);
    double subtraction = payedDiv - itemPrice;
    int result = (GDivineOrb * subtraction).round().abs();
    ctrlChangeChaos.text = result.toString();
  }
}
