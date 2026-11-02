import 'package:flutter/material.dart';
import 'package:skillship/Services/supabase_service.dart';
import 'package:skillship/widgets/button.dart';
import 'package:skillship/widgets/upload_field.dart';
import 'package:skillship/screens/pagina_ingreso.dart';

class RegistroEmpresaScreen extends StatefulWidget {
  final String email;
  final String password;

  const RegistroEmpresaScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<RegistroEmpresaScreen> createState() => _RegistroEmpresaScreenState();
}

class _RegistroEmpresaScreenState extends State<RegistroEmpresaScreen> {
  bool _isLoading = false;

  Future<void> _registrarse() async {
    setState(() => _isLoading = true);

    try {
      // Cuenta de acceso: el resto de los datos sigue siendo maqueta.
      await SupabaseService.instance.crearCuenta(
        email: widget.email,
        password: widget.password,
        rol: 'Empresa',
      );

      if (!mounted) return;
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
                          const UploadField(label: 'Institucion'),
                          const UploadField(label: 'CUIT'),
                          const SizedBox(height: 16),

                          // Campos con ícono de carga
                          const UploadField(
                            label: 'Resolucion',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Copia de DNI de autoridad legal',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Acta de designacion',
                            isUpload: true,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Button(
                                    text: 'Registrarse',
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    borderRadius: 8.0,
                                    onPressed: _registrarse,
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
