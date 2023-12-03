class Graph {
  final int vertices;
  final Map<int, List<Edge>> adjacencyList;

  Graph(this.vertices) : adjacencyList = <int, List<Edge>>{};
  void makeGraph(List<Map<String, dynamic>> documentDataList, String weight) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < documentDataList[i]['station'].length - 1; j++) {
        addEdge(
            documentDataList[i]['station'][j],
            documentDataList[i]['station'][j + 1],
            documentDataList[i][weight][j]);
      }
    }
    addEdge(
        documentDataList[0]['station']
            [documentDataList[0]['station'].length - 1],
        documentDataList[0]['station'][0],
        documentDataList[0][weight][documentDataList[0]['station'].length - 1]);
    addEdge(
        documentDataList[5]['station']
            [documentDataList[5]['station'].length - 1],
        documentDataList[5]['station'][0],
        documentDataList[5][weight][documentDataList[5]['station'].length - 1]);
  }

  void addEdge(int start, int end, int weight) {
    adjacencyList.putIfAbsent(start, () => []);
    adjacencyList.putIfAbsent(end, () => []);

    adjacencyList[start]!.add(Edge(end, weight));
    adjacencyList[end]!.add(Edge(start, weight));
  }

  List<int> dijkstra(int start, int end, List<int> path) {
    List<int> distances = List.filled(vertices, 10000000000000);
    distances[start] = 0;

    List<Node> priorityQueue =
        List<Node>.generate(vertices, (index) => Node(index, distances[index]));
    priorityQueue.sort((a, b) => a.distance.compareTo(b.distance));

    Map<int, int?> previousVertices = {};

    while (priorityQueue.isNotEmpty) {
      int currentVertex = priorityQueue.removeAt(0).vertex;

      for (Edge edge in adjacencyList[currentVertex] ?? []) {
        int newDistance = distances[currentVertex] + edge.weight;

        if (newDistance < distances[edge.destination]) {
          distances[edge.destination] = newDistance;
          previousVertices[edge.destination] = currentVertex;
          priorityQueue.add(Node(edge.destination, newDistance));
          priorityQueue.sort((a, b) => a.distance.compareTo(b.distance));
        }
      }
    }

    if (path.isNotEmpty) {
      path.clear();
    }

    int currentVertex = end;
    while (currentVertex != start) {
      path.add(currentVertex);
      currentVertex = previousVertices[currentVertex]!;
    }
    path.add(start);
    path = path.reversed.toList();

    return distances;
  }

//경유지 고려 메소드
}

class Edge {
  final int destination;
  final int weight;

  Edge(this.destination, this.weight);
}

class Node {
  final int vertex;
  final int distance;

  Node(this.vertex, this.distance);
}

int weightOfPath(Graph weightGraph, List<int> path) {
  int weight = 0;
  for (int i = 0; i < path.length - 1; i++) {
    weight += weightGraph.adjacencyList[path[i]]!
        .firstWhere((edge) => edge.destination == path[i + 1])
        .weight;
  }
  return weight;
}
// void main() {
//   Graph timeGraph = Graph(905);
//   //Graph costGraph = Graph(6);
//   timeGraph.addEdge(0, 1, 5);
//   timeGraph.addEdge(0, 2, 1);
//   timeGraph.addEdge(1, 2, 2);
//   timeGraph.addEdge(1, 3, 3);
//   timeGraph.addEdge(2, 4, 4);
//   timeGraph.addEdge(3, 4, 6);
//   timeGraph.addEdge(3, 5, 8);
//   timeGraph.addEdge(4, 5, 7);
//   int startVertex = 0;
//   int endVertex = 5;
//   List<int> timePath = [];
//   //List<int> costPath = [];
//   List<int> minTime = timeGraph.dijkstra(startVertex, endVertex, timePath);
//   //List<int> minCost = costGraph.dijkstra(startVertex, endVertex, costPath);
//   print("$startVertex역에서 $endVertex역 까지의 최단 시간: ${minTime[endVertex]}");
//   print("최단 경로: $timePath");
//   //print("$startVertex역에서 $endVertex역 까지의 최소 비용: ${minCost[endVertex]}");
//   //print("최단 경로: $costPath");
// }
