package week1maybe;
import java.util.Scanner;// the java modulue?? that is used for taking inputs from the terminal/command line

public class Arithmetic
{
    public static void main(String[] args)
    {
        Scanner inputDevice = new Scanner(System.in);

        System.out.println("Please enter a number");
        int firstNumber = inputDevice.nextInt();
        inputDevice.nextLine();
        System.out.println("You chose " + firstNumber + " as your first number");
        
        System.out.println("Please enter a second number");
        int secondNumber = inputDevice.nextInt();
        inputDevice.nextLine();
        System.out.println("You chose " + secondNumber + " as your first number");

        int sum = firstNumber + secondNumber;
        int multiplication = firstNumber * secondNumber;
        int dividionFirstBySecond = firstNumber / secondNumber;
        int divisionSecondByFirst = secondNumber / firstNumber;

        System.out.println(firstNumber + "+" +  secondNumber + "=" + sum);
        System.out.println(firstNumber + "*" +  secondNumber + "=" + multiplication);
        System.out.println(firstNumber + "/" +  secondNumber + "=" + dividionFirstBySecond);
        System.out.println(secondNumber + "/" +  firstNumber + "=" + divisionSecondByFirst);
    }
}
        