### Proyecto de grafos 
- link: https://shadic78.github.io/Proyecto-Matematicas-Discretas-Grafos/.
---

## Bitacora
- Notas: En algunos navegadores no funciona el borrar el nombre del vertice debido a que no permiten detectar cuando se presiona
la tecla "BACKSPACE", borrar el nombre del vertice funciona correctamente si ejecutas el archivo de manera local con Processing 3.

## 12/04/19
La interfaz grafica esta casi terminada, solo queda hacer muchas pruebas para verificar que no hayan bugs y agregar el poder
borrar vertices y aristas.

**Añadidos:**
- Se agrego una "matriz de adyacencia", la cual representa al grafo (no dirigido).
- Se agrego el poder agregar vertices al dar clic derecho.

**Correciones:**
- Puedes borrar el nombre del vertice que estes escribiendo.


**Problemas:**
- La matriz que representa al grafo tiene un limite de tamaño.

**Screenshots:**
![](Screenshot1.png)

## 11/04/19
Se sigue trabajando en la interfaz grafica.

**Añadidos:**
- Se agrego el poder nombrar los vertices al crearlos.
- Se agrego que no puedas crear o mover otros vertices hasta que no hayas terminado de nombrar el vertice actual.
- Se agrego un pequeño efecto de "parpadeo" al nombrar un vertice (no se nota mucho).
- Se agrego un mensaje que aparece abajo de la ventana, el cual le da indicaciones al usuario.
- se agrego una variable que sirve para saber si se esta arrastrando un vertice.
- Se agrego una variable que sirve para saber si se esta nombrando un vertice.

**Correciones:**
Optimicé bastante el codigo de arrastrar el vertice, antes el codigo llamaba a mouseSobreVertice() continuamente mientras arrastrabas un vertice
y debido a ello los vertices se "atraían" y al mover rapido el mouse se dejaba de arrastrar el vertice, ahora solo se llama a esa funcion una vez.
- Se corrigio el problema de que al mover rapido el mouse dejabas de arrastrar el vertice.
- Se corrigio el problema de que al arrastrar un vertice y acercarte a otro vertice se "atraen", como imanes.


**Problemas:**
- El nombrado del vertice no tiene limite de tamaño.

## 10/04/19
Se empezo el proyecto, se esta trabajando la interfaz grafica.

**Añadidos:**
- se agrego la funcionalidad de poder agregar vertices al dar clic con el mouse.
- se agrego la funcionalidad de poder arrastrar los vertices manteniendo presionando el clic izquierdo del mouse.
- se agrego que no se pueda poner un vertice muy cerca de otro.

**Problemas:**
- **(Corregido 11/04/19)** Al mover un rapido el mouse se deja de arrastrar el vertice.
- Al dar clic se verifica que no se puedan poner muy cerca los vertices, pero no se verifica lo mismo para arrastrar los vertices.
- **(Corregido 11/04/19)** Al arrastrar un vertice cerca de algun otro vertice se "atraen", como un iman.
