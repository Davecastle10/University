package week9;

import java.util.HashSet;
import java.util.ArrayList;
import java.util.Random;

public class Population 
{
    private int size;
    private ArrayList<HashSet<Integer>> pop;
    private Random generator;

    public Population(int size, Random generator)
    {
        this.size = size;
        this.pop = new ArrayList<HashSet<Integer>>();
        for (int i = 0; i<size; i++)
        {
            HashSet<Integer> s = new HashSet<Integer>();
            pop.add(s);
        }
        this.generator = generator;
    }

    public void initial()
    {
        for (int i = 0; i < size; i++)
        {
            int mother = generator.nextInt(size);
            int father = generator.nextInt(size);
            pop.get(mother).add(i);
            pop.get(father).add(i);
        }
    }

    public void display()
    {
        for (int i = 0; i < size; i++)
        {
            System.out.println(pop.get(i));
        }
    }

    
}
