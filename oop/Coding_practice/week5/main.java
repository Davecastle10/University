package week5;


import java.util.Random;

public class main {

    public static void main(String[] args) 
    {     
        Random generator = new Random();
        Chromosome c = new Chromosome(20, generator);
        
        System.out.println(c.toString());

        c.mutate();
        System.out.println(c.toString());

        System.out.println(c.fitness());
        
        
        Chromosome cCopy = c.copy();

        System.out.println(cCopy.toString());

       

    }
}
