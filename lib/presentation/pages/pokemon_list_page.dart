import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_clean_architecture/domain/usecases/get_pokemon_detail.dart';
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
  Trace? _gridScreenTrace;
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
    _startGridScreenTrace();
    loadInitialPokemons();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore) {
        loadMorePokemons();
      }
    });
  }

  Future<void> _startGridScreenTrace() async {
    _gridScreenTrace =
        FirebasePerformance.instance.newTrace('screen_pokemon_grid');
    await _gridScreenTrace?.start();
    _gridScreenTrace?.setMetric('offset', offset);
    _gridScreenTrace?.setMetric('limit', limit);
    _gridScreenTrace?.setMetric('initial_pokemon_loaded', pokemons.length);
  }

  @override
  void dispose() {
    _gridScreenTrace?.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadInitialPokemons() async {
    setState(() => isLoading = true);
    final list = await widget.getPokemonList(offset: offset, limit: limit);
    _gridScreenTrace?.setMetric('first_batch_loaded', list.length);
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

    final trace = FirebasePerformance.instance
        .newTrace('screen_pokemon_detail_${pokemon.name}');
    await trace.start();

    final detail = await widget.getPokemonDetail(pokemon.name);

    trace.setMetric('types_count', detail.types.length);
    await trace.stop();

    setState(() {
      selectedPokemon = detail;
      isLoadingSelect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex')),
      body: isLoading
          ? const Center(child: PokeballLoader())
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: PokemonDetailCard(
                      pokemon: selectedPokemon,
                      isLoadingSelect: isLoadingSelect),
                ),
                Expanded(
                  flex: 2,
                  child: PokemonGrid(
                    pokemons: pokemons,
                    onTap: selectPokemon,
                    scrollController: _scrollController,
                    isLoadingMore: isLoadingMore,
                    selectedPokemon: selectedPokemon,
                  ),
                ),
              ],
            ),
    );
  }
}
