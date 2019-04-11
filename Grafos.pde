// ArrayLists que almacenan las coordenadas (x, y) de los vertices
ArrayList<Integer> verticesX = new ArrayList<Integer>();
ArrayList<Integer> verticesY = new ArrayList<Integer>();

int widthVertices = 40;
int tamTexto = 16;
int count = 0;

void setup() {
  size(640, 480);
  frameRate(60);
  textSize(tamTexto);
  textAlign(CENTER);
}

void draw() {
  background(0);
  imprimirVertices();
  if(count > 2) {
    stroke(#E7FF36);
    line(verticesX.get(0), verticesY.get(0), verticesX.get(1), verticesY.get(1) ); 
  }
}

void mouseDragged() {
  moverVertice();
}

void mouseClicked() {
  //mouseSobreArista();
  agregarVertices();
  count++;
}

void imprimirVertices() {
  // Se recorre el arrayList y se imprime un ellipse en las coordenadas que tenga esa posicion del arrayList
  for(int i = 0; i < verticesX.size(); i++){
    fill(255);
    noStroke();
    ellipse(verticesX.get(i), verticesY.get(i), widthVertices, widthVertices);
    // El numero del vertice
    fill(0);
    text(i + 1, verticesX.get(i), verticesY.get(i) + (tamTexto / 2));
  }
}

void imprimirAristas() {
  
}

/* Comprueba si el mouse esta sobre una arista o no, si se esta sobre una arista entonces devuelve
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

int getDistanciaEntrePuntos(int x1, int y1, int x2, int y2) {
  int distancia = 0;
  distancia = int(sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2)));
  //println("dist: " + distancia);
  return distancia;
}

void moverVertice() {
  int posicion = mouseSobreVertice(0);
  if(posicion >= 0){
      verticesX.set(posicion, mouseX);
      verticesY.set(posicion, mouseY);
  }
}

void agregarVertices() {
  if(!(mouseSobreVertice(widthVertices) >= 0)) {
    verticesX.add(mouseX); 
    verticesY.add(mouseY); 
  }  
}

void agregarAristas() {
  
}