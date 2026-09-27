import 'package:flutter/material.dart';
import 'package:skillbridge/screens/inicio_sesion.dart';
import 'package:skillbridge/widgets/button.dart';

class PantallaIngreso extends StatelessWidget {
  const PantallaIngreso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      text: 'Iniciar Sesion',
                      onPressed: () {
                        // Navegar a la pantalla de inicio de sesión
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InicioSesionScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Button(
                      text: 'Registrarse',
                      onPressed: () {
                        // Navegar a la pantalla de registro
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
