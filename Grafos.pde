/*
	Carlos Chan Gongora
*/
/*
  ArrayLists para la parte grafica de los grafos
*/
// ArrayLists que almacenan las coordenadas (x, y) de los vertices
ArrayList<Integer> verticesX = new ArrayList<Integer>();
ArrayList<Integer> verticesY = new ArrayList<Integer>();
// ArrayList que almacena los nombres de los vertices
ArrayList<String> nombresVertices = new ArrayList<String>();

int[][] matrizAdyacencia = new int[50][50];

/*{{0, 1, 0}, 
{1, 0, 1}, 
{0, 1, 0}};*/

int widthVertices = 40;
int tamTexto = 16;
int count = 0;
int posVerticeArrastrando = 0;
boolean nombrandoVertice = false;
boolean moviendoVertice = false;
String nombreVertice = "";
String mensaje = "";

boolean agregandoArista = false;
int posVertice1 = -1;
int posVertice2 = -1;

void setup() {
  size(640, 480);
  frameRate(60);
  textSize(tamTexto);
  textAlign(CENTER);
  
  mensaje = "Agrega vertices dando clic izquierdo con el mouse\nPuedes arrastrar los vertices\nPuedes agregar aristas dando click derecho";
  inicializarMatriz();
}

void draw() {
  background(0);
  imprimirAristas();
  imprimirVertices();
  imprimirNombresVertices();
  imprimirMensajes();
  fill(255);
  text("Arrastrando = " + moviendoVertice + "    Nombrando = " + nombrandoVertice, width / 2, 20);
  text("AgregandoArista = " + agregandoArista, width / 2, 35);
}

void mouseDragged() {
  moverVertice();
}

void mouseClicked() {
  //mouseSobreArista();
  agregarVertices();
  agregarAristas();
  count++;
}

void mouseReleased() {
 if(moviendoVertice) {
   moviendoVertice = false; 
 }
}

void keyPressed() {
  nombrarVertice(); 
}

