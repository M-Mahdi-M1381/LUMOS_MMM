LUMOS RISC-V
Computer Organization - Spring 2024
==============================================================
## Iran Univeristy of Science and Technology
## Assignment 2: design FPU for LUMOS RISC-V

- Mohammad Mahdi Masoumi 400413314
- Mohammad Sadegh Aghasi 400411126
- Date:7/2/2024


## Introduction

**LUMOS** is a multicycle RISC-V processor that implements a subset of `RV32I` instruction set, designed for educational use in computer organization classes at **Iran University of Science and Technology**. It allows for modular design projects, enabling students to gain hands-on experience with processor architecture.
## Report

The provided Verilog file appears to define a Fixed-Point Unit (FPU) module. Here’s a summary of its content and functionality:

### Overview
- **Module Name**: `Fixed_Point_Unit`
- **Parameters**: 
  - `WIDTH`: Data width, default is 32 bits.
  - `FBITS`: Fractional bits, default is 10 bits.

### Inputs
- `clk`: Clock signal.
- `reset`: Reset signal.
- `operand_1`: First operand for operations (WIDTH bits).
- `operand_2`: Second operand for operations (WIDTH bits).
- `operation`: Operation selector (2 bits).

### Outputs
- `result`: Result of the operation (WIDTH bits).
- `ready`: Ready signal to indicate the completion of the operation.

### Internal Signals
- `root`: Register to store the result of the square root operation.
- `root_ready`: Signal to indicate the readiness of the square root operation result.
- `product`: Register to store the intermediate product of multiplication.
- `product_ready`: Signal to indicate the readiness of the product from the multiplication.

### Functionality
1. **Arithmetic Operations**:
    - The `always @(*)` block contains a case statement that performs the operation based on the `operation` input:
      - Addition (`FPU_ADD`): `result <= operand_1 + operand_2;`
      - Subtraction (`FPU_SUB`): `result <= operand_1 - operand_2;`
      - Multiplication (`FPU_MUL`): `result <= product[WIDTH + FBITS - 1 : FBITS];`
      - Square Root (`FPU_SQRT`): `result <= root;`
      - Default case: `result <= 'bz;`
    - The `ready` signal is set to 1 for addition and subtraction, and is linked to specific ready signals for multiplication and square root operations.

2. **Reset Handling**:
    - The `always @(posedge reset)` block sets the `ready` signal to 0 on reset.

3. **Multiplier Circuit**:
    - The module defines a 64-bit product register to store multiplication results.
    - It uses four 16-bit multipliers to break down the multiplication of 32-bit operands:
        - `A1` and `A2` are lower and upper 16 bits of `operand_1`.
        - `B1` and `B2` are lower and upper 16 bits of `operand_2`.
        - The partial products `P1`, `P2`, `P3`, and `P4` are computed using these 16-bit segments.
    - The partial products are summed to form the final product.

### Multipliers
- **Multiplier Instances**:
  - The module uses four instances of another module named `Multiplier` to compute partial products:
    ```verilog
    Multiplier multiplier1 (.operand_1(A1), .operand_2(B1), .product(P1));
    Multiplier multiplier2 (.operand_1(A1), .operand_2(B2), .product(P2));
    Multiplier multiplier3 (.operand_1(A2), .operand_2(B1), .product(P3));
    Multiplier multiplier4 (.operand_1(A2), .operand_2(B2), .product(P4));
    ```

### Missing Details
- The file references an included file `Defines.vh`, which likely contains macro definitions for the operations (e.g., `FPU_ADD`, `FPU_SUB`, etc.).
- The full implementation details of the square root circuit are not visible in the provided snippet.
- The `Multiplier` module is instantiated but its internal implementation is not provided in this file.

### Summary
The `Fixed_Point_Unit` module is designed to perform fixed-point arithmetic operations, including addition, subtraction, multiplication, and square root. It uses parameterized bit-widths and relies on additional modules and macros to function correctly. The design separates arithmetic operations into combinational logic with readiness signaling and reset handling to ensure proper operation sequencing.


<picture>
    <img 
        src="https://github.com/M-Mahdi-M1381/LUMOS_MMM/blob/main/Images/1.png"
    > 
</picture> 



<picture>
    <img 
        src="https://github.com/M-Mahdi-M1381/LUMOS_MMM/blob/main/Images/2.png"
    > 
</picture> 


<picture>
    <img 
        src="https://github.com/M-Mahdi-M1381/LUMOS_MMM/blob/main/Images/3.png"
    > 
</picture> 