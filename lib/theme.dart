import 'package:flutter/material.dart';

/// Colores de la app, inspirados en el estilo Pokémon.
class AppColors {
  static const rojo = Color(0xFFE3350D);
  static const rojoOscuro = Color(0xFF9E1B32);
  static const amarillo = Color(0xFFFFCB05);
  static const azul = Color(0xFF2A75BB);
  static const fondoClaro = Color(0xFFF6F6F6);
}

/// Color de cada tipo de Pokémon (para las etiquetas y el detalle).
const Map<String, Color> coloresTipo = {
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

/// Nombre de cada tipo en español.
const Map<String, String> nombresTipo = {
  'normal': 'Normal',
  'fire': 'Fuego',
  'water': 'Agua',
  'electric': 'Eléctrico',
  'grass': 'Planta',
  'ice': 'Hielo',
  'fighting': 'Lucha',
  'poison': 'Veneno',
  'ground': 'Tierra',
  'flying': 'Volador',
  'psychic': 'Psíquico',
  'bug': 'Bicho',
  'rock': 'Roca',
  'ghost': 'Fantasma',
  'dragon': 'Dragón',
  'dark': 'Siniestro',
  'steel': 'Acero',
  'fairy': 'Hada',
};

Color colorDeTipo(String tipo) => coloresTipo[tipo] ?? Colors.grey;
