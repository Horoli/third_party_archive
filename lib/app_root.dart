part of third_party_archive;

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData.dark(),
      title: LABEL.APP_TITLE,
      initialRoute: enablePoeTwo ? PATH.ROUTE_SELECT : PATH.ROUTE_ONE_HOME,
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name == PATH.ROUTE_ONE_KR || name == PATH.ROUTE_ONE_EN) {
          final dashboard = Get.put(GetDashboard());
          final isKr = name == PATH.ROUTE_ONE_KR;
          dashboard.isKorean.value = isKr;
          GSharedPreference.setBool('isKorean', isKr);
          return MaterialPageRoute(
            builder: (_) => const ViewOneHome(),
            settings: settings,
          );
        }
        // 기존 라우트
        final routes = <String, WidgetBuilder>{
          PATH.ROUTE_SELECT: (_) => const ViewSelectVersion(),
          PATH.ROUTE_ONE_HOME: (_) => const ViewOneHome(),
          PATH.ROUTE_TWO_HOME: (_) => const ViewTwoHome(),
        };
        final builder = routes[name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        return MaterialPageRoute(builder: (_) => const ViewOneHome());
      },
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
