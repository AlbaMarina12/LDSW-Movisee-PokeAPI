import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/poke_api.dart';
import '../theme.dart';
import 'pokemon_detail_screen.dart';

/// Lista de Pokémon obtenida con una petición HTTP a la PokéAPI.
class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final _api = PokeApi();
  final _buscador = TextEditingController();

  // Se guarda el Future en initState para no repetir la petición
  // cada vez que la pantalla se redibuja (recomendación del cookbook).
  late Future<List<PokemonResumen>> _futuraLista;

  @override
  void initState() {
    super.initState();
    _futuraLista = _api.obtenerLista();
  }

  @override
  void dispose() {
    _buscador.dispose();
    super.dispose();
  }

  void _reintentar() {
    setState(() => _futuraLista = _api.obtenerLista());
  }

  void _abrirDetalle(String nombreONumero) {
    if (nombreONumero.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PokemonDetailScreen(nombreONumero: nombreONumero),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      appBar: AppBar(
        title: const Text('Pokédex · Movisee',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.rojo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Buscador: consulta cualquier Pokémon por nombre o número
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscador,
              textInputAction: TextInputAction.search,
              onSubmitted: _abrirDetalle,
              decoration: InputDecoration(
                hintText: 'Busca un Pokémon (ej. pikachu, 25)',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _abrirDetalle(_buscador.text),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // FutureBuilder: muestra carga, error o los datos
          Expanded(
            child: FutureBuilder<List<PokemonResumen>>(
              future: _futuraLista,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.rojo));
                }
                if (snapshot.hasError) {
                  return _MensajeError(
                    mensaje: '${snapshot.error}',
                    onReintentar: _reintentar,
                  );
                }

                final lista = snapshot.data ?? [];
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final p = lista[i];
                    return _TarjetaPokemon(
                      pokemon: p,
                      onTap: () => _abrirDetalle(p.nombre),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaPokemon extends StatelessWidget {
  final PokemonResumen pokemon;
  final VoidCallback onTap;

  const _TarjetaPokemon({required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.amarillo, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                // Imagen descargada de internet
                child: Image.network(
                  pokemon.imagenUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.catching_pokemon, size: 48),
                ),
              ),
              const SizedBox(height: 6),
              Text('#${pokemon.id}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.rojo,
                      fontWeight: FontWeight.bold)),
              Text(
                _capitalizar(pokemon.nombre),
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _MensajeError({required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: onReintentar, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}

String _capitalizar(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
