import 'package:flutter/material.dart';
import 'empresa_detalle_pasante_screen.dart'; // Importa la nueva pantalla

class EmpresaGestionarPasantesScreen extends StatelessWidget {
  const EmpresaGestionarPasantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> pasantes = [
      'Pasante 1',
      'Pasante 2',
      'Pasante 3',
      'Pasante 4',
      'Pasante 5',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: pasantes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pasanteActual = pasantes[index];
                return InkWell(
                  onTap: () {
                    // Navega a la pantalla de detalles del pasante seleccionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmpresaDetallePasanteScreen(
                          nombrePasante: pasanteActual,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAFA2A2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pasanteActual,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
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