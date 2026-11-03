/// Propuesta de pasantía publicada por una empresa (tabla `pasantias`).
class Pasantia {
  final int id;
  final String titulo;
  final String empresa;
  final String ubicacion;
  final String modalidad;
  final String carreraRequerida;
  final String descripcion;
  final String requisitos;
  final int horasSemanales;
  final int duracionSemanas;
  final String estado;

  /// Estado de la postulación del estudiante actual (`null` si aún no postuló).
  /// Valores: pendiente | en_proceso | finalizada | rechazada
  final String? estadoPostulacion;

  const Pasantia({
    required this.id,
    required this.titulo,
    required this.empresa,
    required this.ubicacion,
    required this.modalidad,
    required this.carreraRequerida,
    required this.descripcion,
    required this.requisitos,
    required this.horasSemanales,
    required this.duracionSemanas,
    required this.estado,
    this.estadoPostulacion,
  });

  bool get yaPostulo => estadoPostulacion != null;

  /// Copia con cambios puntuales. Lo usa el repositorio en modo demo para
  /// marcar qué propuestas ya tienen postulación.
  Pasantia copyWith({String? estadoPostulacion}) {
    return Pasantia(
      id: id,
      titulo: titulo,
      empresa: empresa,
      ubicacion: ubicacion,
      modalidad: modalidad,
      carreraRequerida: carreraRequerida,
      descripcion: descripcion,
      requisitos: requisitos,
      horasSemanales: horasSemanales,
      duracionSemanas: duracionSemanas,
      estado: estado,
      estadoPostulacion: estadoPostulacion ?? this.estadoPostulacion,
    );
  }

  factory Pasantia.fromMap(Map<String, dynamic> map, {String? estadoPostulacion}) {
    return Pasantia(
      id: (map['id'] as num).toInt(),
      titulo: map['titulo']?.toString() ?? '',
      empresa: map['empresa']?.toString() ?? '',
      ubicacion: map['ubicacion']?.toString() ?? '',
      modalidad: map['modalidad']?.toString() ?? '',
      carreraRequerida: map['carrera_requerida']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      requisitos: map['requisitos']?.toString() ?? '',
      horasSemanales: (map['horas_semanales'] as num?)?.toInt() ?? 0,
      duracionSemanas: (map['duracion_semanas'] as num?)?.toInt() ?? 0,
      estado: map['estado']?.toString() ?? 'disponible',
      estadoPostulacion: estadoPostulacion,
    );
  }
}
