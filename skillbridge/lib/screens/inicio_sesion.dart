
import 'package:flutter/material.dart';
import 'package:skillbridge/screens/dashboard_Empresa.dart';
import 'package:skillbridge/screens/dashboard_universidad.dart';
import 'package:skillbridge/widgets/button.dart';
import 'package:skillbridge/screens/dashBoard_Estudiante.dart';
import 'package:skillbridge/widgets/text_field.dart';

class InicioSesionScreen extends StatefulWidget {
  const InicioSesionScreen({super.key});

  @override
  State<InicioSesionScreen> createState() => _InicioSesionScreenState();
}
class _InicioSesionScreenState() extends State<InicioSesionScreen> {
  String? selectedRole;
  final List<String> roles = ['Estudiante', 'Universidad', 'Empresa'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A101D),
      body: SafeArea(
        // ================= INICIO DEL STACK =================
        child: Stack(
          children: [
            
            // --- CAPA 1: Tu diseño original (El fondo, el logo y el formulario) ---
            Column(
              children: [
                // TERCIO SUPERIOR: EL LOGO
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

                // DOS TERCIOS INFERIORES: EL FORMULARIO
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextField(
                            label: 'Email',
                            hintText: 'Value',
                          ),
                          const SizedBox(height: 20),
                          const CustomTextField(
                            label: 'Password',
                            hintText: 'Value',
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Rol',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedRole,
                                hint: const Text('Value'),
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: roles.map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRole = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),

                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              text: 'Iniciar Sesión',
                              backgroundColor: const Color(0xFF2D2D2D),
                              textColor: Colors.white,
                              borderRadius: 8.0,
                              onPressed: () {
  // 1. Verificamos que el usuario haya seleccionado un rol
                                  if (selectedRole == null) {
                                    // Muestra un mensajito en la parte inferior si intentan avanzar sin elegir
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Por favor, seleccione un rol para ingresar al prototipo'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return; // Detiene la ejecución aquí
                                  }

                                  // 2. Navegación condicional basada en el rol seleccionado
                                  if (selectedRole == 'Estudiante') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Dashboard_Estudiantes_Screen()),
                                    );
                                  } else if (selectedRole == 'Empresa') {
                                    // Aquí pondrás la pantalla de Empresa cuando la creemos
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Dashboard_Empresa_Screen()),
                                    );
                            
                                    
                                  } else if (selectedRole == 'Universidad') {
                                    // Aquí pondrás la pantalla de Universidad cuando la creemos
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Dashboard_Universidad_Screen()),
                                    );
                                    
                                  
                                  }
                                },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ), 
            // --- FIN DE LA CAPA 1 ---

            // --- CAPA 2: El botón flotante para regresar ---
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
            ),
            // --- FIN DE LA CAPA 2 ---

          ], // Fin de los children del Stack
        ), 
      ), // Fin del SafeArea
    ); // Fin del Scaffold
  }
}


