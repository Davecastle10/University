package week4;

import java.util.Scanner;

public class Challenge4 {
    int numberInt;
    String numberString = "";
    int numberOfSymbolsAvailable = 12;// there are 12 symbols in use at the momemnt
    int numbers[] = {1,4,5,9,10,40,50,90,100,400,500,900,1000};// 12 values
    String symbols[] = {"I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M"};
    
    
    public Challenge4 (int numberInt)// int input constructor
    {
        this.numberInt = numberInt;
        int tempNumberInt = numberInt;

        // using a nested loop
        for (int i = numberOfSymbolsAvailable; i >= 0; i--)
        {
            int quotient = tempNumberInt / numbers[i];// how many 1000's are in the number

            while (tempNumberInt >= numbers[i])
            {
                numberString += symbols[i];
                tempNumberInt -= numbers[i];
            }

            tempNumberInt = tempNumberInt % numbers[i];
        }

        /* using 1 loop with a stack of if else statements.
        while (tempNumberInt > 0)
        {

            if (tempNumberInt >= numbers[12])// numbers[12] is 1000
            {
                int quotient = tempNumberInt / numbers[12];// how many 1000's are in the number
                for (int i = 0; i < quotient; i++)// adds the Symbol to the string quotient times
                {
                    numberString += symbols[12];
                }
                tempNumberInt = tempNumberInt % numbers[12];// replaces the number with it's remainder when divided by 1000, so it can be past onto the next stage.
            }

            else if (tempNumberInt >= numbers[11])// numbers[11] is 900
            {
                int quotient = tempNumberInt / numbers[11];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[11];
                }
                tempNumberInt = tempNumberInt % numbers[11];
            }

            else if (tempNumberInt >= numbers[10])// 500
            {
                int quotient = tempNumberInt / numbers[10];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[10];
                }
                tempNumberInt = tempNumberInt % numbers[10];
            }

            else if (tempNumberInt >= numbers[9])// 400
            {
                int quotient = tempNumberInt / numbers[9];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[9];
                }
                tempNumberInt = tempNumberInt % numbers[9];
            }

            else if (tempNumberInt >= numbers[8])// 100
            {
                int quotient = tempNumberInt / numbers[8];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[8];
                }
                tempNumberInt = tempNumberInt % numbers[8];
            }

            else if (tempNumberInt >= numbers[7])// 90
            {
                int quotient = tempNumberInt / numbers[7];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[7];
                }
                tempNumberInt = tempNumberInt % numbers[7];
            }

            else if (tempNumberInt >= numbers[6])// 50
            {
                int quotient = tempNumberInt / numbers[6];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[6];
                }
                tempNumberInt = tempNumberInt % numbers[6];
            }

            else if (tempNumberInt >= numbers[5])// 40
            {
                int quotient = tempNumberInt / numbers[5];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[5];
                }
                tempNumberInt = tempNumberInt % numbers[5];
            }

            else if (tempNumberInt >= numbers[4])// 10
            {
                int quotient = tempNumberInt / numbers[4];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[4];
                }
                tempNumberInt = tempNumberInt % numbers[4];
            }

            else if (tempNumberInt >= numbers[3])// 9
            {
                int quotient = tempNumberInt / numbers[3];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[3];
                }
                tempNumberInt = tempNumberInt % numbers[3];
            }

            else if (tempNumberInt >= numbers[2])// 5
            {
                int quotient = tempNumberInt / numbers[2];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[2];
                }
                tempNumberInt = tempNumberInt % numbers[2];
            }

            else if (tempNumberInt >= numbers[1])// 4
            {
                int quotient = tempNumberInt / numbers[1];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[1];
                }
                tempNumberInt = tempNumberInt % numbers[1];
            }

            else if (tempNumberInt >= numbers[0])// 1
            {
                int quotient = tempNumberInt / numbers[0];
                for (int i = 0; i < quotient; i++)
                {
                    numberString += symbols[0];
                }
                tempNumberInt = tempNumberInt % numbers[0];
            }


        }
        */

    } 


    // using nested loops
    public Challenge4 (String numberString)// string input constructor
    {
        this.numberString = numberString;
        String tempString = numberString;
        
        for (int i = numberOfSymbolsAvailable; i >= 0; i--)
        {
            while (tempString.startsWith(symbols[i]))
            {
                numberInt += numbers[i];
                tempString = tempString.substring(symbols[i].length());
            }
        }
    }
    

    public int getArabicNumeras()
    {
        return numberInt;
    }

    public String toString()
    {
        return numberString;
    }
}
