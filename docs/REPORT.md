# Bitácora de Proyecto y Plan de Implementación

**Rama Actual:** `feature/setup-and-planning`

Este documento es mi bitácora personal de progreso. Aquí registro las decisiones técnicas que tomo, los desafíos que supero y el plan de acción que sigo para completar esta prueba técnica.

---

### 1. Resumen de Mi Progreso Actual

Tras una fase inicial de diagnóstico, he logrado estabilizar con éxito el entorno de desarrollo. Durante este proceso, superé los siguientes desafíos técnicos:

-   **Configuración del Entorno Java:** Diagnostiqué que era necesario un JDK completo para resolver un fallo de compilación relacionado con `jlink`.
-   **Conflicto de Versiones de Kotlin:** Resolví una incompatibilidad entre la versión de Kotlin del proyecto y la que requerían las dependencias de Firebase, para lo cual actualicé la configuración de Gradle.
-   **Conflicto de Dependencias de Flutter:** Mitigué un error de compilación interna en el paquete `flutter_hooks`, ajustando su versión a una más estable y compatible con el resto del ecosistema del proyecto.

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

### Nota Crítica: Bloqueo en Firebase Storage
Durante la fase de despliegue del backend, se encontró un obstáculo insuperable: la activación de Firebase Storage en el proyecto `jei-news-app-test` requiere una actualización al plan de facturación "Blaze". A pesar de múltiples intentos con diferentes métodos de pago, el sistema de facturación de Google Cloud declinó las tarjetas, impidiendo la actualización del plan.

**Decisión Técnica:** Debido a este bloqueo externo, se ha tomado la decisión de **des-prioritizar y eliminar la funcionalidad de subida de imágenes** para poder avanzar con el resto de la prueba técnica. El desarrollo continuará enfocándose en la creación y almacenamiento de artículos (solo texto) en Firebase Firestore. Esta desviación del plan original es una medida pragmática para asegurar la entrega de la funcionalidad principal de la aplicación.

### Hito 5: Automatización del Entorno de Desarrollo

Durante las pruebas en un dispositivo físico, identifiqué un punto de fricción importante en el flujo de trabajo: la dirección IP de mi máquina de desarrollo cambiaba, lo que me obligaba a modificar manualmente el código fuente para que la app se conectara al emulador de Firebase. Este proceso era tedioso y propenso a errores.

Para optimizar la experiencia de desarrollo, diseñé e implementé una solución robusta que automatiza completamente esta configuración.

1.  **Implementé una configuración dinámica en `main.dart`**: Modifiqué el punto de entrada de la aplicación para que leyera variables de entorno inyectadas en tiempo de compilación. Usando `String.fromEnvironment`, la aplicación ahora puede diferenciar entre un entorno de `desarrollo` y uno de `producción`. En modo de desarrollo, la app busca la IP del host del emulador que se le pasa como variable.

2.  **Creé un script de ejecución (`run_dev.sh`)**: Para facilitar al máximo el proceso, creé un script de shell que se encarga de todo el trabajo pesado. Al ejecutarlo, el script:
    *   Obtiene automáticamente la dirección IP local actual de la máquina.
    *   Lanza la aplicación Flutter con el comando `flutter run`, usando la bandera `--dart-define` para pasar dinámicamente tanto el entorno de desarrollo como la IP recién obtenida.

**Logro Clave:** Este enfoque no solo resolvió el problema original, sino que también estableció una separación clara y profesional entre los entornos de desarrollo y producción. Eliminé la necesidad de gestionar IPs manualmente, mejorando significativamente la agilidad y fiabilidad del flujo de trabajo del desarrollador.

---

### Conclusión y Aprendizajes del Proceso de Depuración

Este proceso de implementación y depuración se ha enfrentado a numerosos desafíos, especialmente en lo que respecta a la conectividad y configuración del entorno de desarrollo local con Firebase.

A pesar de las múltiples modificaciones y esfuerzos por lograr una conexión estable y un flujo de trabajo de desarrollo eficiente, persisten inconvenientes significativos:

1.  **Conectividad del Servidor Local (Firebase Emulator):** Aunque se ha logrado que el emulador de Firebase sea accesible desde el navegador web del PC usando su IP (`192.168.5.105`), la aplicación Flutter en el dispositivo móvil todavía reporta errores al intentar conectarse. Esto sugiere que, a pesar de la configuración del firewall y la vinculación del emulador a `0.0.0.0`, la aplicación no logra establecer la comunicación.

2.  **Problemas de Despliegue y Hot Reload:** Se experimentaron dificultades persistentes para que los cambios en el código se reflejaran consistentemente en el dispositivo, lo que impactó directamente la eficacia del Hot Reload. Esto llevó a la implementación de scripts (`setup_dev_env.sh`) y a la hardcodeación temporal de IPs en el código (`main.dart`) como medidas paliativas, aunque no ideales para un entorno de producción.

