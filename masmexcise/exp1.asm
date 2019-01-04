assume cs:abc
abc segment
    start:
	; mov ax,2
        ; add ax,ax
        ; add ax,ax
        ; mov ax,4c00h
        ; int 21h
	
	;wrong comand type??
	;must use the DS?
	;mov [0],cx
	;mov [0],ax
	;add [0],ax
	;sub [0],ax
	
	; mov ax,1000H
	; mov ds,ax
	; mov ax,[0]
	
	; mov ax,8
	; mov ax,bx
	; mov ax,[0]
	; mov ds,ax
	; mov ax,ds
	
	; add ax,8
	; add ax,bx
	; add ax,[0]
	; sub ax,9
	; sub ax,bx
	; sub ax,[0]
	
	;ex3.1
	; mov ax,0
	; mov ds,ax
	; mov ax,ds:[0000]
	; mov bx,ds:[0001H]
	; mov ax,bx
	; mov ax,ds:[0000]
	; mov bx,ds:[0002]
	; add ax,bx
	; add ax,ds:[0004]
	; mov ax,0
	; mov al,ds:[0002]
	; mov bx,0
	; mov bl,ds:[000CH]
	; add al,bl
	
	;how to write the jmp??
	; mov ax,6622H
	; jmp CS:[0000]
	; mov bx,ax
	
	; mov ax,0123h
	; push ax
	; mov bx,2266h
	; push bx
	; mov cx,1122h
	; push cx
	; pop ax
	; pop bx
	; pop cx
	
	;EX3.8
	; MOV AX,1000H
	; MOV SS,AX
	; MOV SP,0010H
	; MOV AX,001AH
	; MOV BX,001BH
	; PUSH AX
	; PUSH BX
	; SUB AX,AX
	; SUB BX,BX
	; POP BX
	; POP AX
	
	;EX3.9
	; MOV AX,1000H
	; MOV SS,AX
	; MOV SP,0010H
	; MOV AX,002AH
	; MOV BX,002BH
	; PUSH AX
	; PUSH BX
	; POP AX
	; POP BX
	
	;EX3.10
	; MOV AX,1000H
	; MOV DS,AX
	; MOV AX,2266H
	; MOV DS:[0000H],AX
	
	;?? CANNOT WORK
	; MOV AX,1000H
	; MOV SS,AX
	; MOV SP,0002H	
	; MOV AX,2266H
	; PUSH AX
	
	;EX3.2(1)
	; MOV AX,1000H
	; MOV DS,AX
	; MOV AX,1FF0H
	; MOV SS,AX
	; MOV SP,0110H
	; PUSH DS:[0]
	; PUSH DS:[2]
	; PUSH DS:[4]
	; PUSH DS:[6]
	; PUSH DS:[8]
	; PUSH DS:[000AH]
	; PUSH DS:[000CH]
	; PUSH DS:[000EH]
	
	;EX3.2(2)
	; MOV AX,2000H
	; MOV DS,AX
	; MOV AX,0FFFH
	; MOV SS,AX
	; MOV SP,0010H
	; POP DS:[000EH]
	; POP DS:[000CH]
	; POP DS:[000AH]
	; POP DS:[0008H]
	; POP DS:[0006H]
	; POP DS:[0004H]
	; POP DS:[0002H]
	; POP DS:[0000H]
	
	;实验2
	MOV AX,65535
	MOV DS,AX
	MOV AX,2200H
	MOV SS,AX
	MOV SP,0100H
	MOV AX,DS:[0]
	ADD AX,DS:[2]
	MOV BX,DS:[4]
	ADD BX,DS:[6]
	PUSH AX
	PUSH BX
	POP AX
	POP BX
	PUSH DS:[4]
	PUSH DS:[6]
	
	
abc ends
end start
