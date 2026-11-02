import 'package:flutter/material.dart';

class EmpresaPublicarTrabajoScreen extends StatelessWidget {
  const EmpresaPublicarTrabajoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Detalles del trabajo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Campos del formulario
            _buildTextField(label: 'Rubro'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Horario'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Requisitos'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Correo Institucion'),
            const SizedBox(height: 24),

            // Botón de Enviar solicitud
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  // Lógica para enviar propuesta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Propuesta enviada con éxito')),
                  );
                },
                child: const Text(
                  'Enviar\nsolicitud',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para mantener el estilo de los inputs de texto
  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}