package weekTwoHomework.Challenge;

public class Main {

    public static void main(String[] args)
    {
        Expression expression = new Expression("UUUIIII");
        expression.ruleOne();
        System.out.println(expression.toString());
        expression.ruleTwo();
        System.out.println(expression.toString());
        expression.ruleThree();
        System.out.println(expression.toString());
        expression.ruleFour();
        System.out.println(expression.toString());
    }
}
