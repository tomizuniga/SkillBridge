/// Reclamo que un estudiante deja durante su pasantía (tabla `reclamos`).
class Reclamo {
  final int id;
  final int postulacionId;
  final String mensaje;

  /// abierto | resuelto
  final String estado;

  /// Timestamp completo que devuelve Supabase (`2026-10-05T12:34:56+00:00`).
  final String createdAt;

  const Reclamo({
    required this.id,
    required this.postulacionId,
    required this.mensaje,
    required this.estado,
    required this.createdAt,
  });

  /// Fecha corta en formato `YYYY-MM-DD`.
  String get fecha => createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

  /// Fecha para mostrar en pantalla: `05/10/2026`.
  String get fechaLegible {
    final partes = fecha.split('-');
    if (partes.length != 3) return fecha;
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  String get estadoLegible {
    switch (estado) {
      case 'resuelto':
        return 'Resuelto';
      case 'abierto':
      default:
        return 'Abierto';
    }
  }

  factory Reclamo.fromMap(Map<String, dynamic> map) {
    return Reclamo(
      id: (map['id'] as num).toInt(),
      postulacionId: (map['postulacion_id'] as num).toInt(),
      mensaje: map['mensaje']?.toString() ?? '',
      estado: map['estado']?.toString() ?? 'abierto',
      createdAt: map['created_at']?.toString() ?? '',
    );
  }
}
