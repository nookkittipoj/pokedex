import 'package:flutter/material.dart';

class PokemonTypeColor {
  static Color getColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.green;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'bug':
        return Colors.lightGreen;
      case 'electric':
        return Colors.amber;
      case 'psychic':
        return Colors.purple;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pinkAccent;
      case 'poison':
        return Colors.deepPurple;
      case 'ground':
        return Colors.brown;
      case 'fighting':
        return Colors.orange;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurpleAccent;
      case 'steel':
        return Colors.blueGrey;
      case 'flying':
        return Colors.lightBlueAccent;
      case 'normal':
      default:
        return Colors.black54;
    }
  }
}
