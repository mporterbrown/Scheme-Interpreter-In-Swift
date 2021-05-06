# Final Project

Mason Porter-Brown <mp3902@bard.edu>

12/18/20

CMSC 305

## Collaboration Statement:

I worked on this assignment alone.
                                 
## Lab Report:

Summary: 

For my final project, I created a Scheme interpreter in Swift. I followed the Crafting Interpreters method very closely. Overall, I was successful in interpreting most of the major Scheme methods. 

Methods:

I began by creating my Token object in Swift. I did this by using a Swift struct, and a Swift enum. I used these two structures as the Token object did not require mutability or inheritance. 

Next, I created my Scanner, Parser, Expr, and Environment. I followed crafting interpreters closely. The Expr Class utilized the visitor pattern. 

Finally, I worked on my Interpreter class and used the visitor pattern in order to evaluate my AST. Because my Parser did very little work, the bulk of the work was done within my Interpreter. This is displayed by the amount of unpacking I had to do from each Expr type within each visitor pattern. The prepareSListExpression method was created to help with this unpacking process.

Reflection: 

Overall, I am pleased with the amount that my Interpreter can accomplish. I did not have quite as much time as I would have liked to polish the code.

I feel as though my Interpreter code can be simplified a lot, and that is something that I will fix in the future.

## Note:

Within the project folder (or Repl.it), the "Scheme.txt" file contains tests that are written in order to display some of the main methods and accomplishments of this project.

 