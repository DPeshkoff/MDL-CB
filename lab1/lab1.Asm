; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    0AH,"Press Enter to Exit",0AH,0DH,0

         .DATA
        A       SDWORD   -30 ; E2 FF FF FF
        B       SDWORD  21  ; 15 00 00 00

         .DATA?
inbuf   DB      100     DUP (?)
        X       SDWORD  ?


         .CODE
Start:
        mov     EAX,    A   ; move A to EAX
        add     EAX,    5   ; EAX := EAX + 5
        sub     EAX,    B   ; EAX := EAX - B
        mov     X,      EAX ; Save to X
        XOR     EAX,    EAX ; Clear EAX
Invoke  dwtoa,  X,      ADDR inbuf    ; Transfer X to buffer 
Invoke  StdOut,         ADDR inbuf    ; Output the result 
Invoke  StdOut,         ADDR MsgExit  ; Output the exit message 
Invoke  StdIn,          ADDR inbuf,LengthOf inbuf		
	
Invoke  ExitProcess,    0
        End     Start

