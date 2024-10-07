part of third_party_archive;

class HoverButton extends StatefulWidget {
  Widget child;
  Widget hoverChild;
  double hoverWidth;
  VoidCallback? onPressed;
  void Function(PointerEnterEvent)? onEnter;
  void Function(PointerExitEvent)? onExit;
  void Function(PointerHoverEvent)? onHover;
  HoverButton({
    required this.child,
    required this.hoverChild,
    this.hoverWidth = 50,
    this.onEnter,
    this.onExit,
    this.onHover,
    this.onPressed,
    super.key,
  });

  @override
  HoverButtonState createState() => HoverButtonState();
}

class HoverButtonState extends State<HoverButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.alias,
      onHover: widget.onHover,
      onEnter: widget.onEnter,
      onExit: widget.onExit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 55,
            child: InkWell(
              onTap: widget.onPressed,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
