package week7;

public class User implements Subscriber
{
    protected String name;
    protected MessageBoard board;

    public User(String name, MessageBoard board)
    {
        this.name = name;
        this.board = board;
        //this.board.addUser(this);
    }

    public void post(String news)
    {
        board.setNews(news);
    }

    public void alert()
    {
        System.out.println("Alert recieved by " + name);
    }
}
