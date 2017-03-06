import edu.uci.ics.jung.algorithms.shortestpath.DijkstraDistance;
import edu.uci.ics.jung.algorithms.shortestpath.DijkstraShortestPath;
import edu.uci.ics.jung.graph.SparseGraph;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.util.EdgeType;

import java.util.List;


/**
 * Created by afashokova on 27.02.2017.
 */
public class graf {
   Graph<Integer, String> graph;
     public graf() {
        graph = new SparseGraph<Integer, String>();
        for (int i = 0; i<21;i++)
            graph.addVertex(i);

        graph.addEdge("1-1,1-2",0,1, EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-3",0,2,EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-4",0,3,EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-5",0,4,EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-6",0,5,EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-7",0,6,EdgeType.UNDIRECTED);
        graph.addEdge("1-1,1-8",0,7,EdgeType.UNDIRECTED);
        graph.addEdge("1-4,2-4",3,11,EdgeType.UNDIRECTED);
        graph.addEdge("2-1,2-2",8,9,EdgeType.UNDIRECTED);
        graph.addEdge("2-1,2-4",8,11,EdgeType.UNDIRECTED);
        graph.addEdge("2-1,2-6",8,13,EdgeType.UNDIRECTED);
        graph.addEdge("2-1,2-7",8,14,EdgeType.UNDIRECTED);
        graph.addEdge("2-2,2-5",9,12,EdgeType.UNDIRECTED);
        graph.addEdge("2-3,2-7",10,14,EdgeType.UNDIRECTED);
        graph.addEdge("2-4,2-7",11,14,EdgeType.UNDIRECTED);
        graph.addEdge("2-3,2-4",11,18,EdgeType.UNDIRECTED);
        graph.addEdge("2-6,2-7",13,14,EdgeType.UNDIRECTED);
        graph.addEdge("3-1,3-2",15,16,EdgeType.UNDIRECTED);
        graph.addEdge("3-1,3-3",15,17,EdgeType.UNDIRECTED);
        graph.addEdge("3-1,3-4",15,18,EdgeType.UNDIRECTED);
        graph.addEdge("3-1,3-6",15,20,EdgeType.UNDIRECTED);
        graph.addEdge("3-2,3-5",16,19,EdgeType.UNDIRECTED);
        graph.addEdge("3-3,3-6",17,20,EdgeType.UNDIRECTED);

}
      public void NearestPath(Integer FirstVertex, Integer EndVertex){
         DijkstraShortestPath<Integer,String> alg = new DijkstraShortestPath(graph);
         List<String> l = alg.getPath(20,0);
         System.out.println("Кратчайший путь "+ l);
         DijkstraDistance<Integer,String> alg2 = new DijkstraDistance<Integer, String>(graph);
         Number l2 = alg2.getDistance(FirstVertex, EndVertex);
         System.out.println("расстояние " +l2 );
      }}
