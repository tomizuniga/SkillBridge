/// Usuario tal como queda guardado en la tabla `usuarios`.
///
/// Nota: la contraseña viaja en texto plano porque así está diseñado el esquema
/// actual del proyecto (`usuarios.password`). En un proyecto real se usaría
/// Supabase Auth / hashes.
class Usuario {
  final int id;
  final String email;
  final String rol;

  /// Viene de `perfiles_estudiantes.nombre` (puede no existir para otros roles).
  final String? nombre;

  const Usuario({
    required this.id,
    required this.email,
    required this.rol,
    this.nombre,
  });

  bool get esEstudiante => rol == 'Estudiante';

  factory Usuario.fromMap(Map<String, dynamic> map, {String? nombre}) {
    return Usuario(
      id: (map['id'] as num).toInt(),
      email: map['email']?.toString() ?? '',
      rol: map['rol']?.toString() ?? '',
      nombre: nombre,
    );
  }
}