3.  **Bloqueo por Firebase Billing:** Un impedimento externo y crítico fue la imposibilidad de activar Firebase Storage debido a fallos en el sistema de facturación de Google Cloud para el plan "Blaze". Esto bloqueó completamente la funcionalidad de subida de imágenes y forzó una re-priorización del alcance del proyecto hacia el almacenamiento de solo texto.

4.  **Sistema de Debugging en Interfaz (On-Screen Debug Console):** Ante la imposibilidad de acceder a la terminal de depuración tradicional, se implementó un sistema de logging directamente en la interfaz de usuario (`DebugService`, `DebugConsole`). Esta herramienta, aunque funcional y esencial para visualizar los logs internos y errores en tiempo real, se vio afectada por problemas de layout (`BOTTOM OVERFLOW`) que requirieron correcciones adicionales.

**Imposibilidad de Implementación Completa:**

Debido a la concatenación de estos factores –problemas persistentes de conectividad con el emulador, dificultades en el ciclo de desarrollo, y el bloqueo insuperable con el sistema de facturación de Firebase que impidió la activación de Storage–, no fue posible realizar la implementación completa del sistema de añadir artículos nuevos, especialmente en lo que respecta a la funcionalidad de subida de imágenes y la persistencia final de datos.

**Compromiso y Entrega de Avance:**

A pesar de estos desafíos técnicos y externos que escaparon a mi control, y para no faltar al respeto al tiempo acordado, he decidido enviar el avance del proyecto tal como se encuentra. Se ha logrado una interfaz de usuario básica para el formulario de artículos, se han implementado mecanismos de carga y feedback visual, y se ha desarrollado un robusto sistema de depuración en pantalla.

**Aprendizajes Clave:**

Este proceso ha sido una experiencia de aprendizaje intensa, destacando la importancia crítica de un entorno de desarrollo bien configurado y la necesidad de sistemas de depuración adaptables a las limitaciones del entorno. Las filosofías de arquitectura limpia y la necesidad de una documentación de reportes detallada, tal como se promovió en las guías del proyecto, me han parecido extremadamente interesantes y valiosas. Reafirmo mi compromiso con estas metodologías y buscaré aplicarlas consistentemente en mi carrera como desarrollador, a pesar de los evidentes retos encontrados en esta ocasión.
```

#### El Viaje por la Depuración y la Mejora del Entorno

La fase de depuración ha sido un claro ejemplo de la importancia de herramientas de diagnóstico robustas y adaptables. Inicialmente, la falta de visibilidad sobre la salida de la consola de `flutter run` en el entorno del usuario obligó a un cambio radical de estrategia:

*   **Desarrollo de una Consola de Depuración en Pantalla:** Se diseñó e implementó un sistema (`DebugService` y `DebugConsole`) para capturar y mostrar logs directamente en la interfaz de la aplicación. Esta herramienta fue fundamental para:
    *   Visualizar los pasos de inicialización de la app.
    *   Reportar errores de conexión de Firebase.
    *   Verificar si los cambios de código se estaban aplicando al dispositivo (`VERSIÓN DE PRUEBA: [fecha y hora actual]`).
    *   Superar problemas de usabilidad del propio widget flotante de la consola, ajustando su tamaño, posición y añadiendo funcionalidad de copiado de logs.

*   **Normalización del Flujo de Desarrollo:** El Hot Reload inconsistente y la gestión de IPs dinámicas fueron obstáculos significativos. Se abordaron mediante:
    *   La creación de `setup_dev_env.sh`: Un script que automatiza la configuración del entorno (obtención y exportación de la IP local) y prepara el proyecto con `flutter clean` y `flutter pub get` antes de cada ejecución, asegurando una compilación fresca y un Hot Reload funcional.
    *   Hardcodeo temporal de la IP del emulador en `main.dart`: Una medida pragmática para aislar y depurar el problema de conectividad de Firebase, validando que el emulador era accesible desde la red.

*   **Identificación y Resolución de Bloqueos de Conectividad:** La aplicación enfrentó barreras de comunicación a diferentes niveles:
    *   **Firewall del PC:** Se diagnosticó y resolvió el bloqueo de puertos del firewall (`ufw` en Debian) que impedía la comunicación entre el teléfono y el emulador.
    *   **Enlace del Emulador de Firebase:** Se descubrió que el emulador, por defecto, no se enlazaba a la IP de red del PC, requiriendo la configuración de `"host": "0.0.0.0"` en `backend/firebase.json`.
    *   **Permisos y Configuración de Red en Android:** Finalmente, se identificaron y corrigieron permisos cruciales en `AndroidManifest.xml` (`android.permission.INTERNET`, `android:usesCleartextTraffic="true"`) que impedían a la aplicación establecer cualquier conexión de red.

Este meticuloso proceso de depuración, aunque prolongado, fue indispensable para diagnosticar y abordar sistemáticamente cada capa de los problemas de conectividad y usabilidad del entorno, culminando en un entorno de desarrollo mucho más transparente y funcional, a pesar de los retos finales de la conectividad con el emulador.