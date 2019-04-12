/*
	Carlos Chan Gongora
*/
// ArrayLists que almacenan las coordenadas (x, y) de los vertices
ArrayList<Integer> verticesX = new ArrayList<Integer>();
ArrayList<Integer> verticesY = new ArrayList<Integer>();
ArrayList<String> nombresVertices = new ArrayList<String>();

int widthVertices = 40;
int tamTexto = 16;
int count = 0;
int posVerticeArrastrando = 0;
boolean nombrandoVertice = false;
boolean moviendoVertice = false;
String nombreVertice = "";
String mensaje = "";

void setup() {
  size(640, 480);
  frameRate(60);
  textSize(tamTexto);
  textAlign(CENTER);
  
  mensaje = "Agrega vertices dando clic con el mouse\nPuedes arrastrar los vertices";
}

void draw() {
  background(0);
  imprimirVertices();
  imprimirNombresVertices();
  imprimirMensajes();
  fill(255);
  text("Arrastrando = " + moviendoVertice + "    Nombrando = " + nombrandoVertice, width/2, 20);
}

void mouseDragged() {
  moverVertice();
}

void mouseClicked() {
  //mouseSobreArista();
  agregarVertices();
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
  Hace que un vertice siga las coordenadas del mouse, si no se esta nombrando un vertice
*/
void moverVertice() {
  if(!moviendoVertice && !nombrandoVertice) {
    posVerticeArrastrando = mouseSobreVertice(0);   
    //println("calculandopos");
  }
  if(posVerticeArrastrando >= 0 && !nombrandoVertice){
      moviendoVertice = true;
      verticesX.set(posVerticeArrastrando, mouseX);
      verticesY.set(posVerticeArrastrando, mouseY);
  }
}

/*
  Agrega un nuevo vertice, siempre y cuando no se este arrastrando otro vertice 
  y que no se este encima de otro vertice y que no se este nombrando un vertice.
  Al activar nombrandoVertice esta funcion se "bloquea", al igual que la de moverVertice()
*/
void agregarVertices() {
  if(!moviendoVertice && !nombrandoVertice){
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
    text(mensaje, width / 2, height - (tamTexto * 3)); 
  }
}
/*----------------------
  Pendiente
*/
void agregarAristas() {
  
}

void imprimirAristas() {
  
}