import 'package:flutter/material.dart';

import '../theme.dart';
import 'pokemon_list_screen.dart';

/// Pantalla de inicio de Movisee con estilo Pokémon.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // STACK: imagen de fondo + capas + contenido
      body: Stack(
        fit: StackFit.expand,
        children: [
          // IMAGE: fondo rojo y amarillo
          Image.asset('assets/images/fondo.jpg', fit: BoxFit.cover),

          // Círculos decorativos
          Positioned(
            top: -60,
            right: -60,
            child: _Circulo(tamano: 220, color: Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: _Circulo(
                tamano: 260, color: AppColors.amarillo.withOpacity(0.15)),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ICON: icono principal
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.amarillo, width: 5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 6)),
                      ],
                    ),
                    child: const Icon(Icons.catching_pokemon,
                        size: 80, color: AppColors.rojo),
                  ),
                  const SizedBox(height: 24),

                  // TEXT: nombre de la app
                  const Text(
                    'Movisee',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: AppColors.amarillo,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                            color: AppColors.azul,
                            offset: Offset(3, 3),
                            blurRadius: 0),
                      ],
                    ),
                  ),
                  const Text(
                    'POKÉDEX',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TEXT: Hello World
                  const Text(
                    'Hello World',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 12),

                  // TEXT: mensaje de bienvenida
                  const Text(
                    '¡Bienvenido, entrenador! Descubre a los 151 Pokémon '
                    'originales: sus tipos, habilidades y estadísticas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.white, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // ROW: tres datos rápidos
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Dato(icono: Icons.catching_pokemon, texto: '151'),
                      SizedBox(width: 12),
                      _Dato(icono: Icons.category, texto: '18 tipos'),
                      SizedBox(width: 12),
                      _Dato(icono: Icons.bar_chart, texto: 'Stats'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PokemonListScreen()),
                    ),
                    icon: const Icon(Icons.search),
                    label: const Text('¡Atrápalos ya!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.amarillo,
                      foregroundColor: AppColors.azul,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circulo extends StatelessWidget {
  final double tamano;
  final Color color;
  const _Circulo({required this.tamano, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _Dato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(texto,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
