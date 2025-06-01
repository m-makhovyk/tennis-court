import 'package:flutter/material.dart';
import '../services/player_service.dart';

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
    return SizedBox(
      width: 140,
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
              alignment: selectedType == RankingType.values.first
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 68,
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
                ...RankingType.values.map(
                  (type) => _buildToggleOption(
                    context,
                    type,
                    isSelected: selectedType == type,
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
    RankingType type, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(type),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 70,
        height: 44,
        alignment: Alignment.center,
        child: Text(
          type.rawValue.toUpperCase(),
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
