# IKN Forest Parks Social App API

A complete Laravel 11 REST API backend for a social mobile application dedicated to exploring, reviewing, and sharing experiences about Forest Parks in Ibu Kota Nusantara (IKN), Indonesia.

## Features
- **Authentication**: JWT-based or Laravel Sanctum token authentication (register, login, logout, profile).
- **Forest Parks Directory**: CRUD, advanced full-text search, filtering, and PostgreSQL JSONB-based metadata for facilities/hours.
- **Social Feed & Posts**: Users can share experiences, tips, and photos from IKN parks.
- **Interactions**: Like posts, comment on posts, and check-in (Park Visits).
- **PostgreSQL Power**: Full-Text Search and JSONB column operations.

---

## Directory Structure
```text
├── app/
│   ├── Http/
│   │   ├── Controllers/API/
│   │   │   ├── AuthController.php
│   │   │   ├── ForestParkController.php
│   │   │   ├── PostController.php
│   │   │   ├── CommentController.php
│   │   │   ├── LikeController.php
│   │   │   └── ParkVisitController.php
│   │   ├── Requests/
│   │   │   └── StorePostRequest.php
│   │   └── Resources/
│   │       ├── ForestParkResource.php
│   │       └── PostResource.php
│   └── Models/
│       ├── User.php
│       ├── ForestPark.php
│       ├── Post.php
│       ├── Comment.php
│       ├── Like.php
│       └── ParkVisit.php
├── database/
│   ├── migrations/
│   │   ├── 001_create_users_table.php
│   │   ├── 002_create_forest_parks_table.php
│   │   ├── 003_create_posts_table.php
│   │   ├── 004_create_comments_table.php
│   │   ├── 005_create_likes_table.php
│   │   └── 006_create_park_visits_table.php
│   └── seeders/
│       └── ForestParkSeeder.php
├── routes/
│   └── api.php
└── .env.example
```

---

## Requirements
- PHP >= 8.2
- Composer
- PostgreSQL >= 12
- Extension `pdo_pgsql` enabled

---

## Installation & Setup

1. **Clone and Navigate**:
   ```bash
   git clone <repository-url> ikn-forest-parks-api
   cd ikn-forest-parks-api
   ```

2. **Install Dependencies**:
   ```bash
   composer install
   ```

3. **Environment Setup**:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```
   *Configure your database credentials inside `.env`.*

4. **Database Migration & Seeding**:
   ```bash
   php artisan migrate --seed
   ```

5. **Start Development Server**:
   ```bash
   php artisan serve
   ```
   The API will now be accessible at `http://127.0.0.1:8000/api`.

---

## Postman / API Client Testing Guide

All API endpoints are prefixed with `/api`. Use `Accept: application/json` and `Content-Type: application/json` headers. For authenticated endpoints, pass `Authorization: Bearer <token>`.

### Authentication Endpoints
- **POST** `/auth/register` — Register a new user profile
- **POST** `/auth/login` — Log in and retrieve Sanctum token
- **POST** `/auth/logout` *(Auth)* — Revoke active token
- **GET** `/auth/me` *(Auth)* — Retrieve current user profile

### Forest Parks Directory
- **GET** `/parks` — List all forest parks (supports search & filter)
- **POST** `/parks` *(Auth)* — Create a forest park entry
- **GET** `/parks/{id}` — Detail view of a park with check-ins & posts
- **PUT** `/parks/{id}` *(Auth)* — Update forest park
- **DELETE** `/parks/{id}` *(Auth)* — Remove forest park

### Social Feed & Posts
- **GET** `/posts` — View public community feed
- **POST** `/posts` *(Auth)* — Share a new post/review/photo
- **GET** `/posts/{id}` — Retrieve specific post with comments & like count
- **PUT** `/posts/{id}` *(Auth)* — Edit post text
- **DELETE** `/posts/{id}` *(Auth)* — Delete post

### Social Interactions
- **POST** `/posts/{postId}/comments` *(Auth)* — Add comment
- **DELETE** `/comments/{id}` *(Auth)* — Delete comment
- **POST** `/posts/{postId}/like` *(Auth)* — Toggle Like/Unlike on a post
- **POST** `/parks/{parkId}/visit` *(Auth)* — Record a park visit check-in
- **GET** `/parks/{parkId}/visits` — Get visitor history
