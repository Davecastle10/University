package week4;
import java.util.Random;

public class Week4Work 
{
    public static void main(String[] args)
    {
        /*
        Random generator = new Random();

        boolean[] data = new boolean[100];
        for(int i = 0; i < 100; i++)
        {
            double r = generator.nextDouble();
            data[i] = (r < 0.25);
        }

        System.out.println(data[99]);

        int count = 0;
        
        for (int i = 0; i < 100; i ++)
        {
            if (data[i])
            {
                count++;
            }
        }

        System.out.println(count);
        */

        Population p = new Population(100, 0.1, 0.2, 0.9);
        System.out.println(p);
        //p.updateOverTimeOutputs(100);
        //System.out.println(p);
    }

    
}
