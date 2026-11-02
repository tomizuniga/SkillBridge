-- =============================================================================
-- SkillShip - Esquema completo del flujo del ESTUDIANTE
--
-- Cómo usarlo:
--   1. Abrí tu proyecto Supabase -> SQL Editor -> New query
--   2. Pegá este archivo completo y presioná "Run"
--   3. Recargá la app (los datos de ejemplo ya van a aparecer)
--
-- Qué hace:
--   * Crea las tablas base solo si faltan (no toca lo que ya tenés)
--   * Crea las tablas nuevas: pasantias, postulaciones, horas_pasantia
--   * Abre las políticas RLS para que la app (rol anon) pueda leer y escribir
--   * Crea el bucket "documentos" de Storage + sus permisos
--   * Carga datos de ejemplo: 6 propuestas de pasantía, 1 aceptada y en proceso
--     con horas cargadas, y 1 postulación pendiente
--
-- Es idempotente: volver a ejecutarlo no duplica nada.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. TABLAS BASE (ya existen en tu proyecto; esto solo las crea si faltan)
-- -----------------------------------------------------------------------------
create table if not exists public.usuarios (
  id        bigserial primary key,
  email     text not null unique,
  password  text not null,
  rol       text not null
);

create table if not exists public.perfiles_estudiantes (
  id          bigserial primary key,
  usuario_id  bigint not null references public.usuarios (id) on delete cascade,
  nombre      text not null,
  institucion text not null,
  carrera     text not null
);

create table if not exists public.documentos_registro (
  id            bigserial primary key,
  usuario_id    bigint not null references public.usuarios (id) on delete cascade,
  tipo_documento text not null,
  archivo_path  text not null
);

-- -----------------------------------------------------------------------------
-- 2. TABLAS NUEVAS DEL FLUJO DE PASANTÍAS
-- -----------------------------------------------------------------------------

-- Propuestas publicadas (las que el estudiante ve en "Buscar Trabajos")
create table if not exists public.pasantias (
  id               bigserial primary key,
  titulo           text not null,
  empresa          text not null,
  ubicacion        text not null default '',
  modalidad        text not null default 'Presencial',   -- Presencial | Híbrido | Virtual
  carrera_requerida text not null default '',
  descripcion       text not null default '',
  requisitos        text not null default '',
  horas_semanales  integer not null default 8,
  duracion_semanas integer not null default 12,
  estado           text not null default 'disponible',   -- disponible | cerrada
  created_at       timestamptz not null default now()
);

-- Lo que un estudiante envía al postular a una propuesta
create table if not exists public.postulaciones (
  id           bigserial primary key,
  pasantia_id  bigint not null references public.pasantias (id) on delete cascade,
  usuario_id   bigint not null references public.usuarios (id) on delete cascade,
  estado       text not null default 'pendiente',        -- pendiente | en_proceso | finalizada | rechazada
  tutor        text,
  fecha_inicio date,
  created_at   timestamptz not null default now(),
  unique (pasantia_id, usuario_id)
);

-- Horas que el estudiante carga durante la pasantía
create table if not exists public.horas_pasantia (
  id             bigserial primary key,
  postulacion_id bigint not null references public.postulaciones (id) on delete cascade,
  fecha          date not null default current_date,
  horas          numeric(5,2) not null,
  descripcion    text not null default '',
  created_at     timestamptz not null default now()
);

create index if not exists idx_postulaciones_usuario on public.postulaciones (usuario_id);
create index if not exists idx_horas_postulacion     on public.horas_pasantia (postulacion_id);

-- -----------------------------------------------------------------------------
-- 3. POLÍTICAS RLS (la app no usa Supabase Auth: entra con la clave pública)
-- -----------------------------------------------------------------------------
-- OJO: esto es un prototipo académico. Dejar las tablas abiertas al rol "anon"
-- es una decisión a propósito para que funcione sin usuarios de Supabase Auth.
-- En un producto real esto NO se hace así.
-- -----------------------------------------------------------------------------
alter table public.usuarios            enable row level security;
alter table public.perfiles_estudiantes enable row level security;
alter table public.documentos_registro  enable row level security;
alter table public.pasantias            enable row level security;
alter table public.postulaciones        enable row level security;
alter table public.horas_pasantia       enable row level security;

do $$
declare t text;
begin
  foreach t in array array[
    'usuarios', 'perfiles_estudiantes', 'documentos_registro',
    'pasantias', 'postulaciones', 'horas_pasantia'
  ] loop
    execute format(
      'drop policy if exists "acceso_prototipo" on public.%I', t);
    execute format(
      'create policy "acceso_prototipo" on public.%I for all to anon, authenticated using (true) with check (true)',
      t);
  end loop;
end $$;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;

-- -----------------------------------------------------------------------------
-- 4. BUCKET DE STORAGE PARA LOS DOCUMENTOS DEL REGISTRO
-- -----------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('documentos', 'documentos', false)
on conflict (id) do nothing;

drop policy if exists "documentos_lectura" on storage.objects;
create policy "documentos_lectura" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'documentos');

drop policy if exists "documentos_escritura" on storage.objects;
create policy "documentos_escritura" on storage.objects
  for insert to anon, authenticated
  with check (bucket_id = 'documentos');

drop policy if exists "documentos_actualizacion" on storage.objects;
create policy "documentos_actualizacion" on storage.objects
  for update to anon, authenticated
  using (bucket_id = 'documentos')
  with check (bucket_id = 'documentos');

drop policy if exists "documentos_borrado" on storage.objects;
create policy "documentos_borrado" on storage.objects
  for delete to anon, authenticated
  using (bucket_id = 'documentos');

