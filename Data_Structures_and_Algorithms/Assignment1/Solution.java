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
            int midRow = (startRow + endRow) / 2;// index of the middle row of the matrix
            int topStartCol = maxIndex(matrix[startRow], startCol, endCol);//find index of max item in top coloum
            int midStartCol = maxIndex(matrix[midRow], startCol, endCol);//find index of max item in middle column

            int topMaxValue = Math.max(matrix[startRow][topStartCol], blockMaxValue(matrix, startRow + 1, topStartCol, midRow, endCol));// max value of top half found from max value of top row, and max value found recursively of the top half minus the top row inculding middle row
            //int bottomMaxValue = Math.max(matrix[midRow + 1][midStartCol], blockMaxValue(matrix, midRow + 1, midStartCol, endRow, endCol));
            int bottomMaxValue = blockMaxValue(matrix, midRow + 1, midStartCol, endRow, endCol);// max value of the bottom half of the matrix

            return Math.max(topMaxValue, bottomMaxValue);
            // not finished yet, need to implement the column aspect???
            // kinda have column stuff, but don't think it is actually decreasing time complexity much if anything might be increasing it by accident.
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