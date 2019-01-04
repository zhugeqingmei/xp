;在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串welcome to masm1。
;1.在显示器0行0列显示红底高亮闪烁绿色的字符串。实际就是向B800：0000输入
;相应的字符数据就可以了。

assume cs:codesg

datadg segment
	;红底，高亮，闪烁，绿色字符，ABCDEF
	;db 41H,0CAH,42H,0CAH,43H,0CAH,44H,0CAH,45H,0CAH,46H,0CAH

	;welcome to masm!:77,65,6C,63,6F,6D,65,20,74,6F,20,6D,61,73,6D,21
	;黑底绿色字体
	db 77H,02H,65H,02H,6CH,02H,63H,02H,6FH,02H,6DH,02H,65H,02H,20H,02H
	db 74H,02H,6FH,02H,20H,02H,6DH,02H,61H,02H,73H,02H,6DH,02H,21H,02H
	;绿底红色字体
	db 77H,24H,65H,24H,6CH,24H,63H,24H,6FH,24H,6DH,24H,65H,24H,20H,24H
	db 74H,24H,6FH,24H,20H,24H,6DH,24H,61H,24H,73H,24H,6DH,24H,21H,24H
	;白底蓝色字体
	db 77H,71H,65H,71H,6CH,71H,63H,71H,6FH,71H,6DH,71H,65H,71H,20H,71H
	db 74H,71H,6FH,71H,20H,71H,6DH,71H,61H,71H,73H,71H,6DH,71H,21H,71H

datadg ends


codesg segment
start:
	;问题：无法看到效果
	; 	mov cx,10
	; s0:	
	; 	mov ax,params
	; 	mov ds,ax
	; 	mov ds:[0],cx

	; 	mov bx,0
	; 	mov cx,6

	; s1:	mov ax,datadg
	; 	mov ds,ax
	; 	mov dx,[bx]
	; 	mov ax,0B800H
	; 	mov ds,ax
	; 	mov [bx],dx
	; 	add bx,2
	; 	loop s1

	; 	mov ax,params
	; 	mov ds,ax
	; 	mov cx,ds:[0]
	; 	loop s0

	;------------------------------------------------
	;采用无限循环的方式,但是无法停止。而且也不能闪烁。
	
	; s0:	
	; 	mov bx,0
	; 	mov cx,6

	; s1:	mov ax,datadg
	; 	mov ds,ax
	; 	mov dx,[bx]
	; 	mov ax,0B800H
	; 	mov ds,ax
	; 	mov [bx],dx
	; 	add bx,2
	; 	loop s1

	; 	jmp s0

	;--------------------------------------------------
	;在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串
	;屏幕中间在那里：11，12，13行显示。一行：160字节，
	;160*10=1600字节。即，第11行开头地址是：640H.如果我们要计算中间的
	;位置，160/2-16=64字节。那么是640H+64=680H
	;第二行在原来在原来的基础上加160字节,但是，bx会增加原来的32字节，所以要减去32字节。
	;680H+160-32=700H
	;同理计算下一行的位置。700H+160-32=760H.问题：但是这里为什么还是减32？
	s0:
		mov bx,0
		mov cx,16

	s1:	mov ax,datadg
		mov ds,ax
		mov dx,[bx]
		mov ax,0B800H
		mov ds,ax
		mov [680H+bx],dx
		add bx,2
		loop s1

	
		mov cx,16

	s2:	mov ax,datadg
		mov ds,ax
		mov dx,[bx]
		mov ax,0B800H
		mov ds,ax
		mov [700H+bx],dx
		add bx,2
		loop s2

		mov cx,16

	s3:	mov ax,datadg
		mov ds,ax
		mov dx,[bx]
		mov ax,0B800H
		mov ds,ax
		mov [780H+bx],dx
		add bx,2
		loop s3

		jmp s0


	mov ax,4c00H
	int 21H


codesg ends
end start