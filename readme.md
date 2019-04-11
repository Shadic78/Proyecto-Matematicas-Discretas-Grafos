### Proyecto de grafos 
- link: https://shadic78.github.io/Proyecto-Matematicas-Discretas-Grafos/.
---

## Bitacora

## 11/04/19
Optimicé bastante el codigo de arrastrar el circulo, antes el codigo llamaba a mouseSobreVertice() continuamente mientras arrastrabas un circulo
y debido a ello los circulos se "atraían" y al mover rapido el mouse se dejaba de arrastrar el circulo, ahora solo se llama a esa funcion una vez.
- Corregi dos problemas: El que al mover rapido el mouse dejas de arrastrar el circulo y el problema de que al arrastrar un circulo
y acercarte a otro circulo se "atraen" como imanes.
- Agregue una variable que sirve para saber si se esta arrastrando un circulo.

## 10/04/19
Empezado el proyecto, se añadio la funcionalidad de poder agregar nodos al dar clic con el mouse,
se agrego la funcionalidad de poder arrastrar los nodos manteniendo presionando el clic izquierdo del mouse y
se agrego que no se pueda poner un nodo muy cerca de otro.
(Todo lo anterior es solo la interfaz grafica)

Problemas:
- **(Corregido 11/04/19)** Al mover un poco rapido el mouse se deja de arrastrar el circulo.
- Al dar clic se verifica que no se puedan poner muy cerca los nodos, pero no se verifica lo mismo para arrastrar los vertices.
- **(Corregido 11/04/19)** Al arrastrar un vertice cerca de algun otro vertice se "atraen", como un iman.
