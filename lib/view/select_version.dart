part of third_party_archive;

class ViewSelectVersion extends StatefulWidget {
  const ViewSelectVersion({super.key});

  @override
  State<ViewSelectVersion> createState() => ViewSelectVersionState();
}

class ViewSelectVersionState extends State<ViewSelectVersion> {
  bool get isPort => MediaQuery.of(context).orientation == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              IMAGE.SELECT_BACKGROUND,
              fit: BoxFit.cover,
            ),
          ),
          buildButtons()
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Center(
      child: SizedBox(
        width: CONSTANTS.LANDSCAPE_WIDTH,
        height: double.infinity,
        child: isPort
            ? Column(children: hoverButtons)
            : Row(children: hoverButtons),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get hoverButtons => [
        HoverImageButton(
          child: Image.asset(
            IMAGE.ONE_LOGO,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              PATH.ROUTE_ONE_HOME,
            );
          },
        ).expand(),
        HoverImageButton(
          child: Image.asset(
            IMAGE.TWO_LOGO,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              PATH.ROUTE_TWO_HOME,
            );
          },
        ).expand(),
      ];

  @override
  void dispose() {
    super.dispose();
  }
}
