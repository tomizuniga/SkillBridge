import 'package:flutter/material.dart';
import 'universidad_detalle_solicitudes_screen.dart'; // Importa la nueva pantalla

class UniversidadSolicitudesScreen extends StatelessWidget {
  const UniversidadSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> trabajosDisponibles = [
      'Trabajo 1',
      'Trabajo 2',
      'Trabajo 3',
      'Trabajo 4',
      'Trabajo 5',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Texto "Ver Solicitudes" convertido en un botón interactivo
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UniversidadDetalleSolicitudesScreen(),
                ),
              );
            },
            child: const Text(
              'Ver Solicitudes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline, // Opcional: para indicar que es clickeable
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Text(
            'Trabajos Disponibles',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.separated(
              itemCount: trabajosDisponibles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAFA2A2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trabajosDisponibles[index],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}