package week7;

public class Reader implements Subscriber
{
    protected String id;
    protected MessageBoard board;

    public Reader(String id, MessageBoard board)
    {
        this.id = id;
        this.board = board;
        //this.board.addUser(this);
    }

    public void alert()
    {
        System.out.println("Alert recieved by " + id);
    }
}
