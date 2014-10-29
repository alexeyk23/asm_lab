.model tiny

org 100h

.DATA

n dw 6; razmer massiva
array dw 1,1,2,3,4,-5; massiv
myes DB 'yes','$'
mno DB 'no','$'

.CODE  

start:  mov bx,0;index 
	mov di,n; size array
	mov ax,0; index last positive
	mov si,0ffh; index first negative
	mov cx,0; flag is first negative          
action:
	cmp array[bx],0
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
	
print:  mov  ah,9             ; напечатать то, адрес чего в dx
        int  21h              
        mov  ah,4ch                 
        int  21h
ret

end start