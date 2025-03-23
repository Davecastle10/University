import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

// this is my alteration fo the solution to implent the changes of doing the distance tracking concurrently with the operations
// and incorporating the bfs directly
public class Solution {



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

        Queue<List<String>> queue = new LinkedList<>();
        List<List<String>> visited = new ArrayList<>();


        List<String> originalXList = new ArrayList<>();// new list
        originalXList.add(x);// add x to the new list
        originalXList.add("0");// add distance 0 to x list
        visited.add(originalXList);// add the new list to the graph
        queue.add(originalXList);

        if (x.length() < 3)// if the length is less than 3 the operations cannot be performed
        {
            return -1;
        }

        mainloop : while (!queue.isEmpty())
        {
            List<String> currentXNode = queue.poll();
            String currentXString = currentXNode.get(0);
            int currentOperationsCount = Integer.parseInt(currentXNode.get(1));

            for (int i = 0; i < x.length() -2; i++)// changed back to -2 realised i was pottentially missing last index
            {
                char[] xArray = currentXString.toCharArray();// char array to make changing the string easier
                List<String> newX = null;
                String substringToCheck = currentXString.substring(i, i + 3);

                // checking the current substring against the three operation types to see if one can be performed and if so it performs the operation
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
                    newX.add(String.valueOf(currentOperationsCount + 1));
                }

                // if newX has not already been visited and an operation was applied to create a newX
                if (newX != null && inGraph(newX.get(0), visited) == -1)
                {
                    // if newX's string value == y
                    if (newX.get(0).equals(y))
                    {
                        return currentOperationsCount + 1;
                    }

                    // implicit else on adding the newX node to the visited array and queue so ti can be iterated on later to see if any of it's 
                    // permutations can have an operation used on them to create string y.
                    visited.add(newX);
                    queue.add(newX);
                }

            }
        }
        return -1;// returns -1 if both loops have exited after all possible permutations have been checked and the only other possibility is that x cannot be made into y
    }

    // time complexity O(n) space O(1) as it doesn't make new stuff
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

}