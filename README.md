# Ejercicio 2: Optimización del Main Thread

Aplicación Flutter de demostración que genera, serializa, parsea y filtra
100,000 registros JSON sintéticos sin ejecutar ese trabajo en el hilo de la
interfaz. Al terminar, presenta un resumen y notifica el resultado con un
`SnackBar`.

## Requisitos y ejecución

- Flutter SDK instalado.
- La restricción de Dart es `^3.13.3` (definida en `pubspec.yaml`).
- Validado con Flutter 3.47.3 y Dart 3.13.3.

Desde la raíz del proyecto:

```shell
flutter pub get
flutter run
```

Pulsa **Generar reporte**. Mientras se calcula, el botón queda deshabilitado y
se muestra un `CircularProgressIndicator`. Al completarse la tarea, la pantalla
muestra el total de registros, las coincidencias filtradas y el tiempo del
procesamiento.

Para validar cambios:

```shell
flutter analyze
flutter test
```

## Arquitectura y estructura

La app usa una separación ligera por responsabilidades: presentación,
procesamiento y tema. No pretende ser una implementación completa de Clean
Architecture con capas de dominio y repositorios, porque el ejercicio tiene un
único flujo local, sin almacenamiento ni API. Mantener el límite entre widgets
y procesamiento, sin capas vacías, resulta más simple y legible para este
alcance.

```text
lib/
  main.dart                         Punto de entrada y configuración de la app
  screens/
    home_screen.dart                Pantalla y estado de presentación
    home_header.dart                Encabezado de la pantalla
    report_action_card.dart         Acción y estado de carga
    report_result_card.dart         Resumen del reporte completado
    thread_info_card.dart           Información sobre el isolate
  services/
    report_processor.dart           Generación y análisis de los registros
  theme/
    app_colors.dart                 Paleta de colores
    app_text_styles.dart            Estilos tipográficos
    app_theme.dart                  Tema Material de la aplicación
test/
  widget_test.dart                  Pruebas del procesamiento y de la interfaz
```

La pantalla y los widgets visuales se encuentran en archivos separados dentro
de `lib/screens/`, como requiere el ejercicio. Los colores, la tipografía y la
configuración del tema también están separados para evitar valores de estilo
dispersos.

## Flujo de procesamiento

1. `HomeScreen` activa el estado de carga y limpia cualquier resultado anterior.
2. `ReportProcessor.generateReport()` llama a `compute()` con una función de
   nivel superior y un entero como entrada.
3. En plataformas nativas, `compute()` ejecuta esa función en un isolate
   independiente. El isolate crea 100,000 registros JSON, los parsea y aplica
   32 iteraciones de cálculo por registro; después devuelve únicamente
   contadores y métricas simples.
4. La pantalla actualiza el resultado y muestra un `SnackBar` de éxito. Si el
   procesamiento falla, presenta un mensaje de error y vuelve a habilitar la
   acción.

La función aislada no accede al estado de widgets ni a objetos de UI. Su entrada
y salida usan valores transferibles entre isolates. El tiempo mostrado mide el
procesamiento en el isolate, no el tiempo total de ida y vuelta.

## Decisiones técnicas

- **`compute()` en vez de concurrencia manual:** cubre este trabajo puntual sin
  gestionar directamente creación, mensajes y ciclo de vida de un `Isolate`.
  La función de cómputo está fuera de la clase y puede ejecutarse
  independientemente del árbol de widgets.
- **Estado con `StatefulWidget` y `setState`:** hay una sola pantalla y un único
  flujo de carga/resultado. Riverpod u otra solución de estado global sería una
  dependencia y una capa adicionales sin estado compartido que lo justifique.
  Si el proyecto incorpora más pantallas o estado compartido, convendría
  reevaluar esa decisión.
- **Sin dependencias de runtime de terceros:** Flutter ya proporciona
  `compute`, Material, el indicador de progreso y `SnackBar`; no se requieren
  paquetes adicionales para el alcance actual.
- **Datos sintéticos deterministas:** cada registro contiene `id`, `name`,
  `amount` y `category`. El filtrado cuenta los registros cuyo resultado del
  cálculo iterativo es divisible por cinco. No se persisten datos ni se simula
  una respuesta de red.
- **Manejo del ciclo de vida:** tras cada operación asíncrona, la pantalla
  comprueba `mounted` antes de actualizar la interfaz o mostrar notificaciones.
  Los errores se hacen visibles; no se convierten en resultados exitosos.

## Rendimiento y alcance

Delegar el cálculo a un isolate nativo mantiene libre el isolate de UI para
atender animaciones y entrada del usuario durante el trabajo. La interfaz
presenta continuamente el indicador mientras la tarea está pendiente. Esto
reduce el riesgo de bloquear el hilo principal, pero no constituye una garantía
absoluta de 60/120 FPS: el resultado real depende del dispositivo, la carga del
sistema, la memoria y el modo de compilación. Para medir FPS se debe perfilar
una compilación de perfil en un dispositivo objetivo.

En Flutter Web, `compute()` no ofrece la misma garantía de ejecución en un
isolate separado que en plataformas nativas. La demostración de concurrencia de
este ejercicio debe evaluarse en Android, iOS o escritorio nativo.

## Pruebas incluidas

- Comprueba que se procesen 100,000 registros y que el filtro produzca un
  subconjunto válido.
- Comprueba que la interfaz muestre el indicador y el estado de procesamiento
  después de iniciar el reporte.
- Comprueba que, al finalizar, aparezcan el resumen y la notificación de éxito.
