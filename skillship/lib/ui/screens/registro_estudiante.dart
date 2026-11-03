import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:skillship/ui/screens/pagina_ingreso.dart';
import 'package:skillship/data/supabase_service.dart';
import 'package:skillship/ui/widgets/button.dart';
import 'package:skillship/ui/widgets/upload_field.dart';

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

  /// Documentos que pide la facultad, en el mismo orden en que se muestran.
  static const List<String> _tiposDocumento = [
    'Certificado de alumno regular',
    'Copia de DNI',
    'Constancia de CUIL',
    'Certificado Analitico',
  ];

  /// etiqueta del campo -> archivo elegido por el usuario
  final Map<String, PlatformFile> _documentos = {};

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _institucionController.dispose();
    _carreraController.dispose();
    super.dispose();
  }

  // Abre el selector de archivos nativo y guarda el elegido.
  Future<void> _seleccionarArchivo(String tipo) async {
    try {
      final archivos = await FilePicker.pickFiles(type: FileType.any);
      if (archivos.isEmpty) return; // el usuario canceló
      setState(() => _documentos[tipo] = archivos.first);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el selector de archivos: $e')),
        );
      }
    }
  }

  // Método para guardar todo en Supabase
  Future<void> _guardarRegistroEnSupabase() async {
    if (_nombreController.text.trim().isEmpty ||
        _institucionController.text.trim().isEmpty ||
        _carreraController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos de texto')),
      );
      return;
    }

    final faltantes = _tiposDocumento.where((t) => !_documentos.containsKey(t));
    if (faltantes.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faltan archivos por cargar: ${faltantes.join(', ')}')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.instance.registrarEstudianteCompleto(
        email: widget.email,
        password: widget.password,
        rol: widget.rol,
        nombre: _nombreController.text,
        institucion: _institucionController.text,
        carrera: _carreraController.text,
        documentos: _documentos,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro completado. Ya podés iniciar sesión.'),
          backgroundColor: Color(0xFF2D2D2D),
        ),
      );

      // Si todo sale bien, redirigimos a la pantalla de ingreso
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PantallaIngreso()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SupabaseService.mensajeError(e)),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _campoDocumento(String tipo) {
    return UploadField(
      label: tipo,
      isUpload: true,
      fileName: _documentos[tipo]?.name,
      onTap: () => _seleccionarArchivo(tipo),
    );
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
                          _campoDocumento('Certificado de alumno regular'),
                          _campoDocumento('Copia de DNI'),
                          _campoDocumento('Constancia de CUIL'),
                          _campoDocumento('Certificado Analitico'),
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
