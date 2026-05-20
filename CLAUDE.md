# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
# Build and run
./mvnw spring-boot:run

# Build only (produces target/car4s.war)
./mvnw package

# Run tests
./mvnw test

# Clean build
./mvnw clean package
```

The app starts at `http://localhost:8080/car4s/`. Test accounts: admin/123456, mechanic1/123456, owner1/123456.

## Tech Stack

- Spring Boot 2.7.0, Java 1.8, Maven, WAR packaging
- MyBatis 2.2.2 + MySQL + Druid connection pool
- JSP views (tomcat-embed-jasper) + JSTL
- PageHelper for pagination

## Database Configuration

MySQL connection defaults to `localhost:3306/car4s_db` with no password. All DB settings support env var overrides:

| Env var | Default |
|---------|---------|
| `DB_URL` | `jdbc:mysql://localhost:3306/car4s_db?...` |
| `DB_USERNAME` | `root` |
| `DB_PASSWORD` | (empty) |
| `SERVER_PORT` | `8080` |
| `DB_POOL_INITIAL/MIN/MAX` | `5/5/20` |

## Project Architecture

```
controller/         ← Spring MVC @Controller (view routing, no REST APIs)
    LoginController     ← /, /login, /logout, /register
    AdminController     ← /admin/* (dashboard, users, parts, orders, complaints, messages)
    MechanicController  ← /mechanic/* (dashboard, orders, messages, maintenance reminders)
    OwnerController     ← /owner/* (dashboard, vehicles, appointments, orders, messages, complaints, evaluations)
service/            ← thin orchestration layer over mappers
mapper/             ← MyBatis mapper interfaces (@Mapper annotation)
model/              ← POJOs: User, Vehicle, ServiceOrder, Part, Message, Complaint, Evaluation
config/
    WebConfig           ← registers LoginInterceptor + DateConverter (String→Date)
    DateConverter       ← @RequestParam String-to-Date converter
interceptor/
    LoginInterceptor    ← session-based auth + role-based URL access control
```

**Role-based access**: The LoginInterceptor checks `session.user` and restricts `/owner/`, `/mechanic/`, `/admin/` paths to the matching role. Admin bypasses role checks (can access all areas).

**MyBatis mappers**: XML files live in `src/main/resources/mapper/*.xml`. Each has a `resultMap` mapping underscore DB columns to camelCase Java properties. `application.yml` enables `map-underscore-to-camel-case` globally.

**View resolution**: JSP views in `src/main/webapp/WEB-INF/jsp/{role}/*.jsp`. Spring MVC view prefix/suffix configured as `/WEB-INF/jsp/` → `.jsp`. Context path is `/car4s`.

## Key Patterns

- Services delegate directly to mappers — no complex business logic
- Controller methods use `Model` for view attributes and return view name strings (no `@ResponseBody`)
- CRUD follows REST-style URL patterns: `/admin/user/edit/{id}` (GET), `/admin/user/update` (POST), `/admin/user/delete/{id}` (GET)
- Session attribute `"user"` holds the logged-in `User` object; checked by `LoginInterceptor.preHandle()`
- `application.properties` not used — all config in `application.yml`
