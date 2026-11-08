# rey-qt6-hp

Tema oscuro para pantalla de inicio de sesión de SDDM, diseñado para entornos Qt 6 y con un estilo visual moderno, limpio y minimalista.

## Descripción

Este proyecto es un tema de greeter para SDDM (Simple Desktop Display Manager) que ofrece una interfaz de login con:

- fondo de pantalla con soporte para múltiples monitores
- selector de sesión y distribución de teclado
- controles de apagado, reinicio y suspensión
- diseño oscuro con estética tipo glassmorphism
- compatibilidad con Qt Quick/QML

La lógica principal se encuentra en `Main.qml`, mientras que los recursos visuales y configuración del tema se ubican en la raíz del proyecto.

## Requisitos

- Linux con SDDM instalado
- Qt 6 runtime/components
- Un entorno gráfico compatible con SDDM

## Estructura del proyecto

```text
.
├── Main.qml                 # Vista principal del tema
├── metadata.desktop         # Metadatos del tema para SDDM
├── theme.conf               # Configuración general del tema
├── wall.jpg                 # Fondo principal
├── wall.png                 # Variante del fondo
├── default.jpg              # Imagen por defecto
├── *.png                    # Iconos y elementos visuales
├── reyComponents/           # Componentes QML reutilizables
└── README.md                # Documentación del proyecto
```

## Instalación

1. Copia la carpeta del tema a la ubicación de temas de SDDM:

```bash
sudo cp -r /ruta/al/proyecto /usr/share/sddm/themes/rey-qt6
```

2. Configura SDDM para usar el tema:

```bash
sudo nano /etc/sddm.conf
```

o, si usas un archivo por separado:

```bash
sudo nano /etc/sddm.conf.d/kde_settings.conf
```

Luego asegúrate de tener algo similar a:

```ini
[Theme]
Current=rey-qt6
```

3. Reinicia SDDM o reinicia el sistema para ver el cambio:

```bash
sudo systemctl restart sddm
```

## Personalización

### Cambiar fondo

Edita el archivo `theme.conf`:

```ini
[General]
background=wall.jpg
```

Puedes reemplazar `wall.jpg` por otra imagen o cambiar la ruta a un archivo nuevo dentro del proyecto.

### Ajustar colores y estilo

La paleta principal y muchos detalles visuales están definidos dentro de `Main.qml`. Allí puedes modificar:

- colores primarios
- sombras y bordes
- fuentes
- dimensiones y espacios
- comportamiento de elementos interactivos

## Solución de problemas

- Si el tema no aparece, verifica que `metadata.desktop` tenga bien definido `MainScript=Main.qml`.
- Si falla el fondo, asegúrate de que el archivo indicado en `theme.conf` exista en la raíz del tema.
- Si SDDM falla al iniciar, revisa los logs del servicio con:

```bash
journalctl -b -u sddm
```

## Licencia

Este proyecto usa la configuración del tema y los recursos asociados con fines de personalización del entorno gráfico. Revisa los archivos individuales y la licencia del contenido si vas a redistribuir o modificar los recursos visuales.

## Créditos

Proyecto basado en el estilo visual de un tema oscuro para SDDM, adaptado para Qt 6 y para uso en entornos Lubuntu/Ubuntu-like.
