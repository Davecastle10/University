package week7;
import java.util.ArrayList;

public class MessageBoard
{
    private String news;
    public ArrayList<Subscriber> members;

    public MessageBoard()
    {
        news = "no news";
        members = new ArrayList<Subscriber>();

    }

    public void setNews(String news)
    {
        this.news = news;

        System.out.println("");
        for (Subscriber m: members)
        {
            m.alert();
        }
        System.out.println("");
    }

    public String getNews()
    {
        return news;
    }

    public void addMember(Subscriber user)
    {
        members.add(user);
    }

    /*
    public String userString()
    {
        String returnString = "";
        for (Subscriber m: members)
        {
            returnString = returnString + m.name + ", ";
        }

        return returnString;
        
    }
         */
}
