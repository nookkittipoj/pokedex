import 'package:flutter/material.dart';
import 'package:pokedex_clean_architecture/presentation/widgets/pokeball_loader.dart';
import 'package:pokedex_clean_architecture/presentation/widgets/pokemon_type_badges.dart';
import '../../domain/entities/pokemon.dart';

class PokemonDetailCard extends StatelessWidget {
  final Pokemon? pokemon;
  final bool? isLoadingSelect;

  const PokemonDetailCard({Key? key, this.pokemon, this.isLoadingSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pokemon == null) {
      return const Center(child: Text('No Pokémon selected'));
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: isLoadingSelect == true
            ? const Center(
                key: ValueKey('loader'),
                child: PokeballLoader(),
              )
            : Row(
                key: const ValueKey('content'),
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'pokemon-front-${pokemon!.id}',
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/animations/pokeball.gif',
                            image: pokemon!.frontDefaultUrl,
                            height: 90,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/animations/pokeball.gif',
                          image: pokemon!.frontShinyUrl,
                          height: 90,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/animations/pokeball.gif',
                          image: pokemon!.backDefaultUrl,
                          height: 90,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/animations/pokeball.gif',
                          image: pokemon!.backShinyUrl,
                          height: 90,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pokemon!.name[0].toUpperCase() +
                              pokemon!.name.substring(1),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        PokemonTypeBadges(types: pokemon!.types),
                        const SizedBox(height: 4),
                        Text(
                          'Height: ${pokemon!.height}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Weight: ${pokemon!.weight}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
