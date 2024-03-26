part of third_party_archive;

class ViewLoading extends StatefulWidget {
  const ViewLoading({super.key});

  @override
  State<ViewLoading> createState() => ViewLoadingState();
}

class ViewLoadingState extends State<ViewLoading> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacementNamed(context, PATH.ROUTE_HOME);
    });
  }
}
