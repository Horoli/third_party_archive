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

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      // print(constraints.maxHeight);
      if (constraints.maxHeight < 90) {
        return Container();
      }
      return Container(
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(
          color: ui.Color.fromARGB(255, 26, 26, 26),
        )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(league.label),
                  Text(league.version),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text('start : ${timeCal.convert(startDate)}'),
                      Text('Running for : '),
                      Text('${timeCal.basedOnStartToNow()}'),
                    ],
                  ).expand(),
                  Column(
                    children: [
                      Text('end : ${timeCal.convert(endDate)}'),
                      Text('${league.period['endState']} ends in: '),
                      Text('${timeCal.basedOnNowToEnd()}'),
                    ],
                  ).expand()
                ],
              ),
            ],
          ),
        ),
      );
    });
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

  String convert(DateTime date) {
    DateTime convertDate = TZ.TZDateTime.from(date, GDetroit);
    return DateFormat('yyyy-MM-dd hh:mm').format(convertDate);
  }

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
