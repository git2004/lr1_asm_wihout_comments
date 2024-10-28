.model small
.186
.stack 100h
.data
A db 1 dup(?)
B db 1 dup(?)
C db 1 dup(?)
D dw ?
message db "A = +000 B = +000 C = +000", 0Ah, 0Dh
filename db "perepoln.txt", 0 
handle	dw ?
.code
start:
	mov ax, @data
	mov ds, ax
	mov al, A
	or al, al
	jnz program_main2 
	mov al, B
	or al, al
	jnz program_main2
	mov al, C
	or al, al
	jnz program_main2
	mov bp, 1h
	jmp checking_znam

program_main2:
	mov bp, 1000h
checking_znam:
	xor dx,dx 
	mov al, C
	imul al 
	shl ax, 2 
	mov bx, ax 
	shl ax, 1 
	add ax, bx 
	adc dx , 0h
	mov bl, A  
	xchg ax,bx 
	cbw  
	add ax, bx 
	jz ZZ 
	or dh, dl
	jne perepoln 
	cmp bp, 1000h         
    	jne skip_chis         
    	jmp chis      

skip_chis:
	jmp next_loop    

chis:
	mov si, ax
	mov al, A
	imul al
	mov bl, C
	xchg ax,bx
	cbw 
	sub bx,ax
	xor ax, ax
	xchg bx, di

	mov al, B
	cbw
	mov cx, ax
	shl ax, 1
	mov bx, ax
	shl bx, 2
	add ax, bx
	add ax, cx
	shl bx, 2
	shl cx, 2
	add bx, cx
	add bx, ax
	imul bx
	add ax, di
	mov bx, si
	idiv bx
	mov [D], ax
ZZ:
	cmp bp, 1000h
	jne our_circle
	jmp Z

perepoln:
	cmp bp, 1h
	je creating 
	cmp bp, 1000h
	je creating
	jmp next_loop

creating:
	dec bp
	call create_file
	
next_loop:
	call a_output
	call write_file
	cmp bp, 0FFFh 
	je Z_end
				
our_circle: 	

next_a:
	cmp [A], 7Fh
	je next_b
	inc [A]
	jmp next_circle      

next_b:
	mov [A], 80h           
	cmp [B], 2h
	je next_c
	inc [B]
	jmp next_circle        

next_c:
	mov [B], 0h
	cmp [C], 7Fh
	je Z_end
	inc [C]
	jmp next_circle       

next_circle:	
	jmp checking_znam
Z_end:
	call close_file
Z:
	mov ah, 4Ch
	int 21h

create_file:
	mov ah, 3Ch
	mov dx, offset filename
	mov cx, 0h
	int 21h
	mov handle, ax
	ret

a_output:
	mov 	al, A
	or	al, al
	jge 	a_output_pol
	neg 	al
	mov 	[message + 4], '-'
a_output_pol:
	aam
        or      al, 30h
        mov     [message + 7], al
        mov     al, ah
        aam
        or      al, 30h
        mov     [message + 6], al
        or      ah, 30h
        mov     [message + 5], ah


	mov 	al, B
	cmp	ax, 7Fh
	jge b_output_pol
	neg al
	mov 	[message + 13], '-'
b_output_pol:
	aam
        or      al, 30h
       	mov 	[message + 16], al
        mov     al, ah
        aam
        or      al, 30h
        mov 	[message + 15], al
        or      ah, 30h
        mov 	[message + 14], ah


	mov 	al, C
	cmp	ax, 7Fh
	jge c_output_pol
	neg al
	mov 	[message + 22], '-'

c_output_pol:
	aam
        or      al, 30h
        mov 	[message + 25], al
        mov     al, ah
        aam
        or      al, 30h
        mov 	[message + 24], al
        or      ah, 30h
        mov 	[message + 23], ah
ret

write_file:
	mov bx, handle
	mov ah, 40h
	mov cx, 28       
	mov dx, offset message
	int 21h
ret

close_file:
	mov bx, handle
	mov ah, 3Eh
	int 21h
ret

end start