-- -----------------------------------------------------------------------------
-- 5. DATOS DE EJEMPLO
-- -----------------------------------------------------------------------------

-- 5.1. Estudiante de prueba (para ver el flujo completo sin registrarse)
--      Email: estudiante@demo.com   Contraseña: demo1234
insert into public.usuarios (email, password, rol)
values ('estudiante@demo.com', 'demo1234', 'Estudiante')
on conflict (email) do nothing;

insert into public.perfiles_estudiantes (usuario_id, nombre, institucion, carrera)
select u.id, 'Sofía Ramírez', 'Universidad Nacional de La Plata', 'Licenciatura en Sistemas de Información'
from public.usuarios u
where u.email = 'estudiante@demo.com'
  and not exists (
    select 1 from public.perfiles_estudiantes p where p.usuario_id = u.id
  );

-- 5.2. Propuestas de pasantía disponibles para buscar
insert into public.pasantias
  (titulo, empresa, ubicacion, modalidad, carrera_requerida, descripcion, requisitos, horas_semanales, duracion_semanas)
select * from (values
  ('Desarrollo Backend .NET',
   'Softtek', 'Ciudad de Buenos Aires', 'Híbrido', 'Licenciatura en Sistemas de Información',
   'Participarás en el desarrollo y mantenimiento de una API REST para gestión de clientes, trabajando con un equipo de 6 personas bajo metodología Scrum.',
   'C# y .NET Core (básico), SQL, lógica de programación. Se valora conocimiento de Git.',
   20, 16),

  ('Análisis de Datos con Python',
   'Mercado Libre', 'Virtual', 'Virtual', 'Licenciatura en Sistemas de Información',
   'Limpieza y análisis de datasets de ventas, construcción de reportes automáticos y apoyo en la creación de tableros de indicadores.',
   'Python (pandas), estadística descriptiva, Excel/Google Sheets. Conocimiento de SQL un plus.',
   16, 12),

  ('Diseño UX/UI de Aplicaciones',
   'Globant', 'Córdoba', 'Híbrido', 'Licenciatura en Diseño',
   'Diseño de flujos y pantallas para una app móvil bancaria, investigación con usuarios y armado del design system.',
   'Figma, nociones de investigación de usuarios y de accesibilidad.',
   20, 12),

  ('Marketing Digital y Contenidos',
   'Grupo Clarín', 'Ciudad de Buenos Aires', 'Presencial', 'Licenciatura en Publicidad',
   'Gestión de redes sociales, redacción de notas para el sitio y medición de campañas con herramientas de analítica.',
   'Redacción, manejo de redes sociales, manejo básico de Canva y Google Analytics.',
   24, 12),

  ('Soporte TI y Redes',
   'Cooperativa de Servicios Tech', 'La Plata', 'Presencial', 'Tecnicatura en Redes y Telecomunicaciones',
   'Atención de incidencias de usuarios, configuración de puestos de trabajo y documentación del parque informático.',
   'Windows/Linux, redes TCP/IP, buena comunicación con usuarios.',
   20, 10),

  ('Prácticas en Recursos Humanos',
   'Adecco Argentina', 'Rosario', 'Presencial', 'Licenciatura en Administración',
   'Apoyo en la selección de candidatos, armado de bases de datos de postulantes y seguimiento de entrevistas.',
   'Organización, manejo de Excel y buena redacción.',
   20, 10)
) as v(titulo, empresa, ubicacion, modalidad, carrera_requerida, descripcion, requisitos, horas_semanales, duracion_semanas)
where not exists (
  select 1 from public.pasantias p where p.titulo = v.titulo
);

-- 5.3. Postulación ACEPTADA Y EN PROCESO + horas cargadas (estudiante demo)
do $$
declare
  v_usuario_id  bigint;
  v_pasantia_id bigint;
  v_post_id     bigint;
begin
  select id into v_usuario_id
    from public.usuarios where email = 'estudiante@demo.com' limit 1;

  -- a) La que está EN PROCESO (aceptada por la empresa)
  select id into v_pasantia_id
    from public.pasantias where titulo = 'Desarrollo Backend .NET' limit 1;

  insert into public.postulaciones (pasantia_id, usuario_id, estado, tutor, fecha_inicio)
  values (v_pasantia_id, v_usuario_id, 'en_proceso', 'Ing. Carolina Méndez', date '2026-09-07')
  on conflict (pasantia_id, usuario_id) do nothing;

  select id into v_post_id from public.postulaciones
   where pasantia_id = v_pasantia_id and usuario_id = v_usuario_id
   limit 1;

  if not exists (select 1 from public.horas_pasantia where postulacion_id = v_post_id) then
    insert into public.horas_pasantia (postulacion_id, fecha, horas, descripcion) values
      (v_post_id, date '2026-09-07', 8, 'Semana 1: armado del entorno y lectura del código base'),
      (v_post_id, date '2026-09-14', 8, 'Semana 2: endpoints de alta y baja de usuarios'),
      (v_post_id, date '2026-09-21', 6, 'Semana 3: corrección de bugs en el módulo de login'),
      (v_post_id, date '2026-09-28', 8, 'Semana 4: tests automatizados del servicio de contratos'),
      (v_post_id, date '2026-10-05', 8, 'Semana 5: despliegue a staging y documentación');
  end if;

  -- b) Una PENDIENTE, para ver el estado "esperando respuesta"
  select id into v_pasantia_id
    from public.pasantias where titulo = 'Análisis de Datos con Python' limit 1;

  insert into public.postulaciones (pasantia_id, usuario_id, estado, fecha_inicio)
  values (v_pasantia_id, v_usuario_id, 'pendiente', null)
  on conflict (pasantia_id, usuario_id) do nothing;
end $$;
