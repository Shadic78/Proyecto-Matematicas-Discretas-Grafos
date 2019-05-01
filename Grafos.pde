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

// Matriz que almacena las conexiones de los vertices
int[][] matrizAdyacencia = new int[50][50];
// Matriz que almacena los costos de las aristas
int[][] matrizCostos = new int[50][50];

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
boolean asignandoCostoArista = false;
String costoArista = "";
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
  inicializarMatriz(matrizAdyacencia, 0);
  inicializarMatriz(matrizCostos, 0);
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
  eliminarAristas(matrizAdyacencia, matrizCostos);
  eliminarVertices(matrizAdyacencia, matrizCostos);
}

void mouseReleased() {
  if (moviendoVertice) {
    moviendoVertice = false;
  }
}

void keyPressed() {
  nombrarVertice();
  asignarCostoAristas(matrizCostos);
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
  if (!moviendoVertice && !nombrandoVertice && !agregandoArista && !borrandoArista && !asignandoCostoArista) {
    // Obtiene la posicion del vertice al que hiciste click
    posVerticeArrastrando = mouseSobreVertice(0);
  }
  // Este if se activa si posVerticeArrastrando es mayor o igual a cero, es decir 
  // si hiciste click sobre un vertice.
  if (posVerticeArrastrando >= 0 && !nombrandoVertice && !agregandoArista && !borrandoArista && !asignandoCostoArista) {
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
  if (!moviendoVertice && !nombrandoVertice && !agregandoArista && !borrandoArista && !asignandoCostoArista && mouseButton == LEFT && !keyPressed) {
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
void eliminarVertices(int matrizAdyacencia[][], int matrizCostos[][]) {
  int vertice = 0;
  if (!borrandoArista && !moviendoVertice && !agregandoArista && !nombrandoVertice && !asignandoCostoArista) {
    if (keyPressed && keyCode == SHIFT && mouseButton == LEFT) {
      // Obtener el vertice al que se le hizo click
      vertice = mouseSobreVertice(0); 
      if (vertice >= 0) {
        // Se elimina la fila y columna correspondiente al vertice de la matriz de adyacencia
        moverColumnasMatriz(matrizAdyacencia, verticesX.size(), verticesX.size(), vertice);
        moverFilasMatriz(matrizAdyacencia, verticesX.size(), verticesX.size(), vertice);
        
        // Se elimina la fila y columna correspondiente al vertice de la matriz de costos
        moverColumnasMatriz(matrizCostos, verticesX.size(), verticesX.size(), vertice);
        moverFilasMatriz(matrizCostos, verticesX.size(), verticesX.size(), vertice);
        
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
  moverColumnasMatriz(matriz, 2, 4, 1);
  
  la salida sera la siguiente:
  
  {
   {1, 3, 4, 0}
   {5, 7, 8, 0}
            }
  (Se rellenan los huecos con ceros)
*/
void moverColumnasMatriz(int matriz[][], int filasMatriz, int columnasMatriz, int posicion) {
  
  if(posicion >= 0 && posicion < columnasMatriz) {
    for(int i = 0; i < filasMatriz; i++) {
      for(int j = posicion; j < columnasMatriz; j++) {
        // Se rellena la ultima columna de la matriz con ceros
        if(j == columnasMatriz - 1) {
          matriz[i][j] = 0;  
        }
        // De lo contrario se realiza el procedimiento de mover las columnas
        else {
          // Mover una columna a la izquierda los valores
          matriz[i][j] = matriz[i][j + 1]; 
          
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
  moverFilasMatriz(matriz, 3, 4, 1);
  
  la salida sera la siguiente:
  
  {
   {1, 2, 3, 4}
   {9, 10, 11, 12}
   {0, 0, 0, 0}
               }
  (Se rellenan los huecos con ceros)
*/
void moverFilasMatriz(int matriz[][], int filasMatriz, int columnasMatriz, int posicion) {
  
  if(posicion >= 0 && posicion < filasMatriz) {
    for(int i = posicion; i < filasMatriz; i++) {
      for(int j = 0; j < columnasMatriz; j++) {
        // Rellenar la ultima columna con ceros
        if(i  == filasMatriz - 1) {
          matriz[i][j] = 0;  
        }
        else {
          // Mover una columna a la izquierda los valores
          matriz[i][j] = matriz[i + 1][j];   
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
  if (mouseButton == RIGHT && !keyPressed && !agregandoArista && !borrandoArista && !asignandoCostoArista && verticesX.size() > 1) {
    int pos = mouseSobreVertice(0);
    if (pos >= 0 && posVertice1 < 0) {
      agregandoArista = true;
      posVertice1 = pos;
      //mensaje = "Da click en otro vertice para unirlos con una arista";
    }
  } 
  else if (mouseButton == RIGHT && agregandoArista) {
    int pos = mouseSobreVertice(0);
    if (pos >= 0 && pos != posVertice1) {
      posVertice2 = pos;
      // Se asigna que hay una conexion entre los vertices en la matriz de adyacencia
      matrizAdyacencia[posVertice1][posVertice2] = 1;
      // Se inicializa el peso de la arista a 1
      matrizCostos[posVertice1][posVertice2] = 1;
      println("Agregado arista: ");
      println("[" + posVertice1 + "][" + posVertice2 + "]" + " = " + matrizAdyacencia[posVertice1][posVertice2]);
      //println("[" + posVertice2 + "][" + posVertice1 + "]" + " = " + matrizAdyacencia[posVertice2][posVertice1] + "\n");
      //posVertice1 = -1;
      //posVertice2 = -1;
      agregandoArista = false;
      asignandoCostoArista = true;
      // Variable que se utiliza para concatenar los valores introducidos por el usuario en la funcion
      // asignarCostoArista()
      costoArista = "asignando";
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
          // Si los vertices estan conectados de los dos lados se imprime una sola flecha con dos puntas
          if(matrizAdyacencia[j][i] == 1) {
            dibujarFlecha(verticesX.get(i), verticesY.get(i), verticesX.get(j), verticesY.get(j), 5, 5, widthVertices / 2 + grosorBordeVertice, true);
            // Se imprime el costo de la arista al primer vertice, el costo de la arista al segundo vertice se imprime
            // despues.
            imprimirMensajeConCirculo(str(matrizCostos[j][i]), verticesX.get(j), verticesY.get(j), verticesX.get(i), verticesY.get(i));
          }
          else {
            // De lo contrario se dibuja una flecha con sola la punta del final
            dibujarFlecha(verticesX.get(i), verticesY.get(i), verticesX.get(j), verticesY.get(j), 0, 5, widthVertices / 2 + grosorBordeVertice, true);  
          }            
          // Se imprime el costo de la arista a la que apunta la flecha (en caso de que los vertices tengan una conexion unidireccional)
          imprimirMensajeConCirculo(str(matrizCostos[i][j]), verticesX.get(i), verticesY.get(i), verticesX.get(j), verticesY.get(j));
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
void dibujarFlecha(float x0, float y0, float x1, float y1, float tamTrianguloInicio, float tamTrianguloFinal, int desfaceFlecha, boolean dibujarLinea) {

  // Aumenta el tamaño del triangulo de la flecha
  float aumentarTam = 1;
  // Obtener el angulo entre los puntos
  float angulo = atan2(y1 - y0, x1 - x0);

  // Dibujar la linea entre los dos puntos
  if(dibujarLinea) {
    strokeCap(SQUARE);
    line(x0, y0, x1, y1); 
  }

  /* Dibujar los triangulos */

  // triangulo del inicio
  if(tamTrianguloInicio > 0) {
     pushMatrix();
    translate(x0, y0);
    rotate(angulo + PI);
    triangle(-tamTrianguloInicio * aumentarTam - desfaceFlecha, -tamTrianguloInicio, 
      -tamTrianguloInicio * aumentarTam - desfaceFlecha, tamTrianguloInicio, 
      -desfaceFlecha, 0);
    popMatrix(); 
  }
  
  // triangulo del final
  if(tamTrianguloFinal > 0) {
    pushMatrix();
    translate(x1, y1);
    rotate(angulo);
    triangle(-tamTrianguloFinal * aumentarTam - desfaceFlecha, -tamTrianguloFinal, 
      -tamTrianguloFinal * aumentarTam - desfaceFlecha, tamTrianguloFinal, 
      -desfaceFlecha, 0);
    popMatrix();
  }
}

/*
  Eliminar arista.
 Si se esta presionando shift y se dio click derecho se guarda la posicion del vertice al que se le hizo click
 y se activa borrandoArista, cuando le das click derecho a otro vertice se guarda su posicion
 y se cambia el valor que haya en esa casilla de la matriz por un 0, de esa manera se elimina la arista.
 */
void eliminarAristas(int matrizAdyacencia[][], int matrizCostos[][]) {
  int vertice = 0;
  if (!borrandoArista && !moviendoVertice && !agregandoArista && !nombrandoVertice && !asignandoCostoArista) {
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
      // Se elimina la arista de la matriz de adyacencia
      matrizAdyacencia[posVertice1][posVertice2] = 0;
      
      // Se elimina la arista de la matriz de costos
      matrizCostos[posVertice1][posVertice2] = 0;
      
      println("Eliminado arista: ");
      println("[" + posVertice1 + "][" + posVertice2 + "]" + " = " + matrizAdyacencia[posVertice1][posVertice2]);
      posVertice1 = -1;
      posVertice2 = -1;
      borrandoArista = false;
    }
  }
}

/*
  Imprime un mensaje encerrado en un circulo usando como parametro el texto a imprimir y las coordenadas de
  2 vertices.
*/
void imprimirMensajeConCirculo(String mensaje, int x0, int y0, int x1, int y1) {
    // Obtener el angulo entre los puntos (debido al sistema de coordenadas hay que sumarle PI o 180 grados para que funcione bien)
  float angulo = atan2(y1 - y0, x1 - x0) + PI;
   /*
    Para ubicar correctamente los circulos con los pesos de las aristas se utiliza la ecuacion parametrica de la circunferencia:
    x = radio * cos(angulo)
    y = radio * sin(angulo)
    En este caso se toma radio =  widthVertices + textWidth(mensaje) / 2, esto para que el circulo se adapte a la cantidad de caracteres
    que tenga el texto y no se pegue mucho al vertice.
  */
  int radio = int(widthVertices + textWidth(mensaje) / 2);
  // El padding que tiene el circulo en el que esta el texto
  int padding = 8;
  
  pushMatrix();
  translate(x1, y1);
  fill(colorArista);
  noStroke();
  textAlign(CENTER, CENTER);
  ellipse(radio * cos(angulo), radio * sin(angulo), textWidth(mensaje) + padding, textWidth(mensaje) + padding);
  
  fill(255);
  text(mensaje, radio * cos(angulo), radio * sin(angulo));
  popMatrix();
}

/*
  Lee los numeros ingresados por el usuario y los almacena en la matriz de costos
 */
void asignarCostoAristas(int matrizCostos[][]) {
  if (asignandoCostoArista) {
    // Ingresar el costo
    if (keyCode == ENTER) {
      // Si presionaste enter sin teclear un valor entonces se pone por defecto el valor 1 como costo.
      if(costoArista.equals("asignando")) {
        costoArista = "1";  
      }
      // Si presionaste enter y la cadena que ingresaste tiene mas de cero caracteres y el valor convertido a entero es mayor de cero.
      // entonces cambia el valor de las variables para declarar que se termino de asignar costo a la arista.
      // (no te deja asignarle costo cero a una arista)
      if(costoArista.length() > 0 && int(costoArista) > 0){
        posVertice1 = -1;
        posVertice2 = -1;
        asignandoCostoArista = false;
        costoArista = "";         
      }
    }
    // Borrar
    else if (keyCode == BACKSPACE || keyCode == 8) {
      if (costoArista.length() > 0) {
        // Si borras apenas creas la arista entonces inicializa el costo en 1.
        // (cuando se crea una arista, la variable costoArista almacena la cadena "asignando")
        if (costoArista.equals("asignando")) {
          costoArista = "1";
        }
        else {
          costoArista = costoArista.substring(0, costoArista.length() - 1);
        }
        // Asigna el nuevo costo
        matrizCostos[posVertice1][posVertice2] = int(costoArista);          
        println("length: " + costoArista.length());
        println(costoArista);
      }
    }
    // Escribir el costo
    else if (key >= '0' && key <= '9') {
      // Hace que el 1 que aparece por defecto al crear la arista sea reemplazado con la tecla que presiones,
      // excepto si presionas cero, entonces no lo cambia.
      // (Cuando creas una arista el valor de costoArista es el string: "asignando", lo cual uso para saber si el usuario no ha ingresado ningun numero)
      if (costoArista.equals("asignando") && key != '0') {
        costoArista = "";
      }
      /*  Este if sirve para que si la longitud de la cadena que almacena el costo de la arista es cero,
          es decir si esta vacia, entonces no permite que ingreses el valor 0, sin este if podrias escribir lo siguiente: 00000000001,
          lo cual hace que el programa no funcione correctamente, solo puedes escribir el cero si ya ingresaste antes otro numero que no sea cero.
          
          El !(costoArista.equals("asignando")) sirve para que no se concatene lo que estas ingresando si la primera tecla
          que presionas al crear la arista es cero, debido a que al crear la arista, la variable costoArista tiene el string "asignando",
          sin el !(costoArista.equals("asignando")) lo que sucederia seria que internamente si presionas cero y como costoArista = "asignando",
          entonces costoArista concatenaria de la siguiente manera: costoArista = "asignando000000", lo cual es un error.
      */
      if(!(key == '0' && costoArista.length() == 0) && !(costoArista.equals("asignando"))) {
        // El numero que el usuario ingrese tendra como maximo 9 digitos, esto debido a que
        // el numero maximo que puede almacenar un int tiene 10 digitos.
        if(costoArista.length() < 9) {
          // Concatena lo que ingresa el usuario
          costoArista += str(key); 
          // Asigna el numero que el usuario introdujo
          matrizCostos[posVertice1][posVertice2] = int(costoArista);  
        }  
        //println(costoArista);
      }
    }
  }
}

/************************************
               OTROS
 ************************************/

// Mensajes que ayudan al usuario
void imprimirMensajes() {
  if (!nombrandoVertice && !agregandoArista && !borrandoArista && !asignandoCostoArista) {
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
    mensaje = "Da click derecho a otro vertice para borrar la arista que los une";
  }
  else if (asignandoCostoArista) {
    mensaje = "Asignale un costo a la arista";
    if(int(costoArista) == 0) {
      mensaje += " (no puedes asignar un costo de cero)" ; 
    }
  }
  
  if(mensaje.length() > 0) {
    // Contenedor del mensaje
    fill(colorContenedorMensajes);
    noStroke();
    rectMode(CORNER);
    rect(0, height - (tamTexto * 3) - 5, textWidth(mensaje) + 65, tamTexto + 10, 0, 10, 10, 0);
  
    // Texto del mensaje
    fill(colorTextoMensajes); 
    textSize(tamTexto);
    textAlign(LEFT, TOP);
    text(mensaje, 50, height - (tamTexto * 3));    
  }
}


//Rellena una matriz cuadrada con el numero que le pases de parametro
void inicializarMatriz(int matriz[][], int num) {
  for (int i = 0; i < matriz.length; i++) {
    for (int j = 0; j < matriz.length; j++) {
      matriz[i][j] = num;
    }
  }
}

void imprimirMatriz() {
  for (int i = 0; i < matrizAdyacencia.length; i++) {
    print(i + ".- ");
    for (int j = 0; j < matrizAdyacencia.length; j++) {
      print(matrizAdyacencia[i][j]);
    }
    println("");
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