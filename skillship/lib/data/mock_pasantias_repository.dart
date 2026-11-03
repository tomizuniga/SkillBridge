import 'package:skillship/data/datos_de_prueba.dart';
import 'package:skillship/data/pasantias_repository.dart';
import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/reclamo.dart';

/// Repositorio en memoria con **datos de prueba (mocks)**.
///
/// No toca la red ni la base de datos: guarda todo en listas. Se usa cuando
/// Supabase no está disponible y también sirve para desarrollar la UI.
///
/// Es una sola "sesión" de demostración: ignora el `usuarioId` porque sólo
/// modela al estudiante de prueba.
class MockPasantiasRepository implements PasantiasRepository {
  MockPasantiasRepository()
      : _pasantias = List.of(DatosDePrueba.pasantias),
        _postulaciones = List.of([
          DatosDePrueba.enProceso,
          DatosDePrueba.pendiente,
        ]),
        _horas = List.of(DatosDePrueba.horas),
        _reclamos = List.of(DatosDePrueba.reclamos);

  final List<Pasantia> _pasantias;
  final List<Postulacion> _postulaciones;
  final List<RegistroHora> _horas;
  final List<Reclamo> _reclamos;

  int _siguienteIdPostulacion = 100;
  int _siguienteIdReclamo = 100;

  Pasantia _buscarPasantia(int id) {
    for (final p in _pasantias) {
      if (p.id == id) return p;
    }
    throw Exception('La pasantía seleccionada ya no está disponible.');
  }

  @override
  Future<List<Pasantia>> obtenerPasantias({required int usuarioId}) async {
    final estados = <int, String>{
      for (final p in _postulaciones) p.pasantiaId: p.estado,
    };

    return _pasantias
        .where((p) => p.estado == 'disponible')
        .map((p) => p.copyWith(estadoPostulacion: estados[p.id]))
        .toList();
  }

  @override
  Future<bool> postularse({
    required int pasantiaId,
    required int usuarioId,
  }) async {
    final yaPostulo = _postulaciones.any(
      (p) => p.pasantiaId == pasantiaId && p.usuarioId == usuarioId,
    );
    if (yaPostulo) return false;

    final pasantia = _buscarPasantia(pasantiaId);
    _postulaciones.add(
      Postulacion(
        id: _siguienteIdPostulacion++,
        pasantiaId: pasantiaId,
        usuarioId: usuarioId,
        estado: 'pendiente',
        pasantia: pasantia.copyWith(estadoPostulacion: 'pendiente'),
      ),
    );
    return true;
  }

  @override
  Future<List<Postulacion>> obtenerPostulaciones({required int usuarioId}) async {
    final propias = _postulaciones
        .where((p) => p.usuarioId == usuarioId)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    return propias;
  }

  @override
  Future<List<RegistroHora>> obtenerHoras({required int postulacionId}) async {
    final horas = _horas.where((h) => h.postulacionId == postulacionId).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
    return horas;
  }

  @override
  Future<List<Reclamo>> obtenerReclamos({required int postulacionId}) async {
    final reclamos =
        _reclamos.where((r) => r.postulacionId == postulacionId).toList()
          ..sort((a, b) => b.id.compareTo(a.id));
    return reclamos;
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

    _reclamos.insert(
      0,
      Reclamo(
        id: _siguienteIdReclamo++,
        postulacionId: postulacionId,
        mensaje: texto,
        estado: 'abierto',
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }
}
