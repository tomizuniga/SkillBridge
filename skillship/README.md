# skillship

Aplicación Flutter para agilizar y centralizar el papeleo de vinculaciones y
pasantías de alumnos de la universidad.

Tres roles: **estudiante**, **empresa** y **universidad**.

---

## Cómo levantar el flujo del estudiante (paso a paso)

### 1. Ejecutar el script SQL

Abrí tu proyecto en [Supabase](https://supabase.com) → **SQL Editor** → *New query*,
pegá todo el archivo [`supabase/schema.sql`](supabase/schema.sql) y presioná **Run**.

> Si ya lo habías ejecutado antes, **pegalo de nuevo**: el script es idempotente
> (no duplica nada) y así se crean las tablas nuevas que se hayan agregado.

Eso crea:

| Qué | Para qué |
| --- | --- |
| Tablas `pasantias`, `postulaciones`, `horas_pasantia`, `reclamos` | Propuestas, postulaciones, horas cargadas y reclamos |
| Políticas RLS | Para que la app (rol `anon`) pueda leer y escribir |
| Bucket `documentos` de Storage | Donde se guardan los archivos del registro |
| Datos de ejemplo | 6 propuestas, 1 postulación **aceptada y en proceso** con horas cargadas, 1 reclamo y 1 postulación pendiente |

> Si no lo ejecutás, la app igualmente arranca: el registro te avisa que falta
> el script en vez de perder los archivos a medias.

### 2. Correr la app

```bash
flutter pub get
flutter run
```

### 3. Recorrer el flujo

1. **Registrarse** → *Registrarse* → rol *Estudiante* → completar nombre,
   institución y carrera, y cargar los 4 documentos pedidos
   (certificado de alumno regular, DNI, CUIL y analítico).
   Los archivos suben al bucket `documentos` y sus rutas quedan guardadas en
   `documentos_registro`.
2. **Iniciar sesión** → correo + contraseña + rol. Se valida contra la tabla
   `usuarios` y según el rol guardado entra a cada panel.
3. **Buscar pasantías** → lista las propuestas de `pasantias`, con buscador por
   título, empresa, ubicación, modalidad o carrera.
4. **Detalle de la propuesta** → *Enviar solicitud* crea la fila en
   `postulaciones` (estado `pendiente`).
5. **Gestionar pasantía** → muestra el trabajo actual, las horas trabajadas
   semanales y acumuladas, el tutor asignado, el detalle de las horas cargadas
   y todas las postulaciones. El apartado **Reclamos** es un campo escribible:
   lo que escribís se guarda en la tabla `reclamos` y aparece listado debajo
   como *Reclamos enviados*.
6. **Perfil** (barra lateral) → datos del estudiante y los documentos que quedaron
   guardados en la base de datos.

### Cuenta de prueba

Para ver el flujo completo sin registrarte:

| | |
| --- | --- |
| Correo | `estudiante@demo.com` |
| Contraseña | `demo1234` |
| Rol | Estudiante |

Tiene una pasantía **aceptada y en proceso** (con 5 semanas de horas cargadas),
un **reclamo de ejemplo** en el apartado de Reclamos y una postulación **pendiente**.

---

## Estructura

```
lib/
├── main.dart                  # Arranque + conexión a Supabase
├── models/                    # Usuario, Pasantia, Postulacion, RegistroHora
├── Services/
│   └── supabase_service.dart  # Toda la lógica contra Supabase
├── screens/                   # Pantallas (una por flujo/rol)
└── widgets/                   # Button, CustomTextField, UploadField
supabase/
└── schema.sql                 # Esquema + RLS + Storage + datos de ejemplo
```

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/codelabs/flutter-codelab-first)
- [Flutter documentation](https://docs.flutter.dev/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
