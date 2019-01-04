;除法指令
;计算第一个数据除以第二个数据，商存放在第三个数据里面
assume cs:codesg,ds:datasg
datasg segment
	dd 100001	;32bit
	dw 100		;16bit
	dw 0		;16bit
datasg ends
codesg segment
start:
	mov ax,datasg
	mov ds,ax
	mov bx,0
	mov ax,[bx]
	mov dx,[bx+2]
	div word ptr [bx+4]
	mov word ptr [bx+6],ax

	mov ax,4c00H
	int 21H
codesg ends
end start
