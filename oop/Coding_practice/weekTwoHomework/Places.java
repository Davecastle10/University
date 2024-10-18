package weekTwoHomework;

public class Places
{
    public static void main(String[] args)
    {
        /*
        Location uni = new Location("University", 10, 20);
        System.out.println(uni);

        uni.setName("University of Brimingham");
        System.out.println(uni.getName());
        System.out.println(uni);
        uni.setxcoord(2.45);
        uni.setycoord(33);
        System.out.println(uni.getxcoord() + "," + uni.getycoord());
        uni.moveTo(33.9, 97.8);
        System.out.println(uni);

        */

        Person Tyla = new Person( "Tyla", 44, 98, "Sloman Loaunge");
        Person Matt = new Person( "Matt", 73, 84, "Sloman Lounge");
        System.out.println(Tyla.distance(Matt.getLocation()));
        
    }
}