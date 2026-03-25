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

  static const _textStyle = TextStyle(
      color: Colors.white, fontSize: 12, fontFamily: 'monospace');

  InputDecoration _decoration({String? labelText, bool readOnly = false}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 11),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      filled: true,
      fillColor: readOnly ? Colors.white.withAlpha(5) : Colors.black45,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.white.withAlpha(30)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.white.withAlpha(30)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.amber),
      ),
      errorStyle: const TextStyle(fontSize: 0, height: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isKr = getCtrlDashboard.isKorean.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(
                isKr ? LABEL.CHANGE_CALCULATOR : LABEL.CHANGE_CALCULATOR_EN,
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // 구매/판매 토글
              WidgetToggleButton(
                label: isKr ? LABEL.BUY : LABEL.BUY_EN,
                isSelected: isSell == LABEL.BUY,
                fontSize: 11,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                onTap: () => setState(() => isSell = LABEL.BUY),
              ),
              const SizedBox(width: 4),
              WidgetToggleButton(
                label: isKr ? LABEL.SELL : LABEL.SELL_EN,
                isSelected: isSell == LABEL.SELL,
                fontSize: 11,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                onTap: () => setState(() => isSell = LABEL.SELL),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 아이템 가격
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 24, height: 24, child: GImageDivineOrb),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextFormField(
                    controller: ctrlItemPrice,
                    focusNode: itemPriceFocus,
                    style: _textStyle,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: _decoration(
                      labelText: isKr ? '아이템 가격' : 'Item Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '';
                      return null;
                    },
                    onChanged: (value) {
                      if (ctrlItemPrice.text.isEmpty ||
                          ctrlPayedDiv.text.isEmpty) return;
                      changeCal();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(payedDivFocus);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 줄 돈 / 받을 돈
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 24, height: 24, child: GImageDivineOrb),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextFormField(
                    controller: ctrlPayedDiv,
                    focusNode: payedDivFocus,
                    style: _textStyle,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: _decoration(
                      labelText: isSell != LABEL.BUY
                          ? (isKr ? '받을 돈' : 'Receive')
                          : (isKr ? '줄 돈' : 'Pay'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '';
                      if (value.contains('.')) return '';
                      return null;
                    },
                    onChanged: (value) {
                      if (ctrlItemPrice.text.isEmpty ||
                          ctrlPayedDiv.text.isEmpty ||
                          value.contains('.')) return;
                      changeCal();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(itemPriceFocus);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 잔돈
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 24, height: 24, child: GImageChaosOrb),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextField(
                    controller: ctrlChangeChaos,
                    readOnly: true,
                    style: _textStyle,
                    decoration: _decoration(
                      labelText: isKr ? '잔돈' : 'Change',
                      readOnly: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  void changeCal() {
    double itemPrice = double.parse(ctrlItemPrice.text);
    int payedDiv = int.parse(ctrlPayedDiv.text);
    double subtraction = payedDiv - itemPrice;
    int result = (GDivineOrb * subtraction).round().abs();
    ctrlChangeChaos.text = result.toString();
  }
}
