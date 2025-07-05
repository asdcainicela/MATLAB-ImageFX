MATLAB ImageFX
==============

MATLAB ImageFX es una herramienta simple para el procesamiento de imágenes en escala de grises. 
Permite cargar imágenes y aplicar efectos básicos como umbralización, negativo, logaritmo, potencia 
y resaltado por rango. Ideal para uso educativo o como base para aplicaciones más avanzadas en 
procesamiento de imágenes.

🎯 Características
------------------

- ✅ Carga imágenes en color o escala de grises
- 🎨 Convierte automáticamente a escala de grises para su procesamiento
- 🧮 Aplica 6 efectos básicos:
  1. Umbralización simple
  2. Negativo
  3. Transformación logarítmica
  4. Transformación potencia (c, y)
  5. Umbral doble (A, B)
  6. Resaltado por rango (A, B)

🖼️ Ejemplo
----------

Puedes generar las imágenes al ejecutar el script y tomar capturas con `saveas` o `exportgraphics`.

Estructura del Proyecto
------------------------

📁 MATLAB-ImageFX  
├── efectos_imagen.m      # Función principal con los efectos  
├── main.m                # Script de entrada para ejecutar  
├── img.png               # Imagen de prueba (opcional)  
└── README.txt            # Este archivo  

🚀 Cómo ejecutar
----------------

1. Abre MATLAB.
2. Asegúrate de estar en la carpeta del proyecto.
3. Ejecuta desde la consola:

```matlab```>>>main
O directamente: matlab 
efectos_imagen('img.png')

⚙️ Valores por defecto
Los siguientes valores se usan internamente si no se modifican:

    umbral = 50;
    c = 1.1;
    y = 0.1;
    A = 120;
    B = 150;

Puedes adaptar la función efectos_imagen para recibir estos como parámetros.

🧠 Créditos
Desarrollado como parte de un ejercicio de procesamiento de imágenes en MATLAB.
Inspirado en transformaciones clásicas de escala de grises y operaciones punto a punto.

📜 Licencia
MIT License.