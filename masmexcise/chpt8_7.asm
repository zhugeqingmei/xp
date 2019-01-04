;除法指令
;如果我们计算100001/100. 100001:186A1H.
assume cs:codesg
codesg segment
start:
	mov dx,1
	mov ax,86A1H
	mov bx,100
	div bx

	mov ax,4c00H
	int 21H
codesg ends
end start
