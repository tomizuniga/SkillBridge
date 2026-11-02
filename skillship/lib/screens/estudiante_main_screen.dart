import 'package:flutter/material.dart';
import 'package:skillship/screens/estudiante_detalle_trabajo_screen.dart';
import 'buscar_trabajos_estudiante.dart';
import 'gestionar_pasantia_estudiante.dart';

class EstudianteMainScreen extends StatefulWidget {
  const EstudianteMainScreen({super.key});

  @override
  State<EstudianteMainScreen> createState() => _EstudianteMainScreenState();
}

class _EstudianteMainScreenState extends State<EstudianteMainScreen> {
  // Índice para controlar qué pantalla se muestra (0: Buscar Trabajos, 1: Gestionar Pasantía)
  int _currentIndex = 0;

  // Lista de las pantallas que corresponden a cada pestaña
  final List<Widget> _screens = [
    const BuscarTrabajosScreenContent(), // Versión adaptada sin Scaffold interno para la barra
    const GestionarPasantiaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
                  // Botón de Perfil
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

                  // Botón Cerrar Sesión
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

            // ================= CONTENIDO CAMBIANTE SEGÚN LA PESTAÑA =================
            Expanded(
              child: _screens[_currentIndex],
            ),
          ],
        ),
      ),
      // ================= BARRA DE NAVEGACIÓN INFERIOR =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF161F33),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar Trabajos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Gestionar Pasantía',
          ),
        ],
      ),
    );
  }
}

// Versión limpia de la vista de búsqueda de trabajos (sin Scaffold propio para evitar conflictos con el BottomBar)
class BuscarTrabajosScreenContent extends StatelessWidget {
  const BuscarTrabajosScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> trabajos = [
      {'titulo': 'Trabajo 1', 'descripcion': 'Descripcion'},
      {'titulo': 'Trabajo 2', 'descripcion': 'Descripcion'},
      {'titulo': 'Trabajo 3', 'descripcion': 'Descripcion'},
      {'titulo': 'Trabajo 4', 'descripcion': 'Descripcion'},
      {'titulo': 'Trabajo 5', 'descripcion': 'Descripcion'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Reemplaza la parte del ListView.separated dentro de BuscarTrabajosScreenContent con esto:

Expanded(
  child: ListView.separated(
    itemCount: trabajos.length,
    separatorBuilder: (context, index) => const SizedBox(height: 12),
    itemBuilder: (context, index) {
      final trabajoActual = trabajos[index];
      return InkWell(
        onTap: () {
          // Navega a los detalles del trabajo del estudiante
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EstudianteDetalleTrabajoScreen(
                tituloTrabajo: trabajoActual['titulo']!,
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
                trabajoActual['titulo']!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                trabajoActual['descripcion']!,
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