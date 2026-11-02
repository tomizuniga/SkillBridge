import 'package:skillship/models/pasantia.dart';

/// Postulación de un estudiante a una pasantía (tabla `postulaciones`).
class Postulacion {
  final int id;
  final int pasantiaId;
  final int usuarioId;

  /// pendiente | en_proceso | finalizada | rechazada
  final String estado;
  final String? tutor;
  final String? fechaInicio;

  /// Propuesta completa (la trae el join `pasantias(*)`).
  final Pasantia? pasantia;

  const Postulacion({
    required this.id,
    required this.pasantiaId,
    required this.usuarioId,
    required this.estado,
    this.tutor,
    this.fechaInicio,
    this.pasantia,
  });

  bool get enProceso => estado == 'en_proceso';
  bool get pendiente => estado == 'pendiente';

  /// Etiqueta legible para mostrar en pantalla.
  String get estadoLegible {
    switch (estado) {
      case 'en_proceso':
        return 'En proceso';
      case 'pendiente':
        return 'Pendiente';
      case 'finalizada':
        return 'Finalizada';
      case 'rechazada':
        return 'Rechazada';
      default:
        return estado;
    }
  }

  factory Postulacion.fromMap(Map<String, dynamic> map) {
    final pasantiaRaw = map['pasantias'];
    return Postulacion(
      id: (map['id'] as num).toInt(),
      pasantiaId: (map['pasantia_id'] as num).toInt(),
      usuarioId: (map['usuario_id'] as num).toInt(),
      estado: map['estado']?.toString() ?? 'pendiente',
      tutor: map['tutor']?.toString(),
      fechaInicio: map['fecha_inicio']?.toString(),
      pasantia: pasantiaRaw is Map<String, dynamic>
          ? Pasantia.fromMap(pasantiaRaw)
          : null,
    );
  }
}

/// Carga de horas de una pasantía (tabla `horas_pasantia`).
class RegistroHora {
  final int id;
  final int postulacionId;

  /// Fecha en formato `YYYY-MM-DD`.
  final String fecha;
  final double horas;
  final String descripcion;

  const RegistroHora({
    required this.id,
    required this.postulacionId,
    required this.fecha,
    required this.horas,
    required this.descripcion,
  });

  factory RegistroHora.fromMap(Map<String, dynamic> map) {
    return RegistroHora(
      id: (map['id'] as num).toInt(),
      postulacionId: (map['postulacion_id'] as num).toInt(),
      fecha: map['fecha']?.toString() ?? '',
      horas: (map['horas'] as num?)?.toDouble() ?? 0,
      descripcion: map['descripcion']?.toString() ?? '',
    );
  }
}
