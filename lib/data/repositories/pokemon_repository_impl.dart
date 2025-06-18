import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Pokemon>> getPokemonList({
    required int offset,
    required int limit,
  }) {
    return remoteDataSource.getPokemonList(offset: offset, limit: limit);
  }

  @override
  Future<Pokemon> getPokemonDetail(String name) {
    return remoteDataSource.getPokemonDetail(name);
  }
}
