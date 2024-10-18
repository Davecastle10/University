package weekTwoHomework;



public class Person
{
    private String name;// private for encapuslation
    private Location location;

    // Constructor method

    public Person(String inputName, double inputxcoord, double inputycoord, String inputLocationName)
    {
        this.location = new Location(inputLocationName, inputxcoord, inputycoord);
        this.name = inputName;// this.name meand the name attribute from the object we are currently in the context of
        //this.location.setxcoord = inputxcoord;// could have also just done name, xcoord, ycoord and it would have worked just aswell as th einputName, inputxcoord, inputycoord
        //this.location.setycoord = inputycoord;
        //this.location.setName = inputLocationName;
    }

    public String toString()
    {
        return this.name + "is at "+ this.location.getName() + "(" + this.location.getxcoord() + "," + this.location.getycoord() + ")";
    }

    // getter methods
    public String getName()
    {
        return this.name;
    }

    public String getLocationName()
    {
        return this.location.getName();
    }
    
    public double getxcoord()
    {
        return this.location.getxcoord();
    }

    public double getycoord()
    {
        return this.location.getycoord();
    }

    public Location getLocation()
    {
        return this.location;
    }
    
    // setter methods
    public void setName(String name)
    {
        this.name = name;
    }

    public void setLocationName(String name)
    {
        this.location.setName(name);
    }
    
    public void setxcoord(double xcoord)
    {
        this.location.setxcoord(xcoord);
    }

    public void setycoord(double ycoord)
    {
        this.location.setycoord(ycoord);
    }

    public  void moveTo(double xcoord, double ycoord)
    {
        this.location.setxcoord(xcoord);
        this.location.setycoord(ycoord);
    }

    public double distance(Location other)
    {
        return Math.sqrt( (this.location.getxcoord() - other.getxcoord())*(this.location.getxcoord() - other.getxcoord()) + (this.location.getycoord() - other.getycoord())*(this.location.getycoord() - other.getycoord()));// trying to return the straiht line distance between this and other location objects, and ive used the pythagorean theorme for the mathematic
    }
}




