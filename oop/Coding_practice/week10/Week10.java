package week10;

import java.util.stream.IntStream;
import java.util.stream.Stream;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.List;


public class Week10 
{
    public static void main(String[] args) 
    {
        /* 
        // prints even numbers form 101 - 110
        IntStream.rangeClosed(1, 10)
                 .map(x -> x + 100)// perform an operation on each element that passes through the stream
                 .filter(x -> x % 2 == 0)// only values that pass this filter (are even) will be returned/printed
                 .forEach(System.out::println);
        */

        /*
        System.out.println("");
        System.out.println("Map");
        // prints first 10 even numbers via map
        IntStream.rangeClosed(1, 10)
                 .map(x -> x *2)// doubles each element in the range so they are even
                 .forEach(System.out::println);

        System.out.println("");
        System.out.println("Filter");
        // like previous but prints first 10 even numbers via filter and ranhge change instead
        IntStream.rangeClosed(1, 20)
                 .filter(x -> x % 2 == 0)// only values that pass this filter (are even) will be returned/printed
                 .forEach(System.out::println);

        System.out.println("");
        System.out.println("Iterate");
        // like previous but prints first 10 even numbers via filter and ranhge change instead
        IntStream.iterate(2, x -> x + 2)
                .limit(10)// limits the operation at 10 values.
                .forEach(System.out::println);

        */
        // Array

        ArrayList<String> list = new ArrayList<String>();
        list.add("red");
        list.add("amber");
        list.add("green");

        Stream<String> stream1 = list.stream();// creates a stream of data from the collection (list)
        stream1.map(x -> x.toUpperCase())
               .filter(x -> x.length() == 5)
               .forEach(System.out::println);//prints out the data in the stream

        System.out.println("peek");
        Stream<String> stream2 = list.stream();
        stream2.peek(x -> System.out.println("Before; " + x))
               .filter(x -> x.length() == 5)// if length != 5 skip to next item in the list
               .map(x -> x.toUpperCase())
               .peek(x -> System.out.println("After; " + x))
               .forEach(System.out::println);

        System.out.println("first version");
        ArrayList<String> first = new ArrayList<String>();
        Stream<String> firstStream = list.stream();
        firstStream.filter(x -> x.length() == 5)
                   .peek(x -> first.add(x))
                   .forEach(System.out::println);
        System.out.println(first);


        System.out.println("second version");
        ArrayList<String> second = new ArrayList<String>();
        Stream<String> secondStream = list.stream();
        secondStream.filter(x -> x.length() == 5)
                   .forEach(x -> second.add(x));
        System.out.println(second);

        System.out.println("third version");
        ArrayList<String> third = new ArrayList<String>();
        list.stream().filter(x -> x.length() == 5).forEach(x -> third.add(x));
        System.out.println(third);

        System.out.println("fourth version");
        List<String> fourth = list.stream()
                                  .filter(x -> x.length() == 5)
                                  .collect(Collectors.toList());
        System.out.println(fourth);

        
    }
}
