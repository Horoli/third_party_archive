part of third_party_archive;

class ChangeCalculator extends StatefulWidget {
  const ChangeCalculator({super.key});

  @override
  ChangeCalculatorState createState() => ChangeCalculatorState();
}

class ChangeCalculatorState extends State<ChangeCalculator> {
  bool isSell = true;
  TextEditingController ctrlItemPrice = TextEditingController();
  TextEditingController ctrlPayedDiv = TextEditingController();
  TextEditingController ctrlChangeChaos = TextEditingController();
  FocusNode itemPriceFocus = FocusNode();
  FocusNode payedDivFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("잔돈 계산기"),
          const Padding(padding: EdgeInsets.all(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTypeSelector('buy'),
              const Padding(padding: EdgeInsets.all(4)),
              buildTypeSelector('sell'),
            ],
          ),
          Row(
            children: [
              const Text('아이템 가격 :'),
              GImageDivineOrb,
              buildDivineOrbTextField(
                  focusNode: itemPriceFocus,
                  controller: ctrlItemPrice,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '값을 입력해주세요';
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
                    // itemPriceFocus.unfocus();
                    // payedDivFocus.requestFocus();
                    FocusScope.of(context).requestFocus(payedDivFocus);
                  }).expand()
            ],
          ),
          Row(
            children: [
              Text(isSell ? '받을 돈 : ' : '줄 돈 : '),
              GImageDivineOrb,
              buildDivineOrbTextField(
                  focusNode: payedDivFocus,
                  controller: ctrlPayedDiv,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '값을 입력해주세요';
                    }

                    if (value.contains(".")) {
                      return '소수점을 포함할 수 없습니다';
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
                  }).expand(),
            ],
          ),
          Row(
            children: [
              Text("잔돈 :"),
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
  }

  Widget buildTypeSelector(String type) {
    return ElevatedButton(
      style: !isSell
          ? ButtonStyle(
              backgroundColor: WidgetStateProperty.all(GSelectedButtonColor),
            )
          : null,
      onPressed: () {
        setState(() {
          isSell = type == 'buy' ? false : true;
        });
      },
      child: Text(type),
    );
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
      // keyboardType: TextInputType.number,
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
