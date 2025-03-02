package Data_Structures_and_Algorithms.week1;

public class problem1 {

    public static int flip(int num)
    {
        /* 
        if (num < 1)
        {
            return null;
        }
        else if (num > 1000000000)
        {
            return null;
        }
            */
        System.out.println(num);
        System.out.println((int)0101);
        String numString = String.valueOf(num);
        System.out.println(numString);

        String flipString = "";
        char ch;

        for (int i = 0; i < numString.length(); i++) {
            ch = numString.charAt(i);
            flipString = ch + flipString; 
        }

        return Integer.parseInt(flipString);

    }
    public static void main (String[] args)
    {
        System.out.println(flip(1024));

        System.out.println(flip(00501024));
        int inNum = 0101;
        System.out.println(flip(inNum));
    }

    
}
