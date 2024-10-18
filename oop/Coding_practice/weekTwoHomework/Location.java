package weekTwoHomework;




public class Location
{
    private String name;// private for encapuslation
    private double xcoord;
    private double ycoord;

    // Constructor method

    public Location(String inputName, double inputxcoord, double inputycoord)
    {
        this.name = inputName;// this.name meand the name attribute from the object we are currently in the context of
        this.xcoord = inputxcoord;// could have also just done name, xcoord, ycoord and it would have worked just aswell as th einputName, inputxcoord, inputycoord
        this.ycoord = inputycoord;
    }

    public String toString()
    {
        return this.name + "(" + this.xcoord + "," + this.ycoord + ")";
    }

    // getter methods
    public String getName()
    {
        return this.name;
    }

    public double getxcoord()
    {
        return this.xcoord;
    }

    public double getycoord()
    {
        return this.ycoord;
    }
    
    // setter methods
    public void setName(String name)
    {
        this.name = name;
    }

    public void setxcoord(double xcoord)
    {
        this.xcoord = xcoord;
    }

    public void setycoord(double ycoord)
    {
        this.ycoord = ycoord;
    }

    public  void moveTo(double xcoord, double ycoord)
    {
        this.xcoord = xcoord;
        this.ycoord = ycoord;
    }
/*
    public double distance(Location other)
    {
        return Math.sqrt( Math.pow(this.xcoord - other.getxcoord(), 2) + Math.pow(this.ycoord - other.getycoord()));// trying to return the straiht line distance between this and other location objects, and ive used the pythagorean theorme for the mathematic
    }*/
}