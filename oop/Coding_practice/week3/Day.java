package week3;

public class Day {
    private int day;
    private int month;
    private int year;

    // Constructor

    public Day(int day, int month, int year)
    {
        this.day = day;
        this.month = month;
        this.year = year;
    }

    // Getter

    public String toString()
    {
        return "The date today is: " + this.day + "/" + this.month + "/" + this.year;
    }

    // Setter

    public void setDay(int day)
    {
        this.day = day;
    }

    public void setMonth(int month)
    {
        this.year = month;
    }

    public void setYear(int Year)
    {
        this.year = Year;
    }

    // util

        // is it new years day

    public boolean newYear()
    {
        if (this.day == 1 && this.month == 1)
        {
            return true;
        }

        else
        {
            return false;
        }

    }

        // is it a century year
    
    public boolean isCentury()
    {
        if (this.year % 100 == 0)
        {
            return true;
        }

        else
        {
            return false;
        }
    }

        // is it a leap year
    
    public boolean isLeapYear()
    {
        if (this.isCentury())
        {
            return this.year % 400 == 0;
        }

        else if (this.year % 4 == 0)
        {
            return true;
        }

        else
        {
            return false;
        }
    }

        // day of the week
    
        public String dayOfWeek()// based on Lewis Carrols day of the week code.
        {
            String result = "unknown";

            // Century item
            // get century by dividing the year by 100
            // get the remainder of that after dividing by 4
            // Subtract the result from 3
            // Multiply by 2

            int centuryItem = this.year / 100;
            centuryItem = centuryItem % 4;
            centuryItem = 3 - centuryItem;
            centuryItem = centuryItem * 2;

            // Year item
            int yearItemx = year % 100;
            int yearItemy = yearItemx/12;
            int yearItemz = yearItemy/4;
            int yearItem = yearItemx + yearItemy + yearItemz;

            // Month score

            int[] monthScore = {0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 4, 5};
            int monthItem = monthScore[month-1];

            // Day item
            int dayItem = day;
            if (this.isLeapYear() && (month == 1 || month ==2))
            {
                dayItem = dayItem + 6;
            }

            int total = (centuryItem + yearItem + monthItem + dayItem) % 7;

            switch(total)
            {
                case 0:
                    result = "Sunday";
                    break;
                case 1:
                    result = "Monday";
                    break;
                case 2:
                    result = "Tuesday";
                    break;
                case 3:
                    result = "Wednesday";
                    break;
                case 4:
                    result = "Thursday";
                    break;
                case 5:
                    result = "Friday";
                    break;
                case 6:
                    result = "Saturday";
                    break;

            }



            return result;
        }

        
}

