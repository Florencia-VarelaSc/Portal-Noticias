# Sistema de publicaciones / noticias

Trabajo Práctico N.º 1 - Programación IV (UTN). Aplicación Ruby on Rails con back-office
administrativo y API JSON para un sistema de noticias.

## Objetivo general

Permitir que administradores y periodistas gestionen noticias mediante un back-office,
y que usuarios finales se registren, consulten noticias, comenten y guarden favoritos
a través de una API JSON versionada, pensada para ser consumida por un frontend externo
(Trabajo Práctico N.º 2).

## Tipos de usuario

- **Administrador / periodista** (`role: admin` / `journalist`): usa el back-office en `/admin`,
  autenticado por sesión de Rails. Gestiona noticias, categorías, usuarios y comentarios.
- **Usuario final** (`role: reader`): consume la API en `/api/v1`, autenticado con un token
  enviado en el header `Authorization: Bearer <token>`.

## Modelo de datos

5 modelos principales:

- `User` — `name`, `email`, `password_digest`, `role` (enum: reader/journalist/admin),
  `active`, `api_token`. `has_many :news_articles, :comments, :favorites`.
- `Category` — `name`. `has_many :news_articles`.
- `NewsArticle` — `title`, `body`, `status` (enum: draft/published/archived), `published_at`.
  `belongs_to :user, :category`. `has_many :comments, :favorites`. `has_one_attached :cover_image`.
  Validación de negocio: no puede guardarse como `published` sin `published_at`.
- `Comment` — `body`. `belongs_to :user, :news_article`.
- `Favorite` — `belongs_to :user, :news_article`. Validación de unicidad (un usuario no puede
  favoritear la misma noticia dos veces).

## Instalación y ejecución

Requisitos: Ruby 3.2+, SQLite3.

```bash
bundle install
bin/rails db:create db:migrate
bin/rails server
```

La app queda disponible en `http://localhost:3000`.

## Preparar la base de datos

```bash
bin/rails db:create db:migrate
```

Para cargar un administrador de prueba:

```bash
bin/rails runner '
User.find_or_create_by!(email: "admin@utn.edu.ar") do |u|
  u.name = "Admin UTN"
  u.password = "admin1234"
  u.role = :admin
end
'
```

## Acceso al back-office

- URL: `http://localhost:3000/admin/login`
- Credenciales de prueba: `admin@utn.edu.ar` / `admin1234`

## Endpoints principales de la API

Todos los endpoints (excepto registro y login) requieren el header:
`Authorization: Bearer <token>`

| Método | Endpoint                          | Descripción                          |
|--------|------------------------------------|---------------------------------------|
| POST   | `/api/v1/register`                | Registro de usuario final             |
| POST   | `/api/v1/login`                   | Login, devuelve token                 |
| GET    | `/api/v1/news`                    | Listado de noticias publicadas        |
| GET    | `/api/v1/news?category_id=:id`    | Noticias filtradas por categoría      |
| GET    | `/api/v1/news/:id`                | Detalle de una noticia                |
| POST   | `/api/v1/news/:id/comments`       | Comentar una noticia                  |
| GET    | `/api/v1/categories`              | Listado de categorías                 |
| GET    | `/api/v1/favorites`               | Favoritos del usuario autenticado     |
| POST   | `/api/v1/favorites`               | Agregar favorito                      |
| DELETE | `/api/v1/favorites/:id`           | Quitar favorito                       |
| GET    | `/api/v1/profile`                 | Perfil del usuario autenticado        |

## Active Storage

Se usa para la imagen de portada de las noticias (`NewsArticle#cover_image`), adjuntable
desde el formulario del back-office.

## Action Mailer

Se envía un email de bienvenida (`UserMailer#welcome_email`) al registrarse un usuario
desde la API. En desarrollo, los emails se loggean en consola (no se envían realmente).

## Testing

```bash
bin/rails test
```

Incluye tests de modelos (validaciones, enum de estado, lógica de publicación, unicidad
de favoritos) y tests de integración (login del back-office, y flujo completo de la API:
registro, login, noticias, comentarios, favoritos, perfil).

## Calidad de código y seguridad

```bash
bin/rubocop      # 0 observaciones
bin/brakeman     # 0 vulnerabilidades de código
```

Brakeman reporta una advertencia de "Unmaintained Dependency" sobre la versión de Ruby
del entorno de desarrollo utilizado (3.2.3, EOL). No corresponde a una vulnerabilidad de
código de la aplicación; se recomienda actualizar a una versión de Ruby soportada antes
de un despliegue a producción.

## Git

El proyecto se desarrolló con commits incrementales que reflejan la evolución: proyecto
inicial, modelos uno por uno, back-office, API, Action Mailer y tests. Ver `git log` para
el historial completo.
