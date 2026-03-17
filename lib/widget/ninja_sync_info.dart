part of third_party_archive;

class WidgetNinjaSyncInfo extends StatelessWidget {
  final String? rawDate;
  const WidgetNinjaSyncInfo({
    super.key,
    required this.rawDate,
  });

  @override
  Widget build(BuildContext context) {
    if (rawDate == null || rawDate!.isEmpty) return const SizedBox.shrink();

    String formattedDate = rawDate!;
    try {
      String cleanedDate = rawDate!.replaceAll('. ', '-').replaceAll('.', '-').trim();
      DateTime dt = DateTime.parse(cleanedDate);
      formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      RegExp reg = RegExp(r'(\d{4}).\s?(\d{1,2}).\s?(\d{1,2}).\s?([^\d]+)?\s?(\d{1,2}):(\d{1,2})');
      var match = reg.firstMatch(rawDate!);
      if (match != null) {
        String year = match.group(1)!;
        String month = match.group(2)!.padLeft(2, '0');
        String day = match.group(3)!.padLeft(2, '0');
        String? ampm = match.group(4);
        int hour = int.parse(match.group(5)!);
        String minute = match.group(6)!.padLeft(2, '0');

        if (ampm != null && ampm.contains('오후') && hour < 12) hour += 12;
        if (ampm != null && ampm.contains('오전') && hour == 12) hour = 0;
        
        formattedDate = '$year-$month-$day ${hour.toString().padLeft(2, '0')}:$minute';
      }
    }

    final GetDashboard getCtrlDashboard = Get.find<GetDashboard>();

    return Obx(() => Tooltip(
      message: getCtrlDashboard.isKorean.value 
          ? LABEL.DATA_SYNCED_WITH_POE_NINJA 
          : LABEL.DATA_SYNCED_WITH_POE_NINJA_EN,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.withAlpha(100)),
        ),
        child: Text(
          formattedDate,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    ));
  }
}
