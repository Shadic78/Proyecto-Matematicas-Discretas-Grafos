/*
  Agregar desde el codigo vertices y aristas
*/

// Recibe el nombre y las coordenadas del vertice
void agregarVerticeManual(String nombre, int x, int y) {
  verticesX.add(x);
  verticesY.add(y);
  nombresVertices.add(nombre);
}

// Recibe el nombre de dos vertices, el costo de la arista y si es doblemente dirigida o no
void agregarAristaManual(String vertice1, String vertice2, int costo) {
  matrizAdyacencia[nombresVertices.indexOf(vertice1)][nombresVertices.indexOf(vertice2)] = 1;
  matrizCostos[nombresVertices.indexOf(vertice1)][nombresVertices.indexOf(vertice2)] = costo; 
}

/* Aqui construyes tu grafo */
void grafoPorDefecto() {
  /* Vertices */
  agregarVerticeManual("Vertice1", 100, 100);  
  agregarVerticeManual("Vertice2", 230, 140);  
  agregarVerticeManual("Vertice3", 380, 250);  
  agregarVerticeManual("Vertice4", 130, 300);  
  agregarVerticeManual("Vertice5", 300, 350);  

  /* Aristas */
  agregarAristaManual("Vertice1", "Vertice3", 4);
  agregarAristaManual("Vertice1", "Vertice2", 3);
  agregarAristaManual("Vertice2", "Vertice3", 6);
  agregarAristaManual("Vertice2", "Vertice4", 2);
  agregarAristaManual("Vertice4", "Vertice2", 1);
  agregarAristaManual("Vertice5", "Vertice3", 2);
  agregarAristaManual("Vertice5", "Vertice1", 3);

}