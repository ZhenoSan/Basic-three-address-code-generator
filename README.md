# Three Address Code Generator for the BASIC programming language

## Introduction
I created this code as a part of my coursework assignment in compiler design to learn the concepts of lex and yacc. It takes a basic program as an input and generates a three address intermediate code as the output. 

- The doc folder contains a latex file. It consists of some commands in basic.
- The src folder consists of the lex file containing the patterns for the tokens and the yacc file containing the grammar

## Features
It supports the following commands

- PRINT
- LET
- INPUT
- GOTO
- DO LOOP
- DO WHILE LOOP
- FOR LOOP (with and without step size)
- If THEN construct
- If ELSE construct

Support for Arithmetic Expressions and labels is also present.

In boolean expressions, precedence does not work and hence expressions containing only AND or OR (NOT can also be present) work properly. This is because I was unable to pass down inherited attributes. Maybe I should have token code as an attribute of the grammar symbols as present in the dragon book.

##Syntax

- First make the project
`make all`

- Then run the file
`./comp`
The output will be generated in out.txt

To generate output on stdout, run
`./comp out`