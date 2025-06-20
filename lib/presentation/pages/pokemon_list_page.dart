import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_clean_architecture/domain/usecases/get_pokemon_detail.dart';
import 'package:pokedex_clean_architecture/presentation/pages/pokemon_detail_page.dart';
import 'package:pokedex_clean_architecture/presentation/utils/screen_trace_observer.dart';
import 'package:pokedex_clean_architecture/presentation/widgets/pokeball_loader.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import '../widgets/pokemon_detail_card.dart';
import '../widgets/pokemon_grid.dart';

class PokemonListPage extends StatefulWidget {
  final GetPokemonList getPokemonList;
  final GetPokemonDetail getPokemonDetail;

  const PokemonListPage({
    Key? key,
    required this.getPokemonList,
    required this.getPokemonDetail,
  }) : super(key: key);

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  List<Pokemon> pokemons = [];
  Pokemon? selectedPokemon;
  bool isLoading = true;
  bool isLoadingSelect = false;
  int offset = 0;
  final int limit = 20;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialPokemons();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore) {
        loadMorePokemons();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadInitialPokemons() async {
    setState(() => isLoading = true);
    final list = await widget.getPokemonList(offset: offset, limit: limit);
    setState(() {
      pokemons = list;
      selectedPokemon = list.isNotEmpty ? list.first : null;
      offset += limit;
      isLoading = false;
    });
  }

  Future<void> loadMorePokemons() async {
    setState(() => isLoadingMore = true);

    final nextOffset = offset + limit;
    final list = await widget.getPokemonList(offset: offset, limit: limit);

    setState(() {
      pokemons.addAll(list);
      offset = nextOffset;
      isLoadingMore = false;
    });
  }

  void selectPokemon(Pokemon pokemon) async {
    setState(() => isLoadingSelect = true);

    final detail = await widget.getPokemonDetail(pokemon.name);

    setState(() => isLoadingSelect = false);

    if (!mounted) return;

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: animation,
        child: PokemonDetailPage(pokemon: detail),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTraceObserver(
      traceName: 'screen_pokemon_grid',
      initialMetrics: {
        'offset': offset,
        'limit': limit,
        'initial_pokemon_loaded': pokemons.length,
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokedex')),
        body: isLoading
            ? const Center(child: PokeballLoader())
            : PokemonGrid(
                pokemons: pokemons,
                onTap: selectPokemon,
                scrollController: _scrollController,
                isLoadingMore: isLoadingMore,
                selectedPokemon: selectedPokemon,
              ),
      ),
    );
  }
}
