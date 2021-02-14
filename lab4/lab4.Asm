; Lab4 console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
    MsgInput    DB    "Input matrix: ",0AH,0DH,0
    MsgMatrix   DB    0AH,0DH,"Matrix: ",0AH,0DH,0
    MsgResult   DB    0AH,0DH,"Result: ",0AH,0DH,0
    NewLine     DB    0AH,0DH,0
    Space       DB    " ",0
    MsgExit     DB    0AH,"Press Enter to Exit...",0AH,0DH,0

         .DATA
        rows    WORD    4
        cols    WORD    6
   sizeofmatrix WORD    24


         .DATA?
        matrix  SWORD   (?),(?),(?),(?),(?),(?)
                SWORD   (?),(?),(?),(?),(?),(?)
                SWORD   (?),(?),(?),(?),(?),(?)
                SWORD   (?),(?),(?),(?),(?),(?)
                
        ns      SWORD   (?),(?),(?),(?),(?),(?)            ; sum of negatives

        
 InOutBuffer    DB      100 DUP (?)

         .CODE
OutputMatrix proc near
 Invoke StdOut,         ADDR MsgMatrix
        XOR     ECX,    ECX
        XOR     ESI,    ESI                 ; clear EDX
        XOR     EDI,    EDI                 ; clear EDI
                     
        mov     CX,     sizeofmatrix                  ; clear EDX
        mov     DI,     cols
        
OutputMatrixLoop:  
        mov     EBX,    ECX
        cmp     EDI,    0 
        jle     OutputNewLine
        ContinueOutputMatrixLoop: 
 Invoke dwtoa,  matrix[ESI*2], ADDR InOutBuffer ; transfer F to buffer 
 Invoke StdOut,         ADDR InOutBuffer    ; output the result 
 Invoke StdOut,         ADDR Space
        mov     ECX,    EBX 
        inc     ESI
        dec     EDI
        loop    OutputMatrixLoop
        ret

  
OutputNewLine:
 Invoke StdOut,         ADDR NewLine
        mov     DI,     cols           
        jmp     ContinueOutputMatrixLoop  

OutputMatrix endp
         
CountRow proc near
        XOR     ECX,    ECX
        XOR     ESI,    ESI                 ; clear EDX
        XOR     EDI,    EDI                 ; clear EDI             
        mov     CX,     sizeofmatrix                  ; clear EDX
        mov     DI,     cols
        
        XOR     EBX,    EBX
        XOR     EDX,    EDX
        
CountRowLoop:   
        cmp     EDI,    0
        jle     InsertNumber
        cmp matrix[ESI*2], 0
        jle     AddNumber
        jmp     ContinueCountRowLoop
        
ContinueCountRowLoop:
        inc     ESI
        dec     EDI
        loop    CountRowLoop
        mov   ns[EBX*2], DX
        ret
        
AddNumber:
        add     DX,     matrix[ESI*2]
        jmp     ContinueCountRowLoop      
     
InsertNumber:
        mov   ns[EBX*2], DX
        XOR     EDX,    EDX
        ;mov     iv,     EBX
        inc     BX
        XOR     EDI,    EDI
        mov     DI,     cols
        jmp     CountRowLoop   
             
CountRow endp         

OutputNegatives proc near
 Invoke StdOut,         ADDR MsgResult
        XOR     ECX,    ECX
        
        mov     CX,     rows
        XOR     ESI,    ESI
        
OutputLoop:   
        mov     EBX,     ECX 
 Invoke dwtoa,  ns[ESI*2],ADDR InOutBuffer ; transfer F to buffer 
 Invoke StdOut,         ADDR InOutBuffer    ; output the result 
 Invoke StdOut,         ADDR Space
        mov     ECX,    EBX 
        inc     ESI
        loop    OutputLoop

OutputNegatives endp 
         
ModifyMatrix proc near
        XOR     ECX,    ECX
        XOR     ESI,    ESI                 ; clear EDX
        XOR     EDI,    EDI                 ; clear EDI   
                  
        mov     CX,     sizeofmatrix                  ; clear EDX
        mov     DI,     cols
        
        XOR     EBX,    EBX
        XOR     EDX,    EDX
        
        mov     DX,     ns[EBX*2]
        mov matrix[ESI*2], DX
        inc     BX
        
CountRowLoop:   
        cmp     EDI,    0
        jle     InsertNumber
        inc     ESI
        dec     EDI
        loop    CountRowLoop
        ret   
     
InsertNumber:
        mov     DX,     ns[EBX*2]
        mov matrix[ESI*2], DX
        XOR     EDX,    EDX
        inc     BX
        XOR     EDI,    EDI
        mov     DI,     cols
        jmp     CountRowLoop   
             
ModifyMatrix endp                  
         
         
         
Start:
        XOR     EAX,    EAX
        XOR     EBX,    EBX
        XOR     EDX,    EDX
        XOR     ECX,    ECX
        mov     AX,     0
 
        XOR     ESI,    ESI
        mov     CX,     sizeofmatrix
        mov     BX,     CX
 Invoke StdOut,         ADDR MsgInput
        mov     CX,     BX        
InputMatrix:   
        mov     BX,     CX
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer
 Invoke StripLF,        ADDR InOutBuffer
 Invoke atol,           ADDR InOutBuffer
 
        mov     CX,     BX
        mov  matrix[ESI*2],    AX  
        inc     ESI
        loop    InputMatrix
        
        call    OutputMatrix
        call    CountRow
        call    OutputNegatives
        call    ModifyMatrix
        call    OutputMatrix
           


        ;mov     ns,     AX
 ;Invoke dwtoa,  ns,     ADDR InOutBuffer   ; transfer F to buffer 
 ;Invoke StdOut,         ADDR MsgResult     ; output resulting message 
 ;Invoke StdOut,         ADDR InOutBuffer   ; output the result 
        XOR     EDX,    EDX                ; clear EDX
        XOR     EAX,    EAX                ; clear EAX
        XOR     EBX,    EBX                ; clear EBX  
 Invoke StdOut,         ADDR MsgExit
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer	
 Invoke ExitProcess,    0
        End    Start

