import 'package:pokedex_clean_architecture/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel({
    required int id,
    required String name,
    required String frontDefaultUrl,
    required String backDefaultUrl,
    required String frontShinyUrl,
    required String backShinyUrl,
    required List<String> types,
    required int height,
    required int weight,
    required List<String> abilities,
    required Map<String, int> stats,
  }) : super(
          id: id,
          name: name,
          frontDefaultUrl: frontDefaultUrl,
          backDefaultUrl: backDefaultUrl,
          frontShinyUrl: frontShinyUrl,
          backShinyUrl: backShinyUrl,
          types: types,
          height: height,
          weight: weight,
          abilities: abilities,
          stats: stats,
        );

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final statsMap = <String, int>{};
    for (var stat in json['stats']) {
      final name = stat['stat']['name'];
      final value = stat['base_stat'];
      statsMap[name] = value;
    }

    final abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    return PokemonModel(
      id: json['id'],
      name: json['name'],
      frontDefaultUrl: json['sprites']['front_default'] ?? '',
      backDefaultUrl: json['sprites']['back_default'] ?? '',
      frontShinyUrl: json['sprites']['front_shiny'] ?? '',
      backShinyUrl: json['sprites']['back_shiny'] ?? '',
      types: (json['types'] as List)
          .map((t) => t['type']['name'].toString())
          .toList(),
      height: json['height'],
      weight: json['weight'],
      abilities: abilitiesList,
      stats: statsMap,
    );
  }
}