/*
  Imprime los vertices
*/
void imprimirVertices() {
  // Se recorre el arrayList y se imprime un ellipse en las coordenadas que tenga esa posicion del arrayList
  for(int i = 0; i < verticesX.size(); i++){
    fill(#CE0018);
    noStroke();
    ellipse(verticesX.get(i), verticesY.get(i), widthVertices, widthVertices);
  }
}

/*
  Imprime los nombres de los vertices y genera el efecto de "parpadeo" al nombrar un vertice
*/
void imprimirNombresVertices() {
  // Se recorre el arrayList de los nombres de los vertices
  for(int i = 0; i < nombresVertices.size(); i++) {
    /*
     Este if sirve para el efecto de "parpadeo" del nombre del vertice.
     Si se esta nombrando el vertice y se esta en el ultimo vertice del arrayList este if
     se activa cada 2 segundos debido a (int(millis() / 1000) % 2 == 0)
    */
    if(nombrandoVertice && (i == nombresVertices.size() - 1) && (int(millis() / 1000) % 2 == 0)) {
      fill(#C6C6C2); 
    }
    else {
      fill(255);
    }
    // Se imprime el nombre
    text(nombresVertices.get(i), verticesX.get(i), verticesY.get(i) + (tamTexto / 2));
  }
}

/* 
   Comprueba si el mouse esta sobre una arista o no, si se esta sobre una arista entonces devuelve
   la posicion de la arista, el parametro es para aumentar la distancia,
   sirve para que no puedas poner los vertices muy pegados
*/
int mouseSobreVertice(int num) {
  int distancia = 0;
  int pos = -1;
  for(int i = 0; i < verticesX.size(); i++) {
    distancia = getDistanciaEntrePuntos(mouseX, mouseY, verticesX.get(i), verticesY.get(i)) - num;
    if(distancia < (widthVertices / 2)) {
      //println("Encima de: " + (i+1)); 
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
  //println("dist: " + distancia);
  return distancia;
}

/*
  Hace que un vertice siga las coordenadas del mouse, si no se esta nombrando un vertice y si no
  se esta agregando una arista.
*/
void moverVertice() {
  if(!moviendoVertice && !nombrandoVertice && !agregandoArista) {
    // Obtiene la posicion del vertice al que hiciste click
    posVerticeArrastrando = mouseSobreVertice(0);   
  }
  // Este if se activa si posVerticeArrastrando es mayor o igual a cero, es decir
  // si hiciste click sobre un vertice.
  if(posVerticeArrastrando >= 0 && !nombrandoVertice && !agregandoArista){
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
  if(!moviendoVertice && !nombrandoVertice && !agregandoArista && mouseButton == LEFT){
    if(!(mouseSobreVertice(widthVertices) >= 0)) {
      verticesX.add(mouseX); 
      verticesY.add(mouseY); 
      
      nombresVertices.add("nombre");
      nombrandoVertice = true;
      
      mensaje = "Ponle un nombre al vertice, acepta con ENTER";
    }  
  } 
}

/*
  Lee los caracteres ingresados por el usuario y los almacena en el arrayList de nombreVertices en
  la ultima posicion que haya, si se presiona Enter se desactiva nombrandoVertice y eso permite que
  puedas seguir agregando y moviendo vertices.
*/
void nombrarVertice() {
  if(nombrandoVertice) {
    if(keyCode == ENTER) {
      nombrandoVertice = false;
      nombreVertice = "";
      mensaje = "Agrega vertices dando clic con el mouse\nPuedes arrastrar los vertices";
    }
    else if((key >= 'a' && key <= 'z') || (key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9')) {
      nombreVertice += str(key); 
      nombresVertices.set(nombresVertices.size() - 1, nombreVertice);
      //println(nombreVertice);
    }
  }
}

void imprimirMensajes() {
  if(mensaje.length() > 0) {
    fill(#EFFC3B); 
    text(mensaje, width / 2, height - (tamTexto * 4)); 
  }
}

/*
  Rellena la matriz de ceros
*/
void inicializarMatriz() {
  for(int i = 0; i < matrizAdyacencia.length; i++) {
    for(int j = 0; j < matrizAdyacencia.length; j++) {
      matrizAdyacencia[i][j] = 0;  
    }
  }
}

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
  if(mouseButton == RIGHT && !agregandoArista && verticesX.size() > 1) {
    int pos = mouseSobreVertice(0);
    if(pos >= 0 && posVertice1 < 0) {
       agregandoArista = true;
       posVertice1 = pos;
       mensaje = "Da click en otro vertice para unirlos con una arista";
    }
  }
  else if(mouseButton == RIGHT && agregandoArista) {
    int pos = mouseSobreVertice(0);
    if(pos >= 0 && pos != posVertice1) {
      posVertice2 = pos;
      matrizAdyacencia[posVertice1][posVertice2] = 1;
      matrizAdyacencia[posVertice2][posVertice1] = 1;
      println("Agregado arista: ");
      println("[" + posVertice1 + "][" + posVertice2 + "]" + " = " + matrizAdyacencia[posVertice1][posVertice2]);
      println("[" + posVertice2 + "][" + posVertice1 + "]" + " = " + matrizAdyacencia[posVertice2][posVertice1] + "\n");
      posVertice1 = -1;
      posVertice2 = -1;
      agregandoArista = false; 
      mensaje = "Agrega vertices dando clic izquierdo con el mouse\nPuedes arrastrar los vertices\nPuedes agregar aristas dando click derecho";
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
  if(verticesX.size() > 1){
    for(int i = 0; i < matrizAdyacencia.length; i++){
      for(int j = 0; j < matrizAdyacencia.length; j++){
        if(matrizAdyacencia[i][j] == 1){
          stroke(#F7FF27);
          line(verticesX.get(i), verticesY.get(i), verticesX.get(j), verticesY.get(j));
        }
      }
    }
  }
}