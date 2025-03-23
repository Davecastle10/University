import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

// this is my alteration fo the solution to implent the changes of doing the distance tracking concurrently with the operations
// and incorporating the bfs directly
public class Solution {
    // instance avriabkles for q2
    // not sure if this being static is good or nto but other stuf wouldnt work if it wasn't
    //static List<List<String>> graph = new ArrayList<>();// for the graph that the string permutations are made to be placed in.
    // not sure if arraylist approach will work as it most likely wont allow fo rme to have the string value followed by an arraylsit of shildren.
    // might have to use regular lsit or some other shenanigans to get round this.

    //static Queue<String> queue = new LinkedList<>();// the queue to maintian order of permutaion for the searching of the string




    // Question 1a
    public static boolean reachable1(String x, String y) {
        // operations require 1 and 0 for each operatoion
        // find num 1's in x
        // as long as same amount of 1's or 1's in y then all good
        int num1X = 0;
        int num1Y = 0;
        for (int i = 0; i < x.length(); i++)
        {
            if (x.charAt(i) == '1')
            {
                num1X +=  1;
            }
            if (y.charAt(i) == '1')
            {
                num1Y +=  1;
            }
        }
        return num1X == num1Y;// time complexity O(n) as for loop use to iterate through both strings technically 2n + 1 comparisons, + 2n + 2 assignments max
        // space complexity constant O(1) as only have two vairbales assigned outside of intial state.
    }

    // Question 1b
    public static int distance1(String x, String y) {
        // consider looping through and performing operations on it unti you get y from x, but this migth nto be the best case complexity
        // consider coding simillar but easier problems to ease into this one.
        // 01 - 10 , 10 - 01
        int numSwaps = 0;
        char temp = 0;
        if (!reachable1(x, y))
        {
            return -1;
        }

        char[] xArray = x.toCharArray();
        //char[] yArray = y.toCharArray();

        for (int i = 0; i < x.length(); i++)
        {
            /* 
            if (x.charAt(i) == y.charAt(i))
            {
            }
            */
            if (xArray[i] != y.charAt(i))
            {
                temp = xArray[i];
                swapLoop : for (int j = i + 1; j < x.length(); j++)
                {
                    //numSwaps += 1;
                    if (xArray[j] == y.charAt(i))
                    {
                        //x = x.substring(0, i) + x.charAt(j) + x.substring(i + 1, j) + temp  + x.substring(j + 1);
                        //System.out.println(xArray);
                        xArray[i] = xArray[j];
                        xArray[j] = temp;
                        //System.out.println(xArray);
                        //System.out.println(numSwaps);

                        numSwaps += j-i;
                        //System.out.println(numSwaps);
                       
                        
                        break swapLoop;
                        
                    }
                }
            }
        }
        return numSwaps;
    }

