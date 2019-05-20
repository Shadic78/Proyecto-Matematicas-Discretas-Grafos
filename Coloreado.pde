
void colorearVertices() {
  /*Si un grafo es plano cumplirá con el teorema de los 4 colores, de lo contrario tal vez no*/
  /*2. - Rojo, 3.- Amarillo, 4.- Verde, 5.- Azul*/
  /*Variables para llevar el control de los colores encontrados*/
  boolean encontradoRojo = false;
  boolean encontradoAmarillo = false;
  boolean encontradoVerde = false;
  /* Colores */
  int rojo = #FF6961;
  int amarillo = #FDFD96;
  int verde = #77DD77;
  int azul = #AEC6CF;
  
  /*Inicializamos una matriz de adyacencia secundaria para llevar el control de los colores encontrados*/
  for(int i = 0; i < adyacencia.length; i++) {
    for(int j = 0; j < adyacencia.length; j++) {
      
      if(matrizAdyacencia[i][j] == 1) {      
         adyacencia[i][j] = 1;
         adyacencia[j][i] = 1;
      }
      
      /*Inicializamos el primer vértice con el color rojo*/
      if((i == 0 || j == 0) && adyacencia[i][j] == 1){     
        adyacencia[i][j] = rojo;
      }
  
    }
    /*Inicializamos el vector donde estarán el orden en que los vértices deben ser coloreados*/
    coloresVert[i] = 0;

  }
  
  /*El primer vértice va de color rojo*/
  coloresVert[0] = rojo;
  
  /*Lectura de la matriz de adyacencia secundaria*/
  for(int i = 1; i < adyacencia.length; i++) {   
    for(int j = 0; j < adyacencia.length; j++) {
      
      /*Empezamos con la segunda fila (la primera ya se inicializó de color rojo)*/
      /*Si encontramos un 2 significa que este vértice es adyacente a uno pintado de color rojo*/
      if(adyacencia[i][j] == rojo){
        
        encontradoRojo = true;
        
        /*Procedemos a checar si es adyacente a un vértice pintado de color amarillo (si hay un 3 en la fila)*/
        for(int x = 0; x < adyacencia.length; x++) {
          
          /*Si encontramos un 3 en esta fila significa que este vértice es adyacente a uno pintado de color amarillo*/
          if(adyacencia[i][x] == amarillo){
            
            encontradoAmarillo = true;
            
            /*Procedemos a checar si es adyacente a un vértice pintado de color verde (si hay un 4 en la fila)*/
            for(x = 0; x < adyacencia.length; x++) {          
               /*Si encontramos un 4 en esta fila significa que este vértice es adyacente a uno pintado de color verde*/
              if(adyacencia[i][x] == verde) {
                encontradoVerde = true;                
                 /*Si encontramos que en esta fila hay un 2(rojo),3(amarillo) o 4(verde), entonces la pintamos de Azul*/
                coloresVert[i] = azul;
                break;             
              }
            }
            
             /*Si al finalizar esta fila NO encontramos un 4(verde) significa que la podemos pintar de verde*/
            if(!encontradoVerde) { 
               coloresVert[i] = verde;              
                for(x = 0; x < adyacencia.length; x++) {               
                  if(adyacencia[i][x] == 1) {                  
                    adyacencia[i][x] = verde;
                    adyacencia[x][i] = verde;                  
                  }
                }                
              }            
            encontradoVerde = false;            
            break;            
        }        
      }
      
      /*Si al finalizar esta fila NO encontramos un 3(amarillo) significa que la podemos pintar de amarillo*/
      if(!encontradoAmarillo) {       
          coloresVert[i] = amarillo;          
          for(int x = 0; x < adyacencia.length; x++) {            
            if(adyacencia[i][x] == 1) {              
              adyacencia[i][x] = amarillo;
              adyacencia[x][i] = amarillo;              
            }
          }                             
        }        
        encontradoAmarillo = false;        
        break;
     }
      
    }//For j
    
    /*Si al finalizar esta fila NO encontramos un 2(rojo) significa que la podemos pintar de rojo*/
    if(!encontradoRojo) {      
      coloresVert[i] = rojo;        
        for(int x = 0; x < adyacencia.length; x++) {          
          if(adyacencia[i][x] == 1) {            
            adyacencia[i][x] = rojo;
            adyacencia[x][i] = rojo;            
          }
        }
      }      
      encontradoRojo = false;
      
  }//For i
  
}

void desactivarColoreadoGrafo() {
  if(colorearGrafo) {
    colorearGrafo = false;  
  }
}

void activarColoreadoGrafo() {
  if(!modoArboles) {
      /*
      Detectar que se presione shift + z
    */
    if(keyCode == SHIFT) {
      keys[0] = true;    
    }
    else {
      if(keys[0]) {
        if(key == 'z' || key == 'Z') {
          keys[1] = true;  
        }
      }
    }
    
    /* Si se presiono shift + z */
    if(keys[0] && keys[1]) {
      if(colorearGrafo) {
        colorearGrafo = false;    
      }
      else {
        colorearVertices();
        colorearGrafo = true;
        existeRuta = false;
      }    
    }      
  }
}