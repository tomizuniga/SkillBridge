import 'package:skillship/data/mock_pasantias_repository.dart';
import 'package:skillship/data/pasantias_repository.dart';
import 'package:skillship/data/supabase_pasantias_repository.dart';
import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/reclamo.dart';

/// Punto único de acceso a los datos de pasantías (Fachada).
///
/// Intenta primero con Supabase. Si la base de datos todavía no está disponible
/// (por ejemplo, falta ejecutar `supabase/schema.sql` o no hay conexión),
/// queda en **modo demo** y responde con [MockPasantiasRepository].
///
/// La UI sólo habla con esta clase, así que no sabe ni tiene que saber de
/// dónde salen los datos.
class RepositorioPasantias implements PasantiasRepository {
  RepositorioPasantias._();

  static final RepositorioPasantias instance = RepositorioPasantias._();

  final SupabasePasantiasRepository _supabase = SupabasePasantiasRepository();
  final PasantiasRepository _mock = MockPasantiasRepository();

  bool _fuenteVerificada = false;
  bool _usarMock = false;

  /// `true` cuando la app está respondiendo con datos de prueba.
  bool get enModoDemo => _usarMock;

  /// Elige la fuente una sola vez y la deja fija para toda la sesión.
  Future<PasantiasRepository> _fuente() async {
    if (_fuenteVerificada) return _usarMock ? _mock : _supabase;

    try {
      await _supabase.probarDisponibilidad();
      _usarMock = false;
    } catch (_) {
      _usarMock = true;
    }

    _fuenteVerificada = true;
    return _usarMock ? _mock : _supabase;
  }

  @override
  Future<List<Pasantia>> obtenerPasantias({required int usuarioId}) async {
    final fuente = await _fuente();
    return fuente.obtenerPasantias(usuarioId: usuarioId);
  }

  @override
  Future<bool> postularse({
    required int pasantiaId,
    required int usuarioId,
  }) async {
    final fuente = await _fuente();
    return fuente.postularse(pasantiaId: pasantiaId, usuarioId: usuarioId);
  }

  @override
  Future<List<Postulacion>> obtenerPostulaciones({required int usuarioId}) async {
    final fuente = await _fuente();
    return fuente.obtenerPostulaciones(usuarioId: usuarioId);
  }

  @override
  Future<List<RegistroHora>> obtenerHoras({required int postulacionId}) async {
    final fuente = await _fuente();
    return fuente.obtenerHoras(postulacionId: postulacionId);
  }

  @override
  Future<List<Reclamo>> obtenerReclamos({required int postulacionId}) async {
    final fuente = await _fuente();
    return fuente.obtenerReclamos(postulacionId: postulacionId);
  }

  @override
  Future<void> enviarReclamo({
    required int postulacionId,
    required String mensaje,
  }) async {
    final fuente = await _fuente();
    return fuente.enviarReclamo(postulacionId: postulacionId, mensaje: mensaje);
  }
}
