/// Modelos que representan los datos que devuelve la PokéAPI.
/// Cada modelo tiene un constructor `fromJson` que convierte
/// el JSON de la respuesta HTTP en un objeto de Dart.

const String _artworkBase =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';

/// Elemento de la lista: GET https://pokeapi.co/api/v2/pokemon?limit=...
class PokemonResumen {
  final int id;
  final String nombre;

  const PokemonResumen({required this.id, required this.nombre});

  /// La lista solo trae `name` y `url`; el id se saca de la url
  /// (por ejemplo .../pokemon/25/ -> 25).
  factory PokemonResumen.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final partes = url.split('/').where((p) => p.isNotEmpty).toList();
    return PokemonResumen(
      id: int.parse(partes.last),
      nombre: json['name'] as String,
    );
  }

  String get imagenUrl => '$_artworkBase/$id.png';
}

/// Detalle: GET https://pokeapi.co/api/v2/pokemon/{nombre}
class PokemonDetalle {
  final int id;
  final String nombre;
  final int altura; // en decímetros
  final int peso; // en hectogramos
  final List<String> tipos;
  final Map<String, int> estadisticas;
  final String imagenUrl;

  const PokemonDetalle({
    required this.id,
    required this.nombre,
    required this.altura,
    required this.peso,
    required this.tipos,
    required this.estadisticas,
    required this.imagenUrl,
  });

  factory PokemonDetalle.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;

    final tipos = (json['types'] as List)
        .map((t) => (t['type']['name'] as String))
        .toList();

    final estadisticas = <String, int>{
      for (final s in json['stats'] as List)
        s['stat']['name'] as String: s['base_stat'] as int,
    };

    final artwork =
        json['sprites']?['other']?['official-artwork']?['front_default'];

    return PokemonDetalle(
      id: id,
      nombre: json['name'] as String,
      altura: json['height'] as int,
      peso: json['weight'] as int,
      tipos: tipos,
      estadisticas: estadisticas,
      imagenUrl: (artwork as String?) ?? '$_artworkBase/$id.png',
    );
  }

  double get alturaMetros => altura / 10;
  double get pesoKg => peso / 10;
}
