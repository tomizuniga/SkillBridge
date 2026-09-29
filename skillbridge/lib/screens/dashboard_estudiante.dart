import 'package:flutter/material.dart';

class Dashboard_Estudiantes_Screen extends StatelessWidget {
  const Dashboard_Estudiantes_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A101D), // Fondo azul oscuro
      body: SafeArea(
        child: Row(
          children: [
            // ================= PANEL LATERAL (SIDEBAR) =================
            Container(
              width: 100, // Ancho fijo para el panel lateral
              color: const Color(0xFF6A7389), // Color gris/azulado del panel
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de Perfil (cuadrado con bordes redondeados)
                  InkWell(
                    onTap: () {
                      // Navegar a pantalla de perfil
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Bordes estilo Iniciar Sesión
                      ),
                      child: const Center(
                        child: Text(
                          'perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Botón Cerrar Sesión
                  InkWell(
                    onTap: () {
                      // Cierra todas las pantallas abiertas y regresa a la pantalla inicial
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

            // ================= CONTENIDO PRINCIPAL =================
            Expanded(
              child: Column(
                children: [
                  // TERCIO SUPERIOR: Logo
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // DOS TERCIOS INFERIORES: Bienvenida y Opciones
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido\n*Usuario*',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Opción 1: Buscar Trabajos
                          _OpcionDashboard(
                            titulo: 'Buscar\nTrabajos\nDisponibles',
                            // Reemplaza esto con la ruta de tu ícono
                            imagenPath: 'assets/images/work.png',
                          ),
                          const SizedBox(height: 32),

                          // Opción 2: Gestionar Pasantía
                          _OpcionDashboard(
                            titulo: 'Gestionar\npasantia',
                            // Reemplaza esto con la ruta de tu ícono
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

// Widget privado para estandarizar el diseño de las opciones centrales
class _OpcionDashboard extends StatelessWidget {
  final String titulo;
  final String imagenPath;

  const _OpcionDashboard({required this.titulo, required this.imagenPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenedor del ícono
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors
                .transparent, // Fondo transparente para que resalte tu asset
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagenPath,
              fit: BoxFit.contain,
              color: Colors.white,
              // Esto mostrará un ícono de error temporal si aún no subes la imagen a la carpeta assets
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
