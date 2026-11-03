import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/reclamo.dart';

/// Contrato que define de dónde salen los datos de pasantías.
///
/// Las pantallas solo conocen esta interfaz: así se puede cambiar de fuente
/// (Supabase o datos de prueba) sin tocar ningún widget.
abstract class PasantiasRepository {
  /// Propuestas disponibles, marcando si el estudiante ya postuló a alguna.
  Future<List<Pasantia>> obtenerPasantias({required int usuarioId});

  /// Devuelve `true` si se creó la postulación, `false` si ya había postulado.
  Future<bool> postularse({required int pasantiaId, required int usuarioId});

  /// Postulaciones del estudiante con su propuesta completa.
  Future<List<Postulacion>> obtenerPostulaciones({required int usuarioId});

  /// Horas cargadas para una postulación, de la más vieja a la más nueva.
  Future<List<RegistroHora>> obtenerHoras({required int postulacionId});

  /// Reclamos enviados para una postulación, del más nuevo al más viejo.
  Future<List<Reclamo>> obtenerReclamos({required int postulacionId});

  /// Guarda un reclamo del estudiante.
  Future<void> enviarReclamo({
    required int postulacionId,
    required String mensaje,
  });
}
