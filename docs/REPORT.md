# Bitácora de Proyecto y Plan de Implementación

**Rama Actual:** `feature/setup-and-planning`

Este documento es mi bitácora personal de progreso. Aquí registro las decisiones técnicas que tomo, los desafíos que supero y el plan de acción que sigo para completar esta prueba técnica.

---

### 1. Resumen de Mi Progreso Actual

Tras una fase inicial de diagnóstico, he logrado estabilizar con éxito el entorno de desarrollo. Durante este proceso, superé los siguientes desafíos técnicos:

-   **Configuración del Entorno Java:** Diagnostiqué que era necesario un JDK completo para resolver un fallo de compilación relacionado con `jlink`.
-   **Conflicto de Versiones de Kotlin:** Resolví una incompatibilidad entre la versión de Kotlin del proyecto y la que requerían las dependencias de Firebase, para lo cual actualicé la configuración de Gradle.
-   **Conflictos de Dependencias de Flutter:** Mitigué un error de compilación interna en el paquete `flutter_hooks`, ajustando su versión a una más estable y compatible con el resto del ecosistema del proyecto.

**Mi Logro Clave:** Como resultado de estos ajustes, la aplicación ahora compila y se ejecuta correctamente en modo de depuración en el emulador. He establecido una base estable, que considero el punto de partida ideal para el desarrollo de nuevas funcionalidades.

> *Mi Reflexión sobre el Proceso: Considero que la superación de estos obstáculos de configuración, aunque fue un reto, es análoga a la cimentación de un edificio. Ahora que he forjado cimientos sólidos para el entorno, puedo proceder a construir la estructura de la aplicación con mayor confianza y agilidad.*

#### Hito 2: Integración Inicial con Firebase
Siguiendo el plan, procedí a configurar la conexión con Firebase. Este proceso implicó:
1.  **Creación del Proyecto en la Consola de Firebase:** Establecí un nuevo proyecto para la aplicación.
2.  **Configuración de Gradle:** Modifiqué los archivos `build.gradle` (tanto a nivel de proyecto como de app) para incluir y aplicar el plugin de `google-services`, un paso indispensable para que Android procese la configuración de Firebase.
3.  **Resolución de Problemas del `google-services.json`:** Tras un fallo inicial en la compilación que indicaba la ausencia del archivo de configuración, verifiqué su ubicación. Descubrí que había colocado el archivo en `frontend/android/` en lugar de la ruta correcta, `frontend/android/app/`. Corregí la ubicación del archivo.

**Logro Clave:** Con la configuración de Gradle corregida y el archivo `google-services.json` en su lugar, la aplicación ahora se compila y ejecuta reconociendo la conexión con el backend de Firebase. El primer y más crítico prerrequisito del plan de implementación ha sido completado.

#### Hito 3: Activación del Entorno de Desarrollo Local
Para completar el ciclo de desarrollo, el siguiente paso fue activar el entorno de backend local y generar el código de soporte de la aplicación.

1.  **Inicialización del Backend:** Se ejecutaron los comandos `firebase init` y `firebase emulators:start`, configurando y lanzando con éxito los emuladores locales para Firestore y Storage.
2.  **Generación de Código:** Se ejecutó el comando `flutter pub run build_runner build --delete-conflicting-outputs` en el frontend. Este paso es crucial, ya que genera automáticamente el código necesario para que la aplicación interactúe con la base de datos local (`Floor`) y los servicios API (`Retrofit`).

**Logro Clave:** El entorno de desarrollo local está 100% operativo. El frontend se ejecuta y puede comunicarse con el backend emulado localmente. Todos los archivos de código necesarios han sido generados. La base para implementar nuevas funcionalidades está completa.

---

### 2. Mi Plan de Tareas para la Prueba Técnica

A continuación, detallo el plan de tareas que he definido para cumplir con el requisito principal: "Implementar la funcionalidad para que un 'periodista' suba sus propios artículos".

-   [x] **Completar la Configuración de Firebase (Prerrequisito Crítico):**
    -   Seguir las instrucciones del `backend/README.md`.
    -   Crear el proyecto en la consola de Firebase.
    -   Generar y colocar el archivo `google-services.json` en `frontend/android/app/`.
    -   Asegurar que las reglas de Firestore y Storage permitan la lectura/escritura.

-   [x] **Generar Archivos Necesarios (`build_runner`):**
    -   Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs`.

-   [x] **Generar los Íconos de la Aplicación:**
    -   Asegurar que exista `frontend/assets/icon/icon.png`.
    *   Ejecutar `flutter pub run flutter_launcher_icons`.

-   [ ] **Implementar la Funcionalidad de Subida de Artículos:**
    -   Diseñar la UI para la creación de artículos.
    -   Integrar con Firebase Firestore para el almacenamiento de datos.
    -   Integrar con Firebase Storage para la subida de imágenes (si aplica).
    -   Adherirme estrictamente a la Arquitectura Limpia del proyecto.

### Hito 4: Implementación Frontend con Mocks y Correcciones Críticas

Intenté implementar la funcionalidad de subida de artículos para el frontend con mocks, pero me encontré con un persistente y complejo conflicto de versiones de Kotlin en Gradle. Fue una batalla ardua, ya que el proyecto se negaba a compilar debido a errores de incompatibilidad de versiones (específicamente, un módulo compilado con Kotlin 1.8.0 cuando se esperaba 1.6.0). Tras múltiples intentos de actualización y reversión de versiones (kotlin_version, Android Gradle Plugin) en los archivos `build.gradle`, así como una limpieza agresiva y repetida de cachés de Gradle (`flutter clean`, eliminación de `.gradle` del proyecto), finalmente logré restaurar el proyecto a un estado compilable y funcional. El frontend vuelve a correr, los íconos están bien y el dolor de cabeza de la configuración se ha mitigado.

Sin embargo, al verificar visualmente la nueva `ArticleSubmissionPage` (la página de envío de artículos), noté que la UI se renderiza correctamente y los campos de texto funcionan. Pero, al pulsar el botón 'Submit Article', no se activa ninguna acción visible ni en la UI (no aparece el SnackBar de éxito) ni en la consola de depuración (no se imprime el mensaje mock del repositorio). Esto sugiere un problema en la correcta conexión de la UI con el `ArticleSubmissionBloc`.
