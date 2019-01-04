assume cs:codesg
codesg segment
	s:	mov ax,bx
		mov si,offset s
		mov di,offset s0
		mov ax,cs:[0]
		mov cs:[di],ax
	s0:	nop
		nop
		mov ax,4c00H
		int 21H
codesg ends
end s