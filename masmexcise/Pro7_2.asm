;使用寄存器SI和DI把字符串复制到后面的内存空间里面
assume cs:codesg,ds:datasg
datasg segment
	db 'welcome to masm!'
	db '................'
datasg ends

codesg segment
start:
	mov si,datasg
	mov ds,si
	mov di,0
	mov cx,8
	s:
	mov si,[di] 
	mov [di+16],si
	add di,2
	loop s
	mov ax,4c00H
	int 21H
codesg ends
end start