# 🎬 Movie Application Backend

A robust, scalable RESTful API and GraphQL backend for managing a movie catalog, built with Go and designed for cloud-native deployment.

## 📋 Table of Contents

- [Overview](#Overview)
- [Features](#Features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Local Development with Docker Compose](#local-development-with-docker-compose)
  - [Kubernetes Deployment](#kubernetes-deployment)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Authentication](#authentication)
- [Environment Variables](#environment-variables)
- [Future Enhancements](#future-enhancements)

## 🎯 Overview

This project is a full-featured backend service for a movie catalog application. It provides both RESTful and GraphQL APIs for managing movies, genres, and user authentication. The application is containerized with Docker and includes Kubernetes manifests for production-ready cloud deployment.

## ✨ Features

- **RESTful API**: Complete CRUD operations for movies and genres
- **GraphQL Support**: Flexible queries with list, search, and get operations
- **JWT Authentication**: Secure user authentication with access and refresh tokens
- **External API Integration**: Automatic poster image fetching from TheMovieDB
- **Role-Based Access Control**: Protected admin routes for content management
- **PostgreSQL Database**: Relational database with proper foreign key relationships
- **Docker Support**: Fully containerized application with multi-stage builds
- **Kubernetes Ready**: Production-ready K8s manifests with persistent storage
- **CORS Enabled**: Configured for frontend integration

## 🛠 Tech Stack

**Backend:**
- Go 1.21
- Chi Router (HTTP routing)
- GraphQL-Go (GraphQL implementation)
- JWT-Go (JSON Web Tokens)
- PostgreSQL (Database)

**DevOps:**
- Docker & Docker Compose
- Kubernetes
- Multi-stage Docker builds

**External Services:**
- TheMovieDB API (for poster images)

## 🏗 Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│   Go Backend API    │
│  (Chi Router)       │
│  - REST Endpoints   │
│  - GraphQL API      │
│  - JWT Auth         │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   PostgreSQL DB     │
│  - Movies           │
│  - Genres           │
│  - Users            │
│  - Movies_Genres    │
└─────────────────────┘
```

## 📦 Prerequisites

- **Go** 1.21 or higher
- **Docker** and Docker Compose
- **Kubernetes** cluster (for K8s deployment)
- **kubectl** configured
- **PostgreSQL** 14 (if running without Docker)

## 🚀 Getting Started

### Local Development with Docker Compose

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd <project-directory>
   ```

2. **Start the services**
   ```bash
   docker-compose up --build
   ```

3. **Access the API**
   - Backend API: `http://localhost:8080`
   - PostgreSQL: `localhost:5433`

4. **Stop the services**
   ```bash
   docker-compose down
   ```

### Kubernetes Deployment

1. **Build and push Docker image**
   ```bash
   docker build -t mmuzza3/myapp:1.0.0 .
   docker push mmuzza3/myapp:1.0.0
   ```

2. **Apply Kubernetes manifests**
   ```bash
   # Create PostgreSQL resources
   kubectl apply -f postgres-configmap.yaml
   kubectl apply -f postgres-pvc.yaml
   kubectl apply -f postgres-deployment.yaml
   kubectl apply -f postgres-service.yaml

   # Create backend resources
   kubectl apply -f backend-deployment.yaml
   kubectl apply -f backend-service.yaml
   ```

3. **Verify deployment**
   ```bash
   kubectl get pods
   kubectl get services
   ```

4. **Access the application**
   ```bash
   # Port forward to access locally
   kubectl port-forward service/backend-service 8080:80
   ```

## 📡 API Documentation

### Public Endpoints

#### Health Check
```http
GET /
```
Returns API status and version.

#### Authentication
```http
POST /authenticate
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "password"
}
```

#### Get All Movies
```http
GET /movies
```

#### Get Single Movie
```http
GET /movies/{id}
```

#### Get All Genres
```http
GET /genres
```

#### Get Movies by Genre
```http
GET /movies/genres/{id}
```

#### GraphQL Query
```http
POST /graph
Content-Type: application/json

{
  "query": "{ list { id title description } }"
}
```

**GraphQL Operations:**
- `list`: Get all movies
- `search(titleContains: "keyword")`: Search movies by title
- `get(id: 1)`: Get movie by ID

### Protected Admin Endpoints

Requires JWT token in Authorization header: `Bearer <token>`

#### Get Movie for Edit
```http
GET /admin/movies/{id}
Authorization: Bearer <token>
```

#### Insert Movie
```http
PUT /admin/movies/0
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Movie Title",
  "release_date": "2023-01-01T00:00:00Z",
  "runtime": 120,
  "mpaa_rating": "PG-13",
  "description": "Movie description",
  "genres_array": [1, 2, 3]
}
```

#### Update Movie
```http
PATCH /admin/movies/{id}
Authorization: Bearer <token>
```

#### Delete Movie
```http
DELETE /admin/movies/{id}
Authorization: Bearer <token>
```

### Token Management

#### Refresh Token
```http
GET /refresh
Cookie: __Host-refresh_token=<refresh-token>
```

#### Logout
```http
GET /logout
```

## 📁 Project Structure

```
.
├── cmd/
│   └── api/
│       ├── main.go              # Application entry point
│       ├── handlers.go          # HTTP handlers
│       ├── routes.go            # Route definitions
│       ├── middleware.go        # Custom middleware
│       ├── auth.go              # JWT authentication logic
│       ├── db.go                # Database connection
│       └── utils.go             # Helper functions
├── internal/
│   ├── models/
│   │   ├── movie.go            # Movie and Genre models
│   │   └── user.go             # User model
│   ├── graph/
│   │   └── graphql.go          # GraphQL schema and resolvers
│   └── repository/
│       ├── repository.go        # Repository interface
│       └── dbrepo/
│           └── postgres.go      # PostgreSQL implementation
├── sql/
│   └── create_tables.sql       # Database schema
├── kubernetes/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-service.yaml
│   ├── postgres-pvc.yaml
│   └── postgres-configmap.yaml
├── Dockerfile                   # Multi-stage Docker build
├── docker-compose.yaml          # Local development setup
├── go.mod                       # Go module dependencies
└── README.md                    # This file
```

## 🗄 Database Schema

### Tables

**movies**
- `id` (PK)
- `title`
- `release_date`
- `runtime`
- `mpaa_rating`
- `description`
- `image`
- `created_at`
- `updated_at`

**genres**
- `id` (PK)
- `genre`
- `created_at`
- `updated_at`

**users**
- `id` (PK)
- `first_name`
- `last_name`
- `email`
- `password` (bcrypt hashed)
- `created_at`
- `updated_at`

**movies_genres** (junction table)
- `id` (PK)
- `movie_id` (FK → movies.id)
- `genre_id` (FK → genres.id)

## 🔐 Authentication

The application uses JWT (JSON Web Tokens) for authentication with a two-token system:

1. **Access Token**: Short-lived (15 minutes) for API requests
2. **Refresh Token**: Long-lived (24 hours) stored in HTTP-only cookie

**Default credentials:**
- Email: `admin@example.com`
- Password: `password` (bcrypt hashed in database)

## 🔧 Environment Variables

**Docker Compose:**
- `DB_HOST`: postgres
- `DB_PORT`: 5432
- `DB_USER`: postgres
- `DB_PASSWORD`: postgres
- `DB_NAME`: movies

**Kubernetes:**
Environment variables are defined in `backend-deployment.yaml` and use the `postgres-service` for database connectivity.

**Application Flags:**
- `--dsn`: Database connection string
- `--jwt-secret`: JWT signing secret
- `--jwt-issuer`: Token issuer
- `--jwt-audience`: Token audience
- `--cookie-domain`: Cookie domain
- `--api-key`: TheMovieDB API key

---

**Built with ❤️ using Go**
