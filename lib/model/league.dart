part of third_party_archive;

class PathOfExileLeague {
  String label;
  String version;
  String officialApi;
  Map period;
  Map status;
  PathOfExileLeague({
    required this.label,
    required this.version,
    required this.officialApi,
    required this.period,
    required this.status,
  });

  factory PathOfExileLeague.fromMap({required Map item}) {
    return PathOfExileLeague(
      label: item['label'],
      version: item['version'],
      officialApi: item['officialApi'],
      period: Map.from(item['period']),
      status: Map.from(item['status']),
    );
  }
}
