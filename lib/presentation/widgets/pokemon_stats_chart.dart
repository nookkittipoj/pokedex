import 'package:flutter/material.dart';

class PokemonStatsChart extends StatelessWidget {
  final Map<String, int> stats;

  const PokemonStatsChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stats.entries.map((entry) {
        final statName = entry.key;
        final value = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statName.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  value.toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: value / 150,
              backgroundColor: Colors.grey[300],
              color: Colors.redAccent,
              minHeight: 8,
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}
