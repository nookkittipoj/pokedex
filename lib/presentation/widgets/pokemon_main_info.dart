import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import 'pokemon_type_badges.dart';

class PokemonMainInfo extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonMainInfo({super.key, required this.pokemon});

  @override
  State<PokemonMainInfo> createState() => _PokemonMainInfoState();
}

class _PokemonMainInfoState extends State<PokemonMainInfo>
    with SingleTickerProviderStateMixin {
  bool _showFront = true;
  bool _isShiny = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _flipTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });

    _flipTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_showFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      setState(() {
        _showFront = !_showFront;
      });
    });

    _controller.value = 0;
  }

  Future<void> _preloadImages() async {
    final context = this.context;
    final urls = [
      widget.pokemon.frontDefaultUrl,
      widget.pokemon.backDefaultUrl,
      widget.pokemon.frontShinyUrl,
      widget.pokemon.backShinyUrl,
    ];

    for (var url in urls) {
      if (url.isNotEmpty) {
        try {
          await precacheImage(NetworkImage(url), context);
        } catch (e) {
          // ignore errors for missing images
        }
      }
    }
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  void _toggleShiny() {
    setState(() {
      _isShiny = !_isShiny;
    });
  }

  Widget _buildImage() {
    String url;
    if (_showFront && !_isShiny) {
      url = widget.pokemon.frontDefaultUrl;
    } else if (_showFront && _isShiny) {
      url = widget.pokemon.frontShinyUrl;
    } else if (!_showFront && !_isShiny) {
      url = widget.pokemon.backDefaultUrl;
    } else {
      url = widget.pokemon.backShinyUrl;
    }

    return Image.network(
      url,
      key: ValueKey(url),
      height: 100,
      width: 100,
      fit: BoxFit.contain,
    );
  }

  @override
  void dispose() {
    _flipTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              children: [
                Hero(
                  tag: 'pokemon-${widget.pokemon.id}',
                  child: GestureDetector(
                    onTap: _flip,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final angle = _animation.value * 3.1415926535897932;
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: angle <= 3.1415926535897932 / 2
                              ? _buildImage()
                              : Transform(
                                  transform: Matrix4.identity()
                                    ..rotateY(3.1415926535897932),
                                  alignment: Alignment.center,
                                  child: _buildImage(),
                                ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _toggleShiny,
                    child: Text(_isShiny ? 'Show Normal' : 'Show Shiny'),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pokemon.name[0].toUpperCase() +
                        widget.pokemon.name.substring(1),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  PokemonTypeBadges(types: widget.pokemon.types),
                  const SizedBox(height: 8),
                  Text('Height: ${widget.pokemon.height}'),
                  Text('Weight: ${widget.pokemon.weight}'),
                  Text('Abilities: ${widget.pokemon.abilities.join(', ')}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
