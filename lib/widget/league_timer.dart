part of third_party_archive;

class LeagueTimer extends StatefulWidget {
  final String start;
  final String end;

  const LeagueTimer({
    required this.start,
    required this.end,
    super.key,
  });

  @override
  LeagueTimerState createState() => LeagueTimerState();
}

class LeagueTimerState extends State<LeagueTimer> {
  late final Timer setTimer;
  late DateTime startDate =
      TZ.TZDateTime.from(DateTime.parse(widget.start), GDetroit);
  late DateTime endDate =
      TZ.TZDateTime.from(DateTime.parse(widget.end), GDetroit);
  @override
  Widget build(context) {
    final TimeCalculator timeCal = TimeCalculator(
      start: startDate,
      end: endDate,
    );
    return Column(
      children: [
        // Text('${timeCal.basedOnNowToStart()}'),
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
