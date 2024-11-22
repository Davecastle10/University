package week8;

import java.nio.file.*;
import java.io.*;
import static java.nio.file.StandardOpenOption.*;

public class FileOut 
{
    public static void main(String[] args) 
    {
        // for some reason this needs \\ rather than \ int eh file path
        Path file = Paths.get("\\Users\\davec\\Documents\\Repositories\\University\\oop\\Coding_practice\\week8\\storageFile.txt");

        String s = "Hello World";
        byte[] data = s.getBytes();

        try 
        {
            OutputStream output = new BufferedOutputStream(Files.newOutputStream(file, CREATE));
            output.write(data);
            output.flush();
            output.close();
        } 
        catch (Exception e) 
        {
            System.out.println("No such file");
            System.out.println(e.getMessage());
        }        
        
    }
}
