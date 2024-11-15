package week7;

public class Forum {
    
    public static void main(String[] args) 
    {
        MessageBoard board1 = new MessageBoard();
        User u1 = new User("Day", board1);
        User u2 = new User("Matt", board1);
        User u3 = new User("Tyla", board1);
        User u4 = new User("Chris", board1);
        User u5 = new User("Elliot", board1);
        board1.addMember(u1);
        board1.addMember(u2);
        board1.addMember(u3);
        board1.addMember(u4);
        board1.addMember(u5);

        Reader r1 = new Reader("001", board1);
        Reader r2 = new Reader("002", board1);
        board1.addMember(r1);
        board1.addMember(r2);

        Moderator m1 = new Moderator("Admin", board1);
        board1.addMember(m1);

        u1.post("Hello World !!!");

        System.out.println(board1.getNews());

        m1.delete();
        System.out.println(board1.getNews());


        //System.out.println(board1.userString());
    }
}
