package weekTwoHomework.Challenge;
// the week 2 challenge
public class Expression 
{
    private String content = "";

    public Expression(String content)
    {
        this.content = content;
    }

    // getter

    public String toString()
    {
        return content;
    }

    // setters

    public void ruleOne()
    {
        if (this.content.endsWith("I"))
        {
            this.content = this.content +"U";
        }
    }

    public void ruleTwo()
    {
        this.content = this.content.charAt(0) + this.content.substring(1) + this.content.substring(1);
    }

    public void ruleThree()
    {
        this.content = this.content.replaceAll("III", "U");
    }

    public void ruleFour()
    {
        this.content = this.content.replaceAll("UU", "");
    }
}
