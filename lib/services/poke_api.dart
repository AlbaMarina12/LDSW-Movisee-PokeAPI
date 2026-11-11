import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

/// Servicio que hace las peticiones HTTP a la PokéAPI.
/// Sigue el procedimiento del cookbook "Obtener datos desde internet":
/// 1. Hacer la petición con el paquete http.
/// 2. Revisar el código de estado (200 = OK).
/// 3. Convertir el JSON en objetos de Dart.
/// 4. Lanzar una excepción si algo falla.
class PokeApi {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  final http.Client _client;

  PokeApi({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene una lista de Pokémon (por defecto los primeros 151).
  Future<List<PokemonResumen>> obtenerLista({int limite = 151}) async {
    final respuesta =
        await _client.get(Uri.parse('$_baseUrl/pokemon?limit=$limite'));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
      final resultados = datos['results'] as List;
      return resultados
          .map((e) => PokemonResumen.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'No se pudo cargar la lista (código ${respuesta.statusCode})');
    }
  }

  /// Obtiene el detalle de un Pokémon por nombre o número.
  Future<PokemonDetalle> obtenerDetalle(String nombreONumero) async {
    final consulta = nombreONumero.trim().toLowerCase();
    final respuesta =
        await _client.get(Uri.parse('$_baseUrl/pokemon/$consulta'));

    if (respuesta.statusCode == 200) {
      return PokemonDetalle.fromJson(
          jsonDecode(respuesta.body) as Map<String, dynamic>);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No se encontró el Pokémon "$nombreONumero"');
    } else {
      throw Exception(
          'No se pudo cargar el Pokémon (código ${respuesta.statusCode})');
    }
  }
}
