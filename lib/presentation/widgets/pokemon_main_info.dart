import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import 'pokemon_type_badges.dart';

class PokemonMainInfo extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonMainInfo({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Main Sprite
            Hero(
              tag: 'pokemon-front-${pokemon.id}',
              child: Image.network(
                pokemon.frontDefaultUrl,
                height: 100,
              ),
            ),
            const SizedBox(width: 16),
            // Basic Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  PokemonTypeBadges(types: pokemon.types),
                  const SizedBox(height: 8),
                  Text('Height: ${pokemon.height}'),
                  Text('Weight: ${pokemon.weight}'),
                  if (pokemon.abilities != null)
                    Text('Abilities: ${pokemon.abilities!.join(', ')}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
