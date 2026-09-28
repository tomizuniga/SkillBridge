import 'package:flutter/material.dart';
import 'package:skillbridge/screens/inicio_sesion.dart';
import 'package:skillbridge/screens/pagina_ingreso.dart';

class DashboardEstudianteScreen extends StatelessWidget {
  const DashboardEstudianteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 100,
              color: Colors.cyanAccent,
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // pagina de perfil
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PantallaIngreso(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cerrar Sesion',
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
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido\nUsuario', //cambiar para que aparezca el usuario
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _OpcionDashboard(
                            titulo: 'Buscar\nTrabajos\nDisponibles',
                            imagenPath: 'assets/images/work.png',
                          ),
                          const SizedBox(height: 32),
                          _OpcionDashboard(
                            titulo: 'Gestionar\npasantia',
                            imagenPath: 'assets/images/internship.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionDashboard extends StatelessWidget {
  final String titulo;
  final String imagenPath;
  const _OpcionDashboard({required this.titulo, required this.imagenPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagenPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFD3D7DC),
                child: const Icon(Icons.image, color: Colors.grey, size: 40),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
