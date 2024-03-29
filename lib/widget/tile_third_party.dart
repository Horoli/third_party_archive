part of third_party_archive;

class TileThirdParty extends StatefulWidget {
  final ThirdParty thirdParty;
  const TileThirdParty({
    required this.thirdParty,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TileThirdPartyState();
}

class TileThirdPartyState extends State<TileThirdParty> {
  ThirdParty get thirdParty => widget.thirdParty;

  final double logoSize = 100;

  bool isExpanded = false;
  final double subCollapseHeight = kToolbarHeight;
  double collapsedHeight = kToolbarHeight * 2.3;
  double expandHeight = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.transparent,
      duration: const Duration(milliseconds: 200),
      height: isExpanded ? expandHeight : collapsedHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Image.memory(
                base64Decode(thirdParty.images['thumbnail']!),
              ).sizedBox(height: logoSize, width: logoSize),
              Text(thirdParty.label),
            ],
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Column(
            children: [
              Text(thirdParty.description['main']!)
                  .sizedBox(height: kToolbarHeight),
              buildSubText(thirdParty.description['sub']!),
            ],
          ).expand(flex: 3),
          const Padding(padding: EdgeInsets.all(4)),
          buildButtonSet().sizedBox(height: logoSize),
        ],
      ),
    );
  }

  Widget buildSubText(String text) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        TextPainter wordWrapTp = TextPainter(
          text: TextSpan(
            text: text,
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        // print('wordWrapTp.height ${wordWrapTp.height}');
        expandHeight =
            collapsedHeight - kToolbarHeight + wordWrapTp.height + 35;

        // print('expandHeight $expandHeight');

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isExpanded ? wordWrapTp.height + 35 : subCollapseHeight,
          child: Stack(
            children: [
              Text(text),
              if (wordWrapTp.height > kToolbarHeight)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButtonSet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('open'),
          onPressed: () async {
            await launchUrl(Uri.parse(
              thirdParty.url['main']!,
            ));
            await postUserAction(
              id: GUuid,
              label: thirdParty.label,
              url: thirdParty.url['main']!,
              platform: GPlatform,
            );
          },
        ).flex(),
        const Padding(padding: EdgeInsets.all(8)),
        ElevatedButton(
          child: const Text('URL copy'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: thirdParty.url['main']!));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          },
        ).flex(),
        const Padding(padding: EdgeInsets.all(8)),
        if (thirdParty.url['manual'] != "")
          ElevatedButton(
            child: const Text('manual'),
            onPressed: () {},
          ).flex(),
      ],
    );
  }
}
