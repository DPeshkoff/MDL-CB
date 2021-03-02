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
        A       SDWORD  -30 
        B       SDWORD  21  
        ;A       DWORD   -30 
        ;B       DWORD  21   
        val1 	BYTE 	255
	    chart 	WORD	256
	    lue3 	SWORD 	-128
	    alu 	BYTE 	?
	    v5 		BYTE 	10h
	    	    BYTE 	100101B
	    beta 	BYTE 	23,23h,0ch
	    sdk 	BYTE	"Hello",0
	    min 	SWORD 	-32767
	    ar 		DWORD 	12345678h
	    valar   BYTE 	5 DUP (1, 2, 8)
	    
	    
        X1      SWORD   25
        X2      SDWORD  -35
        X3      DB      'Dmitriy Peshkov',0
        X4      DB      'Дмитрий Пешков',0
        
        Y1      SWORD   37
        Y2      WORD    25h
        Y3      SWORD   -56064
        Y4      SWORD   2500h
        
        F1      WORD    65535
        F2      DWORD   65535
        
<<<<<<< HEAD
=======
        te      BYTE    1
>>>>>>> 03683ee2d40520299cae92c0e8c17cd8ba99df8c

         .DATA?
inbuf   DB      100     DUP (?)
        X       SDWORD  ?
        ;X       DWORD  ?

         .CODE
Start:
        mov     EAX,     A   ; move A to EAX
        add     EAX,    5   ; EAX := EAX + 5
        sub     EAX,    B   ; EAX := EAX - B
        mov     X,      EAX ; Save to X
        add 	F1,     1
<<<<<<< HEAD
        add 	F2,     1
=======
 	    add 	F2,     1
>>>>>>> 03683ee2d40520299cae92c0e8c17cd8ba99df8c
        XOR     EAX,    EAX ; Clear EAX
Invoke  dwtoa,  X,      ADDR inbuf    ; Transfer X to buffer 
Invoke  StdOut,         ADDR inbuf    ; Output the result 
Invoke  StdOut,         ADDR MsgExit  ; Output the exit message 
Invoke  StdIn,          ADDR inbuf,LengthOf inbuf		
	
Invoke  ExitProcess,    0
        End     Start

