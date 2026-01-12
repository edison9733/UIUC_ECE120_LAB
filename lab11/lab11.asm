; This program calculates X! (X factorial). It can calculate
;   different numbers (4!, 6!, etc.) by changing the value of the first memory
;   location at the bottom of the code. It is currently set up to calculate
;   5!. The program does not account for zero or negative numbers as input.

; This program primarily uses registers in the following manner:
; R0 contains 0 (registers contain zero after reset)
; R1 contains multiplication result (6x5 = 30, 30x4 = 120, etc)
; R2 contains -1
; R3 contains counter for outer loop
; R4 contains counter for inner loop
; R5 contains current sum
; R6 contains temp of inner count 

            .ORIG  x3000              ; Start execution

            LD    R0, ZERO            ; Clear R0 to 0 (used for copying)
            LD    R5, ZERO            ; Clear R5 to 0 (sum accumulator)         
            LD    R3, INPUT           ; R3 contains input number
            LD    R2, MINUS_ONE       ; R2 contains -1 
            ADD   R1, R3, R0          ; R1 contains input number for outer loop
            ADD   R4, R3, R2          ; R4 cointains input number - 1 for inner loop 

                          
OUTERLOOP   LD    R5, ZERO            ; Initial sum is ZER0 
            ADD   R6, R0, R4          ; Copy outer count into inner count

; This loop multiplies via addition (6x5 = 6+6+6+6+6 = 30,
;   30x4 = 30+30+30+30 = 120, etc)
INNERLOOP   ADD   R5,R5,R1            ; Increment sum
            ADD   R6,R6,R2            ; Decrement inner count
            BRp  INNERLOOP            ; Branch to inner loop if inner count
                                      ;   is positive only
            ADD   R1,R0,R5            ; R1 now contains sum result from inner loop
            ADD   R4,R4,R2            ; Decrement outer count
            BRp  OUTERLOOP            ; Branch to outer loop if outer count 
                                      ;   is positive only 

            STI   R1, RESULT_PTR      ; Point to the memory of X30FF      
            TRAP x25

INPUT      .FILL  x0005               ; Input for X!, in this case X = 5
ZERO       .FILL  x0000               ; Just a 0 
MINUS_ONE  .FILL  xFFFF               ; 2's complement of 1 (i.e. -1)
RESULT_PTR .FILL  x30FF               ; At program completion, the result is
                                      ;   stored here
           .END                       ; Stop the execution 