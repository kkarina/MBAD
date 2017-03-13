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

        graph.addEdge("1-1 1-2",0,1, EdgeType.DIRECTED);
        graph.addEdge("1-1 1-3",0,2,EdgeType.DIRECTED);
        graph.addEdge("1-1 1-4",0,3,EdgeType.DIRECTED);
        graph.addEdge("1-1 1-5",0,4,EdgeType.DIRECTED);
        graph.addEdge("1-1 1-6",0,5,EdgeType.DIRECTED);
        graph.addEdge("1-1 1-7",0,6,EdgeType.DIRECTED);
        graph.addEdge("1-1 1-8",0,7,EdgeType.DIRECTED);
        graph.addEdge("1-4 2-4",3,11,EdgeType.DIRECTED);
        graph.addEdge("2-1 2-2",8,9,EdgeType.DIRECTED);
        graph.addEdge("2-1 2-4",8,11,EdgeType.DIRECTED);
        graph.addEdge("2-1 2-6",8,13,EdgeType.DIRECTED);
        graph.addEdge("2-1 2-7",8,14,EdgeType.DIRECTED);
        graph.addEdge("2-2 2-5",9,12,EdgeType.DIRECTED);
        graph.addEdge("2-3 2-7",10,14,EdgeType.DIRECTED);
        graph.addEdge("2-4 2-7",11,14,EdgeType.DIRECTED);
        graph.addEdge("2-4 3-4",11,18,EdgeType.DIRECTED);
        graph.addEdge("2-6 2-7",13,14,EdgeType.DIRECTED);
        graph.addEdge("3-1 3-2",15,16,EdgeType.DIRECTED);
        graph.addEdge("3-1 3-3",15,17,EdgeType.DIRECTED);
        graph.addEdge("3-1 3-4",15,18,EdgeType.DIRECTED);
        graph.addEdge("3-1 3-6",15,20,EdgeType.DIRECTED);
        graph.addEdge("3-2 3-5",16,19,EdgeType.DIRECTED);
        graph.addEdge("3-3 3-6",17,20,EdgeType.DIRECTED);
        graph.addEdge("1-2 1-1",1,0, EdgeType.DIRECTED);
        graph.addEdge("1-3 1-1",2,0,EdgeType.DIRECTED);
        graph.addEdge("1-4 1-1",3,0,EdgeType.DIRECTED);
        graph.addEdge("1-5 1-1",4,0,EdgeType.DIRECTED);
        graph.addEdge("1-6 1-1",5,0,EdgeType.DIRECTED);
        graph.addEdge("1-7 1-1",6,0,EdgeType.DIRECTED);
        graph.addEdge("1-8 1-1",7,0,EdgeType.DIRECTED);
        graph.addEdge("2-4 1-4",11,3,EdgeType.DIRECTED);
        graph.addEdge("2-2 2-1",9,8,EdgeType.DIRECTED);
        graph.addEdge("2-4 2-1",11,8,EdgeType.DIRECTED);
        graph.addEdge("2-6 2-1",13,8,EdgeType.DIRECTED);
        graph.addEdge("2-7 2-1",14,8,EdgeType.DIRECTED);
        graph.addEdge("2-5 2-2",12,9,EdgeType.DIRECTED);
        graph.addEdge("2-7 2-3",14,10,EdgeType.DIRECTED);
        graph.addEdge("2-7 2-4",14,11,EdgeType.DIRECTED);
        graph.addEdge("3-4 2-4",18,11,EdgeType.DIRECTED);
        graph.addEdge("2-7 2-6",14,13,EdgeType.DIRECTED);
        graph.addEdge("3-2 3-1",16,15,EdgeType.DIRECTED);
        graph.addEdge("3-3 3-1",17,15,EdgeType.DIRECTED);
        graph.addEdge("3-4 3-1",18,15,EdgeType.DIRECTED);
        graph.addEdge("3-6 3-1",20,15,EdgeType.DIRECTED);
        graph.addEdge("3-5 3-2",19,16,EdgeType.DIRECTED);
        graph.addEdge("3-6 3-2",20,17,EdgeType.DIRECTED);


}
      public void NearestPath(Integer FirstVertex, Integer EndVertex){
         DijkstraShortestPath<Integer,String> alg = new DijkstraShortestPath(graph);
         List<String> l = alg.getPath(FirstVertex,EndVertex);
         System.out.println("Кратчайший путь "+ l);
         DijkstraDistance<Integer,String> alg2 = new DijkstraDistance<Integer, String>(graph);
         Number l2 = alg2.getDistance(FirstVertex, EndVertex);
         System.out.println("расстояние " +l2 );
      }}
