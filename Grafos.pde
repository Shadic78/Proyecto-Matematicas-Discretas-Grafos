/*
	Carlos Chan Gongora
 */
/*******************
  ArrayLists para la parte grafica de los grafos
 *******************/
// ArrayLists que almacenan las coordenadas (x, y) de los vertices
ArrayList<Integer> verticesX = new ArrayList<Integer>();
ArrayList<Integer> verticesY = new ArrayList<Integer>();
// ArrayList que almacena los nombres de los vertices
ArrayList<String> nombresVertices = new ArrayList<String>();

// Matriz que representa al grafo internamente
int[][] matrizAdyacencia = new int[50][50];

// Variables de los mensajes que aparecen abajo izquierda de la pantalla
int tamTexto = 16;
String mensaje = " ";

// Variables para los vertices
int widthVertices = 40;
int posVerticeArrastrando = 0;
boolean nombrandoVertice = false;
boolean moviendoVertice = false;
String nombreVertice = "";

// Variables para las aristas
boolean agregandoArista = false;
boolean borrandoArista = false;
// Guarda la posicion en los arrayList del primer vertice al que le das click
int posVertice1 = -1;
// Guarda la posicion en los arrayList del segundo vertice al que le das click
int posVertice2 = -1;

/********
 Colores
 **********/
// Color de fondo original: #e8e9ea
int colorBackground = #e8e9ea;
PImage imgBackground;

// Colores de los vertices
int rellenoVertice = #51EDEC;
int bordeVertice = #46cecd;
// Grosor del borde del vertice
int grosorBordeVertice = 5;

// Color de las aristas
int colorArista = #FF8D8D;

// Color de los nombres de los vertices
int colorNombresVertices1 = 0;
int colorNombresVertices2 = #444444;

// Color de los mensajes
int colorTextoMensajes = 0;
int colorContenedorMensajes = #FF8D8D;

// Fuente
PFont fuente;

// Variables del menu de ayuda
PImage menuAyuda;
PImage menuAyudaOculto;
boolean mostrarMenuAyuda = true;

void setup() {
  size(1024, 576);
  frameRate(60);
  textSize(tamTexto);
  textAlign(CENTER);

  // Cargar la fuente personalizada
  fuente = createFont("LetterGothicStdBold.ttf", tamTexto);
  textFont(fuente);
  
  // Cargar la imagen del menu de ayuda
  menuAyuda = loadImage("img/menuAyuda.png");
  menuAyudaOculto = loadImage("img/menuAyudaOculto.png");

  // Cargar la imagen del background
  imgBackground = loadImage("img/background1.png");
  inicializarMatriz(matrizAdyacencia);
  
    int[][] matriz = {
                {1, 2, 3, 4},
                {5, 6, 7, 8},
                {9, 10, 11, 12}
                };
                
  moverFilasMatriz(matriz, 3, 4, 2);
}

void draw() {
  background(imgBackground);
  imprimirAristas();
  imprimirVertices();
  imprimirNombresVertices();
  imprimirMensajes();
  imprimirMenuAyuda();
}

void mouseDragged() {
  moverVertice();
}

void mouseClicked() {
  agregarVertices();
  agregarAristas();
  eliminarAristas(matrizAdyacencia);
  eliminarVertices(matrizAdyacencia);
}

void mouseReleased() {
  if (moviendoVertice) {
    moviendoVertice = false;
  }
}

void keyPressed() {
  nombrarVertice();
  ocultarMenuAyuda();
}

/************************************
               VERTICES
 ************************************/
/*
  Imprime los vertices
 */
void imprimirVertices() {
  // Se recorre el arrayList y se imprime un ellipse en las coordenadas que tenga esa posicion del arrayList
  for (int i = 0; i < verticesX.size(); i++) {
    fill(rellenoVertice);
    strokeWeight(grosorBordeVertice);
    stroke(bordeVertice);
    ellipse(verticesX.get(i), verticesY.get(i), widthVertices, widthVertices);
  }
}

/*
  Imprime los nombres de los vertices y genera el efecto de "parpadeo" al nombrar un vertice
 */
