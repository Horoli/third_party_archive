part of third_party_archive;

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Map<String, Widget Function(BuildContext)> routes = {
    PATH.ROUTE_LOADING: (BuildContext context) => ViewLoading(),
    PATH.ROUTE_HOME: (BuildContext context) => ViewHome()
  };

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: LABEL.APP_TITLE,
      initialRoute: PATH.ROUTE_LOADING,
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
