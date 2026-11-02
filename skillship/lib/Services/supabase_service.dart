import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  Future<void> registrarEstudianteCompleto({
    required String email,
    required String password,
    required String rol,
    required String nombre,
    required String institucion,
    required String carrera,
    required Map<String, String> documentosPaths,
  }) async {
    try {
      // 1. Insertar el usuario principal
      final usuarioResponse = await Supabase.instance.client
          .from('usuarios')
          .insert({
            'email': email,
            'password': password,
            'rol': rol,
          })
          .select('id')
          .single();

      final int usuarioId = usuarioResponse['id'];

      // 2. Insertar los datos del alumno
      await Supabase.instance.client.from('perfiles_estudiantes').insert({
        'usuario_id': usuarioId,
        'nombre': nombre,
        'institucion': institucion,
        'carrera': carrera,
      });

      // 3. Insertar las rutas de los documentos
      for (var entry in documentosPaths.entries) {
        await Supabase.instance.client.from('documentos_registro').insert({
          'usuario_id': usuarioId,
          'tipo_documento': entry.key,
          'archivo_path': entry.value,
        });
      }

      print('¡Estudiante registrado con éxito en Supabase!');
    } catch (e) {
      print('Error durante el registro: $e');
    }
  }
}