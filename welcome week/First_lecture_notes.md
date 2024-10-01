# First notes from the first proper lecture in week 1  

## Rules

1. Don't grief (don't prevent yourself or others from learning)

## Module team
1. Module lead: Pieter p.joubert@bham.ac.uk
2. Lecturee : jon j.rowe.2@bham.ac.uk
3. Lecturer : wendy w.yanez@bham.ac.uk

## Module structure

1. Creating Java programs and using data
2. Methods, classes and objects
3. Decisions
4. Looping
5. Characters, strings and arrays
6. support and consolidation
7. inheritance
8. exception handling an file i/o
9. recursion and collections
10. streams
11. revision and good coding practice

## Java

Will be using JDK 17, but it is installed on the virtual lab, so don't really need to worry too much about that.  

- Java compiles to byte code that is run on the Java Virtual Machine, this means that Jvae code can be run on any device with a java virtual machine without needing to be re compiled, this adds more security as the Java Virual Machine (JVM) seperates the code from the device so it can pick up on damgerous code/security risks

- The compiler and code only does exactly what you tell it to do, so it mi9ght still run, but the output is wrong because you made an error.

- You can use // to comment in Java code, this means what us written in the comment is ignored by the compiler, so yiou can use the comment to explain what you are doing. and you can use /* and */ to create multi line comments

- be explicit/descriptive with variable names, because it can make it easier to read/understand and reduce the need for lots of comments

### Using Data
  
#### Variables
  
- hardcoded data like what was done before isn't easilly changed
- e.g. # `System.out.println("Hello World")`
- varibales can be used to allow for data to be more easily manipulated
- variables typically refer to a specific memory location, storing data of a specific type, with a name used to access it later, and containing some type of value
- e.g. # `int numStudents = 100;`
- you can also do things like, `System.out.println("Number of students " + numStudents);`
- another application is `final string HEADER = "=======================";`
- using final at the start of a line makes a variable into a constant which cannot be changhed later down the line in the program

#### Idnetifier names and conventions
  
- We need to follow a number of rules to ensure that variables (and other identifiers) have valid names.
- Identifiers must start with a letter, an underscore or a dollar sign.
- Identifiers can only contain Letters, Digits, Underscores and Dollar Signs.
- Java uses camel case for naming, where typically the first letter is lower case (unless it is a class) and the start of every word following after the first world is a capital e.g. `numPinkFlowersInGarden`.
- You can use Snake case e.g. `num_pink_flowers_in_garden` but this is mroe common in languages like python, and it is best to use camel case for javca so it is easily recognisable.
- Typically in Java, variabel names are as verbose and descriptive as possible, to allow fro easy identification later in the program.

#### Scope
  
- When a variable is decklared, it can only be used in certain areas of the program that are in it's scope.
- If you try to acces a varible outside of it's scope you will get a syntax error, as java will let you know that you haven't declared that variable within the scope yet.

1. add an example of ascope here

#### Primitive data types
  
- Java has several primitve data types
- A primitve data type is not a class
- Some examples of primitive data types are:  
  1. byte: usually the smalles single value you can store
  2. short, int, long: various lengths of integer numbers 
  3. float, double: numbers that can have a decimal point in them
  4. boolean: a value that can store true or false
  5. char: a single character value
- Note that String is not a primitive data type as String is a built in class with added functionality in Java

#### Operations
  
- The standard mathematical operators cna be used in Java
- Operators with the same precedence are excecuted left to right, otherwise BIDMAS/PEMDAS takes effect
- Higher precednce : * / %
- Lower precednec : + -
- Brackets can be used to make the operations easier to understand, as it can help to split up an equation into more easily manageable chunks
- This cna be done further, by splitting a complivcated calculation up ovber multiple variables that take place sepratly and then combining the variables together later on to finish the calculation.
- Brackets take effect first based on whichever bracket is the most innermost, after that the leftmost bracket takes effect first.
