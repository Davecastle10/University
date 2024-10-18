package week3;
import java.util.Scanner;

public class Week3 {
    public static void main(String[] args)
    {
        /*
        Scanner inputDevice = new Scanner(System.in);
        int intInput;
        System.out.println("Please enter an integer");
        intInput = inputDevice.nextInt();
        inputDevice.nextLine();

        if (intInput % 2 == 0)
        {
            System.out.println("Even");
        }

        else if (intInput % 2 != 0)
        {
            System.out.println("Odd");
        }
        */

        Day d = new Day(18,10,2024);
        System.out.println(d);
        System.out.println(d.dayOfWeek());
    }
}
