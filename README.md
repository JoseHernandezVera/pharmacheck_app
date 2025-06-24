# PharmaCheck - Gestión de Medicamentos para Atención Domiciliaria
![Logo de PharmaCheck](assets/images/logo_pildora.png)

## Descripción del Proyecto

PharmaCheck es una aplicación móvil desarrollada con Flutter diseñada para optimizar el trabajo de enfermeros y profesionales de la salud que realizan atención domiciliaria. Su objetivo principal es:

- Registro confiable de la administración de medicamentos a pacientes.
- Mejorar la trazabilidad de tratamientos médicos.
- Reducir errores en la gestión de medicamentos.
- Visualización clara del estado de cada paciente.

La aplicación combina funcionalidades clave con una interfaz amigable y adaptable a diferentes dispositivos.

## Funcionalidades Principales

### 1. Gestión de Pacientes

- Lista organizada de pacientes con filtros (Todos, Críticos, Listos).
- Añadir nuevos pacientes con foto y datos personales.
- Editar o eliminar pacientes existentes.
- Sistema de colores para identificar pacientes críticos (rojo) y aquellos que ya tomaron sus medicamentos (verde).

### 2. Administración de Medicamentos

- Registro de remedios por paciente con horarios específicos.
- Marcar medicamentos como administrados.
- Orden inteligente de medicamentos según proximidad horaria.
- Edición o eliminación de remedios.

### 3. Mapa Integrado

- Visualización de la ubicación aproximada de pacientes.
- Edición manual de direcciones.

### 4. Perfil de Usuario

- Edición de datos personales (nombre, correo, teléfono, fecha de nacimiento).
- Cambio de foto de perfil (desde galería o cámara).

### 5. Noticias Relevantes

- Sección con información útil sobre descuentos en farmacias, campañas de vacunación, entre otros.

### 6. Sistema de Feedback

- Valoración por categorías (usabilidad, diseño, rendimiento).
- Envío de comentarios directamente al desarrollador.

### 7. Personalización

- Modo claro/oscuro o ajuste automático según sistema.
- Tamaños de elementos ajustables (pequeño/mediano).

## Diagrama de la Aplicación

A continuación, se muestra el diagrama de la navegación de la app:

![Diagrama de la App](diagrama_pharmacheck.png)

## Screenshots
| Inicio de Sesión                            | Lista de Pacientes                          | Gestión de Medicamentos                     |
|--------------------------------------------|--------------------------------------------|---------------------------------------------|
| ![Inicio de Sesión](fotos_app/login.jpeg) | ![Lista de Pacientes](fotos_app/1.jpeg) | ![Gestión de Medicamentos](fotos_app/5.jpeg) |

| Mapa                                       | Perfil                                     | Noticias                                    |
|--------------------------------------------|--------------------------------------------|---------------------------------------------|
| ![Mapa](fotos_app/8.jpeg)           | ![Perfil](fotos_app/9.jpeg)       | ![Noticias](fotos_app/10.jpeg)         |

| Drawer                                       |
|--------------------------------------------|
| <img src="fotos_app/4.jpeg" alt="Drawer" width="305"/>           |

## Enlaces Relevantes
- **Repositorio GitHub:** [Acceder al Código](https://github.com/JoseHernandezVera/pharmacheck_app.git)
- **APK de la App:** [Descargar APK](https://github.com/JoseHernandezVera/pharmacheck_app/tree/main/APK/pharmacheck.apk)

## Tecnologías Utilizadas

- Flutter (Framework multiplataforma)
- Sqflite (Autenticación y base de datos)
- Google Maps API (Integración de mapas)
- Provider (Gestión de estado)
- SharedPreferences (Almacenamiento local)
- Image picker (Seleccionar imágenes/videos de la galería o capturar una nueva foto/video con la cámara)

## Autor

José Fernando Hernández Vera  
RUT: 21.370.316-1  
