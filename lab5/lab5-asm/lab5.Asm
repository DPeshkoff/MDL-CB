; lr5
         .586
         .MODEL  flat
      
         .DATA
    LenOfStr   SDWORD   0  
    ResStr     DB      255 DUP (0)
    TestStr   DB     255 DUP (0)

         .STACK 4096

         .CODE    
  public _STRREP@4         
externdef _StdOutF:near


         
_STRREP@4 proc

        XOR     EAX,    EAX
        XOR     EBX,    EBX  
        
        push	EBP
        mov	    EBP,    ESP
        
        mov     EAX,    [EBP+4]
        
        mov     ECX,    255
        mov     ESI,    EAX
        lea     EDI,    TestStr
        rep     movsb
        
        lea     EDI,    TestStr 
        mov     ECX,    LengthOf TestStr  
        mov     AL,     0 
        repne   scasb
        
        mov     EAX,     LengthOf TestStr
        sub     EAX,     ECX 
        mov     ECX,     EAX 
        sub     ECX,     1
        mov   LenOfStr, ECX
        
              
        std                                 ; set direction flag
        
        mov     ECX,    LenOfStr
        lea     EDI,    TestStr
        lea     ESI,    TestStr
        
        add     EDI,    ECX 
LoopStr:        
        mov     AL,     '#'      
                         
        repne   scasb                      
        je      Equals
        
        mov     BL,     1
        jmp     Continue
        
Equals: mov     BL,     0        
        
Continue:        mov     AL,     ' '
        inc     EDI
       
        
LoopRemove:
        
        cmp     BL,     0
        je      Remove
        jmp ContinueRemove
Remove: mov     BYTE PTR [EDI], AL
ContinueRemove:        
        dec     EDI
        
        cmp     BYTE PTR [EDI], AL 
        jne     LoopRemove  
        
        cmp     EDI,    ESI
        jg      LoopStr
        
        
        cld
        
        lea     ESI,    ResStr
        lea     EDI,    TestStr
        
        mov     ECX,    EDI
        add     ECX,    LenOfStr
        
LoopSpace:        
        mov     AL,     ' '  
        scasb
        je      Move 
         
        xchg    ESI,    EDI
        dec     ESI
        movsb
        xchg    EDI,    ESI 
           
        jmp     LoopSpace 
        
Move:
        mov     AL,     BYTE PTR [EDI]        
        cmp     BYTE PTR [EDI-1], AL
        je      ContinueSpace
        xchg    ESI,    EDI
        dec     ESI
        movsb
        xchg    EDI,    ESI 
               
ContinueSpace: 
        cmp     EDI,    ECX
        jl      LoopSpace
        
        lea     EAX,    ResStr
        push    EAX
        call    _StdOutF
        
        pop     EBP
        ret     4
    _STRREP@4 endp
End
