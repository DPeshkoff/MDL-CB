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

        
 InOutBuffer    DB      200 DUP (?)
 
         .STACK 4096
        

         .CODE
OutputMatrix proc near

 Invoke StdOut,         ADDR MsgMatrix
        XOR     ECX,    ECX
        XOR     ESI,    ESI                 ; clear required registers
        XOR     EDI,    EDI                 
                     
        mov     CX,     sizeofmatrix        ; loop counter
        mov     DI,     cols                ; newline counter
        
OutputMatrixLoop:  
        push    ECX
        cmp     EDI,    0 
        jle     OutputNewLine
        ContinueOutputMatrixLoop: 
 Invoke dwtoa,  matrix[ESI*2], ADDR InOutBuffer ; transfer F to buffer 
 Invoke StdOut,         ADDR InOutBuffer    ; output the result 
 Invoke StdOut,         ADDR Space
        pop     ECX
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
        XOR     ESI,    ESI                 
        XOR     EBX,    EBX                 ; clear required registers
        XOR     EDX,    EDX        
        XOR     EDI,    EDI  
                                   
        mov     CX,     sizeofmatrix        ; loop counter
        mov     DI,     cols                ; newline counter
        
        
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
        inc     BX
        XOR     EDI,    EDI
        mov     DI,     cols
        jmp     CountRowLoop   
             
CountRow endp         

OutputNegatives proc near

 Invoke StdOut,         ADDR MsgResult
 
        XOR     ECX,    ECX
        XOR     ESI,    ESI
                
        mov     CX,     rows

        
OutputLoop:   
        mov     EBX,     ECX 
 Invoke dwtoa, ns[ESI*2],ADDR InOutBuffer 
 Invoke StdOut,         ADDR InOutBuffer   
 Invoke StdOut,         ADDR Space
        mov     ECX,    EBX 
        inc     ESI
        loop    OutputLoop

OutputNegatives endp 
         
ModifyMatrix proc near

        XOR     ECX,    ECX
        XOR     ESI,    ESI                 ; clear required registers
        XOR     EDI,    EDI 
        XOR     EBX,    EBX
        XOR     EDX,    EDX                  
                  
        mov     CX,     sizeofmatrix        ; loop counter
        mov     DI,     cols                ; newline counter
        
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
        XOR     ESI,    ESI
        
        mov     CX,     sizeofmatrix
        push    CX
        
 Invoke StdOut,         ADDR MsgInput
        pop     CX     
           
InputMatrix:   
        push    CX
 Invoke StdIn,          ADDR InOutBuffer, LengthOf InOutBuffer
 Invoke atol,           ADDR InOutBuffer
 
        pop     CX
        mov  matrix[ESI*2],    AX  
        inc     ESI
        loop    InputMatrix
        
        call    OutputMatrix
        call    CountRow
        call    OutputNegatives
        call    ModifyMatrix
        call    OutputMatrix
           

        XOR     EAX,    EAX 
        XOR     EBX,    EBX  
        XOR     ECX,    ECX
        XOR     EDX,    EDX 
        XOR     ESI,    ESI                     
                
 Invoke StdOut,         ADDR MsgExit
 Invoke StdIn,          ADDR InOutBuffer,LengthOf InOutBuffer	
 Invoke ExitProcess,    0
 
        End    Start

