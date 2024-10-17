part of third_party_archive;

class ViewOneHome extends StatefulWidget {
  const ViewOneHome({super.key});

  @override
  State<ViewOneHome> createState() => ViewOneHomeState();
}

class ViewOneHomeState extends State<ViewOneHome>
    with TickerProviderStateMixin {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: enablePoeTwo
          ? FloatingActionButton(
              child: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  PATH.ROUTE_SELECT,
                );
              },
            )
          : null,
      body: isPort
          ? const WidgetOneHomePortrait()
          : const WidgetOneHomeLandscape(),
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
