import 'package:flutter/material.dart';
import 'universidad_detalle_alumno_screen.dart'; // Importa la nueva pantalla

class UniversidadGestionarAlumnosScreen extends StatelessWidget {
  const UniversidadGestionarAlumnosScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final List<Map<String, String>> alumnos = [
      {'nombre': 'Alumno 1', 'detalle': 'Descripcion'},
      {'nombre': 'Alumno 2', 'detalle': 'Descripcion'},
      {'nombre': 'Alumno 3', 'detalle': 'Descripcion'},
      {'nombre': 'Alumno 4', 'detalle': 'Descripcion'},
      {'nombre': 'Alumno 5', 'detalle': 'Descripcion'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: alumnos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alumno = alumnos[index];
                return InkWell(
                  onTap: () {
                    // Navega a la pantalla de detalles del alumno seleccionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversidadDetalleAlumnoScreen(
                          nombreAlumno: alumno['nombre']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAFA2A2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alumno['nombre']!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alumno['detalle']!,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
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