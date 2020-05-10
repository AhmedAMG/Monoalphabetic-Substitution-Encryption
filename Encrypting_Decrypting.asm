org 100h

;Project 6: Monoalphabetic Substitution Encryption 
;Done By: Ahmed Mohammed Gamal Al-Din Ali
;Section: 1 ,Seat_number: 36 


MAIN    PROC
        call userprompt
        call inputtext
    
load:   mov Dtemp, -1       ;Dtemp = -1 to have it 0 after the 1st increment
        inc Stemp           ;Stemp++ to loop over the input string characters
        mov bx,ds           ;BX will be used in Based-index addressing mode
        LEA SI, input       ;Source index = offset of the input string
        LEA DI, alphabets   ;Destination index = offset of the alphabets
        mov ch, 0           ;ch = 0 
        mov cl, Stemp       ;cl = Stemp
        
;loop untill next character in input text exploiting CX = 00 Stemp
A1:     inc si              ;pointing to next character
        dec cx              ;CX--
        cmp cx, 0           ;check whether CX reached 0 or not
        jne A1              ;chack the ZERO FLAG to know if CX reached 0
                            ;if not then iterate again
                            
        lodsb               ;mov al, [SI] (BX should be like DS)
        dec DI              ;DI-- because it will incremented in Look

Look:   inc Dtemp           ;Dtemp will start from 0 which is 'a' till the 
                            ;required character reached in alphabets (Dtemp 
                            ;is just an indicator for the offset(index) of
                            ;the required character in alphabets
        inc DI              ;to point to next character in alphabets
        cmp [DI],al         ;check if the input character is equal to
                            ;the currect character DI pointing to
        jne Look            ;return to Look if the 2 characters don't match
        
        
        lea DI, cipher      ;DI = offset of cipher string
        mov cl, Dtemp       ;cl = Dtemp (the index of matched substituent)
        add DI, cx          ;point to that specific substituent in cipher
        mov al,[DI]         ;al = that character in cihper
        
        lea di, input       ;DI = offset of input string
        mov cl, Stemp       ;set loop counter cl = Stemp where Stemp is the
                            ;current character working on it

A2:     inc di              ;pointing to the next character of input
        dec cx              ;CX--
        cmp cx, 0           ;check whether CX reached 0 or not
        jne A2              ;chack the ZERO FLAG to know if CX reached 0
                            ;if not then iterate again
        stosb               ;mov [DI], al (Note: ES = DS also)
        
        
        lea di, input       ;DI = offset of input string
        inc di              ;pointing to the length of the input string
        mov cl, Stemp       ;cl = Stemp
        dec cl              ;decrementing 2 times because in the first
        dec cl              ;iteration Stemp is equal to 2
        cmp cl, [DI]        ;checking if (cl-2 == length of the input text)
        jne load            ;move to the next iteration with next character
        
        
        call usercipherinit 
        
        mov cl, input[1]    ;cl = length of input string = length of
                            ;encrypted text
        mov ch, 0           ;ch = 0
        lea di, input       ;DI = offset of input string
        inc di              ;incrementing 2 times to point to the beginning
        inc di              ;of the string

len:    inc di              ;point to next character
        cmp cx, 0           ;check if cx is equal to 0
        dec cx              ;CX--
        jne len             ;loop until DI exceeds the end of string by 1
        
        mov [di], "$"       ;put the termination character after the
                            ;encrypted text in order to read it   
        call usercipher
        
        mov Stemp, 1
        call reverse
        
        ret
        
MAIN ENDP


REVERSE PROC
    
load1:  mov Dtemp, -1       ;Dtemp = -1 to have it 0 after the 1st increment
        inc Stemp           ;Stemp++ to loop over the input string characters
        mov bx,ds           ;BX will be used in Based-index addressing mode
        LEA SI, input       ;Source index = offset of the input string
        LEA DI, cipher      ;Destination index = offset of the alphabets
        mov ch, 0           ;ch = 0 
        mov cl, Stemp       ;cl = Stemp
        
;loop untill next character in input text exploiting CX = 00 Stemp
A11:    inc si              ;pointing to next character
        dec cx              ;CX--
        cmp cx, 0           ;check whether CX reached 0 or not
        jne A11              ;chack the ZERO FLAG to know if CX reached 0
                            ;if not then iterate again
                            
        lodsb               ;mov al, [SI] (BX should be like DS)
        dec DI              ;DI-- because it will incremented in Look

Look1:  inc Dtemp           ;Dtemp will start from 0 which is 'a' till the 
                            ;required character reached in alphabets (Dtemp 
                            ;is just an indicator for the offset(index) of
                            ;the required character in alphabets
        inc DI              ;to point to next character in alphabets
        cmp [DI],al         ;check if the input character is equal to
                            ;the currect character DI pointing to
        jne Look1            ;return to Look if the 2 characters don't match
        
        
        lea DI, alphabets   ;DI = offset of cipher string
        mov cl, Dtemp       ;cl = Dtemp (the index of matched substituent)
        add DI, cx          ;point to that specific substituent in cipher
        mov al,[DI]         ;al = that character in cihper
        
        lea di, input       ;DI = offset of input string
        mov cl, Stemp       ;set loop counter cl = Stemp where Stemp is the
                            ;current character working on it

A21:    inc di              ;pointing to the next character of input
        dec cx              ;CX--
        cmp cx, 0           ;check whether CX reached 0 or not
        jne A21              ;chack the ZERO FLAG to know if CX reached 0
                            ;if not then iterate again
        stosb               ;mov [DI], al (Note: ES = DS also)
        
        
        lea di, input       ;DI = offset of input string
        inc di              ;pointing to the length of the input string
        mov cl, Stemp       ;cl = Stemp
        dec cl              ;decrementing 2 times because in the first
        dec cl              ;iteration Stemp is equal to 2
        cmp cl, [DI]        ;checking if (cl-2 == length of the input text)
        jne load1            ;move to the next iteration with next character
        
        
        call usercipherinit2 
        
        mov cl, input[1]    ;cl = length of input string = length of
                            ;encrypted text
        mov ch, 0           ;ch = 0
        lea di, input       ;DI = offset of input string
        inc di              ;incrementing 2 times to point to the beginning
        inc di              ;of the string

len1:   inc di              ;point to next character
        cmp cx, 0           ;check if cx is equal to 0
        dec cx              ;CX--
        jne len1             ;loop until DI exceeds the end of string by 1
        
        mov [di], "$"       ;put the termination character after the
                            ;encrypted text in order to read it   
        call usercipher
        
        
        ret
        
REVERSE ENDP




;print user prompt to enter the string 
userprompt proc
    mov     ah,9         ; display string fcn 
    lea     dx,msg1      ; prompting the user to enter the text 
    int     21h          ; display it 
    ret
userprompt ENDP


;input text from the user (get the string from the user)
inputtext proc
    mov     dx,offset input     ; input is the offset buffer 
    mov     ah,0ah              ; read string function 
    int     21h                 ; interupt (get the string from the user)
    ret
inputtext ENDP    

;change the cursor to the next line
;and print notification that the cipher text will be printed 
usercipherinit proc
    mov     dl,0         ; colomn number     
    mov     dh,1         ; row number
    mov     ah,2         ; change cursor function                  
    mov     bh,0                  
    int     10h

    mov     ah,9         ; display string fcn 
    lea     dx,msg2      ; get notification message 
    int     21h          ; display it
    ret
usercipherinit ENDP


;change the cursor to the next line
;and print notification that the cipher text will be printed 
usercipherinit2 proc
    mov     dl,0         ; colomn number     
    mov     dh,2         ; row number
    mov     ah,2         ; change cursor function                  
    mov     bh,0                  
    int     10h

    mov     ah,9         ; display string fcn 
    lea     dx,msg3      ; get notification message 
    int     21h          ; display it
    ret
usercipherinit2 ENDP


;print encrypted text 
usercipher proc
    mov     ah,9        ; display string fcn 
    lea     dx,input    ; get the encrypted message 
    inc     dx          ; double incrementing di to point at the right byte 
    inc     dx          ; after 2 bytes (after 100 and the size of the text)
    int     21h         ; display it
    
    ret
usercipher ENDP



;Plain text, cipher text, messages and variables definitions
alphabets   db "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
cipher      db "qwertyuiopasdfghjklzxcvbnm QWERTYUIOPASDFGHJKLZXCVBNM"
msg1        db "Enter the message you want to encrypt: ",'$'
msg2        db "The encrypted message is: ",'$'
msg3        db "The decrypted message is: ",'$'
input       db 100,?, 100 dup(' ')
Stemp       db 1                    ; To loop over the input text
Dtemp       db -1                   ; To loop over alphabets

END

