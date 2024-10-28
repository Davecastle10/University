package week4;


import java.util.Random;
public class Population
{

    private int populationSize;
    private boolean[] populationArray = new boolean[populationSize];
    private double infectedAtStart;
    private double recoverChance;
    private double transmissionChance;
    private Random generator;
/*
Constructor
- The constructor should take in the population size and the three probabilities.
- It should allocate space for the array of booleans.
- It should create the random number generator.
- Then it should have a for-loop which makes each person infected according to the
initial probability.
*/
    public Population( int populationSize, double infectedAtStart, double recoverChance, double transmissionChance)
    {
        this.populationSize = populationSize;
        this.infectedAtStart = infectedAtStart;
        this.recoverChance = recoverChance;
        this.transmissionChance = transmissionChance;
        this.populationArray = new boolean[populationSize];
        generator = new Random();

        for (int i = 0; i < populationSize; i++)
        {
            populationArray[i] = (generator.nextDouble() < infectedAtStart);
        }
    }


    public int getInfections()
    {
        int count = 0;    
        for (int i = 0; i < populationSize; i ++)
        {
            if (populationArray[i])
            {
                count++;
            }
        }

        return count;
    }


    public String toString()
    {
        return this.getInfections() + " people infected.";
    }


/*
update
*/

    public void update()
    {
        boolean[] newPopulationArray = new boolean[populationSize];
        for (int i = 0; i < populationSize; i++)
        {
            if (populationArray[i])
            {
                newPopulationArray[i] = (generator.nextDouble() > recoverChance);
            }
            else 
            {
                int randomPersonIndex = generator.nextInt(populationSize);

                if (populationArray[randomPersonIndex] == true)
                {
                    newPopulationArray[i] = (generator.nextDouble() < transmissionChance);
                }
                else
                {
                    newPopulationArray[i] = false;
                }
            }
        }

        populationArray = newPopulationArray;

    }

    public boolean areThereInfected()
    {
        boolean anyInfected = false;
        int count = 0;
        while (anyInfected != true && count < populationSize)
        {
            if (populationArray[count] == true)
            {
                anyInfected = true;
            }
             count++;
        }

        return anyInfected;
    }

    public void updateOverTime(int time)
    {
        for (int i = 0; i < time; i++)
        {
            this.update();
        }
    }

    public void updateOverTimeOutputs(int time)
    {
        for (int i = 0; i < time; i++)
        {
            this.update();
            System.out.println(this.toString());
        }
    }

    public int updateUnitllNoInfected(int time)
    {
        // probably need to do a double loop
        //boolean infected = true;
        //int personIndex = 0;
        //int infectedCount = 0;
        int runCount = 0;
        while (this.areThereInfected() != false && runCount < time)
        {
            /* 
            if ( populationArray[personIndex])
            {
                infected = true;
                infectedCount++;
            }
            else
            {
                infected = false;
            }*/

            runCount++;
            this.update();
        }

        return runCount;
    }

    public int averageUpdateUntilNoInfected(int amountOfRuns, int individualRunTime)
    {
        int runTotals = 0;
        int average;
        for (int i = 0; i < amountOfRuns; i ++)
        {
            int currentRun = this.updateUnitllNoInfected(individualRunTime);// something is wrong here 

            runTotals = runTotals + currentRun;
            //System.out.println(currentRun);

        }

        average = runTotals / amountOfRuns;

        return average;
    }
}

