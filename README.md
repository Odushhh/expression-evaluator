# Expression Evaluator

## Overview
This is a simple parser and evaluator for mathematical expressions built using Flex (scanning) and Bison/Yacc (parsing). 

It supports basic arithmetic operations, conditional statements, and variable assignments.

This is a group project for a Compiler Construction class

## Contributors:
1. [Jesse Kamau](https://github.com/jesse1234)
2. [Singh Sehmi](https://github.com/Jeevyy)
3. [Aman Vasani](https://github.com/VasaniAman)
4. [Sylvester Leting](https://github.com/Leting7)
5. Adrian Oduma

## Features
- Supports arithmetic operations: addition, subtraction, multiplication, and division.
- Handles conditional statements (`if` and `else`).
- Allows variable assignments and lookups.
- Generates an Abstract Syntax Tree (AST) for parsed expressions.

## Project Structure
- `ast.c` & `ast.h`: Function definitions for creating & manipulating the Abstract Syntax Tree (AST).
- `symbol.c` & `symbol.h`: Implements a symbol table for managing variable names and their types.
- `parser.y`: Bison grammar file that defines the syntax and rules for parsing expressions.
- `parser.tab.c` & `parser.tab.h`: Generated files from Bison that contain the parser implementation (run `bison -v -d parser.y` to generate them).
- `lex.yy.c`: Generated file from Flex that contains the lexical analyzer (run `flex lexer.l` to generate it).
- `Makefile`: Build script to compile/automate the whole project.

## Pre-requisites
- Ubuntu (or preferred Linux distro)
- GCC
- Flex
- Bison
- Make

## Installation

Modify `parser.y` and `lexer.l` with the correct grammar & tokens declaration then run:

```bash
bison -v -d parser.y
flex lexer.l
gcc -o -Wall parser ast.c symbol.c parser.tab.c lex.yy.c -lfl
```

Build the project:

```bash
make
```

Source files are compiled and an executable file is created -> `expression_evaluator`.


## Error Handling
The parser wiil report syntax errors if the input does not align with defined grammar in `parser.y` or tokens declaration in `lexer.l`.

To debug errors, run:

```bash
bison -v -d -Wcounterexamples parser.y
```

## Usage
Run the compiled program:

```bash
./expression_evaluator
```

Enter expressions and end them with a semicolon (`;`). Type `exit` or `CTRL+C` to terminate the program.

### Examples of Expressions you can input:
```
a = 5 + 3;

if (a > 3) b = 10 else b = 20;

x = 5;
y = 10;
z = x + y;

```


## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
