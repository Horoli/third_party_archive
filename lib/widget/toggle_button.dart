part of third_party_archive;

/// 앱 전역에서 사용하는 amber 테마 토글 버튼
class WidgetToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const WidgetToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.amber.withAlpha(50)
              : Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white.withAlpha(30),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.amber : Colors.white54,
            fontSize: fontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
