package week1maybe;
// week 1 oop challenge work
import java.util.Scanner;
import java.time.Period;

public class ParseTest 
{
    public static void main(String[] args)
    {
        String time;// time will from a string of from "PaYbMcD" where a = num years, b = num months, and c = num days
        Scanner inputDevice = new Scanner(System.in);


        System.out.println("Enter A Number Of Years");
        time = "P" + inputDevice.nextLine() +"Y";

        System.out.println("Enter A Number Of Months");
        time = time + inputDevice.nextLine() + "M";

        System.out.println("Enter A Number Of Days");
        time = time + inputDevice.nextLine() + "D";
        
        Period p = Period.parse(time);// the Period object p cn nparse the data from the weird string, to provide a value for years, months, and days

        System.out.println("The Time Is:");
        System.out.println(p.getYears() + " Years\n");
        System.out.println(p.getMonths() + " Months\n");
        System.out.println(p.getDays() + " Days\n");


    }
    
}
