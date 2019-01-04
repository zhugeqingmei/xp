;测试命令ret。--------------------
; assume cs:code

; stack segment
; 	db 16 dup(0)
; stack ends

; code segment
; 	mov ax,4c00H
; 	int 21H

; start:
; 	mov ax,stack
; 	mov ss,ax
; 	mov sp,16
; 	mov ax,0
; 	push ax
; 	mov bx,0
; 	ret
; code ends
; end start

;测试命令retf-----------------------
; assume cs:code

; stack segment
; 	db 16 dup(0)
; stack ends

; code segment
; 	mov ax,4c00H
; 	int 21H

; start:
; 	mov ax,stack
; 	mov ss,ax
; 	mov sp,16
; 	mov ax,0
; 	push cs
; 	push ax
; 	;mov bx,0
; 	retf
; code ends
; end start

;检测点10.1
;从内存1000：0000处开始执行指令
; assume cs:code

; stack segment
; 	db 16 dup(0)
; stack ends

; code segment
; start:
; 	mov ax,stack
; 	mov ss,ax
; 	mov sp,16
; 	mov ax,1000H
; 	push ax
; 	mov ax,0
; 	push ax
; 	retf
; code ends
; end start

;检测点10.2，
;实际是把下一条指令的地址保存在堆栈里面，而且进行跳转。
; assume cs:codeseg

; codeseg segment
; start:
; 	mov ax,0
; 	call s
; 	inc ax
; s:	
; 	pop ax
; codeseg ends
; end start


; ;检测点10.3
; ;实际是把下一条指令的地址保存在堆栈里面，而且进行跳转。
; ; assume cs:codeseg
; assume cs:codeseg
; codeseg segment
; start:
; 	mov ax,0
; 	call far ptr s
; 	inc ax
; s:	
; 	pop ax
; 	add ax,ax
; 	pop bx
; 	add ax,bx
; codeseg ends
; end start



;检测点10.5
;
; assume cs:codeseg
; codeseg segment
; start:
; 	mov ax,6
; 	call ax
; 	inc ax
; 	mov bp,sp
; 	add ax,[bp]
; codeseg ends
; end start


;检测点10.5（1）
;这个函数不能进行单步
; assume cs:codeseg
; stack segment
; 	dw 8 dup (0)
; stack ends

; codeseg segment
; start:
; 	mov ax,stack
; 	mov ss,ax
; 	mov sp,16
; 	mov ds,ax
; 	mov ax,0
; 	call word ptr ds:[0EH]
; 	inc ax
; 	inc ax
; 	inc ax

; 	mov ax,4c00H
; 	int 21H
; codeseg ends
; end start



;检测点10.5（2）
;这个函数不能进行单步
;stack:
; assume cs:codeseg
; stack segment
; 	dw 8 dup (0)
; stack ends

; codeseg segment
; start:
; 	mov ax,stack
; 	mov ss,ax
; 	mov sp,16
; 	mov word ptr ss:[0],offset s
; 	mov ss:[2],cs
; 	call dword ptr ss:[0]
; 	nop

; s:	mov ax,offset s
; 	sub ax,ss:[0cH]
; 	mov bx,cs
; 	sub bx,ss:[0eH]

; 	mov ax,4c00H
; 	int 21H
; codeseg ends
; end start



;问题10.1
;这个函数不能进行单步

assume cs:codeseg

codeseg segment
start:
	mov ax,1
	mov cx,3
	call s
	mov bx,ax
	mov ax,4c00H
	int 21H
s:	add ax,ax
	loop s
	ret
codeseg ends
end start
