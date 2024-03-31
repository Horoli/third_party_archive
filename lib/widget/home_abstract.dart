part of third_party_archive;

abstract class WidgetHome extends StatelessWidget {
  bool isPort;
  BuildContext context;
  TabController tabController;
  List<String> tags;
  GetTag getController;
  WidgetHome({
    required this.isPort,
    required this.context,
    required this.tabController,
    required this.tags,
    required this.getController,
    super.key,
  });

  Widget buildNavigationButton({
    required bool selected,
    required String label,
    required int index,
  }) {
    Color buttonColor = const Color.fromARGB(255, 72, 57, 99);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: selected
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
              )
            : null,
        onPressed: () async {
          await getController.changeSelectedTag(label);
          tabController.animateTo(index);
          if (isPort) Navigator.pop(context);
        },
        child: Text(label),
      ),
    );
  }

  Widget buildWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(IMAGE.APPLICTION_WALLPAPER),
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget buildCopyrightText() {
    return Text('Copyright © 2024 Horoli');
  }

  Widget buildGithubIconButton() {
    return IconButton(
      icon: const Icon(SimpleIcons.github),
      onPressed: () async {
        await launchUrl(Uri.parse(URL.GIT_HUB));
      },
    );
  }

  Widget buildGmailIconButton() {
    return IconButton(
      icon: const Icon(SimpleIcons.gmail),
      onPressed: () {
        Clipboard.setData(const ClipboardData(text: URL.GMAIL));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(MSG.COPY_TO_CLIPBOARD)),
        );
      },
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCopyrightText(),
        const Padding(padding: EdgeInsets.all(8)),
        buildGithubIconButton(),
        const Padding(padding: EdgeInsets.all(8)),
        buildGmailIconButton(),
      ],
    );
  }
}
