package week9;
import java.util.Random;

public class Ancestors 
{
    public static void main(String[] args) 
    {
        Random generator = new Random();
        Population pop = new Population(10, generator);
        //pop.display();
        pop.initial();
        pop.display();
        

        System.out.println("");
        Population previous = pop.generation();
        previous.display();
        System.out.println(previous.max());

        Population recent = pop.mostRecent();
        recent.display();
    }
    

}
