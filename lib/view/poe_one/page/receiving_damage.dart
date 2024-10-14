part of third_party_archive;

class PageReceivingDamageCalculator extends StatefulWidget {
  const PageReceivingDamageCalculator({super.key});

  @override
  State<PageReceivingDamageCalculator> createState() =>
      PageReceivingDamageCalculatorState();
}

class PageReceivingDamageCalculatorState
    extends State<PageReceivingDamageCalculator> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('준비 중 : RECEIVING_DAMAGE_CALCULATOR'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
