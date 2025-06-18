import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonDetail {
  final PokemonRepository repository;

  GetPokemonDetail(this.repository);

  Future<Pokemon> call(String url) {
    return repository.getPokemonDetail(url);
  }
}
