import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class Solution {
    // instance avriabkles for q2
    // not sure if this being static is good or nto but other stuf wouldnt work if it wasn't
    static ArrayList[][] graph = new ArrayList[50][2];// for the graph that the string permutations are made to be placed in.
    // not sure if arraylist approach will work as it most likely wont allow fo rme to have the string value followed by an arraylsit of shildren.
    // might have to use regular lsit or some other shenanigans to get round this.

    static Queue<String> queue = new LinkedList<>();// the queue to maintian order of permutaion for the searching of the string




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
        // 110 - 001
        // 011 - 100
        // 101 - 110

        /*  perhaps try making global tree array/arraylist that cna be edited by any recursive sub call
            to add further permutaions, and whenever the end is reached run searching algorithm
            breadthfirst or depthfirst? to determine the shortest path from start to end

            might be better to do 2d array with valu and children, so it can point to all child nodes desendant form that point maybe
            or too make a custom node class seperately,. although that migth not be allowed so on second thought just go for 2d array


        */

        /* need to decide ont he structure of my graph,
           do i go for arraylist[ list[[string] [arraylist(string) to contain children]] ]  
        */

        char[] xArray = x.toCharArray();
        String newX = "";
        //char[] yArray = y.toCharArray(); 
        if (x.equals(y))
        {
            return 0;// change this to have it be the case where it starts the shrotest path search over the array
        }
        for (int i = 0; i < x.length() -3; i++)
        {
            // add code to swap the 3 char substring for its permutaion - think this nwo done
            // add permutation as a child of current/old string on graph array, and permutaion as new node if ti doesnt alreay exist
            if (x.substring(i, i + 3) == "110")
            {
                xArray[i] = '0';
                xArray[i + 1] = '0';
                xArray[i + 2] = '1';
                newX = xArray.toString();
            }
            else if (x.substring(i, i + 3) == "011")
            {
                xArray[i] = '1';
                xArray[i + 1] = '0';
                xArray[i + 2] = '0';
                newX = xArray.toString();
            }
            else if (x.substring(i, i + 3) == "101")
            {
                xArray[i] = '1';
                xArray[i + 1] = '1';
                xArray[i + 2] = '0';
                newX = xArray.toString();
            }
            else
            {
                // add something here for if none of the above happen
            }

            int newXIndex = inGraph(newX);
            int xIndex = inGraph(x);
            if (newXIndex != -1)// add as a child for x
            {
                
                //graph[xIndex]. add to the graph somehow
            }
            else// add newX to the graph and give it an arraylist/list thingy that its children can be referenced in in the future.
            // also add newX to the queue so it will eventually get searched through
            {
                queue.add(newX);
            }
        }
        return -1000000;
    }

    public static int inGraph(String x)
    {
        for (int i = 0; i < graph.length; i++)
        {
            if (graph[i].equals(x))
            {
                return i;
            }
        }
        return -1;
    }

}