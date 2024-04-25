part of third_party_archive;

class LeagueInformation extends StatefulWidget {
  final PathOfExileLeague league;

  const LeagueInformation({
    required this.league,
    super.key,
  });

  @override
  LeagueInformationState createState() => LeagueInformationState();
}

class LeagueInformationState extends State<LeagueInformation> {
  PathOfExileLeague get league => widget.league;

  late final Timer setTimer;
  late DateTime startDate =
      TZ.TZDateTime.from(DateTime.parse(league.period['start']), GDetroit);
  late DateTime endDate =
      TZ.TZDateTime.from(DateTime.parse(league.period['end']), GDetroit);
  @override
  Widget build(context) {
    final TimeCalculator timeCal = TimeCalculator(
      start: startDate,
      end: endDate,
    );
    return Column(
      children: [
        Text('${league.label}'),
        Text('${league.version}'),
        Text('${timeCal.basedOnStartToNow()}'),
        Text('${timeCal.basedOnNowToEnd()}'),
      ],
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    setTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    setTimer.cancel();
    super.dispose();
  }
}

class TimeCalculator {
  DateTime start;
  DateTime end;
  TimeCalculator({
    required this.start,
    required this.end,
  });

  final DateTime _now = TZ.TZDateTime.now(GDetroit);

  String _getString(int difference) {
    int days = difference ~/ 86400;
    int hours = (difference % 86400) ~/ 3600;
    int minutes = (difference % 3600) ~/ 60;
    int seconds = difference % 60;
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  String basedOnNowToStart() {
    int difference = start.difference(_now).inSeconds;
    return _getString(difference);
  }

  String basedOnStartToNow() {
    int difference = _now.difference(start).inSeconds;
    return _getString(difference);
  }

  String basedOnNowToEnd() {
    int difference = end.difference(_now).inSeconds;
    return _getString(difference);
  }
}
