import 'package:flutter/material.dart';
import 'universidad_aceptar_solicitud_screen.dart'; // Importa la pantalla de detalles

class UniversidadDetalleSolicitudesScreen extends StatelessWidget {
  const UniversidadDetalleSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> trabajos = [
      'Trabajo 1',
      'Trabajo 2',
      'Trabajo 3',
      'Trabajo 4',
      'Trabajo 5',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A101D),
      body: SafeArea(
        child: Row(
          children: [
            // ================= PANEL LATERAL (SIDEBAR FIJO) =================
            Container(
              width: 100,
              color: const Color(0xFF6A7389),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cerrar Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Icon(Icons.logout, color: Colors.black, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= LISTA DE SOLICITUDES =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: trabajos.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final trabajoActual = trabajos[index];
                          return InkWell(
                            onTap: () {
                              // Navega a la pantalla de detalles al tocar cualquier trabajo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UniversidadAceptarSolicitudScreen(
                                    tituloTrabajo: trabajoActual,
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
                              child: Text(
                                trabajoActual,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}