package week5;

import java.util.Random;

public class Chromosome {

    /*
    Chromosome class
    Attributes:
    - the size of the chromosome
    - a boolean array to represent the genes
    - a random number generator
    Constructor
    - takes as arguments the size of the chromosome and a random number generator
    - initialises these, and then creates the array, filled with random values
    toString
    - converts the chromosome into a string of 1s and 0s
    Mutate
    - pick a random gene and change it
    Copy
    - create a new chromosome and make it a copy of this one
    Fitness
    - return a count of the number of times "true" appears in the chromosome
    */

    private int size;
    private boolean[] gene;
    private Random generator;

    public Chromosome(int size, Random generator)
    {
        this.size = size;
        this.generator = generator;
        this.gene = new boolean[size];
        for (int i = 0; i < size; i++)
        {
            this.gene[i] = (generator.nextDouble() < 0.5);
        }
    }

    public String toString()
    {
        String stringReturn = "";
        for (int i = 0; i < size; i++)
        {
            if (gene[i] == true)
            {
                stringReturn = stringReturn + "1";
            }
            else
            {
                stringReturn = stringReturn + "0";
            }
            
        }

        return stringReturn;
    }

    public void mutate()
    {
        int randomGene = generator.nextInt(size - 1);
        gene[randomGene] = !gene[randomGene];
    }

    public Chromosome copy()
    {
        Chromosome copyChromosome = new Chromosome(size, generator);
        return copyChromosome;
    }

    public int fitness()
    {
        int count = 0;

        for (int i = 0; i < size; i++)
        {
            if (gene[i] == true)
            {
                count++;
            }
        }

        return count;
    }
    
}
