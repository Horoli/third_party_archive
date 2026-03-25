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
          textDirection: ui.TextDirection.ltr,
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
                  child: InkWell(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white.withAlpha(30)),
          ),
          child: Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ),
      ),
    );
  }

  Widget buildButtonSet() {
    final GetDashboard dash = Get.find<GetDashboard>();
    return Obx(() {
      final isKr = dash.isKorean.value;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            label: isKr ? '링크 열기' : 'Open Link',
            onTap: () async {
              await launchUrl(Uri.parse(thirdParty.url['main']!));
              await postUserAction(
                id: GUuid,
                label: thirdParty.label,
                url: thirdParty.url['main']!,
                platform: GPlatform,
              );
            },
          ),
          const SizedBox(height: 6),
          _buildActionButton(
            label: isKr ? 'URL 복사' : 'Copy URL',
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: thirdParty.url['main']!));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(isKr
                        ? MSG.COPY_TO_CLIPBOARD
                        : MSG.COPY_TO_CLIPBOARD_EN)),
              );
            },
          ),
          if (thirdParty.url['manual'] != "") ...[
            const SizedBox(height: 6),
            _buildActionButton(
              label: isKr ? '사용법 보기' : 'Manual',
              onTap: () async {
                await launchUrl(Uri.parse(thirdParty.url['manual']!));
              },
            ),
          ],
        ],
      );
    });
  }
}
