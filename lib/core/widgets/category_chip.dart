import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  String get _displayLabel {
    return label
        .split('-')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          _displayLabel,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: theme.chipTheme.backgroundColor,
        selectedColor: theme.colorScheme.primary,
        checkmarkColor: theme.colorScheme.onPrimary,
        showCheckmark: false,
      ),
    );
  }
}
