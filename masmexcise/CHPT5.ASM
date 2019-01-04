assume cs:code
code segment
	;compute 2^12
	; mov ax,2
	; mov cx,11
; s:	add ax,ax
	; loop s
	
	
	;compute 123*236
	; mov ax,0
	; mov cx,123
; s:	add ax,236
	; loop s
	
	;5.3 compute the ffff:6 byte A,A*3->dx
	; mov ax,0ffffh
	; mov ds,ax
	; mov al,ds:[6]
	; cbw
	; mov dx,0
	; mov cx,3
; s:	add dx,ax
	; loop s
	
	;5.3 compute the ffff:6 byte A,A*123->dx
	; mov ax,0ffffh
	; mov ds,ax
	; mov al,ds:[6]
	; cbw
	; mov dx,0
	; mov cx,123
; s:	add dx,ax
	; loop s

	;5.5 compute FFFF:0-FFFF:b SUM->dx
	; mov ax,0ffffh
	; mov ds,ax
	; mov dx,0
	; mov bx,0
	; mov cx,12
; s:	mov al,[bx]
	; inc bx
	; ;cbw
	; mov ah,0
	; add dx,ax
	; loop s

	;ex5.8
	; mov cx,12
	; mov bx,0
; s:	mov ax,0ffffh
	; mov ds,ax
	; mov	dl,[bx]
	; mov ax,0020h
	; mov ds,ax
	; mov [bx],dl
	; inc bx
	; loop s

	;向内存0:200-0:23F传送数据0-63.
	; mov ax,0
	; mov ds,ax
	; mov cx,64
	; mov bx,200h
; s:	mov [bx],al
	; inc al
	; inc bx
	; loop s
	; mov ax,4c00H
	; int 21H
	
	; mov ax,20
	; mov ds,ax
	; mov cx,64
; s:	sub cx,1
	; mov [cx],cl
	; inc cx
	; loop s
	; mov ax,4c00H
	; int 21h
	
	
	;把mov ax,4c0h之前的指令复制到0：200处
	;问题：如何确定有几个字节？调试出来？
	; mov ax,cs
	; mov ds,ax
	; mov ax,0020h
	; mov es,ax
	; mov bx,0
	; mov cx,17h
; s:	mov al,[bx]
	; mov es:[bx],al
	; inc bx
	; loop s
	
	;ex6.1 compute values' sum and put it in ax
	dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
start:
	mov bx,0
	mov ax,0
	mov cx,8
s:	add ax,cs:[bx]
	add bx,2
	loop s
	mov ax,4c00h
	int 21h
	
code ends
end start



















