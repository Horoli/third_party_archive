part of third_party_archive;

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome> with TickerProviderStateMixin {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;

  String tag = 'a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // title: Text(tag),
      // ),
      body: isPort ? const WidgetHomePortrait() : const WidgetHomeLandscape(),
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
