package week1maybe;
// I think this is week 1 oop homework
import java.util.Scanner;


public class ExtraPractice 
{

    public static void main(String[] args)
    {
        Scanner inputDevice = new Scanner(System.in);

        System.out.println("Enter Your Age");
        String myAge = inputDevice.nextLine();

        int age = Integer.parseInt(myAge);

        System.out.println("You are :" + age);


    }
    
}
