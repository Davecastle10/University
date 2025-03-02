public class Solution {
    
    public static int maxIndex(int[] row, int start, int end) {
        // Returns the index of the maximum entry between start and end 
        int value = row[start];
        int valueIndex = start;
        
        for (int i = start +1; i <= end; i++ )
        {
            if(value < row[i])
            {
                value = row[i];
                valueIndex = i;
            }
        }
        return valueIndex;

        /*  space complexity adds two variables so constant
            time complexity searches through all of a row in the area with maximimum possible iterations m with 4 operations per incerment so time O(4m) so O(m)
            might be wrong but think those are correct
         * 
         */

    }

    public static int blockMaxValue(int[][] matrix, int startRow, int startCol, int endRow, int endCol) {
        // Returns the maximum value in the matrix

        if (startCol == endCol && startRow == endRow)
        {
            return matrix[startRow][startCol];
        }

        else if (startRow == endRow)
        {
            
            int[] row = matrix[startRow];
            int index = maxIndex(row, startCol, endCol);
            return row[index];
        }

        else if (startCol == endCol)
        {
            //return matrix[startRow][startCol];
            int value = matrix[startRow][startCol];
            //int valueIndex = startRow;
            
            for (int i = startRow +1; i <= endRow; i++ )
            {
                if(value < matrix[i][startCol])
                {
                    value = matrix[i][startCol];
                    //valueIndex = i;
                }
            }
            return value;
        }

        else
        {
            // calculations for these done in if for better time complexity so that mid row index and mid col max not done if matrix only has two rows
            int midRow;// index of the middle row of the matrix
            int topStartCol;//find index of max item in top row
            int midStartCol;//find index of max item in middle row from max item from start row to end column
            int bottomEndCol;//find max item item in end row from max item in mid row to end col

            if (matrix.length == 2)// if only two coloumns, is more efficient to do this iff than two find max value in middle column
            {   
                topStartCol = maxIndex(matrix[startRow], startCol, endCol);//find index of max item in top row
                bottomEndCol = maxIndex(matrix[endRow], topStartCol, endCol);//find max item item in end row from max item in mid row to end col
                midRow = startRow;// if only two rows make mid row equal to top/start row so base case is used
                midStartCol = bottomEndCol;// if only two rows make mid start col = to end row col
            }
            else
            {
                midRow = (startRow + endRow) / 2;// index of the middle row of the matrix
                topStartCol = maxIndex(matrix[startRow], startCol, endCol);//find index of max item in top row
                midStartCol = maxIndex(matrix[midRow], topStartCol, endCol);//find index of max item in middle row from max item from start row to end column
                bottomEndCol = maxIndex(matrix[endRow], midStartCol, endCol);//find max item item in end row from max item in mid row to end col
            }
            
            int topMaxValue = Math.max(matrix[startRow][topStartCol], blockMaxValue(matrix, startRow + 1, topStartCol, midRow, midStartCol));// max value of top half found from max value of top row, and max value found recursively of the top half minus the top row inculding middle row
            //int bottomMaxValue = Math.max(matrix[midRow + 1][midStartCol], blockMaxValue(matrix, midRow + 1, midStartCol, endRow, endCol));
            int bottomMaxValue = blockMaxValue(matrix, midRow + 1, midStartCol, endRow, bottomEndCol);// max value of the bottom half of the matrix

            return Math.max(topMaxValue, bottomMaxValue);
            // not finished yet, need to implement the column aspect???
            // kinda have column stuff, but don't think it is actually decreasing time complexity much if anything might be increasing it by accident.
            //think time complexity is now done to O(m*log(n)) now as it searches recursively well through the rows
            //space complexity will be O(log(n)) as it is recursive and splits the the matrix in half with each call until matrix is just 1d array
        }

        /* 

        else
        {
            // this is O(nxm) which is bad, hwo to implement divide and conquer?
            int maxRowValue = matrix[startRow][startCol];//max val in row, set to first val of first row for inital val
            int maxMatrixValue = maxRowValue;// max val in matrix, set to first val of first row for inital val 
            int columnIndex = startCol;
            for (int i = startRow +1; i <= endRow; i++ )
            {
                for (int j = columnIndex; j <= endCol; j++)
                {
                    
                    if(maxRowValue < matrix[i][j])
                    {
                        maxRowValue = matrix[i][j];
                        columnIndex = j;
                    }
                }
                if (maxMatrixValue < maxRowValue)
                {
                    maxMatrixValue = maxRowValue;
                }
                
            }
            return maxMatrixValue;

        }

        */
    }

    public static int matrixMaxValue(int[][] matrix) {
        // Returns the maximum entry in the matrix between columns startCol, endCol inclusive and between rows startRow, endRow inclusive
        
        return blockMaxValue(matrix, 0, 0, matrix.length -1, matrix[0].length -1);
        //return -1000;
    }

    
    
}