part of third_party_archive;

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Map<String, Widget Function(BuildContext)> routes = {
    PATH.ROUTE_SELECT: (BuildContext context) => const ViewSelectVersion(),
    PATH.ROUTE_ONE_HOME: (BuildContext context) => const ViewOneHome(),
    PATH.ROUTE_TWO_HOME: (BuildContext context) => const ViewTwoHome()
  };

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      title: LABEL.APP_TITLE,
      initialRoute: enablePoeTwo ? PATH.ROUTE_SELECT : PATH.ROUTE_ONE_HOME,
      routes: routes,
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
