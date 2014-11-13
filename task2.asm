.model tiny

org 100h

.DATA
fl dw ?
n dw ? ; размер массива
array dw 255 dup(?); массив
myes DB 'yes','$'
mno DB 'no','$'
mInpSize DB  '¬ведите размер массива:' , '$'
mInpArray DB '¬ведите элементы через Enter: ','$'
crlf db 0dh,0ah,'$' ; перевод строки 13,10 символы

.CODE  
; ввод размерности массива в регистр AX
    mov ah,9 
    lea dx,mInpSize
    int 21h 
    call ReadInteger
    mov n,ax
    call newline
    
; ввод массива через Enter
    mov cx, n	; количество повторений
    mov ah,9
    lea dx,mInpArray
    int 21h 
    mov bx,0 ; индекс в массиве
inputarray:
	call ReadInteger	
	mov array[bx],ax
	add bx,2 
	call newline
loop inputarray
lea bp, array ; адрес массива
push bp ;массив в  стек
mov bp, n
push bp; size array in stack
call main

;----------------------------------------------------------------
newline proc; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h
    ret
newline endp
;----------------------------------------------------------------
main proc 
PUSH BP	    ; сохран€ем bp
MOV BP, SP ; адрес вершины стека
push bx
push di
push ax
push si
push cx
	mov di,[bp+4]   ; size array	
	mov bx,[bp+6]   ; array	address
	mov ax,0	; index last positive
	mov si,[bp+4]	; index first negative
	add si,2 	; index first negative out of array size
	mov cx,0	; flag is first negative          
	action:
		cmp [bx],0
		jle negative
		jmp positive
	negative:
		cmp cx,0
		je firstneg
		jmp next
	firstneg:
		mov cx,1; set flag =1
		mov si,bx
		jmp next	
	positive:
		mov ax,bx
		jmp next	
	next:	
		add bx,2
		dec di	
		jnz action
		jz endwork	
	endwork:	
		cmp ax,si
		jle writeyes	
		lea dx,mno
		jmp print	
	writeyes:	
		lea dx,myes	
		jmp print
		
	print:  mov  ah,9       
	        int  21h              
	        mov  ah,4ch                 
	        int  21h
	ret
pop cx
pop si
pop ax
pop di
pop bx
pop bp
main endp
;----------------------------------------------------------------
ReadInteger proc  ; до 65535
    push    cx      ; сохранение регистров
    push    dx
    push    bx   
    mov     fl,0    ; флаг отрицательного числа(0 - полож., 1 -отриц.)
    mov     cx, 0  
    mov     bx, 10 ; умножение на bx
    call    ReadChar  ; ввод символа
    cmp     al,'-'   ; если минус - установить флаг
    je      minus
    jmp     go
minus:
    mov     fl,1  
read: 
    call    ReadChar   ; ввод очередного символа
go: cmp     al, 13     ; нажато Enter ?
    je      readEnd    ; да- окончить ввод число результат в ax    
    sub     al, '0'    ;вычесть из кода симовла код символа '0' char -> int
    mov     ah, 0      
    xchg    cx, ax  ; сохранили ax в cx
    mul     bx      ;ax= al*bx или dx:ax=ax*bx умножение чисел без знака
    add     ax, cx  ; то, что получили, сложили с тем, что сохранили
    xchg    ax, cx  ; число в ax записали
    jmp     read  
readEnd:  
    xchg    ax, cx  ; число в ax записали
    cmp     fl,1
    je      setMinus
    jmp     popStack
setMinus:
    neg     ax ; изменение знака
popStack:    
    pop     bx 
    pop     dx 
    pop     cx     
    ret  
ReadInteger endp  
;----------------------------------------------------------------
readChar proc
	mov ah,1
	int 21h
	ret
readChar endp	 
;----------------------------------------------------------------
end start