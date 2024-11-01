package week1maybe;
// week 1 oop challenge work
import java.util.Scanner;
import java.time.Period;


public class StoringNumbersDatatypeTesting {
    
    public static void main(String[] args)
    {
        String time;// time will from a string of from "PaYbMcD" where a = num years, b = num months, and c = num days
        Scanner inputDevice = new Scanner(System.in);
        int testing1 = 2141483647;
        int testing2 = 2141483647;
        
        double posInf = Double.POSITIVE_INFINITY;
        double negInf = Double.NEGATIVE_INFINITY;


        System.out.println(testing1 + testing2);
        System.out.println(posInf + negInf);
        System.out.println(posInf + posInf);
        System.out.println(negInf + negInf);

    }
    
}
