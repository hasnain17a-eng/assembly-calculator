# 8086 Assembly Calculator

A simple calculator written in **8086 assembly language** for the **emu8086** emulator.

> **Note:** This is a recreated version of my coursework project. The original
> files were lost with my old laptop, so I rebuilt it from scratch.

## Features
- Adds, subtracts, multiplies and divides two single-digit numbers
- Handles **negative results** (for example `3 - 8 = -5`)
- Division shows the **quotient and remainder**
- Detects **division by zero**
- Validates input (digits 0-9 and operators `+ - * /`)
- Repeats until the user chooses to quit

## How to run
1. Install and open **emu8086**.
2. Open `calculator.asm` (File > Open).
3. Click **Compile**, then **Run** (or **Emulate** then **Run**).
4. Use the console window to enter numbers and operators.

## Example
```
Enter first number (0-9): 7
Enter operator (+ - * /): /
Enter second number (0-9): 2
Result = 3  remainder = 1
```

## Concepts used
- `.model small`, `.stack`, `.data` and `.code` segments
- DOS interrupts `INT 21h` (functions 01h, 02h, 09h, 4Ch)
- Procedures (`proc` / `endp`, `call`, `ret`)
- Arithmetic: `ADD`, `SUB`, `IMUL`, `DIV`, `NEG`
- Comparisons and jumps: `CMP`, `JE`, `JNE`, `JB`, `JA`, `JNS`
- The stack (`PUSH` / `POP`) to convert a number into printable digits

## Ideas to extend
- Accept multi-digit numbers
- Add modulus or power operations
