import 'package:flutter/material.dart';
import 'package:skillbridge/widgets/button.dart';
import 'package:skillbridge/widgets/text_field.dart';

import 'package:skillbridge/screens/registro_estudiante.dart';
import 'package:skillbridge/screens/registro_empresa.dart';
import 'package:skillbridge/screens/registro_universidad.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  String? selectedRole;
  final List<String> roles = ['Estudiante', 'Empresa', 'Universidad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                            label: 'Correo Electronico',
                            hintText: 'Ingrese su correo electronico',
                          ),
                          const SizedBox(height: 16),

                          const CustomTextField(
                            label: 'Contraseña',
                            hintText: 'Ingrese su contraseña',
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),

                          const CustomTextField(
                            label: 'Confirmar Contraseña',
                            hintText: 'Reingrese su contraseña',
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Rol',
                            style: TextStyle(
                              color: Colors.black,
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
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedRole,
                                hint: const Text('Seleccione su rol'),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
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
                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              text: 'Registrarse',
                              backgroundColor: const Color(0xFF2D2D2D),
                              textColor: Colors.white,
                              borderRadius: 8.0,
                              onPressed: () {
                                //agregar ifs para los otros roles
                                /////
                                if (selectedRole == 'Estudiante') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistroEstudianteScreen(),
                                    ),
                                  );
                                }
                                if (selectedRole == 'Empresa') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistroEmpresaScreen(),
                                    ),
                                  );
                                }
                                if (selectedRole == 'Universidad') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistroUniversidadScreen(),
                                    ),
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
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
