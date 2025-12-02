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

---

### 2. Mi Plan de Tareas para la Prueba Técnica

A continuación, detallo el plan de tareas que he definido para cumplir con el requisito principal: "Implementar la funcionalidad para que un 'periodista' suba sus propios artículos".

-   [x] **Completar la Configuración de Firebase (Prerrequisito Crítico):**
    -   Seguir las instrucciones del `backend/README.md`.
    -   Crear el proyecto en la consola de Firebase.
    -   Generar y colocar el archivo `google-services.json` en `frontend/android/app/`.
    -   Asegurar que las reglas de Firestore y Storage permitan la lectura/escritura.

-   [ ] **Generar Archivos Necesarios (`build_runner`):**
    -   Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs`.

-   [ ] **Generar los Íconos de la Aplicación:**
    -   Asegurar que exista `frontend/assets/icon/icon.png`.
    *   Ejecutar `flutter pub run flutter_launcher_icons`.

-   [ ] **Implementar la Funcionalidad de Subida de Artículos:**
    -   Diseñar la UI para la creación de artículos.
    -   Integrar con Firebase Firestore para el almacenamiento de datos.
    -   Integrar con Firebase Storage para la subida de imágenes (si aplica).
    -   Adherirme estrictamente a la Arquitectura Limpia del proyecto.

-   [ ] **Revisar Documentación del Proyecto:**
    -   Asegurar que toda la implementación cumpla con las guías en `docs/`.

---