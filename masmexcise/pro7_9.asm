;把datasg段中的每个单词的前四个字母改成大写字母。
assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
	db '1. file         '
	db '2. edit         '
	db '3. search       '
	db '4. view         '
	db '5. options      '
	db '6. help         '
datasg ends

codesg segment
start:	mov ax,datasg
		mov ds,ax
		
		mov ax,stacksg
		mov ss,ax
		mov sp,8
		
		mov cx,6
		mov bx,3
	s:	push cx
		mov cx,4
		mov si,0
	s0:	mov al,[bx+si]
		and al,11011111B
		mov [bx+si],al
		inc si
		loop s0
		pop cx
		add bx,16
		loop s
			
		mov ax,4c00H
		int 21H
codesg ends
end start