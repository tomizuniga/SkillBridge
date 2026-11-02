import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skillship/widgets/button.dart';
import 'package:skillship/widgets/upload_field.dart';
import 'package:skillship/screens/pagina_ingreso.dart';

class RegistroEstudianteScreen extends StatefulWidget {
  final String email;
  final String password;
  final String rol;

  const RegistroEstudianteScreen({
    super.key,
    required this.email,
    required this.password,
    required this.rol,
  });

  @override
  State<RegistroEstudianteScreen> createState() => _RegistroEstudianteScreenState();
}

class _RegistroEstudianteScreenState extends State<RegistroEstudianteScreen> {
  // Controladores para los nuevos campos específicos del estudiante
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _institucionController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _institucionController.dispose();
    _carreraController.dispose();
    super.dispose();
  }

  // Método para guardar todo en Supabase
  Future<void> _guardarRegistroEnSupabase() async {
    if (_nombreController.text.isEmpty ||
        _institucionController.text.isEmpty ||
        _carreraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos de texto')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Insertar el usuario principal en la tabla 'usuarios'
      final usuarioResponse = await Supabase.instance.client
          .from('usuarios')
          .insert({
            'email': widget.email,
            'password': widget.password,
            'rol': widget.rol,
          })
          .select('id')
          .single();

      final int usuarioId = usuarioResponse['id'];

      // 2. Insertar los datos del alumno en la tabla 'perfiles_estudiantes'
      await Supabase.instance.client.from('perfiles_estudiantes').insert({
        'usuario_id': usuarioId,
        'nombre': _nombreController.text.trim(),
        'institucion': _institucionController.text.trim(),
        'carrera': _carreraController.text.trim(),
      });

      // Si todo sale bien, redirigimos a la pantalla de ingreso
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PantallaIngreso()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar en Supabase: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9E9E9E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // NUEVO: Campo de Nombre (colocado encima de Institución)
                          TextField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre completo',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo de Institución
                          TextField(
                            controller: _institucionController,
                            decoration: const InputDecoration(
                              labelText: 'Institucion',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo de Carrera
                          TextField(
                            controller: _carreraController,
                            decoration: const InputDecoration(
                              labelText: 'Carrera',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campos con ícono de carga (Documentos)
                          const UploadField(
                            label: 'Certificado de alumno regular',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Copia de DNI',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Constancia de CUIL',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Certificado Analitico',
                            isUpload: true,
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                                : Button(
                                    text: 'Registrarse',
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    borderRadius: 8.0,
                                    onPressed: _guardarRegistroEnSupabase,
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
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}