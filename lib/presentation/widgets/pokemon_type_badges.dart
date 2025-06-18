import 'package:flutter/material.dart';
import 'package:pokedex_clean_architecture/presentation/utils/pokemon_type_color.dart';

class PokemonTypeBadges extends StatelessWidget {
  final List<String> types;
  final double fontSize;
  final FontWeight fontWeight;

  const PokemonTypeBadges(
      {Key? key,
      required this.types,
      this.fontSize = 10,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: types.map((type) {
        final color = PokemonTypeColor.getColor(type);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type[0].toUpperCase() + type.substring(1),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        );
      }).toList(),
    );
  }
}
