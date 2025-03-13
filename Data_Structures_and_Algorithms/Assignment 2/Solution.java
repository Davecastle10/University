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

        if (!reachable1(x, y))
        {
            return -1;
        }
        int numDifferences = 0;
        for (int i = 0; i < x.length(); i++)
        {
            if (x.charAt(i) == y.charAt(i))
            {
                numDifferences +=  1;
            }
        }
        return numDifferences;
    }

    // Question 2
    public static int distance2(String x, String y) {
        return -1000000;
    }
}