void imprimirNombresVertices() {
  // Se recorre el arrayList de los nombres de los vertices
  for (int i = 0; i < nombresVertices.size(); i++) {
    /*
     Este if sirve para el efecto de "parpadeo" del nombre del vertice.
     Si se esta nombrando el vertice y se esta en el ultimo vertice del arrayList este if
     se activa cada 2 segundos debido a (int(millis() / 1000) % 2 == 0)
     */
    if (nombrandoVertice && (i == nombresVertices.size() - 1) && (int(millis() / 1000) % 2 == 0)) {
      fill(colorNombresVertices2);
    } else {
      fill(colorNombresVertices1);
    }
    // Se imprime el nombre
    textAlign(CENTER, CENTER);
    textSize(tamTexto);
    text(nombresVertices.get(i), verticesX.get(i), verticesY.get(i));
  }
}

/* 
 Comprueba si el mouse esta sobre un vertice o no, si se esta sobre una arista entonces devuelve
 la posicion de la arista, el parametro es para aumentar artificialmente la distancia, lo uso
 para que no puedas poner los vertices muy pegados al crearlos.
 */
int mouseSobreVertice(int num) {
  int distancia = 0;
  int pos = -1;
  for (int i = 0; i < verticesX.size(); i++) {
    distancia = getDistanciaEntrePuntos(mouseX, mouseY, verticesX.get(i), verticesY.get(i)) - num;
    if (distancia < (widthVertices / 2)) {
      pos = i;
      break;
    }
  }
  return pos;
}

/*
  Calcula la distancia entre dos puntos
 */
int getDistanciaEntrePuntos(int x1, int y1, int x2, int y2) {
  int distancia = 0;
  distancia = int(sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2)));
  return distancia;
}

/*
  Hace que un vertice siga las coordenadas del mouse, si no se esta nombrando un vertice y si no
 se esta agregando una arista.
 */
void moverVertice() {
  if (!moviendoVertice && !nombrandoVertice && !agregandoArista && !borrandoArista) {
    // Obtiene la posicion del vertice al que hiciste click
    posVerticeArrastrando = mouseSobreVertice(0);
  }
  // Este if se activa si posVerticeArrastrando es mayor o igual a cero, es decir
  // si hiciste click sobre un vertice.
  if (posVerticeArrastrando >= 0 && !nombrandoVertice && !agregandoArista && !borrandoArista) {
    moviendoVertice = true;
    verticesX.set(posVerticeArrastrando, mouseX);
    verticesY.set(posVerticeArrastrando, mouseY);
  }
}

/*
  Agrega un nuevo vertice, siempre y cuando no se este moviendo otro vertice 
 y que no se este encima de otro vertice y que no se este nombrando un vertice y que no se este agregando una arista.
 Al activar nombrandoVertice o agregandoArista o moviendoVertice esta funcion se "bloquea", al igual que la de moverVertice()
 */
void agregarVertices() {
  if (!moviendoVertice && !nombrandoVertice && !agregandoArista && !borrandoArista && mouseButton == LEFT && !keyPressed) {
    if (!(mouseSobreVertice(widthVertices) >= 0)) {
      verticesX.add(mouseX); 
      verticesY.add(mouseY); 

      nombreVertice = " ";
      nombresVertices.add("Nombre");
      nombrandoVertice = true;
    }
  }
}

/*
  Lee los caracteres ingresados por el usuario y los almacena en el arrayList de nombreVertices en
 la ultima posicion que haya, si se presiona Enter se desactiva nombrandoVertice y eso permite que
 puedas seguir agregando y moviendo vertices.
 */
