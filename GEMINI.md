## Project Overview

This is a Flutter-based mobile news application designed for Android. It follows a strict **Clean Architecture** pattern, ensuring a separation of concerns, scalability, and maintainability. The core functionality of the application is to fetch top headlines from the [NewsAPI.org](http://NewsAPI.org) service, display them to the user, and allow the user to save articles for offline reading.

The project is divided into two main parts:
1.  `frontend/`: The Flutter application itself.
2.  `backend/`: Configuration files for a Firebase backend, although the primary news feature does not seem to utilize it.

---

## Frontend Analysis (`frontend/`)

The Flutter application is well-organized and leverages several modern libraries to achieve its robust architecture.

### 1. Core Architecture: Clean Architecture

The application is structured into three distinct layers as per Clean Architecture principles:

#### a. Domain Layer
This is the core of the application. It contains the business logic and is completely independent of any other layer.
-   **Entities (`lib/features/daily_news/domain/entities/`):** Represents the core business objects. `ArticleEntity` is the main entity, defining what a news article is within the app.
-   **Repositories (`lib/features/daily_news/domain/repository/`):** Abstract interfaces that define the contract for data operations (e.g., `getNewsArticles`, `saveArticle`). This layer dictates *what* data operations are possible, but not *how* they are implemented.
-   **Use Cases (`lib/features/daily_news/domain/usecases/`):** Encapsulate a single, specific business rule. For example, `GetArticle` is responsible for fetching the list of news articles. They orchestrate the flow of data from repositories to the presentation layer.

#### b. Data Layer
This layer is responsible for the implementation of the repository contracts defined in the domain layer. It handles all data retrieval and storage logic.
-   **Models (`lib/features/daily_news/data/models/`):** Data Transfer Objects (DTOs) that are responsible for parsing data from external sources (like JSON from an API) and being mapped to/from domain entities. `ArticleModel` extends `ArticleEntity` and adds data-specific functionalities like `fromJson` and database annotations (`@Entity`).
-   **Data Sources:**
    -   **Remote (`.../remote/`):** Handles fetching data from the network. `NewsApiService` uses the `retrofit` library to define a type-safe client for the NewsAPI.org REST API. The API key and base URL are defined in `lib/core/constants/constants.dart`.
    -   **Local (`.../local/`):** Manages local data persistence. `AppDatabase` (using the `floor` library, a SQLite abstraction) and `ArticleDao` provide the mechanism to save, retrieve, and delete articles from a local SQLite database.
-   **Repositories Impl (`.../repository/`):** `ArticleRepositoryImpl` is the concrete implementation of the `ArticleRepository` from the domain layer. It decides whether to fetch data from the `NewsApiService`, the `AppDatabase`, or both.

#### c. Presentation Layer
This is the layer that the user interacts with (the UI). It is responsible for displaying data and capturing user input.
-   **State Management (`.../bloc/`):** The project uses `flutter_bloc` for state management. This is a predictable state management library that helps separate UI from business logic.
    -   `RemoteArticleBloc`: Manages the state for fetching articles from the API (loading, success, error).
    -   `LocalArticleBloc`: Manages the state for saved articles.
-   **Pages/Views (`.../pages/`):** These are the actual screens of the application, such as the home page displaying the news (`DailyNews`) and the page for saved articles (`SavedArticle`). These widgets listen to state changes from the BLoCs and rebuild themselves accordingly.
-   **Widgets (`.../widgets/`):** Reusable UI components, like `ArticleTile`, used across different pages.

### 2. Dependency Injection (`get_it`)

The file `lib/injection_container.dart` is the architectural heart of the application. It uses the `get_it` service locator to initialize and register all major components (BLoCs, Use Cases, Repositories, Data Sources). This decouples the layers from each other, making the app easier to test and maintain. For instance, when a BLoC requests a `GetArticle` use case, `get_it` provides the registered instance without the BLoC needing to know how it was created.

### 3. Navigation

The file `lib/config/routes/routes.dart` defines the navigation routes for the application, mapping string-based routes to the corresponding page widgets.

### 4. Entry Point

`lib/main.dart` is the entry point. It initializes the dependency injection container (`initializeDependencies()`) and sets up the initial BLoC provider (`RemoteArticlesBloc`). Upon startup, it immediately dispatches the `GetArticles` event to the BLoC, triggering the initial data fetch to populate the main screen with news.

---

## Backend Analysis (`backend/`)

The `backend/` directory contains standard configuration files for deploying services to Google Firebase.

-   `firebase.json`: Configures which Firebase services are deployed. It's set up for Firestore and Storage.
-   `firestore.rules`: Defines the security rules for the Cloud Firestore database. The current rules are restrictive, only allowing reads/writes if a user is authenticated (`allow read, write: if request.auth != null;`).
-   `storage.rules`: Defines security rules for Firebase Cloud Storage, with similar authentication requirements.

**Observation:** While the Flutter app's `pubspec.yaml` includes Firebase dependencies (`firebase_core`, `cloud_firestore`), the core "daily news" feature fetches data from **NewsAPI.org** and stores it in a **local SQLite database**. The Firebase backend seems to be configured but is not used by the main feature. It may be intended for future features like user authentication and profile synchronization, or it could be a remnant of a different implementation.

---

## Summary of Key Files

-   `frontend/pubspec.yaml`: Project manifest. Lists all dependencies (bloc, get_it, retrofit, floor, firebase).
-   `frontend/lib/injection_container.dart`: **Architectural blueprint.** Wires all layers together using dependency injection.
-   `frontend/lib/main.dart`: App entry point. Initializes services and triggers the first data fetch.
-   `frontend/lib/features/daily_news/domain/entities/article.dart`: The core business object.
-   `frontend/lib/features/daily_news/data/models/article.dart`: The data transfer object with JSON/database logic.
-   `frontend/lib/features/daily_news/data/repository/article_repository_impl.dart`: The mediator between remote/local data sources and the rest of the app.
-   `frontend/lib/features/daily_news/data/data_sources/remote/news_api_service.dart`: Retrofit client for the external NewsAPI.
-   `frontend/lib/features/daily_news/data/data_sources/local/app_database.dart`: `floor` database definition for local storage.
-   `frontend/lib/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart`: State management for the main news feed.
-   `backend/firebase.json` & `backend/firestore.rules`: Configuration and security for a currently unused Firebase backend.

---

## Development and Architectural Guidelines

This section summarizes the rules, guidelines, and conventions extracted from the `/docs` directory. These are critical for maintaining code quality and architectural integrity.

### 1. Core Architectural Principles (`APP_ARCHITECTURE.md`)

-   **Structure:** The app is strictly divided into three layers: `Presentation`, `Domain` (Business Logic), and `Data`.
-   **Communication Flow:** The `Domain` layer is central and must be self-contained (pure Dart, no external project imports).
    -   The `Data` layer can only import from the `Domain` layer.
    -   The `Presentation` layer can only import from the `Domain` layer.
-   **Test Folder:** The `test/` directory must mirror the `lib/` folder structure exactly.

### 2. Architectural Violations to Avoid (`ARCHITECTURE_VIOLATIONS.md`)

This is a list of strict "don'ts". Violating these will result in rejected Pull Requests.

-   **Data Layer:**
    -   **NEVER** import from the `Presentation` layer.
    -   **`data_sources`** is the **ONLY** place to interact with external services (APIs, Firebase, etc.).
    -   **`repository`** implementations are the **ONLY** place to import from `data_sources`.
    -   Models in `data/models` **MUST ALWAYS** extend an `Entity` from the domain layer.
    -   Repository methods that fetch data **MUST** return a `DataState<Type>`.

-   **Domain Layer (Business Logic):**
    -   **NEVER** import from any other module within the project (except core Dart/Flutter libraries). It must remain pure.
    -   Repository interfaces (`domain/repository`) must **ONLY** contain abstract definitions, no implementation.
    -   Repository interface methods must return `Entities`, **NEVER** `Models`.

-   **Presentation Layer:**
    -   **NEVER** access the `Data` layer directly.
    -   **`blocs`** are the **ONLY** place to interact with `Use Cases` from the domain layer. They should not contain business logic themselves, only UI state management.

### 3. Coding Guidelines (`CODING_GUIDELINES.md`)

-   **Boy Scout Rule:** Always leave the code cleaner than you found it. Refactor and add tests when modifying existing code.
-   **Meaningful Names:**
    -   Use intention-revealing names.
    -   Class names are **Nouns**.
    -   Function names are **Verbs**.
-   **Functions:**
    -   Must be **small** and follow the **Single Responsibility Principle (SRP)**.
    -   Nesting depth should not exceed 2.
    -   The ideal number of arguments is 0 or 1. Avoid 3 or more.
    -   **Command Query Separation:** Functions should either *do* something (mutate state) or *answer* something (return data), but not both.
-   **Classes:**
    -   Must be **small** and have a single responsibility.
-   **TDD (Test-Driven Development):** Writing a failing test before writing production code is a strict rule.
-   **Abstract Classes:** Use abstract classes/interfaces to isolate code from changes in concrete implementations.

### 4. Contribution Guidelines (`CONTRIBUTION_GUIDELINES.md`)

-   All changes must be made on a **separate branch**.
-   Changes are merged into the `main` branch via **Pull Requests (PRs)**.
-   PRs are reviewed against the architecture and coding guidelines documents.

### 5. Step-by-Step Development Workflow

This is the strict workflow to follow for any code modification or implementation.

1.  **Create a New Branch:** Never work directly in `main`. Always create a new branch for your task (e.g., `feature/your-feature-name`).

2.  **Identify the Correct Layer:** Before coding, determine where the change belongs in the **Clean Architecture**:
    *   **Presentation Layer:** For UI and user interaction changes.
    *   **Domain Layer:** For new business logic or rules.
    *   **Data Layer:** For new data sources or repository implementations.

3.  **Apply the TDD (Test-Driven Development) Cycle:**
    *   **a. Write a Failing Test:** In the `test/` folder, write a unit test for the new functionality. Run it and confirm that it fails.
    *   **b. Write Minimum Code:** Write only the necessary production code to make the test pass.
    *   **c. Refactor:** Once the test passes, clean up your code. Apply the "Boy Scout Rule" to improve the surrounding area.

4.  **Verify Architectural Rules:** While coding, continuously check:
    *   Are you respecting the dependency flow (Data -> Domain <- Presentation)?
    *   Is your function/class small and has a single responsibility?
    *   Are you avoiding forbidden imports between layers?

5.  **Repeat the Cycle:** Continue the TDD cycle (Steps 3 & 4) for each piece of functionality until the task is complete.

6.  **Create a Pull Request:** Once your feature is finished and all tests pass, push your branch and open a **Pull Request** to merge into `main`.

### 6. Report Instructions (`REPORT_INSTRUCTIONS.md`)

-   This document contains instructions for a project-end report, likely for the user (as an applicant). It does not contain direct development guidelines for the codebase itself.

---
## Aviso: Configuración de Entorno Específica del Usuario

La siguiente sección detalla una configuración de entorno de desarrollo altamente específica, diseñada para un caso de uso particular (almacenamiento dividido entre SSD y HDD). **Esta configuración no es un requisito para la ejecución estándar del proyecto.** Si usted no comparte esta necesidad específica de dividir los SDKs y el código fuente en diferentes unidades de almacenamiento, puede ignorar esta sección sin que afecte su capacidad para compilar y ejecutar el proyecto.

---

## Contexto Técnico Detallado: Entorno de Desarrollo Flutter en Almacenamiento Dividido

### 1. Resumen Ejecutivo y Objetivo Principal

El entorno de desarrollo ha sido configurado con una arquitectura de almacenamiento dividido. El objetivo principal es mitigar el uso de espacio en el disco de estado sólido (SSD) principal, que es de capacidad limitada, delegando el almacenamiento de herramientas y componentes pesados a un disco duro mecánico (HDD) externo de mayor capacidad.

*   **SSD (Principal):** Reservado para el sistema operativo y el código fuente de los proyectos.
*   **HDD (Externo):** Aloja los SDKs de Flutter y Android, así como los Dispositivos Virtuales de Android (AVDs), que son los componentes que más espacio consumen.

Cualquier operación, instalación o actualización debe respetar imperativamente esta división.

---

### 2. Arquitectura de Rutas y Ubicaciones de Componentes

La siguiente tabla detalla la ubicación exacta de cada componente crítico:

┌───────────────────┬──────────────────┬───────────────────────────────────────────────────────┐
│ Componente        │ Ubicación Física │ Ruta Absoluta                                         │
├───────────────────┼──────────────────┼───────────────────────────────────────────────────────┤
│ SDK de Flutter    │ HDD Externo      │ /media/jeisonleon/CopiesWee/development/flutter/      │
│ SDK de Android    │ HDD Externo      │ /media/jeisonleon/CopiesWee/development/android_sdk/  │
│ AVDs (Emuladores) │ HDD Externo      │ /media/jeisonleon/CopiesWee/development/.android/avd/ │
│ Código Fuente     │ SSD Principal    │ /home/jeisonleon/Documentos/projects/Technical tests/ │
└───────────────────┴──────────────────┴───────────────────────────────────────────────────────┘

**IMPERATIVO:** No se debe instalar ni mover ninguno de los SDKs o AVDs a las rutas por defecto (p. ej., `~/` o `~/Android/`). Todas las herramientas deben operar sobre las rutas especificadas en el HDD.

---

### 3. Configuración de Variables de Entorno: El Rol Crítico de `~/.profile`

Toda la configuración de las variables de entorno se ha centralizado en el archivo `~/.profile`.

*   **Archivo de Configuración:** `~/.profile`
*   **Justificación:** El archivo `~/.bashrc` del usuario contiene una "cláusula de guarda" que impide su ejecución en shells no interactivas (`case $- in ... *) return;; esac`). Dado que las herramientas de automatización y algunos terminales integrados (como los de una IA) pueden usar shells no interactivas, `~/.bashrc` no es una opción fiable para definir el `PATH`. `~/.profile` se carga al iniciar la sesión y sus variables son heredadas por todos los procesos, garantizando que el entorno esté disponible tanto para terminales interactivas como para scripts y aplicaciones GUI.

*   **Variables Definidas en `~/.profile`:**
    *   `ANDROID_HOME`: Apunta a la raíz del SDK de Android.
        *   `export ANDROID_HOME="/media/jeisonleon/CopiesWee/development/android_sdk"`
    *   `ANDROID_AVD_HOME`: Apunta a la carpeta donde se guardan los emuladores.
        *   `export ANDROID_AVD_HOME="/media/jeisonleon/CopiesWee/development/.android/avd"`
    *   `PATH`: Se ha modificado para incluir las rutas a los binarios de Flutter y de las herramientas de Android.
        *   `...:$PATH:/media/jeisonleon/CopiesWee/development/flutter/bin`
        *   `...:$PATH:$ANDROID_HOME/cmdline-tools/latest/bin`
        *   `...:$PATH:$ANDROID_HOME/platform-tools/bin`
        *   `...:$PATH:$ANDROID_HOME/emulator/bin`

---

### 4. Flujo de Trabajo y Comandos Esenciales

**Regla de Oro para Scripts y Terminales No-Login:** Antes de ejecutar cualquier comando de Flutter o Android en un nuevo shell de scripting, se debe asegurar que el entorno esté cargado.

*   **Comando de Activación (OBLIGATORIO en scripts):**
    ```bash
    source ~/.profile
    ```
    Ejemplo: `source ~/.profile && flutter doctor`

*   **Verificación del Entorno:**
    ```bash
    source ~/.profile && flutter doctor
    ```
    Resultado esperado: `[✓] Android toolchain` debe aparecer con un tic verde.

*   **Manejo del Emulador:**
    *   Listar emuladores disponibles: `source ~/.profile && flutter emulators`
    *   Iniciar el emulador creado: `source ~/.profile && flutter emulator --launch pixel_8_api_34`

*   **Ejecución de la Aplicación:**
    *   Desde una terminal (ya sea en VS Code o independiente): `source ~/.profile && flutter run`
    *   Para un dispositivo específico: `source ~/.profile && flutter run -d pixel_8_api_34`

---

### 5. Componentes Instalados y Estado Actual

*   **SDK de Flutter:** Versión 3.22.2 (o la que se haya instalado), canal stable.
*   **SDK de Android:**
    *   `platform-tools`
    *   `build-tools;34.0.0`
    *   `platforms;android-34`
    *   `emulator`
    *   `system-images;android-34;google_apis;x86_64`
*   **AVD Creado:**
    *   Nombre: `pixel_8_api_34`
*   **Licencias de Android:** Todas las licencias han sido aceptadas.

---

### 6. Puntos Críticos y Advertencias para la IA

1.  **NO MODIFICAR `~/.bashrc`:** No intentes añadir ninguna variable de entorno a `~/.bashrc`. Fallará en shells no interactivas. Usa siempre `~/.profile`.

2.  **REINICIO PARA APLICACIONES GRÁFICAS:** Para que aplicaciones como VS Code detecten correctamente las variables de entorno, es necesario reiniciar el sistema o, como mínimo, cerrar la sesión y volver a iniciarla. Abrir una nueva terminal no es suficiente para las aplicaciones GUI.

3.  **VERIFICACIÓN ANTES DE LA ACCIÓN:** Antes de intentar instalar nuevos paquetes o ejecutar la aplicación, siempre ejecuta `source ~/.profile && flutter doctor` para asegurar que el estado del entorno es el esperado.

4.  **PERSISTENCIA DE LA CONFIGURACIÓN:** Todas las rutas son absolutas y apuntan a un disco montado en `/media/jeisonleon/CopiesWee`. Si el punto de montaje del disco cambia, el entorno dejará de funcionar y será necesario actualizar las rutas en `~/.profile`.

5.  **NO USAR `sudo` PARA COMANDOS FLUTTER/SDK:** Ninguno de los comandos de `flutter`, `sdkmanager` o `avdmanager` debe ejecutarse con `sudo`. Todos los permisos están a nivel de usuario.
