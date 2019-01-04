;把datasg段中的每个单词改成大写字母。
;使用循环的时候，把变量存放在我们自己定义的内存空间里面
;bx进行行偏移，si进行列偏移。
assume cs:codesg,ds:datasg

datasg segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
	dw 0
datasg ends

codesg segment
start:	mov ax,datasg
		mov ds,ax
		mov bx,0
		
		mov cx,4
	s0:	mov ds:[40H],cx
		mov si,0
		mov cx,3
		
	s:	mov al,[bx+si]
		and al,11011111B
		mov [si + bx],al
		inc si
		loop s
		
		add bx,16
		mov cx,ds:[40H]
		loop s0
		
		mov ax,4c00H
		int 21H
codesg ends
end start