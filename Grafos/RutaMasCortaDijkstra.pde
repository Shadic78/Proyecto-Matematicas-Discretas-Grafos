class ShortestPath
{
  String mensajeError = "";
  int costoRutaMasCorta = 0;
  
  String getMensajeError() {
    return mensajeError;
  }
  
  int getCostoRuta() {
    return costoRutaMasCorta;  
  }
  
    // Obtiene la posicion del vertice a menor distancia del vertice actual.
  int minDistance(int dist[], Boolean sptSet[], int cantidadVertices) {
    int min = Integer.MAX_VALUE, min_index=-1;
      
      for (int v = 0; v < cantidadVertices; v++) {
          if (sptSet[v] == false && dist[v] <= min)
          {
              min = dist[v];
              min_index = v;
          }
      }
      return min_index;
    }

    void printSolution(int dist[], int cantidadVertices)
    {
        System.out.println("Vertex Distance from Source");
        for (int i = 0; i < cantidadVertices; i++)
            System.out.println(i + " \t\t " + dist[i]);
    }
    
    void imprimirMatriz(int matriz[][]) {
      for (int i = 0; i < matriz.length; i++) {
        print(i + ".- ");
        for (int j = 0; j < matriz.length; j++) {
          print(matriz[i][j]);
        }
        println("");
      } 
    }
    
    void getRutaMasCorta(int origen, int destino, int padres[], ArrayList<Integer> ruta) {
      int verticeDestino = destino;
      // Se agrega al arraylist el vertice destino
      ruta.add(0, destino);
      // Se obtiene el resto de la ruta a partir de los padres de los vertices.
      while(verticeDestino != origen) {
        ruta.add(0, padres[verticeDestino]);
        verticeDestino = padres[verticeDestino];
      }
            
      println("\n*****ruta desde " + origen + " hasta " + destino + " : " + ruta);
      
    }

    boolean dijkstra(int graph[][], int cantidadVertices, int origen, int destino, ArrayList<Integer> ruta) {
      // Vector que almacena los vertices que ya fueron visitados
      Boolean sptSet[] = new Boolean[cantidadVertices];
      // Vector que almacena el costo minimo desde el origen hasta cualquier otro vertice.
      int dist[] = new int[cantidadVertices];
      // Vector que guarda los padres de cada vertice
      int[] padres = new int[cantidadVertices];
      boolean existeRuta = false;
      
      // Se vacia el arrayList que almacenara la ruta mas corta
      ruta.clear();

      // Se inicializan los vectores
      for (int i = 0; i < cantidadVertices; i++) {
          // Como no conocemos aun el costo desde el origen hasta el resto de los vertices entonces almacenamos el "infinito"
          dist[i] = Integer.MAX_VALUE;
          // Se declara que no se a visitado ningun vertice
          sptSet[i] = false;
          // Como no sabemos los padres de cada vertice entonces almacenamos -1
          padres[i] = -1;
      }
      
      // Se declara que el costo del origen al origen es cero y que el padre del origen es el mismo
      dist[origen] = 0;
      padres[origen] = origen;

      for (int count = 0; count < cantidadVertices - 1; count++) {
        int u = minDistance(dist, sptSet, cantidadVertices);

        sptSet[u] = true;
        
        // Se calculan las distancias minimas
        for (int v = 0; v < cantidadVertices; v++) {
          if (!sptSet[v] && graph[u][v]!=0 && dist[u] != Integer.MAX_VALUE && dist[u]+graph[u][v] < dist[v]) {
            // Se almacena la distancia del origen al vertice v
            dist[v] = dist[u] + graph[u][v];   
            // Se declara que el padre del vertice v es u
            padres[v] = u;
          }              
        }
      }

      //printSolution(dist, cantidadVertices);
      
      /*println("\n");
      for(int i = 0; i < cantidadVertices; i++) {
        println("Hijo: " + i + ", padre: " + padres[i]);  
      }*/
      
      // Si existe una ruta entre el vertice origen y el vertice destino, es decir si el costo es distinto de "infinito".
      if(dist[destino] != Integer.MAX_VALUE) {
        // Se almacena la ruta en arrayList ruta.
        getRutaMasCorta(origen, destino, padres, ruta); 
        // Se almacena el costo de la ruta
        costoRutaMasCorta = dist[destino];
        existeRuta = true;
      }
      else {
        mensajeError = "No hay ningun camino desde " + origen + " hasta " + destino;
        println(mensajeError);  
         
        existeRuta = false;
      }
      // Se devuelve un booleano para saber si se encontro una ruta o no.
      return existeRuta;
    }
}