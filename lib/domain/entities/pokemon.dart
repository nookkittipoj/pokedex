class Pokemon {
  final int id;
  final String name;
  final String frontDefaultUrl;
  final String backDefaultUrl;
  final String frontShinyUrl;
  final String backShinyUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<String> abilities;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.frontDefaultUrl,
    required this.backDefaultUrl,
    required this.frontShinyUrl,
    required this.backShinyUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });
}
