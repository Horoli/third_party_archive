part of third_party_archive;

class WidgetSkillGemInfo extends StatelessWidget {
  SkillGemInfo info;
  WidgetSkillGemInfo({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.memory(base64Decode(info.base64Image)),
            Container(
              height: kToolbarHeight,
              width: double.infinity,
              // color: const ui.Color.fromARGB(255, 126, 150, 127),
              child: Center(
                child: Text('${info.lcText}'),
              ),
            ),
            buildStatsObject(),
            buildCustomDivider(),
            Text('${info.requirementsText}'),
            buildCustomDivider(),
            Text('${info.gemText}'),
            buildCustomDivider(),
            buildExplicitMods(),
            const SizedBox(height: 10),
            Text('${info.qualityHeaderText}'),
            Text('${info.qualityModText}'),
            buildCustomDivider(),
            Text('${info.defaultText}'),
            Text('${info.name}'),
            Divider(),
            Row(
              children: [
                ElevatedButton(
                  child: Text('find build(for poe.ninja)'),
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        "https://poe.ninja/builds/${currentLeague}?skills=${info.name}"));
                  },
                ),
                ElevatedButton(
                  child: Text('find poeDB'),
                  onPressed: () async {
                    String replace = info.name.replaceAll(' ', '_');

                    await launchUrl(
                        Uri.parse('https://poedb.tw/kr/${replace}'));
                  },
                )
              ],
            ).sizedBox(height: kToolbarHeight)
          ],
        ),
      ),
    );
  }

  Widget buildStatsObject() {
    return Column(
      children: info.statsObject.entries.map((entry) {
        return Center(
          child: Text('${entry.key} : ${entry.value}'),
        );
      }).toList(),
    );
  }

  Widget buildExplicitMods() {
    return Column(children: info.explicitMods.map((e) => Text(e)).toList());
  }

  Widget buildCustomDivider() {
    return const Divider(
      indent: 200,
      endIndent: 200,
    );
  }
}
