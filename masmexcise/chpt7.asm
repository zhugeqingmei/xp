;把第一串字符串改成大写字母，第二串改成小写字母
;使用相对寻址的方式对字符串进行操作。
assume cs:code,ds:data,ss:stack
data segment
	db 'BaSiC'
	db 'iNfOrMaTiOn'
data ends

stack segment
stack ends

code segment
start:
	;------------------------------
	;例题里面是对长度相同的字符串进行操作。这里是不同的。
	
	
	;------------------------------
	; mov ax,data
	; mov ds,ax
	; mov cx,5
	; mov bx,0
	; s:mov al,[bx]
	; and al,11011111B
	; mov [bx],al
	; inc bx
	; loop s
	
	; mov bx,5
	; mov cx,11
	; s0:mov al,[bx]
	; or al,00100000B
	; mov [bx],al
	; inc bx
	; loop s0
	;------------------------------------
	; mov al,01100011B
	; or al,11111111B
	; and al,11110000B
	mov ax,4c00H
	int 21H
code ends
end start