    // Question 2
    public static int distance2(String x, String y) {
        // 110 -> 001
        // 011 -> 100
        // 101 -> 110

        /*  perhaps try making global tree array/arraylist that cna be edited by any recursive sub call
            to add further permutaions, and whenever the end is reached run searching algorithm
            breadthfirst or depthfirst? to determine the shortest path from start to end

            might be better to do 2d array with valu and children, so it can point to all child nodes desendant form that point maybe
            or too make a custom node class seperately,. although that migth not be allowed so on second thought just go for 2d array


        */

        /* need to decide ont he structure of my graph,
           do i go for arraylist[ list[[string] [arraylist(string) to contain children]] ]  
        */
        Queue<List<String>> queue = new LinkedList<>();
        List<List<String>> visited = new ArrayList<>();


        List<String> originalXList = new ArrayList<>();// new list
        originalXList.add(x);// add x to the new list
        originalXList.add("0");// add distance 0 to x list
        visited.add(originalXList);// add the new list to the graph
        queue.add(originalXList);

        //String newX = x;

        if (x.length() < 3)// if the length is less than 3 the operations cannot be performed
        {
            return -1;
        }


        //char[] xArray = x.toCharArray();
        //String newX = "";

        //char[] yArray = y.toCharArray(); 
        int counter = 0;
        mainloop : while (!queue.isEmpty() && counter < 100)
        {
            counter = counter + 1;
            // might need to add another loop here and move the queue code around slighlty to deal with the ifinite looping over the same string problem
            // if adding additional loop here, check if the current item is already in the graph, and if so move to the next item in the queue.
            // additionally might want to mess around with the code such that if there is ever no items in the queue when ther should be that -1 is returned
            // becuase if there are no items in the queue it wouls seem to me like there were no additional permutaions to be added,
            // and if this occurs withought y being reached and the graph searching algorithm having been called, it impleis y cannot be reached from x.

            /*  could probably also alter the code so that the second item (index 1) of the node sub-array represents the distance from x 
            //and have it check if the distance is longer or shorter than the current distance every time the same node is found by a differnt 
            permutaion path, and if the new node is shorter, updat the numebr to the lower 1, this would mean that when y is found it would already give use the number
            and we do not need to run an additional bfs algorithm, considering the current code is already kinda bfs inspired.
            */

            for (int i = 0; i < x.length() -2; i++)// changed back to -2 realised i was pottentially missing last index
            {
                System.out.println("Q2 strings");
                System.out.println(queue.peek());

                List<String> currentXNode = queue.poll();
                String currentXString = currentXNode.get(0);
                int currentOperationsCount = Integer.parseInt(currentXNode.get(1));

                //String currentX = qu.get(0);

                //System.out.println(currentX);

                char[] xArray = currentXString.toCharArray();
                List<String> newX = null;
                //currentX = currentX.trim();
                //y = y.trim();
                System.out.println("y value: ," +y);

                // testing prints
                System.out.println(currentXNode.get(0));
                System.out.println(currentXNode.get(0).substring(i, i + 3));
                System.out.println(i);

                String substringToCheck = currentXString.substring(i, i + 3);

                if (substringToCheck.equals("110"))
                {
                    xArray[i] = '0';
                    xArray[i + 1] = '0';
                    xArray[i + 2] = '1';
                    newX = new ArrayList<>();
                    newX.add(new String(xArray));
                    newX.add( String.valueOf(currentOperationsCount + 1));
                }
                else if (substringToCheck.equals("011"))
                {
                    xArray[i] = '1';
                    xArray[i + 1] = '0';
                    xArray[i + 2] = '0';
                    newX = new ArrayList<>();
                    newX.add(new String(xArray));
                    newX.add( String.valueOf(currentOperationsCount + 1));
                }
                else if (substringToCheck.equals("101"))
                {
                    xArray[i] = '1';
                    xArray[i + 1] = '1';
                    xArray[i + 2] = '0';
                    newX = new ArrayList<>();
                    newX.add(new String(xArray));
                    newX.add( String.valueOf(currentOperationsCount + 1));
                }

                // if newX has not already been visited and an operation was applied to create a newX
                // code to check the value
                System.out.println("check val before visited and queue addition");
                System.out.println(newX.get(0));
                System.out.println(inGraph(newX.get(0), visited));
                if (newX != null && inGraph(newX.get(0), visited) == -1)
                {
                    // if newX's string value == y
                    System.out.println("newX.get(0); " + newX.get(0));
                    if (newX.get(0).equals(y))
                    {
                        return currentOperationsCount + 1;
                    }

                    visited.add(newX);
                    queue.add(newX);
                }

            }
        }
        return -1;
    }

    public static int inGraph(String x, List<List<String>> graph)// should probably change this to in visited but can't really be bothered atm
    {
        for (int i = 0; i < graph.size(); i++)
        {
            if (graph.get(i).get(0).equals(x))
            {
                return i;
            }
        }
        return -1;
    }

    public static int bfs(String x, String y)
    {
        Queue<String> nodeQueue = new LinkedList<>();
        List<List<String>> visited = new ArrayList<>();
        List<List<String>> unvisited = new ArrayList<>();
        return -1111;

    }

}