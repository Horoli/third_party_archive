part of third_party_archive;

class HoverImageButton extends StatefulWidget {
  Widget child;
  VoidCallback onPressed;
  HoverImageButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  @override
  State<HoverImageButton> createState() => HoverImageButtonState();
}

class HoverImageButtonState extends State<HoverImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrlAnimation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrlAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: ctrlAnimation.value,
          child: child,
        );
      },
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) {
          if (value) {
            ctrlAnimation.forward();
          } else {
            ctrlAnimation.value = 0.5;
          }
        },
        child: widget.child,
        //  Image.asset(
        //   IMAGE.ONE_LOGO,
        //   scale: ctrlAnimation.value,
        // ),
      ),
    );
  }

  @override
  void initState() {
    // init();
    super.initState();
    initController();
  }

  void initController() {
    ctrlAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.5,
    );

    // oneAnimation = CurvedAnimation(
    //   parent: ctrlOne,
    //   curve: Curves.easeIn,
    // );
  }

  @override
  void dispose() {
    super.dispose();
    ctrlAnimation.dispose();
  }
}
