# 🚀 Pasos Finales para Despliegue

Este documento sirve como recordatorio de las configuraciones externas necesarias para que **Filmer** funcione al 100% en producción.

## 1. Configuración de Datos (Películas) 🎬

### Obtener API Key de TMDb
1.  Registrate o inicia sesión en [themoviedb.org](https://www.themoviedb.org/).
2.  Ve a **Ajustes** -> **API** (o usa este enlace directo: [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)).
3.  Solicita una clave API (Tipo "Developer" es suficiente).
4.  Copia la **"API Key (v3 auth)"**.

### Insertar en la App
1.  Abre el archivo `.env` que está en la raíz del proyecto (`c:\Users\NicolasTercero\filmer\.env`).
2.  Sustituye el texto por tu clave:
    ```env
    TMDB_API_KEY=tu_clave_copiada_aqui
    ```
3.  ¡Listo! La app ya descargará datos reales.

---

## 2. Configuración del Proyecto Firebase 🔥

Para que funcione el Login (Google/Apple) y el Multijugador (Sincronización de Salas):

1.  Ve a [Firebase Console](https://console.firebase.google.com/).
2.  Crea un nuevo proyecto (ej. `filmer-app`).

### Activar Servicios en la Consola
*   **Authentication**:
    *   Ve al menú "Authentication" -> "Sign-in method".
    *   Activa el proveedor **Google**.
    *   Activa el proveedor **Apple**.
*   **Firestore Database**:
    *   Ve al menú "Firestore Database".
    *   Pulsa **"Crear base de datos"**.
    *   Selecciona ubicación (ej. `eur3` para Europa o `nam5` para US).
    *   Elige **"Modo de prueba"** (Test Mode) para empezar sin bloqueos de seguridad iniciales.

### Conectar la App (Archivos de Configuración)

#### Para Android (Google Login)
1.  En la configuración del proyecto Firebase (engranaje), añade una app **Android**.
2.  Paquete: `com.example.filmer` (verifícalo en tu `android/app/build.gradle`).
3.  **Generar Huella SHA-1** (CRÍTICO para que el login funcione):
    *   Abre una terminal en la carpeta del proyecto.
    *   Ejecuta: `cd android` y luego `./gradlew signingReport` (Mac/Linux) o `gradlew signingReport` (Windows).
    *   Busca la sección `Task :app:signingReport`. Copia el código hexadecimal que pone **SHA1** de la variante `debug`.
    *   Pégalo en la configuración de la app en Firebase.
4.  Descarga el archivo `google-services.json`.
5.  Muévelo a: `c:\Users\NicolasTercero\filmer\android\app\google-services.json`.

#### Para iOS (Google & Apple Login)
1.  Añade una app **iOS** en Firebase.
2.  Descarga el archivo `GoogleService-Info.plist`.
3.  Abre el proyecto en Xcode (`ios/Runner.xcworkspace`).
4.  Arrastra el archivo dentro de la carpeta `Runner` en el navegador de Xcode.
5.  Asegúrate de marcar "Sign in with Apple" en la pestaña "Signing & Capabilities" de tu proyecto ("Runner").

---

## 3. Verificación Final ✅

1.  Cierra la app completamente y vuélvela a lanzar (`flutter run`).
2.  Si ves portadas de películas reales en lugar de datos de prueba -> **TMDb funciona**.
3.  Si puedes loguearte con Google/Apple y crear una sala sin ver errores en la consola -> **Firebase Auth y Firestore funcionan**.
