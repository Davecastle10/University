package week8;

import java.nio.file.*;
import java.io.*;
import static java.nio.file.StandardOpenOption.*;

import java.util.Scanner;

public class BufferedOut
{
    public static void main(String[] args) 
    {
        // for some reason this needs \\ rather than \ int eh file path
        Path file = Paths.get("\\Users\\davec\\Documents\\Repositories\\University\\oop\\Coding_practice\\week8\\storageFile.txt");

        Scanner inputDevice = new Scanner(System.in);

        String s1 = "Hello";
        String s2 = "World!";


        try 
        {
            OutputStream output = new BufferedOutputStream(Files.newOutputStream(file, CREATE, TRUNCATE_EXISTING));
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(output));

            
            String inputString = " ";
            while (!inputString.equals("")) 
            {
                System.out.println("Please enter a string: ");
                inputString = inputDevice.nextLine();
                writer.write(inputString);
                writer.newLine();
            }
            
            
            writer.flush();
            writer.close();
        } 
        catch (Exception e) 
        {
            System.out.println("No such file");
            System.out.println(e.getMessage());
        }        
        
    }
}