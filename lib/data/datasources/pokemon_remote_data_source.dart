import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import '../models/pokemon_model.dart';

/// Abstract class to define the contract for remote data operations.
abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemonList({
    required int offset,
    required int limit,
  });

  Future<PokemonModel> getPokemonDetail(String name);
}

/// Concrete implementation that uses Dio for HTTP requests and Firebase Performance.
class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio dio;

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  PokemonRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PokemonModel>> getPokemonList({
    required int offset,
    required int limit,
  }) async {
    final url = '$_baseUrl?offset=$offset&limit=$limit';
    final metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    metric.putAttribute('request_type', 'list');

    await metric.start();
    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
        options: Options(extra: {'noLoading': true}),
      );

      final results = response.data['results'] as List;

      final pokemons = await Future.wait(results.map((item) async {
        return _fetchDetailWithTracking(item['url']);
      }));

      return pokemons;
    } catch (e) {
      rethrow;
    } finally {
      await metric.stop();
    }
  }

  @override
  Future<PokemonModel> getPokemonDetail(String name) async {
    final url = '$_baseUrl/$name';
    final metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    metric.putAttribute('request_type', 'detail');

    await metric.start();
    try {
      final response = await dio.get(url);
      return PokemonModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    } finally {
      await metric.stop();
    }
  }

  /// Helper method to fetch detail by URL with Firebase performance tracking.
  Future<PokemonModel> _fetchDetailWithTracking(String url) async {
    final metric =
        FirebasePerformance.instance.newHttpMetric(url, HttpMethod.Get);
    metric.putAttribute('request_type', 'detail');

    await metric.start();
    try {
      final response = await dio.get(url);
      return PokemonModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    } finally {
      await metric.stop();
    }
  }
}
