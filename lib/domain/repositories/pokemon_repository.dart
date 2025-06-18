import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemonList(
      {required int offset, required int limit});
  Future<Pokemon> getPokemonDetail(String name);
}
