import 'package:skillship/models/pasantia.dart';
import 'package:skillship/models/postulacion.dart';
import 'package:skillship/models/reclamo.dart';

/// Datos de prueba locales (listas) que consumen los repositorios en modo demo.
///
/// Es el equivalente en Dart de la semilla que trae `supabase/schema.sql`:
/// así la app muestra lo mismo aunque la base de datos no esté disponible.
class DatosDePrueba {
  DatosDePrueba._();

  /// Ids fijos: al estudiante de prueba siempre le pasó lo mismo.
  static const int idPostulacionEnProceso = 1;
  static const int idPostulacionPendiente = 2;

  static const int idUsuarioDemo = 1;

  /// Busca una propuesta por su título (se usa para armar las postulaciones).
  static Pasantia porTitulo(String titulo) =>
      pasantias.firstWhere((p) => p.titulo == titulo);

  // ---------------------------------------------------------------------------
  // Propuestas publicadas
  // ---------------------------------------------------------------------------
  static final List<Pasantia> pasantias = [
    const Pasantia(
      id: 1,
      titulo: 'Desarrollo Backend .NET',
      empresa: 'Softtek',
      ubicacion: 'Ciudad de Buenos Aires',
      modalidad: 'Híbrido',
      carreraRequerida: 'Licenciatura en Sistemas de Información',
      descripcion:
          'Participarás en el desarrollo y mantenimiento de una API REST para '
          'gestión de clientes, trabajando con un equipo de 6 personas bajo '
          'metodología Scrum.',
      requisitos:
          'C# y .NET Core (básico), SQL, lógica de programación. Se valora '
          'conocimiento de Git.',
      horasSemanales: 20,
      duracionSemanas: 16,
      estado: 'disponible',
    ),
    const Pasantia(
      id: 2,
      titulo: 'Análisis de Datos con Python',
      empresa: 'Mercado Libre',
      ubicacion: 'Virtual',
      modalidad: 'Virtual',
      carreraRequerida: 'Licenciatura en Sistemas de Información',
      descripcion:
          'Limpieza y análisis de datasets de ventas, construcción de reportes '
          'automáticos y apoyo en la creación de tableros de indicadores.',
      requisitos:
          'Python (pandas), estadística descriptiva, Excel/Google Sheets. '
          'Conocimiento de SQL un plus.',
      horasSemanales: 16,
      duracionSemanas: 12,
      estado: 'disponible',
    ),
    const Pasantia(
      id: 3,
      titulo: 'Diseño UX/UI de Aplicaciones',
      empresa: 'Globant',
      ubicacion: 'Córdoba',
      modalidad: 'Híbrido',
      carreraRequerida: 'Licenciatura en Diseño',
      descripcion:
          'Diseño de flujos y pantallas para una app móvil bancaria, '
          'investigación con usuarios y armado del design system.',
      requisitos: 'Figma, nociones de investigación de usuarios y de accesibilidad.',
      horasSemanales: 20,
      duracionSemanas: 12,
      estado: 'disponible',
    ),
    const Pasantia(
      id: 4,
      titulo: 'Marketing Digital y Contenidos',
      empresa: 'Grupo Clarín',
      ubicacion: 'Ciudad de Buenos Aires',
      modalidad: 'Presencial',
      carreraRequerida: 'Licenciatura en Publicidad',
      descripcion:
          'Gestión de redes sociales, redacción de notas para el sitio y '
          'medición de campañas con herramientas de analítica.',
      requisitos:
          'Redacción, manejo de redes sociales, manejo básico de Canva y '
          'Google Analytics.',
      horasSemanales: 24,
      duracionSemanas: 12,
      estado: 'disponible',
    ),
    const Pasantia(
      id: 5,
      titulo: 'Soporte TI y Redes',
      empresa: 'Cooperativa de Servicios Tech',
      ubicacion: 'La Plata',
      modalidad: 'Presencial',
      carreraRequerida: 'Tecnicatura en Redes y Telecomunicaciones',
      descripcion:
          'Atención de incidencias de usuarios, configuración de puestos de '
          'trabajo y documentación del parque informático.',
      requisitos: 'Windows/Linux, redes TCP/IP, buena comunicación con usuarios.',
      horasSemanales: 20,
      duracionSemanas: 10,
      estado: 'disponible',
    ),
    const Pasantia(
      id: 6,
      titulo: 'Prácticas en Recursos Humanos',
      empresa: 'Adecco Argentina',
      ubicacion: 'Rosario',
      modalidad: 'Presencial',
      carreraRequerida: 'Licenciatura en Administración',
      descripcion:
          'Apoyo en la selección de candidatos, armado de bases de datos de '
          'postulantes y seguimiento de entrevistas.',
      requisitos: 'Organización, manejo de Excel y buena redacción.',
      horasSemanales: 20,
      duracionSemanas: 10,
      estado: 'disponible',
    ),
  ];

  // ---------------------------------------------------------------------------
  // Postulaciones del estudiante de prueba
  // ---------------------------------------------------------------------------

  /// La aceptada y en curso, con tutor y fecha de inicio.
  static final Postulacion enProceso = Postulacion(
    id: idPostulacionEnProceso,
    pasantiaId: porTitulo('Desarrollo Backend .NET').id,
    usuarioId: idUsuarioDemo,
    estado: 'en_proceso',
    tutor: 'Ing. Carolina Méndez',
    fechaInicio: '2026-09-07',
    pasantia: porTitulo('Desarrollo Backend .NET'),
  );

  /// Una enviada, esperando respuesta.
  static final Postulacion pendiente = Postulacion(
    id: idPostulacionPendiente,
    pasantiaId: porTitulo('Análisis de Datos con Python').id,
    usuarioId: idUsuarioDemo,
    estado: 'pendiente',
    pasantia: porTitulo('Análisis de Datos con Python'),
  );

  // ---------------------------------------------------------------------------
  // Horas y reclamos de esa pasantía en curso
  // ---------------------------------------------------------------------------
  static final List<RegistroHora> horas = [
    const RegistroHora(
      id: 1,
      postulacionId: idPostulacionEnProceso,
      fecha: '2026-09-07',
      horas: 8,
      descripcion: 'Semana 1: armado del entorno y lectura del código base',
    ),
    const RegistroHora(
      id: 2,
      postulacionId: idPostulacionEnProceso,
      fecha: '2026-09-14',
      horas: 8,
      descripcion: 'Semana 2: endpoints de alta y baja de usuarios',
    ),
    const RegistroHora(
      id: 3,
      postulacionId: idPostulacionEnProceso,
      fecha: '2026-09-21',
      horas: 6,
      descripcion: 'Semana 3: corrección de bugs en el módulo de login',
    ),
    const RegistroHora(
      id: 4,
      postulacionId: idPostulacionEnProceso,
      fecha: '2026-09-28',
      horas: 8,
      descripcion: 'Semana 4: tests automatizados del servicio de contratos',
    ),
    const RegistroHora(
      id: 5,
      postulacionId: idPostulacionEnProceso,
      fecha: '2026-10-05',
      horas: 8,
      descripcion: 'Semana 5: despliegue a staging y documentación',
    ),
  ];

  static final List<Reclamo> reclamos = [
    const Reclamo(
      id: 1,
      postulacionId: idPostulacionEnProceso,
      mensaje:
          'El tutor no se presentó a la reunión de seguimiento del 30/09. '
          'Solicito que se reprograme.',
      estado: 'abierto',
      createdAt: '2026-09-30T15:40:00+00:00',
    ),
  ];
}
