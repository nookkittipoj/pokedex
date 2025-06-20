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
            Text(statName.toUpperCase()),
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
