# Supabase

Aqui viven las migraciones SQL y las funciones necesarias para el backend.

Proyecto conectado: **Examenes** (organizacion `Anzi`, ref `sdkacefvpppvufkfzolb`, region `eu-west-1`). La URL y la clave publica ya estan en `.env.local` (no versionado); para volver a vincular la CLI usa `supabase link --project-ref sdkacefvpppvufkfzolb` con un access token de cuenta (`supabase login` o `SUPABASE_ACCESS_TOKEN`).

## Migraciones

1. `0001_initial_schema.sql` - categorias, perfiles (con `username` para el login), tests, preguntas, intentos y respuestas.
2. `0002_row_level_security.sql` - RLS en todas las tablas; `questions` solo es consultable directamente por administradores.
3. `0003_ranking_views.sql` - vistas `test_rankings`, `category_rankings` y `general_rankings`.
4. `0004_test_taking_functions.sql` - `get_test_questions()` (preguntas sin `correct_options`) y `submit_attempt()` (corrige y guarda el intento en el servidor).
5. `0005_self_registration.sql` - columnas `first_name`/`last_name`/`birth_date` en `profiles`; permite que un participante cree su propia fila en `profiles` (nunca con `is_admin = true`) y que `age_categories` se lea sin sesion (para el desplegable de categorias en el registro).

Aplicar en orden con `supabase db push` o pegando el contenido en el SQL editor del proyecto.

## Contenido (seed)

`seed/` guarda el SQL generado por `scripts/import-questions.mjs` a partir de un CSV con el formato de `content/plantilla_preguntas.csv` (categorias que falten + `tests` + `questions`). Se aplica despues de las 4 migraciones. Ver la seccion "De la plantilla al SQL" del README principal para el comando exacto.

## Decisiones tomadas

- Los participantes inician sesion con **usuario**, no con email. `profiles.username` guarda el nombre visible para el login y Supabase Auth almacena un email sintetico `<username>@participants.local`.
- Desde la migracion `0005`, el alta de usuarios es **autoregistro**: cualquiera crea su propia cuenta desde `/registro` (nombre, apellido, fecha de nacimiento, categoria, usuario, contrasena). La politica RLS de insert/update en `profiles` permite `id = auth.uid()` pero nunca deja que el propio usuario se ponga `is_admin = true`; solo un admin existente puede crear perfiles admin.
- Requisito de configuracion en el proyecto Supabase (no esta en las migraciones SQL, es config de Auth): `mailer_autoconfirm` debe estar en `true` (Authentication > Providers > Email > "Confirm email" desactivado), porque el dominio sintetico `@participants.local` no puede recibir correos de confirmacion. Sin esto, `auth.signUp()` no devuelve sesion activa y el registro se queda a medias.
- Las edades no se validan contra la categoria elegida: si no coinciden, la pantalla de registro muestra un aviso pero deja continuar (decision explicita del profesor).
- Un participante solo puede enviar **un intento por test** (`unique (test_id, user_id)` en `test_attempts`). Si el profesor quiere permitir reintentos, hay que revisar esta restriccion y la funcion `submit_attempt`.
- Las clasificaciones (`*_rankings`) son vistas propiedad del rol de migracion, por lo que no aplican las politicas RLS de "solo mis propios intentos": muestran datos agregados de todos los participantes a proposito. Muestran `profiles.display_name` (nombre y apellido reales desde el registro), nunca `username`.

## Pendiente

- Decidir si se ocultan las clasificaciones mientras un test sigue abierto (`tests.ends_at`).
- El autoregistro abierto permite que una misma persona cree varias cuentas con distinto usuario para repetir un test que solo permite un intento; no hay control contra esto todavia (p. ej. deduplicar por nombre+apellido+fecha de nacimiento).
- Cargar contenido real de preguntas por categoria (hoy solo esta el ejemplo de 1 Samuel 1).
