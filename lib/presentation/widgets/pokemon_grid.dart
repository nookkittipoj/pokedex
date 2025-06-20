import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex_clean_architecture/presentation/widgets/pokemon_type_badges.dart';
import '../../domain/entities/pokemon.dart';

class PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemons;
  final Function(Pokemon) onTap;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Pokemon? selectedPokemon;

  const PokemonGrid(
      {Key? key,
      required this.pokemons,
      required this.onTap,
      required this.scrollController,
      required this.isLoadingMore,
      this.selectedPokemon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: pokemons.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= pokemons.length) {
          // Show loading animation for infinite scroll
          return Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: FadeTransition(
                opacity: const AlwaysStoppedAnimation(0.8),
                child: Lottie.asset(
                  'assets/animations/pokeball_lottie.json',
                  repeat: true,
                ),
              ),
            ),
          );
        }

        final pokemon = pokemons[index];

        return GestureDetector(
          onTap: () => onTap(pokemon),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/animations/pokeball.gif',
                    image: pokemon.frontDefaultUrl,
                    height: 90,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                Text(
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                PokemonTypeBadges(types: pokemon.types)
              ],
            ),
          ),
        );
      },
    );
  }
}
