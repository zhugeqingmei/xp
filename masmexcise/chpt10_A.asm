; ;计算第一组数据的3次方，结果放入后面一组的dword中。

; assume cs:code
; data segment
; 	dw 1,2,3,4,5,6,7,8
; 	dd 0,0,0,0,0,0,0,0
; data ends
; code segment
; start:
; 	mov cx,8
; 	mov ax,data
; 	mov ds,ax
; 	mov bx,0
; 	mov si,0
; 	mov di,0
; s:	mov dx,[bx+si]
; 	call sub1
; 	mov [bx+16+di],ax
; 	mov [bx+16+di+2],dx
; 	add si,2
; 	add di,4
; 	loop s

; 	mov ax,4c00H
; 	int 21H

; 	;计算N的3次方
; 	;传入参数使用寄存器：dx
; 	;返回的参数使用寄存器：dx:ax
; 	;使用到的寄存器：
; sub1:
; 	mov ax,dx
; 	mul ax
; 	mul ax
; 	ret

; code ends
; end start


;10.12，寄存器冲突的问题
;把data段中的字符串转换为大写字母
assume cs:code
data segment
	db 'word',0
	db 'unix',0
	db 'wind',0
	db 'good',0
data ends
stack segment
	db 16 dup (0)
stack ends

code segment
start:	mov ax,data
		mov ds,ax
		mov bx,0

		mov ax,stack
		mov ss,ax
		mov sp,16

		mov cx,4
	s:	mov si,bx
		call captital
		add bx,5
		loop s

		mov ax,4c00H
		int 21H

;把字母转化为大写字母
;传入的参数：ds:si
;传回的参数：无
;使用的寄存器：cx,si

captital:
		push cx
		push si
	change:
		mov cl,[si]
		mov ch,0
		jcxz ok
		and byte ptr [si],11011111B
		inc si
		jmp short change
	ok:	pop si
		pop cx
		ret
code ends
end start