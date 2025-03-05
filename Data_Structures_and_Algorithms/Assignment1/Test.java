public class Test {
    
    static void printTest(int result, int output) {
        if (result == output) {
            System.out.println("Test passed.");
        } else {
            System.out.println("Test failed: Expected " + output + ", got " + result);
        }
    }
    
    static void testMaxIndex(int[] row, int start, int end, int output) {
        System.out.println("Testing maxIndex on row between " + start + " and " + end);
        int result = Solution.maxIndex(row, start, end);
        printTest(result, output);
    }
    
    static void testBlockMaxValue(int[][] matrix, int startRow, int startCol, int endRow, int endCol, int output) {
        System.out.println("Testing blockMaxValue between (" + startRow + "," + startCol + ") and (" + endRow + "," + endCol + ")");
        int result = Solution.blockMaxValue(matrix, startRow, startCol, endRow, endCol);
        printTest(result, output);
    }
    
    static void testMatrixMaxValue(int[][] matrix, int output) {
        System.out.println("Testing matrixMaxValue");
        int result = Solution.matrixMaxValue(matrix);
        printTest(result, output);
    }

    static void testCasesMaxIndex() {
        {
            int[] row = {1, 3, 2, -1, 0, 1}; int start = 0, end = 5, output = 1;
            testMaxIndex(row, start, end, output);
        }
        {
            int[] row = {3, 2, -1, 0, 1}; int start = 2, end = 4, output = 4;
            testMaxIndex(row, start, end, output);
        }
        {
            int[] row = {1, -1, -3, -2}; int start = 1, end = 3, output = 1;
            testMaxIndex(row, start, end, output);

        }
    }

    static void testCasesBlockMaxValue() {
        {
            int[][] matrix = {{1, 7, 6}, {3, 8, 5}, {4, 2, 9}};
            int startRow = 0, startCol = 0, endRow = 0, endCol = 2;
            int output = 7;
            testBlockMaxValue(matrix, startRow, startCol, endRow, endCol, output);
        }
        {
            int[][] matrix = {{3}, {2}, {-1}, {0}, {1}};
            int startRow = 2, startCol = 0, endRow = 4, endCol = 0;
            int output = 1;
            testBlockMaxValue(matrix, startRow, startCol, endRow, endCol, output);
        }
        {
            int[][] matrix = {{1, -1, -2, -4}, {-1, -3, -2, -5}, {1, 2, -2, -1}};
            int startRow = 0, startCol = 2, endRow = 2, endCol = 3;
            int output = -1;
            testBlockMaxValue(matrix, startRow, startCol, endRow, endCol, output);
        }
    }

    static void testCasesMatrixMaxValue() {
        {
            int[][] matrix = {{1, 7, 6}, {3, 8, 5}, {4, 2, 9}};
            int output = 9;
            testMatrixMaxValue(matrix, output);
        }
        {
            int[][] matrix = {{3}, {2}, {-1}, {0}, {1}};
            int output = 3;
            testMatrixMaxValue(matrix, output);
        }
        {
            int[][] matrix = {{1, -1, -2, -4}, {-1, -3, -2, -5}, {1, 2, -2, -1}};
            int output = 2;
            testMatrixMaxValue(matrix, output);
        }
        {
            int[][] matrix = {{1, -1, -2, -4}, {-1, -3, -2, -5}, {1, 10, -2, -1}, {1, 2, -2, -1}};
            int output = 10;
            testMatrixMaxValue(matrix, output);
        }
    }
    
    public static void main(String[] args) {
        testCasesMaxIndex();
        testCasesBlockMaxValue();
        testCasesMatrixMaxValue();
    }
}