import 'package:flutter/material.dart';

/// A component for selecting note colors
class ColorSelector extends StatelessWidget {
  static const noteColors = [
    Colors.indigo,
    Colors.green, // Emerald
    Colors.redAccent,
    Colors.blueAccent,
    Colors.brown,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
  ];

  final Color selectedColor;
  final Function(Color) onColorSelected;
  final String title;

  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.palette_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildColorGrid(context),
      ],
    );
  }

  /// Builds the horizontal list of color options
  Widget _buildColorGrid(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: noteColors.length,
        itemBuilder: (context, index) {
          final color = noteColors[index];
          final isSelected = selectedColor == color;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        )
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
} 