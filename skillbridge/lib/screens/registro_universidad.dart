import 'package:flutter/material.dart';
import 'package:skillbridge/widgets/button.dart';
import 'package:skillbridge/widgets/upload_field.dart';

import 'package:skillbridge/screens/pagina_ingreso.dart';

class RegistroUniversidadScreen extends StatelessWidget {
  const RegistroUniversidadScreen({super.key});

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
                          const UploadField(label: 'Empresa'),
                          const UploadField(label: 'CUIT'),
                          const UploadField(label: 'Telefono'),
                          const SizedBox(height: 16),

                          // Campos con ícono de carga
                          const UploadField(
                            label: 'Convenio de Marco de Pasantias',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Copia de DNI',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Estatuto social',
                            isUpload: true,
                          ),
                          const UploadField(
                            label: 'Constancia de CUIT',
                            isUpload: true,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              text: 'Registrarse',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              borderRadius: 8.0,
                              onPressed: () {
                                //
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PantallaIngreso(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
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
