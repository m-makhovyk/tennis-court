import 'package:flutter/material.dart';
import '../services/player_service.dart';

class SegmentedToggle<T extends Enum> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<T> values;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    // Measure text widths
    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final optionWidths = values
        .map(
          (value) =>
              _measureTextWidth(labelBuilder(value), textStyle) +
              32, // 32 for padding
        )
        .toList();

    final totalWidth = optionWidths.reduce((a, b) => a + b);
    final selectedIndex = values.indexOf(selectedValue);

    // Calculate position for animated background
    double backgroundLeft = 0;
    for (int i = 0; i < selectedIndex; i++) {
      backgroundLeft += optionWidths[i];
    }
    backgroundLeft += 2; // Margin offset

    return SizedBox(
      width: totalWidth,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: backgroundLeft,
              top: 2,
              child: Container(
                width: optionWidths[selectedIndex] - 4,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                ...values.asMap().entries.map(
                  (entry) => _buildToggleOption(
                    context,
                    entry.value,
                    optionWidths[entry.key],
                    textStyle,
                    isSelected: selectedValue == entry.value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _measureTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  Widget _buildToggleOption(
    BuildContext context,
    T value,
    double width,
    TextStyle textStyle, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          labelBuilder(value),
          style: textStyle.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// Convenience wrapper for RankingType
class RankingTypeToggle extends StatelessWidget {
  const RankingTypeToggle({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final RankingType selectedType;
  final ValueChanged<RankingType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedToggle<RankingType>(
      values: RankingType.values,
      selectedValue: selectedType,
      onChanged: onChanged,
      labelBuilder: (type) => type.rawValue.toUpperCase(),
    );
  }
}
