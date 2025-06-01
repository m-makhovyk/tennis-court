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
    final optionWidth = 70.0;
    final totalWidth = optionWidth * values.length;
    final selectedIndex = values.indexOf(selectedValue);

    // Calculate alignment: -1.0 (left) to 1.0 (right)
    final alignment = values.length == 1
        ? Alignment.center
        : Alignment(-1.0 + (2.0 * selectedIndex / (values.length - 1)), 0.0);

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
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: alignment,
              child: Container(
                width: optionWidth - 4,
                height: 40,
                margin: const EdgeInsets.all(2),
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
                ...values.map(
                  (value) => _buildToggleOption(
                    context,
                    value,
                    optionWidth,
                    isSelected: selectedValue == value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    BuildContext context,
    T value,
    double width, {
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
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
