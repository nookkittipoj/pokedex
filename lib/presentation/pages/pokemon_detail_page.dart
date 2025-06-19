import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
import '../../domain/entities/pokemon.dart';
import '../widgets/pokemon_detail_card.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Trace _trace;
  bool _isLoadingSelect = true;

  @override
  void initState() {
    super.initState();
    _startPerformanceTrace();
    _simulateLoad();
  }

  Future<void> _startPerformanceTrace() async {
    _trace = FirebasePerformance.instance
        .newTrace('screen_pokemon_detail_${widget.pokemon.name}');
    await _trace.start();
    _trace.setMetric('types_count', widget.pokemon.types.length);
  }

  Future<void> _simulateLoad() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoadingSelect = false;
      });
    }
  }

  @override
  void dispose() {
    _trace.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name[0].toUpperCase() +
            widget.pokemon.name.substring(1)),
      ),
      body: PokemonDetailCard(
        pokemon: widget.pokemon,
        isLoadingSelect: _isLoadingSelect,
      ),
    );
  }
}
