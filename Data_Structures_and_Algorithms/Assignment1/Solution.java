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
            // this is O(nxm) which is bad, hwo to implement divide and conquer?
            int maxRowValue = matrix[startRow][startCol];//max val in row, set to first val of first row for inital val
            int maxMatrixValue = maxRowValue;// max val in matrix, set to first val of first row for inital val 
            int columnIndex = startCol;
            for (int i = startRow +1; i <= endRow; i++ )
            {
                for (int j = columnIndex; j <= endCol; j++)
                    if(maxRowValue < matrix[i][j])
                    {
                        maxRowValue = matrix[i][j];
                        columnIndex = j;
                    }
                
                if (maxMatrixValue < maxRowValue)
                {
                    maxMatrixValue = maxRowValue;
                }
                
            }
            return maxMatrixValue;

        }

        //return -1000;
    }

    public static int matrixMaxValue(int[][] matrix) {
        // Returns the maximum entry in the matrix between columns startCol, endCol inclusive and between rows startRow, endRow inclusive
        return -1000;
    }

    
    
}