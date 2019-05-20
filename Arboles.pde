// Se actualiza al agregar un vertice
int numNodos = 0;
// Se actualizan al agregar aristas
int numHojas = 0;
int alturaArbol = 0;
/* Raiz del arbol */
int raizArbol = -1;
// Variable para que al cambiar a arboles tengas que asignar una raiz obligatoriamente
boolean seleccionandoRaiz = false;
boolean existeArbol = false;

void validarArbol() { 
  
  /*Únicamente validamos si estamos en modo árboles*/
  if(modoArboles){
    
    int cont = 0, contVert = 0;
    boolean vertSolo = false;
    
    /*Recorremos nuestra matriz de adyacencia*/
    for(int i = 0; i < verticesX.size(); i++){
      
      for(int j = 0; j < verticesX.size(); j++){
        
        /*Contamos el número de aristas*/
        if(matrizAdyacencia[i][j] == 1){
        
                  cont++;
                  contVert++;
         }
       }
       
       /*Si hay algún vértice solo nuestro grafo no puede ser un árbol*/
       if(contVert == 0){
         
         vertSolo = true;
       
       
       }else{
       
         contVert = 0;
       
       }
     }
       
       /*Si se cumple la siguiente condición procedemos a comprobar que sea un árbol el grafo dibujado*/
     if(verticesX.size() - 1 == cont/2 && !vertSolo){
         
       existeArbol = true;
       
       contVert = getAltura();
       
       /*Si la altura nos retorna un 0 significa que se 'trabó' tratando de calcular la altura (no pudo cambiar el valor 0 a algún vértice porque 
       no era adyacente a alguno que tuviese alguna ruta con la raíz)*/
       if(contVert == 0){
         
         existeArbol = false;
       
       
       }else{
       
         existeArbol = true;
       
       }

     }else{
       
       existeArbol = false;
     
     }
  }
  
  
  //return true;  /*******  Aqui va el codigo para validar que sea un arbol  *********/
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
  if(modoArboles && raizArbol >= 0 && existeArbol) {
    int x = 0, y = 0;
    String nodos = "Nodos: " + numNodos;
    String hojas = "Hojas: " + numHojas;
    String altura = "Altura: " + getAltura();
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
  }//else ***Aquí va un texto que diga 'Este grafo no es un árbol'***
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
  
  /*Si existe un árbol, se procede a calcular la altura*/
  if(existeArbol){
    
    /*Variables locales*/
    int a = 1, maximo, contRepeticion = 0;
    int cont = 0, contaux = 0;
    
    /*Vector para almacenar las distancias de todos los vértices a la raíz*/
    int[] distancias = new int[25];
  
    /*Todos los vértices que sean adyacentes a la raíz se inicilizan con 1 (están a 1 de distancia de la raíz)*/
    for(int j = 0; j < verticesX.size(); j++){
    
      if(matrizAdyacencia[0][j] == 1){
      
        distancias[j] = 1;
    
    
      }else{
      
        distancias[j] = 0;
    
      } 
  
    }
    
    
    do{
      
      contaux = 0;
      
      /*Si hay ceros en nuestro vector de distancias significa que a algún vértice no le hemos calculado su distancia con respecto a la raíz*/
      for(int x = 1; x < verticesX.size(); x++){
      
        if(distancias[x] == 0){
        
          contaux++;
        
        }
    
      }
      
      /*Si aún quedan vértices a los cuales calcularles su distancia*/
      if(contaux != 0){
        
        /*Vamos recorriendo nuestro vector de distancias*/
        for(int i = 1; i < verticesX.size(); i++){
          
          /*El índice 'a' fue inicializado con 1. En la primera iteración solo habrá unos (la distancia de los adyacentes a la raíz)*/    
          if(distancias[i] == a){
            
            /*Procedemos a checar quienes son los adyacentes a los que tienen distancia 1 (los que son adyacente a la raíz)*/
            for(int z = 1; z < verticesX.size(); z++){
              
              /*A todos los vértices que sean adyacentes al número 1 se les pondrá en su correspondiente posición de distancias un 2 (están a 2 de distancia de la raíz)*/
              if(matrizAdyacencia[i][z] == 1 && distancias[z] == 0){
          
                distancias[z] = distancias[i] + 1;
          
               }
            }
            
            /*Las distancias que eran 1 serán borradas puesto que hay vértices más alejados*/
            distancias[i] = -1;
            
          }
        }
        
        /*Checamos si aún quedan vértices con distancia 1 a la raíz, en caso afirmativo se vuelve a repetir el proceso anterior*/
        for(int i = 1; i < verticesX.size(); i++){
          
          if(distancias[i] == a){
        
          cont++;
        }
    
      }
      
      /*Si ya no quedan más unos entonces aumentamos nuestro índice a 2 (ahora nos interesa saber cuales vértices están a 3 de distancia)*/
      if(cont == 0){
      
        a++;
      
      }else{
      
        cont = 0;
      }
   
    }
    
    /*Esta función también sirve para validar si existe un árbol, en caso de que no podamos acceder a un vértice (que no sea adyacente con alguno que tenga una ruta desde la raíz) el vector 
    con las distancias se quedará con ceros a los cuales no vamos a poder cambiarles su valor. En caso de que esto pase, podemos estar seguros de que el grafo dibujado no es un árbol*/
    if(contRepeticion == verticesX.size()){
      
      existeArbol = false;
      
      break;
    
    }else{
      
      existeArbol = true;
    
    }
    
    contRepeticion++;
    
  /*Este proceso se repite hasta que ya no queden más vértices a los cuales calcularles las distancia con respecto a la ráiz*/
  } while(contaux != 0);
  
  maximo = distancias[1];
  
  if(existeArbol){
    
    /*Calculamos el trono de nuestro vector(cuando finalizó el proceso, únicamente se quedó el vértice más alejado de la raíz)*/
    for(int i = 1; i < verticesX.size(); i++){
      
      if(distancias[i] > maximo){
        
        maximo = distancias[i];
      }
    }
    
    /*Retornamos el máximo*/
    return maximo;
    
  }else{
    
    return 0;
  }
  
 }

  return 0;

}
