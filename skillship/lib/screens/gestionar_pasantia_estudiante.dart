import 'package:flutter/material.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/usuario.dart';
import 'package:skillship/Services/supabase_service.dart';

class GestionarPasantiaScreen extends StatefulWidget {
  final Usuario usuario;

  const GestionarPasantiaScreen({super.key, required this.usuario});

  @override
  State<GestionarPasantiaScreen> createState() => _GestionarPasantiaScreenState();
}

class _GestionarPasantiaScreenState extends State<GestionarPasantiaScreen> {
  bool _cargando = true;
  String? _error;

  Postulacion? _enProceso;
  List<Postulacion> _postulaciones = [];
  List<RegistroHora> _horas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final servicio = SupabaseService.instance;
      final postulaciones = await servicio.obtenerPostulaciones(
        usuarioId: widget.usuario.id,
      );

      Postulacion? enProceso;
      for (final p in postulaciones) {
        if (p.enProceso) {
          enProceso = p;
          break;
        }
      }

      var horas = <RegistroHora>[];
      if (enProceso != null) {
        horas = await servicio.obtenerHoras(postulacionId: enProceso.id);
      }

      if (!mounted) return;
      setState(() {
        _postulaciones = postulaciones;
        _enProceso = enProceso;
        _horas = horas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = SupabaseService.mensajeError(e);
        _cargando = false;
      });
    }
  }

  /// 38 -> "38"   7.6 -> "7,6"
  static String _formatear(double valor) {
    final texto = valor == valor.roundToDouble()
        ? valor.toInt().toString()
        : valor.toStringAsFixed(1);
    return texto.replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    }

    final enProceso = _enProceso;
    final pasantia = enProceso?.pasantia;
    final fechaInicio = enProceso?.fechaInicio;
    final estadoTexto = enProceso?.estadoLegible;
    final tutorBruto = enProceso?.tutor;
    final tutor = (tutorBruto != null && tutorBruto.isNotEmpty) ? tutorBruto : null;
    final totalHoras = _horas.fold<double>(0, (suma, h) => suma + h.horas);
    final promedio = _horas.isEmpty ? 0.0 : totalHoras / _horas.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- TRABAJO ACTUAL ----------------
                  const Text(
                    'Trabajo Actual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (pasantia == null)
                    const Text(
                      'Todavía no tenés una pasantía en curso.',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    )
                  else ...[
                    Text(
                      pasantia.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pasantia.empresa} · ${pasantia.ubicacion}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: $estadoTexto'
                      '${fechaInicio != null ? ' · desde $fechaInicio' : ''}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 40),

                  // ---------------- HORAS ----------------
                  const Text(
                    'Horas Trabajadas\n(Semanales)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _horas.isEmpty
                        ? 'Sin horas cargadas'
                        : '${_formatear(promedio)} h por semana',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_horas.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${_formatear(totalHoras)} h acumuladas en ${_horas.length} semanas',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 40),

                  // ---------------- TUTOR ----------------
                  const Text(
                    'Tutor Asignado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tutor ?? 'Aún sin asignar',
                    style: TextStyle(
                      color: tutor != null ? Colors.white : Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ---------------- RECLAMOS ----------------
                  const Text(
                    'Reclamos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Caja blanca de reclamos según el diseño
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ---------------- HORAS CARGADAS ----------------
                  if (_horas.isNotEmpty) ...[
                    const Text(
                      'Horas cargadas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._horas.map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${h.fecha}  ·  ${_formatear(h.horas)} h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (h.descripcion.isNotEmpty)
                              Text(
                                h.descripcion,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // ---------------- MIS POSTULACIONES ----------------
                  if (_postulaciones.isNotEmpty) ...[
                    const Text(
                      'Mis postulaciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._postulaciones.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.pasantia?.titulo ?? 'Pasantía',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${p.pasantia?.empresa ?? ''} · ${p.estadoLegible}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
