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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all(Colors.red),
        // ),
        onPressed: () async {
          await getController.changeSelectedTag(label);
          tabController.animateTo(index);
          if (isPort) Navigator.pop(context);
        },
        child: Text(label),
      ),
    );
  }
}
