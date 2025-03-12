
import java.util.Arrays;

public class Test {
    
    static boolean testReachable1(String x, String y, boolean output) {
        boolean result = Solution.reachable1(x, y);
        if(result != output) {
            System.out.println("\tTest failed. Expected " + output + ", got " + result);
            System.out.println("\tInput string x = " + x);
            System.out.println("\tInput string y = " + y);
        }
        return result == output;
    }
    
    static boolean testDistance1(String x, String y, int output) {
        int result = Solution.distance1(x, y);
        if(result != output) {
            System.out.println("\tTest failed. Expected " + output + ", got " + result);
            System.out.println("\tInput string x = " + x);
            System.out.println("\tInput string y = " + y);
        }
        return result == output;
    }
    
    static boolean testDistance2(String x, String y, int output) {
        int result = Solution.distance2(x, y);
        if(result != output) {
            System.out.println("\tTest failed. Expected " + output + ", got " + result);
            System.out.println("\tInput string x = " + x);
            System.out.println("\tInput string y = " + y);
        }
        return result == output;
    }

    static String testCasesReachable1() {
        int passes = 0;
        {
            String x = "00111", y = "10101";
            boolean output = true;
            if (testReachable1(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "1011101011", y = "0100111111";
            boolean output = true;
            if (testReachable1(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "0100", y = "1011";
            boolean output = false;
            if (testReachable1(x, y, output)) {
                passes++;
            }
        }
        return Integer.toString(passes);
    }

    static String testCasesDistance1() {
        int passes = 0;
        {
            String x = "00111", y = "10101";
            int output = 3;
            if (testDistance1(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "1011101011", y = "0100111111";
            int output = 8;
            if (testDistance1(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "0100", y = "1011";
            int output = -1;
            if (testDistance1(x, y, output)) {
                passes++;
            }
        }
        return Integer.toString(passes);
    }
    
    static String testCasesDistance2() {
        int passes = 0;
        {
            String x = "11001", y = "01000";
            int output = 3;
            if (testDistance2(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "11001", y = "00100";
            int output = -1;
            if (testDistance2(x, y, output)) {
                passes++;
            }
        }
        {
            String x = "0111110101", y = "0101000001";
            int output = 4;
            if (testDistance2(x, y, output)) {
                passes++;
            }
        }
        return Integer.toString(passes);
    }
    
    public static void main(String[] args) {

        String numPassed;

        System.out.println("Testing Q1 a\n");
        numPassed = testCasesReachable1();
        System.out.println("Q1: " + numPassed + " tests passed\n\n\n");

        System.out.println("Testing Q1 b\n");
        numPassed = testCasesDistance1();
        System.out.println("Q2: " + numPassed + " tests passed\n\n\n");

        System.out.println("Testing Q2\n");
        numPassed = testCasesDistance2();
        System.out.println("Q3: " + numPassed + " tests passed\n\n\n");
    }
}