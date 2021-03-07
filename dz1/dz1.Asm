; dz1 console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
    VowelStr    DB    "AEIOUaeiou",0
    MsgExit     DB    0AH,"Press Enter to Exit...",0AH,0DH,0
    MsgInput    DB    "Input a string:",0AH,0DH,0
    MsgF        DB    "F:",0AH,0DH,0
    Space       DB    " ",0

         .DATA
         
    FirstL      DB     0
    LastL       DB     0 
    WordsC      DWORD  0        
         

         .DATA?
    LenOfStr    DWORD   (?)

    StrBuf      DB     100 DUP (?)
    InOutBuf    DB     100 DUP (?)

         .STACK 4096

         .CODE       
; CheckLetter :: if current letter is a vowel, returns BL==1; else returns BL==0         
CheckLetter proc near

        pop     EBX                         ; get ret address
        pop     EAX                         ; get [EDI-1]
        push    EBX                         ; push back ret address
        push    EDI

        mov     ECX,    10
        lea     EDI,    VowelStr       
                         
        repne   scasb                        ; searching for AL in VowelStr
        je      CLEqual 
        XOR     BL,    BL
        mov     BL,     0
        pop     EDI
        ret
       
CLEqual:
        XOR     BL,    BL
        mov     BL,     1
        pop     EDI
        ret

CheckLetter endp 


        
         
Start:
        XOR     ECX,    ECX  
        
Invoke  StdOut, ADDR MsgInput
Invoke  StdIn,  ADDR StrBuf, LengthOf StrBuf
Invoke  StripLF,ADDR StrBuf                 ; replace #13#10 with 0

CalculateLen:
        lea     EDI,    StrBuf 
        mov     ECX,    LengthOf StrBuf  
        mov     AL,     0 
        repne   scasb
        
        mov     EAX,     LengthOf StrBuf
        sub     EAX,     ECX 
        mov     ECX,     EAX 
        sub     ECX,     1
        mov   LenOfStr, ECX
         
Main:
        XOR     EAX,    EAX
        XOR     EBX,    EBX        
       
        cld                                 ; clear direction flag
    
        lea     EDI,    StrBuf
        
        ; Check first letter - returns in BL
        push    ECX
        mov     ECX,    [EDI] 
        push    ECX 
        call CheckLetter
        mov     FirstL, BL
        pop     ECX 
        
        inc     EDI                         ; inc EDI to skip first letter in loop
        
        mov     ECX,    LenOfStr
        mov     EDX,    1                   ; word index 
        
LoopStr:
        cmp     ECX,    0
        je      Fin

LoopWord:
        cmp     ECX,    0                   ; redundant code for safety reasons
        je      Fin
        cmp     EDX,    0
        je      CheckFirst                  ; check first letter of a word or pass
        jmp     CLW
        
CheckFirst:
        push    ECX
        mov     ECX,    [EDI] 
        push    ECX                     ; sic(!)
        call CheckLetter
        mov     FirstL, BL
        pop     ECX  
        jmp     CLW              
        
        
CLW:
        mov     AL,     ' '                 ; CheckLetter messes with EAX register
        scasb
        je      EndWord
        inc     EDX
        dec     ECX
        jmp     LoopWord    
        
EndWord:
        push    ECX
        mov     ECX,    [EDI-2] 
        push    ECX                     ; sic(!)
        call CheckLetter
        cmp     EDX, 0
        je      CTF
        
        mov     LastL, BL
        jmp     CCon  
               
            
CTF:
        mov     FirstL, BL
        jmp     CCon
                 
CCon:
        inc     WordsC
        mov     BL,     FirstL
        mov     BH,     LastL
        cmp     BL, BH
        je      WordFound
        
CCCon:  
        pop     ECX 
        
        mov     EDX,    0
        mov     FirstL, 0
        mov     LastL,  0
        jmp     LoopStr
        
        
WordFound:
Invoke  dwtoa,  WordsC  ,ADDR InOutBuf
Invoke  StdOut, ADDR InOutBuf                   ; TODO: copy and print word  
Invoke  StdOut, ADDR Space
        jmp     CCCon     
        
 
Fin:
Invoke  StdOut, ADDR MsgExit
Invoke  StdIn,  ADDR InOutBuf,LengthOf InOutBuf		
	
         Invoke ExitProcess,0
         End    Start

