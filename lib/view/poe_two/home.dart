part of third_party_archive;

class ViewTwoHome extends StatefulWidget {
  const ViewTwoHome({super.key});

  @override
  State<ViewTwoHome> createState() => ViewTwoHomeState();
}

class ViewTwoHomeState extends State<ViewTwoHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            PATH.ROUTE_SELECT,
          );
        },
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
