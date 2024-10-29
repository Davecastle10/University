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

        //Population p = new Population(100, 0.1, 0.2005, 0.2);
        //System.out.println(p.updateUnitllNoInfected(200));
        //System.out.println(p.averageUpdateUntilNoInfected(100, 200));
        //p.updateOverTimeOutputs(100);

        Challenge4 intInputTest = new Challenge4(3459);
        Challenge4 StringInputTest = new Challenge4("MMMCDLIX");
        

        System.out.println(intInputTest.toString());
        System.out.println(StringInputTest.getArabicNumeras());
    }

    
}
