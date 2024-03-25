part of '../third_party_archive.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(color: Colors.red).expand(),
          Container().expand(),
        ],
      ),
    );
  }
}
