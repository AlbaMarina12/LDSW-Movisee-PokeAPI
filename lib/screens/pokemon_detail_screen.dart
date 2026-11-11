import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/poke_api.dart';
import '../theme.dart';

/// Detalle de un Pokémon: hace una segunda petición HTTP
/// a https://pokeapi.co/api/v2/pokemon/{nombre}.
class PokemonDetailScreen extends StatefulWidget {
  final String nombreONumero;

  const PokemonDetailScreen({super.key, required this.nombreONumero});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Future<PokemonDetalle> _futuroDetalle;

  @override
  void initState() {
    super.initState();
    _futuroDetalle = PokeApi().obtenerDetalle(widget.nombreONumero);
  }

  static const Map<String, String> _nombresStats = {
    'hp': 'PS',
    'attack': 'Ataque',
    'defense': 'Defensa',
    'special-attack': 'At. especial',
    'special-defense': 'Def. especial',
    'speed': 'Velocidad',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.rojo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PokemonDetalle>(
        future: _futuroDetalle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.rojo));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '${snapshot.error}'.replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final p = snapshot.data!;
          final colorPrincipal = colorDeTipo(p.tipos.first);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorPrincipal, colorPrincipal.withOpacity(0.55)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(p.imagenUrl, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              Text(
                '#${p.id} ${p.nombre[0].toUpperCase()}${p.nombre.substring(1)}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: p.tipos
                    .map((t) => Chip(
                          label: Text(
                            (nombresTipo[t] ?? t).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: colorDeTipo(t),
                          side: BorderSide.none,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Dato(
                      icono: Icons.height,
                      valor: '${p.alturaMetros} m',
                      etiqueta: 'Altura'),
                  _Dato(
                      icono: Icons.monitor_weight_outlined,
                      valor: '${p.pesoKg} kg',
                      etiqueta: 'Peso'),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Estadísticas base',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...p.estadisticas.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 110,
                          child: Text(_nombresStats[e.key] ?? e.key)),
                      SizedBox(
                          width: 36,
                          child: Text('${e.value}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (e.value / 200).clamp(0.0, 1.0),
                          minHeight: 8,
                          color: colorPrincipal,
                          backgroundColor: colorPrincipal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;

  const _Dato(
      {required this.icono, required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: AppColors.rojo),
        const SizedBox(height: 4),
        Text(valor,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(etiqueta, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
