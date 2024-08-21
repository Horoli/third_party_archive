part of third_party_archive;

class PageSmallChangeCalculator extends StatefulWidget {
  const PageSmallChangeCalculator({super.key});

  @override
  State<PageSmallChangeCalculator> createState() =>
      PageSmallChangeCalculatorState();
}

class PageSmallChangeCalculatorState extends State<PageSmallChangeCalculator> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('준비 중 : SMALL_CHANGE'),
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
