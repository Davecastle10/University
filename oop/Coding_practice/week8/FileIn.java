package week8;

import java.nio.file.*;
import java.io.*;

public class FileIn 
{
    public static void main(String[] args) 
    {
        Path file = Paths.get("\\Users\\davec\\Documents\\Repositories\\University\\oop\\Coding_practice\\week8\\storageFile.txt");

        try 
        {
            InputStream input = new BufferedInputStream(Files.newInputStream(file));
            BufferedReader reader = new BufferedReader(new InputStreamReader(input));

            String s = reader.readLine();
            while (s != null)
            {
                System.out.println(s);
                s = reader.readLine();
            }
        } 
        catch (Exception e) 
        {
            System.out.println("No such file");
            System.out.println(e.getMessage());// not neccescary but easier for testing
        }
        
    }
}
