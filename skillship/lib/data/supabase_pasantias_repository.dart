import 'package:skillship/data/pasantias_repository.dart';
import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/reclamo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementación real de [PasantiasRepository]: habla con Supabase.
///
/// Sólo necesita que se haya ejecutado `supabase/schema.sql`.
class SupabasePasantiasRepository implements PasantiasRepository {
  SupabasePasantiasRepository();

  SupabaseClient get _client => Supabase.instance.client;

  /// Comprueba que las tablas de pasantías existan y sean accesibles.
  /// Si falla, el repositorio con fallback pasa a datos de prueba.
  Future<void> probarDisponibilidad() async {
    await _client.from('pasantias').select('id').limit(1);
  }

  @override
  Future<List<Pasantia>> obtenerPasantias({required int usuarioId}) async {
    final filas = await _client
        .from('pasantias')
        .select()
        .eq('estado', 'disponible')
        .order('id', ascending: false);

    final postulaciones = await _client
        .from('postulaciones')
        .select('pasantia_id, estado')
        .eq('usuario_id', usuarioId);

    final Map<int, String> estados = {
      for (final p in postulaciones)
        (p['pasantia_id'] as num).toInt(): p['estado']?.toString() ?? '',
    };

    return filas
        .map((f) => Pasantia.fromMap(
              f,
              estadoPostulacion: estados[(f['id'] as num).toInt()],
            ))
        .toList();
  }

  @override
  Future<bool> postularse({
    required int pasantiaId,
    required int usuarioId,
  }) async {
    final existente = await _client
        .from('postulaciones')
        .select('id')
        .eq('pasantia_id', pasantiaId)
        .eq('usuario_id', usuarioId)
        .limit(1);

    if (existente.isNotEmpty) return false;

    await _client.from('postulaciones').insert({
      'pasantia_id': pasantiaId,
      'usuario_id': usuarioId,
      'estado': 'pendiente',
    });
    return true;
  }

  @override
  Future<List<Postulacion>> obtenerPostulaciones({required int usuarioId}) async {
    final filas = await _client
        .from('postulaciones')
        .select(
          'id, pasantia_id, usuario_id, estado, tutor, fecha_inicio, created_at, pasantias(*)',
        )
        .eq('usuario_id', usuarioId)
        .order('created_at', ascending: false);

    return filas.map(Postulacion.fromMap).toList();
  }

  @override
  Future<List<RegistroHora>> obtenerHoras({required int postulacionId}) async {
    final filas = await _client
        .from('horas_pasantia')
        .select()
        .eq('postulacion_id', postulacionId)
        .order('fecha');

    return filas.map(RegistroHora.fromMap).toList();
  }

  @override
  Future<List<Reclamo>> obtenerReclamos({required int postulacionId}) async {
    final filas = await _client
        .from('reclamos')
        .select()
        .eq('postulacion_id', postulacionId)
        .order('created_at', ascending: false);

    return filas.map(Reclamo.fromMap).toList();
  }

  @override
  Future<void> enviarReclamo({
    required int postulacionId,
    required String mensaje,
  }) async {
    final texto = mensaje.trim();
    if (texto.isEmpty) {
      throw Exception('Escribí el reclamo antes de enviarlo.');
    }

    await _client.from('reclamos').insert({
      'postulacion_id': postulacionId,
      'mensaje': texto,
      'estado': 'abierto',
    });
  }
}
