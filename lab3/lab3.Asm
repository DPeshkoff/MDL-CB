; Lab3 console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
    MsgInputB   DB    "Input B: ",0AH,0DH,0
    MsgInputY   DB    "Input C: ",0AH,0DH,0
    MsgResult   DB    "F equals: ",0AH,0DH,0
    MsgExit     DB    0AH,"Press Enter to Exit...",0AH,0DH,0

         .DATA

         .DATA?
        F       SWORD   ?
        
        B       SWORD   ?
        Y       SWORD   ?
        
        InOutBuffer    DB    100 DUP (?)

         .CODE
    Start:
    InputB:                                 ; input SWORD B
 Invoke StdOut,         ADDR MsgInputB
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
        

        cmp     B,      0                   ; compare F and 0
        jle     OThree                      ; jump if F <= 0
        jmp     OF                          ; jump to calculation
        
        ; if b > 0: (b*b - c) / b
    OF:   
        mov     AX,     B                   ; move B to AX
        mov     BX,     B                   ; move B to BX
        imul    BX                          ; DX:AX := B * B
        sub     AX,     Y                   ; AX := AX - Y
        mov     BX,     B                   ; move B to BX
        cwd                                 ; sword to sdword for idiv handling (exception '1,5')
        idiv    BX                          ; AX := (DX:AX) / BX
        mov     F,      AX                  ; move stage result to F
        jmp     Output                      ; jump to output section
        
        ; else: 3
    OThree:
        mov     F,      3                   ; if b <= 0: F := 3 
        jmp     Output                      ; jump to output section
        
    Output:
 Invoke dwtoa,  F,      ADDR InOutBuffer    ; transfer F to buffer 
 Invoke StdOut,         ADDR MsgResult      ; output resulting message 
 Invoke StdOut,         ADDR InOutBuffer    ; output the result 
        xor     EDX,     EDX                ; clear EDX
        xor     EAX,     EAX                ; clear EAX
        xor     EBX,     EBX                ; clear EBX        
 Invoke StdOut, ADDR    MsgExit             ; output exit message 
 Invoke StdIn,  ADDR    InOutBuffer,LengthOf InOutBuffer		
 Invoke ExitProcess,    0
End    Start