void nombrarVertice() {
  if (nombrandoVertice) {
    // Ingresar el nombre
    if (keyCode == ENTER) {
      nombrandoVertice = false;
      nombreVertice = "";
    }
    // Borrar
    else if (keyCode == BACKSPACE || keyCode == 8) {
      if (nombreVertice.length() > 0) {
        nombreVertice = nombreVertice.substring(0, nombreVertice.length() - 1);
        nombresVertices.set(nombresVertices.size() - 1, nombreVertice);
      }
    }
    // Escribir el nombre
    else if ((key >= 'a' && key <= 'z') || (key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9')) {
      if (nombreVertice == "Nombre") {
        nombreVertice = "";
      }
      nombreVertice += str(key); 
      nombresVertices.set(nombresVertices.size() - 1, nombreVertice);
    }
  }
}

/*---------------
    BORRAR VERTICES
-------------------*/
/*
  Elimina un vertice y todas las aristas que conecten con el.
*/
void eliminarVertices(int matriz[][]) {
  int vertice = 0;
  if (!borrandoArista && !moviendoVertice && !agregandoArista && !nombrandoVertice) {
    if (keyPressed && keyCode == SHIFT && mouseButton == LEFT) {
      // Obtener el vertice al que se le hizo click
      vertice = mouseSobreVertice(0); 
      if (vertice >= 0) {
        // Se elimina la fila y columna correspondiente al vertice
        moverColumnasMatriz(matriz, verticesX.size(), verticesX.size(), vertice + 1);
        moverFilasMatriz(matriz, verticesX.size(), verticesX.size(), vertice + 1);
        
        // Se elimina la posicion del vertice dentro de los arrayList
        verticesX.remove(vertice);
        verticesY.remove(vertice);
        nombresVertices.remove(vertice);
        
        println("Vertice eliminado: [" + vertice + "]" + "[" + vertice + "]");
      }
    }
  } 
}

/*
  Desplaza las columnas de la matriz una posicion a la "izquierda"

  Ejemplo:
  int[][] matriz = {
                {1, 2, 3, 4},
                {5, 6, 7, 8}
                };
  moverColumnasMatriz(matriz, 2, 4, 2);
  
  la salida sera la siguiente:
  
  {
   {1, 3, 4, 0}
   {5, 7, 8, 0}
            }
  (Se rellenan los huecos con ceros)
*/
void moverColumnasMatriz(int matriz[][], int filasMatriz, int columnasMatriz, int posicion) {
  
  if(posicion > 0 && posicion < columnasMatriz) {
    for(int i = 0; i < filasMatriz; i++) {
      for(int j = posicion; j < columnasMatriz; j++) {
        // Mover una columna a la izquierda los valores
        matriz[i][j - 1] = matriz[i][j]; 
        // Rellenar la ultima columna con ceros
        if(j  == columnasMatriz - 1) {
          matriz[i][j] = 0;  
        }
      }
    }
  }
   
}

/*
  Desplaza las filas de la matriz una posicion "arriba"

  Ejemplo:
  int[][] matriz = {
                {1, 2, 3, 4},
                {5, 6, 7, 8},
                {9, 10, 11, 12}
                };
  moverFilasMatriz(matriz, 3, 4, 2);
  
  la salida sera la siguiente:
  
  {
   {1, 2, 3, 4}
   {9, 10, 11, 12}
   {0, 0, 0, 0}
               }
  (Se rellenan los huecos con ceros)
*/
void moverFilasMatriz(int matriz[][], int filasMatriz, int columnasMatriz, int posicion) {
  
  if(posicion > 0 && posicion < filasMatriz) {
    for(int i = posicion; i < filasMatriz; i++) {
      for(int j = 0; j < columnasMatriz; j++) {
        // Mover una columna a la izquierda los valores
        matriz[i - 1][j] = matriz[i][j]; 
        // Rellenar la ultima columna con ceros
        if(i  == filasMatriz - 1) {
          matriz[i][j] = 0;  
        }
      }
    }
  }
  
}

/************************************
                 ARISTAS
 ************************************/
/*
  Esta funcion agrega aristas.
 Primero checa que si se apreto el click derecho del mouse y si no se esta agregando aristas y si hay mas de un vertice,
 de ser verdad verifica si hiciste click en algun vertice, de ser verdad guarda la posicion
 del vertice al que clickeaste y activa agregandoArista.
 Segundo, si se esta agregandoArista entonces se verifica si se hizo click en algun vertice y
 si el vertice al que clickeaste es distinto al que ya habias clickeado, de ser verdad entonces
 guarda la posicion del vertice que clickeaste y a la matriz de adyacencia en las posiciones
 de los vertices que clickeaste le asigna un 1, representando que esos vertices estan conectados,
 posterior reinicializa las variables de las posiciones de los vertices y desactiva agregandoArista.
 */
void agregarAristas() {
  if (mouseButton == RIGHT && !keyPressed && !agregandoArista && !borrandoArista && verticesX.size() > 1) {
    int pos = mouseSobreVertice(0);
    if (pos >= 0 && posVertice1 < 0) {
      agregandoArista = true;
      posVertice1 = pos;
      //mensaje = "Da click en otro vertice para unirlos con una arista";
    }
  } else if (mouseButton == RIGHT && agregandoArista) {
    int pos = mouseSobreVertice(0);
    if (pos >= 0 && pos != posVertice1) {
      posVertice2 = pos;
      matrizAdyacencia[posVertice1][posVertice2] = 1;
      //matrizAdyacencia[posVertice2][posVertice1] = 1;
      println("Agregado arista: ");
      println("[" + posVertice1 + "][" + posVertice2 + "]" + " = " + matrizAdyacencia[posVertice1][posVertice2]);
      //println("[" + posVertice2 + "][" + posVertice1 + "]" + " = " + matrizAdyacencia[posVertice2][posVertice1] + "\n");
      posVertice1 = -1;
      posVertice2 = -1;
      agregandoArista = false;
    }
  }
}

/*
  Imprime las aristas.
 Si hay mas de un vertice entonces se recorre la matriz de adyacencia y si en la casilla
 hay un 1 entonces se imprime una linea desde el vertice que esta en la fila (i) hasta el
 vertice que esta en la columna (j).
 */
void imprimirAristas() {
  if (verticesX.size() > 1) {
    // Se recorre hasta verticesX,size() debido a que es el numero de vertices que hay
    for (int i = 0; i < verticesX.size(); i++) {
      for (int j = 0; j < verticesX.size(); j++) {
        strokeWeight(2);
        stroke(colorArista);
        if (matrizAdyacencia[i][j] == 1) {
          fill(colorArista);
          // Se dibuja la flecha solo con el segundo triangulo
          dibujarFlecha(verticesX.get(i), verticesY.get(i), verticesX.get(j), verticesY.get(j), 0, 5, widthVertices / 2 + grosorBordeVertice);
        }
        if (agregandoArista) {
          // Si se esta agregando una arista se dibuja una linea desde el vertice al que hiciste click
          // hasta las coordenadas del mouse
          line(verticesX.get(posVertice1), verticesY.get(posVertice1), mouseX, mouseY);
        }
      }
    }
  }
}

/*
  Dibuja una flecha.
 Sus parametros son las coordenadas de los 2 puntos y el tamaño de la flecha inicial y final y el desface con respecto al cual
 se dibujara la punto de la flecha.
 */
void dibujarFlecha(float x0, float y0, float x1, float y1, float tamTrianguloInicio, float tamTrianguloFinal, int desfaceFlecha) {

  // Aumenta el tamaño del triangulo de la flecha
  float aumentarTam = 1;

  // Dibujar la linea entre los dos puntos
  strokeCap(SQUARE);
  line(x0, y0, x1, y1);

  // Obtener el angulo entre los puntos
  float angulo = atan2(y1 - y0, x1 - x0);

  /* Dibujar los triangulos */

  // triangulo del inicio
  pushMatrix();
  translate(x0, y0);
  rotate(angulo + PI);
  triangle(-tamTrianguloInicio * aumentarTam - desfaceFlecha, -tamTrianguloInicio, 
    -tamTrianguloInicio * aumentarTam - desfaceFlecha, tamTrianguloInicio, 
    -(widthVertices / 2), 0);
  popMatrix();

  // triangulo del final
  pushMatrix();
  translate(x1, y1);
  rotate(angulo);
  triangle(-tamTrianguloFinal * aumentarTam - desfaceFlecha, -tamTrianguloFinal, 
    -tamTrianguloFinal * aumentarTam - desfaceFlecha, tamTrianguloFinal, 
    -desfaceFlecha, 0);
  popMatrix();
}

/*
  Eliminar arista.
 Si se esta presionando shift y se dio click derecho se guarda la posicion del vertice al que se le hizo click
 y se activa borrandoArista, cuando le das click derecho a otro vertice se guarda su posicion
 y se cambia el valor que haya en esa casilla de la matriz por un 0, de esa manera se elimina la arista.
 */
void eliminarAristas(int matriz[][]) {
  int vertice = 0;
  if (!borrandoArista && !moviendoVertice && !agregandoArista && !nombrandoVertice) {
    if (keyPressed && keyCode == SHIFT && mouseButton == RIGHT) {
      vertice = mouseSobreVertice(0); 
      if (vertice >= 0) {
        println("Click derecho y shift");
        posVertice1 = vertice;
        borrandoArista = true;
      }
    }
  } 
  else if (mouseButton == RIGHT && borrandoArista) {
    vertice = mouseSobreVertice(0);
    if (vertice >= 0 && vertice != posVertice1) {
      posVertice2 = vertice;
      matriz[posVertice1][posVertice2] = 0;
      println("Eliminado arista: ");
      println("[" + posVertice1 + "][" + posVertice2 + "]" + " = " + matriz[posVertice1][posVertice2]);
      posVertice1 = -1;
      posVertice2 = -1;
      borrandoArista = false;
    }
  }
}
/************************************
               OTROS
 ************************************/

// Mensajes que ayudan al usuario
void imprimirMensajes() {
  if (!nombrandoVertice && !agregandoArista && !borrandoArista) {
    //mensaje = "- Agrega vertices dando clic izquierdo con el mouse.\n- Puedes mover de lugar los vertices.\n";
    //mensaje += "- Puedes agregar aristas dando click derecho a dos vertices.\n- Puedes borrar aristas manteniendo pulsado SHIFT y dando click derecho a dos vertices.";
    mensaje = "";
  } 
  else if (nombrandoVertice) {
    mensaje = "Ponle un nombre al vertice, acepta con ENTER";
  } 
  else if (agregandoArista) {
    mensaje = "Da click derecho a otro vertice para unirlos con una arista";
  } 
  else if (borrandoArista) {
    mensaje = "Da click derecho a otro vertice para borrar la arista que los une.";
  }
  
  if(mensaje.length() > 0) {
    // Contenedor del mensaje
    fill(colorContenedorMensajes);
    noStroke();
    rect(0, height - (tamTexto * 3) - 5, textWidth(mensaje) + 65, tamTexto + 10, 0, 10, 10, 0);
  
    // Texto del mensaje
    fill(colorTextoMensajes); 
    textSize(tamTexto);
    textAlign(LEFT, TOP);
    text(mensaje, 50, height - (tamTexto * 3));    
  }
}


//Rellena una matriz cuadrada de ceros
void inicializarMatriz(int matriz[][]) {
  for (int i = 0; i < matriz.length; i++) {
    for (int j = 0; j < matriz.length; j++) {
      matriz[i][j] = 0;
    }
  }
}

/************************************
            MENU DE AYUDA
 ************************************/
// Imprime la imagen del menu de acuerdo a si la variable mostrarMenuAyuda esta activa o no
void imprimirMenuAyuda() {
   if(mostrarMenuAyuda) {
     image(menuAyuda, width - menuAyuda.width, height - menuAyuda.height); 
   }
   else {
     image(menuAyudaOculto, width - menuAyudaOculto.width, height - menuAyudaOculto.height);
   }
}

// Es un interuptor, si se esta mostrando el menu entonces se oculta y viceversa
void ocultarMenuAyuda() {
  if((key == 'h' || key == 'H') && !nombrandoVertice) {
    if(mostrarMenuAyuda) {
      mostrarMenuAyuda = false; 
    }
    else {
      mostrarMenuAyuda = true; 
    }
  }
}