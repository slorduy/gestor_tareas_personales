# Gestor de Tareas Personales

App móvil construida con Flutter para crear, organizar y hacer seguimiento de tareas personales. Permite gestionar el ciclo de vida de cada tarea desde su creación hasta su completitud, con persistencia local y soporte de tema oscuro.

---

## Capturas

| Inicio – Todas las tareas | Inicio – Por hacer | Detalle |
|:---:|:---:|:---:|
| ![Inicio - todas las tareas](screenshots/home_all.png) | ![Inicio - por hacer](screenshots/home_todo.png) | ![Detalle](screenshots/task_detail.png) |

| Nueva tarea | Editar tarea | Tema oscuro |
|:---:|:---:|:---:|
| ![Nueva tarea](screenshots/add_task.png) | ![Editar tarea](screenshots/edit_task.png) | ![Tema oscuro](screenshots/dark_mode.png) |

---

## Funcionalidades

- **Crear tareas** con título y descripción
- **Ver detalle** de cada tarea al tocarla
- **Editar** título y descripción de una tarea existente
- **Eliminar** tareas con confirmación previa
- **Avanzar estado** desde el menú contextual de cada tarjeta: `Por hacer → En proceso → Completado`
- **Filtrar por estado** mediante tabs: Todos, Por hacer, En proceso, Completado
- **Tema oscuro / claro** con persistencia de la preferencia
- **Persistencia local** con SharedPreferences: las tareas se conservan al cerrar la app

---

## Tecnologías

| Paquete | Uso |
|---|---|
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | Gestión de estado |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistencia local |
| [uuid](https://pub.dev/packages/uuid) | Generación de IDs únicos por tarea |

---

## Estructura del proyecto

```
lib/
├── core/
│   ├── enums/
│   │   └── task_states.dart           # Estados de tarea con color y clave de persistencia
│   └── models/
│       └── task.dart                  # Modelo inmutable de tarea
├── data/
│   ├── repositories/
│   │   └── task_repository.dart       # Acceso a datos y construcción de nuevas tareas
│   └── storage/
│       └── preference_service.dart    # Abstracción sobre SharedPreferences
├── presentation/
│   ├── providers/
│   │   ├── preference_provider.dart   # Provider de SharedPreferences (inyectado en main)
│   │   ├── task_repository_provider.dart
│   │   ├── task_selectors.dart        # Providers derivados filtrados por estado
│   │   ├── tasks_provider.dart        # Estado y lógica de la lista de tareas
│   │   └── theme_provider.dart        # Estado del tema claro/oscuro
│   ├── screens/
│   │   ├── home_screen.dart           # Pantalla principal con tabs por estado
│   │   ├── add_task_screen.dart       # Formulario para crear una tarea
│   │   ├── edit_task_screen.dart      # Formulario para editar una tarea existente
│   │   └── task_detail_screen.dart    # Vista de detalle de una tarea
│   ├── theme/
│   │   └── app_theme.dart             # Definición de temas claro y oscuro
│   └── widgets/
│       ├── delete_task_dialog.dart    # Diálogo de confirmación de eliminación
│       ├── task_badge.dart            # Chip de estado de la tarea
│       ├── task_card.dart             # Tarjeta reutilizable para mostrar una tarea
│       ├── task_list_builder.dart     # agrupa y crea la lista de tareas de acuerdo a la agrupacion por estado
│       ├── task_form.dart             # Formulario compartido entre crear y editar
│       └── task_list.dart             # Lista de tareas con estado vacío
└── main.dart                          # Punto de entrada e inyección de dependencias
```

---

## Cómo correr el proyecto

**Requisitos previos:** Flutter SDK instalado. Verificar con:

```bash
flutter doctor
```

**Pasos:**

```bash
# 1. Clonar el repositorio
git clone https://github.com/slorduy/gestor_tareas_personales.git
cd gestor_de_tareas_personales

# 2. Instalar dependencias
flutter pub get

# 3. Correr la app
flutter run
```

---

## Flujo de estados de una tarea

```
Por hacer  ──▶  En proceso  ──▶ Completado
```

El avance es unidireccional. Una tarea completada no puede retroceder de estado.

---

## Decisiones de diseño

- **Modelo inmutable:** `Task` tiene todos sus campos `final`. Cualquier modificación crea una nueva instancia, lo que hace los cambios trazables y evita mutaciones accidentales.
- **Separación de capas:** La lógica de negocio vive en `data/`, los providers en `presentation/providers/` y los widgets en `presentation/widgets/`, siguiendo una arquitectura por capas.
- **Inyección de SharedPreferences:** Se inicializa en `main()` antes de `runApp` y se inyecta vía `ProviderScope.overrides`, desacoplando los providers del acceso directo a disco.
- **Color en el enum:** `TaskStates` lleva el color y la clave de persistencia directamente para evitar mapeos dispersos en la UI y mantener compatibilidad con datos guardados si el texto visible cambia.
- **Formulario compartido:** `TaskForm` es reutilizado por las pantallas de crear y editar, evitando duplicación de lógica de validación.
 