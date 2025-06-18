import '../../domain/entities/pokemon.dart';

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
        );

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
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
    );
  }
}
