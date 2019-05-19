// Se actualiza al agregar un vertice
int numNodos = 0;
// Se actualizan al agregar aristas
int numHojas = 0;
int alturaArbol = 0;
/* Raiz del arbol */
int raizArbol = -1;
// Variable para que al cambiar a arboles tengas que asignar una raiz obligatoriamente
boolean seleccionandoRaiz = false;

boolean validarArbol() { 
  return true;  /*******  Aqui va el codigo para validar que sea un arbol  *********/
}

void activarSeleccionarRaiz() {
  if(modoArboles && !nombrandoVertice && !asignandoCostoArista && !agregandoArista && !borrandoArista && !preparandoRutaMasCorta) {
    if(key == 'r' || key == 'R') {
      seleccionandoRaiz = true;  
    }  
  }
}

void seleccionarRaiz() {
  if(modoArboles && seleccionandoRaiz && mouseButton == LEFT) {
    int raizNueva = mouseSobreVertice(0);
    if(raizNueva >= 0) {
      raizArbol = raizNueva; 
      seleccionandoRaiz = false;
    }
  }
}

// Hace que todas las aristas sean de doble camino y con costo 1
void convertirAGrafoNoDirigido(int matrizAdyacencia[][], int matrizCostos[][]) {
  for(int i = 0; i < verticesX.size(); i++) {
    for(int j = 0; j < verticesX.size(); j++) {
      if(matrizAdyacencia[i][j] == 1) {
        matrizAdyacencia[j][i] = 1;  
      }
      if(matrizCostos[i][j] > 0) {
        matrizCostos[i][j] = 1;
        matrizCostos[j][i] = 1;
      }
    }
  }
}

void imprimirDatosArbol() {
  if(modoArboles && raizArbol >= 0) {
    int x = 0, y = 0;
    String nodos = "Nodos: " + numNodos;
    String hojas = "Hojas: " + numHojas;
    String altura = "Altura: " + alturaArbol;
    String raiz = "Raiz: " + nombresVertices.get(raizArbol);
    // Contenedor
    fill(#CB99C9);
    strokeWeight(0);
    textAlign(LEFT);
    rect(x, y, textWidth(raiz) + 40, tamTexto * 4 + 8 * 3 + 20, 8);
    // Texto
    fill(255);
    text(nodos, x + 20, y + 20);
    text(hojas, x + 20, y + 20 + tamTexto + 8);
    text(altura, x + 20, y + 20 + tamTexto * 2 + 8 * 2);
    text(raiz, x + 20, y + 20 + tamTexto * 3 + 8 * 3);
  }
}

/************
  PENDIENTES
************/
int getNumNodos() {
  return verticesX.size();  
}

int getNumHojas() {
  int hojas = 0;
  int contador = 0;
  for(int i = 0; i < verticesX.size(); i++) {
    for(int j = 0; j < verticesX.size(); j++) {
      
      if(matrizAdyacencia[i][j] == 1 && i != raizArbol) {
        contador++;
        if(contador > 1) {
          break;  
        }
      }        
      
    } //for j
    
    if(contador == 1) {
      hojas++;  
    }
    contador = 0;
    
  } //for i
  return hojas;
}

int getAltura() {
  return 0;
}