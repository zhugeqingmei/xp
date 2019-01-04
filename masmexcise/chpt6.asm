
assume cs:codeseg
codeseg segment
	;check point 
	
	;6.1 使用0-15内存单元里面数据来改变程序开始的那些数据
	; dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
; start:	mov ax,0
		; mov ds,ax
		; mov bx,0
		; mov cx,8
	; s:	mov ax,[bx]
		; mov cs:[bx],ax
		; add bx,2
		; loop s
		; mov ax,4c00h
		; int 21h
		
		;检测点 6.1 使用0-15内存单元里面数据来改变程序开始的那些数据
	; dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
	; dw 0,0,0,0,0
; start:	mov ax,cs
		; mov ss,ax
		; mov sp,26
		; mov ax,0
		; mov ds,ax
		; mov bx,0
		; mov cx,8
	; s:	push [bx]
		; pop ax
		; mov cs:[bx],ax
		; add bx,2
		; loop s
		; mov ax,4c00h
		; int 21h
		
		;程序6.3，使用堆栈把程序前面的8个字单元换顺序
		dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
		dw 0,0,0,0,0,0,0,0
start:	mov ax,cs
		mov ss,ax
		mov sp,32
		mov bx,0
		mov cx,8
	s:	push cs:[bx]
		add bx,2
		loop s
		mov bx,0
		mov cx,8
	s0:	pop cs:[bx]
		add bx,2
		loop s0
		mov ax,4c00h
		int 21h
		
codeseg ends
end start
