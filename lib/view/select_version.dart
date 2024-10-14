part of third_party_archive;

class ViewSelectVersion extends StatefulWidget {
  const ViewSelectVersion({super.key});

  @override
  State<ViewSelectVersion> createState() => ViewSelectVersionState();
}

class ViewSelectVersionState extends State<ViewSelectVersion> {
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
          Center(
            child: SizedBox(
              width: CONSTANTS.LANDSCAPE_WIDTH,
              height: double.infinity,
              child: Row(
                children: [
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
                  const Padding(padding: EdgeInsets.all(8)),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // Future init() async {
  //   await Future.delayed(const Duration(milliseconds: 1000), () {
  //     Navigator.pushReplacementNamed(context, PATH.ROUTE_HOME);
  //   });
  // }
}
