import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
import '../../domain/entities/pokemon.dart';
import '../widgets/pokemon_main_info.dart';
import '../widgets/pokemon_stats_chart.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Trace _trace;

  @override
  void initState() {
    super.initState();
    _startPerformanceTrace();
  }

  Future<void> _startPerformanceTrace() async {
    _trace = FirebasePerformance.instance
        .newTrace('screen_pokemon_detail_${widget.pokemon.name}');
    await _trace.start();
    _trace.setMetric('types_count', widget.pokemon.types.length);
  }

  @override
  void dispose() {
    _trace.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '#${pokemon.id.toString().padLeft(3, '0')} ${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PokemonMainInfo(pokemon: pokemon),
            const SizedBox(height: 16),
            PokemonStatsChart(stats: pokemon.stats),
          ],
        ),
      ),
    );
  }
}
