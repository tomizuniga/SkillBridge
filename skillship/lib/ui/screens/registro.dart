import 'package:flutter/material.dart';
import 'package:skillship/ui/widgets/button.dart';
import 'package:skillship/ui/widgets/text_field.dart';

import 'package:skillship/ui/screens/registro_estudiante.dart';
import 'package:skillship/ui/screens/registro_empresa.dart';
import 'package:skillship/ui/screens/registro_universidad.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controladores para los campos generales
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? selectedRole;
  final List<String> roles = ['Estudiante', 'Empresa', 'Universidad'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                      color: Colors.white,
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
                          CustomTextField(
                            controller: _emailController, // Asegúrate de que tu CustomTextField acepte controller
                            label: 'Correo Electronico',
                            hintText: 'Ingrese su correo electronico',
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            hintText: 'Ingrese su contraseña',
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _confirmPasswordController,
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
                                // Validaciones básicas
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    selectedRole == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Por favor completa todos los campos y selecciona un rol')),
                                  );
                                  return;
                                }

                                if (_passwordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Las contraseñas no coinciden')),
                                  );
                                  return;
                                }

                                // Navegación según el rol
                                if (selectedRole == 'Estudiante') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistroEstudianteScreen(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                        rol: selectedRole!,
                                      ),
                                    ),
                                  );
                                } else if (selectedRole == 'Empresa') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistroEmpresaScreen(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      ),
                                    ),
                                  );
                                } else if (selectedRole == 'Universidad') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistroUniversidadScreen(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      ),
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