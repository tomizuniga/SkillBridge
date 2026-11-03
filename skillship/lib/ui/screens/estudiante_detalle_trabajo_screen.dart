import 'package:flutter/material.dart';
import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/usuario.dart';
import 'package:skillship/data/repositorio_pasantias.dart';
import 'package:skillship/data/supabase_service.dart';

class EstudianteDetalleTrabajoScreen extends StatefulWidget {
  final Pasantia pasantia;
  final Usuario usuario;

  const EstudianteDetalleTrabajoScreen({
    super.key,
    required this.pasantia,
    required this.usuario,
  });

  @override
  State<EstudianteDetalleTrabajoScreen> createState() =>
      _EstudianteDetalleTrabajoScreenState();
}

class _EstudianteDetalleTrabajoScreenState
    extends State<EstudianteDetalleTrabajoScreen> {
  bool _enviando = false;

  Future<void> _enviarSolicitud() async {
    if (_enviando) return;

    if (widget.pasantia.yaPostulo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya postulaste a esta pasantía')),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      final creado = await RepositorioPasantias.instance.postularse(
        pasantiaId: widget.pasantia.id,
        usuarioId: widget.usuario.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            creado
                ? 'Solicitud enviada con éxito'
                : 'Ya habías enviado una postulación a esta pasantía',
          ),
          backgroundColor: const Color(0xFF2D2D2D),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SupabaseService.mensajeError(e)),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Widget _lineaDato(String etiqueta, String valor) {
    if (valor.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$etiqueta: $valor',
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pasantia = widget.pasantia;

    return Scaffold(
      backgroundColor: const Color(0xFF0A101D), // Fondo azul oscuro general
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
                          'perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
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

            // ================= CONTENIDO PRINCIPAL DE DETALLE =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Botón de retroceso para volver a la lista
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFAFA2A2), // Color de tarjeta según diseño
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pasantia.titulo,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${pasantia.empresa} · ${pasantia.ubicacion}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Descripcion',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pasantia.descripcion,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              if (pasantia.requisitos.trim().isNotEmpty) ...[
                                const SizedBox(height: 24),
                                const Text(
                                  'Requisitos',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  pasantia.requisitos,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              const Text(
                                'Detalles del puesto',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _lineaDato('Modalidad', pasantia.modalidad),
                              _lineaDato(
                                'Horas semanales',
                                '${pasantia.horasSemanales} hs',
                              ),
                              _lineaDato(
                                'Duracion',
                                '${pasantia.duracionSemanas} semanas',
                              ),
                              _lineaDato('Carrera', pasantia.carreraRequerida),
                              const SizedBox(height: 24),

                              // Botón de Enviar Solicitud centrado en la parte inferior
                              Center(
                                child: _enviando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 28,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: _enviarSolicitud,
                                        child: const Text(
                                          'Enviar solicitud',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
