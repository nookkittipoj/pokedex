import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonList {
  final PokemonRepository repository;

  GetPokemonList(this.repository);

  Future<List<Pokemon>> call({int offset = 0, int limit = 20}) {
    return repository.getPokemonList(offset: offset, limit: limit);
  }
}
