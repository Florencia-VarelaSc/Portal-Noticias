# Portal de Noticias

Trabajo Práctico N.º 1 - Programación IV - UTN.

Aplicación desarrollada con Ruby on Rails que implementa un back-office administrativo y una API JSON versionada para la gestión de un portal de noticias.

## Objetivo

El sistema permite que administradores y periodistas gestionen el contenido mediante un back-office autenticado.

Además, dispone de una API REST bajo `/api/v1`, destinada a usuarios finales y preparada para ser consumida posteriormente por un frontend externo.

## Tipos de usuario

El sistema utiliza tres roles:

- `admin`: administrador del sistema.
- `journalist`: periodista.
- `reader`: usuario final de la API.

El back-office utiliza autenticación mediante sesión de Rails.

Los usuarios finales de la API utilizan un token enviado mediante:

`Authorization: Bearer <token>`

## Modelo de datos

El sistema cuenta con los siguientes modelos principales:

### User

Contiene:

- nombre
- email
- contraseña segura
- rol
- estado activo
- token de API

Roles disponibles:

- reader
- journalist
- admin

Un usuario puede tener noticias, comentarios y favoritos.

### Category

Representa las categorías utilizadas para clasificar las noticias.

Una categoría puede contener múltiples noticias.

### NewsArticle

Representa una noticia.

Contiene:

- título
- cuerpo
- estado
- fecha de publicación
- autor
- categoría

Estados disponibles:

- draft
- published
- archived

Una noticia puede tener comentarios y favoritos.

Además utiliza Active Storage para almacenar una imagen de portada.

### Comment

Representa un comentario realizado por un usuario sobre una noticia.

### Favorite

Relaciona un usuario con una noticia marcada como favorita.

Existe una validación de unicidad para impedir que un usuario marque dos veces como favorita la misma noticia.

## Instalación

Requisitos principales:

- Ruby 3.2.3
- Rails 8.1.3.1
- SQLite3
- Bundler

Instalar las dependencias:

```bash
bundle install
```

Preparar la base de datos:

```bash
bin/rails db:prepare
bin/rails db:seed
```

Los seeds generan los usuarios y categorías necesarios para realizar una demostración del sistema.

## Ejecutar el proyecto

```bash
bin/rails server -p 3001
```

La aplicación estará disponible en:

`http://localhost:3001`

## Back-office

Acceso:

`http://localhost:3001/admin/login`

### Administrador

Email:

`admin@utn.edu.ar`

Contraseña:

`admin123`

### Periodista

Email:

`finoraapp@gmail.com`

Contraseña:

`periodista123`

El back-office permite gestionar:

- Noticias
- Categorías
- Usuarios
- Comentarios

Las operaciones disponibles dependen del rol del usuario autenticado.

## API REST

La API se encuentra versionada bajo:

`/api/v1`

### Autenticación

El login devuelve un token de API.

Los endpoints protegidos requieren:

```text
Authorization: Bearer <token>
```

### Endpoints principales

| Método | Endpoint | Descripción |
|---|---|---|
| POST | `/api/v1/register` | Registrar usuario final |
| POST | `/api/v1/login` | Autenticar usuario y obtener token |
| GET | `/api/v1/news` | Listar noticias |
| GET | `/api/v1/news/:id` | Obtener una noticia |
| GET | `/api/v1/categories` | Listar categorías |
| POST | `/api/v1/news/:news_id/comments` | Crear comentario |
| GET | `/api/v1/favorites` | Listar favoritos |
| POST | `/api/v1/favorites` | Agregar favorito |
| DELETE | `/api/v1/favorites/:id` | Eliminar favorito |
| GET | `/api/v1/profile` | Obtener perfil del usuario autenticado |

## Active Storage

Active Storage se utiliza para asociar una imagen de portada a cada noticia.

La imagen puede cargarse desde el formulario de noticias del back-office.

## Action Mailer

El proyecto incluye `UserMailer`.

Cuando un usuario se registra mediante la API se ejecuta el correo de bienvenida mediante:

```ruby
UserMailer.welcome_email(user).deliver_later
```

## Testing

Ejecutar:

```bash
bin/rails test
```

Último resultado verificado:

```text
13 runs
42 assertions
0 failures
0 errors
0 skips
```

Se incluyen pruebas de modelos y pruebas de integración de los principales flujos de la aplicación.

## RuboCop

Para analizar la calidad y el estilo del código:

```bash
bin/rubocop
```

Último resultado verificado:

```text
68 files inspected, no offenses detected
```

## Brakeman

Para realizar el análisis estático de seguridad:

```bash
bin/brakeman
```

Último análisis:

```text
Errors: 0
Security Warnings: 2
```

Las advertencias detectadas son:

1. `Unmaintained Dependency`: Ruby 3.2.3 finalizó su período de soporte.
2. `Mass Assignment`: Brakeman advierte que `role` puede ser modificado desde el controlador de usuarios.

La modificación del rol pertenece al back-office y está protegida mediante `require_admin_role`, por lo que únicamente un administrador autorizado puede realizar dicha operación.

La actualización de Ruby queda como mejora futura del entorno.

## Comandos de verificación

```bash
bin/rails test
bin/rubocop
bin/brakeman
```

## Ramas del proyecto

### main

Versión correspondiente al TP1, enfocada en:

- Back-office
- API REST
- modelos y lógica de negocio

### front-tp2

Conserva el desarrollo realizado del frontend para continuar su integración en la siguiente etapa del proyecto.