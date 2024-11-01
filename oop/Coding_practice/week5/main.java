package week5;


import java.util.Random;

public class main {

    public static void main(String[] args) 
    {     
        Random generator = new Random();

        /*
        Chromosome c = new Chromosome(20, generator);
        System.out.println(c.toString());       
        Chromosome cCopy = c.copy();
        c.mutate();
        System.out.println(c.toString());
        System.out.println(c.fitness());
        System.out.println(cCopy.toString());
        */

        Chromosome x = new Chromosome(20, generator);
        System.out.println("The original chromosome");
        System.out.println(x.toString());
        System.out.println(x.fitness());
        for (int i = 0; i < 100; i ++)
        {
            Chromosome y = x.copy();
            y.mutate();

            if (y.fitness() > x.fitness())
            {
                x = y;
            }
        }

        System.out.println("");
        System.out.println("The new chromosome");
        System.out.println(x.toString());
        System.out.println(x.fitness());


        // write code to work out how long on average it will take to convert all 0s to all 1s, like the coupon collectors problem.


       

    }
}
