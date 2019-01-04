;初始化这个起始状态
;修改排名为38，收入为70，产品名称为VAX
assume cs:codesg,ds:datasg

datasg segment
	db 'DEC'
	db 'Ken Oslen'
	dw 137
	dw 40
	db 'PDP'
datasg ends

codesg segment

start:
	mov ax,datasg
	mov ds,ax
	mov bx,00
	mov word ptr [bx + 12],38
	
	add word ptr [bx + 14],70
	
	mov si,0
	mov byte ptr [bx + 16 + si],'V'
	inc si
	mov byte ptr [bx + 16 + si],'A'
	inc si
	mov byte ptr [bx + 16 + si],'X'
	
	mov ax,4c00H
	int 21H

codesg ends
end start
