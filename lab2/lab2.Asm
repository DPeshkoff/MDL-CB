; Lab2 Console Application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
    MsgInputA   DB    "Input A: ",0AH,0DH,0
    MsgInputB   DB    "Input B: ",0AH,0DH,0
    MsgInputY   DB    "Input Y: ",0AH,0DH,0
    MsgResult   DB    "Result: ",0AH,0DH,0
    MsgExit     DB    0AH,"Press Enter to Exit...",0AH,0DH,0

         .DATA
 
         .DATA?
        X       SWORD   ?

        A       SWORD   ?
        B       SWORD   ?
        Y       SWORD   ?
        
        InOutBuffer    DB    100 DUP (?)

         .CODE
    Start:
        ; entry point - no jumps necessary
        
    InputA:                                 ; input SWORD A
 Invoke StdOut,         ADDR MsgInputA
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer
 Invoke StripLF,        ADDR InOutBuffer
 Invoke atol,           ADDR InOutBuffer
        mov DWORD PTR A,    EAX
        
    InputB: 
 Invoke StdOut,         ADDR MsgInputB      ; input SWORD B
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer
 Invoke StripLF,        ADDR InOutBuffer
 Invoke atol,           ADDR InOutBuffer
        mov DWORD PTR B,    EAX
        
    InputY: 
 Invoke StdOut,         ADDR MsgInputY      ; input SWORD Y
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer
 Invoke StripLF,        ADDR InOutBuffer
 Invoke atol,           ADDR InOutBuffer
        mov DWORD PTR Y,    EAX  
 
    Calculate:  
        ; We need: x = ((a * y * (b - a) ) / 4) + a^2 - 2
        ; first step: calculate A * Y * (B - A)
        ; second step: divide step 1 by literal 4
        ; third step: calculate A * A
        ; fourth step: step 2 + step 3 - literal 2
        
        mov     AX,     A                   ; move A to AX
        mov     CX,     Y                   ; move Y to CX
        imul    CX                          ; DX:AX := A * Y
        mov     AX,     DX                  ; move DX to AX
        mov     BX,     B                   ; move B to BX
        sub     BX,     A                   ; BX := B - A
        imul    BX                          ; DX:AX := A * Y * (B - A)
        mov     CX,     4                   ; move literal 4 to CX
        idiv    CX                          ; AX := (DX:AX) / 4
        mov     X,      AX                  ; move AX to X
        mov     AX,     A                   ; move A to AX
        imul    AX                          ; DX:AX := A * A
        add     X,      AX                  ; X := X + A*A
        sub     X,      2                   ; X := X - 2
 Invoke dwtoa,  X,      ADDR InOutBuffer    ; transfer X to buffer 
 Invoke StdOut,         ADDR MsgResult      ; output resulting message 
 Invoke StdOut,         ADDR InOutBuffer    ; output the result 
        xor     DX,     DX                  ; clear DX
        xor     CX,     CX                  ; clear CX
        xor     AX,     AX                  ; clear AX
        xor     BX,     BX                  ; clear BX        
 Invoke StdOut, ADDR    MsgExit             ; output exit message 
 Invoke StdIn,  ADDR    InOutBuffer,LengthOf InOutBuffer		
 Invoke ExitProcess,    0
End    Start

