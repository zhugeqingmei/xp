;程序6.4，使用多个段
; assume cs:code,ds:data,ss:stack

; data segment
	; dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
; data ends

; stack segment
	; dw 0,0,0,0,0,0,0,0,0,0,0,0,0
; stack ends

; code segment
; start:
	; mov ax,stack
	; mov ss,ax
	; mov sp,26
	; mov ax,data
	; mov ds,ax
	; mov bx,0
	; mov cx,8
; s:	push [bx]
	; add bx,2
	; loop s
	
	; mov bx,0
	; mov cx,8
; s0:	pop [bx]
	; add bx,2
	; loop s0
	; mov ax,4c00h
	; int 21h		
; code ends
; end start

;实验5编写，调试具有多个段的程序
; assume cs:code,ds:data,ss:stack
; data segment
	; dw 0123H,0456H,0789H,0abcH,0defH,0fedH,0cbaH,0987H
; data ends

; stack segment
	; dw 0,0,0,0,0,0,0,0,0,0,0,0,0
; stack ends

; code segment
; start:
	; mov ax,stack
	; mov ss,ax
	; mov sp,16
	; mov ax,data
	; mov ds,ax
	; push ds:[0]
	; push ds:[2]
	; pop ds:[2]
	; pop ds:[0]
	; mov ax,4c00h
	; int 21H
; code ends
; end start

;--------------------------------------
; assume cs:code,ds:data,ss:stack
; data segment
	; dw 0123H,0456H
; data ends

; stack segment
	; dw 0,0
; stack ends

; code segment
; start:
	; mov ax,stack
	; mov ss,ax
	; mov sp,16
	; mov ax,data
	; mov ds,ax
	; push ds:[0]
	; push ds:[2]
	; pop ds:[2]
	; pop ds:[0]
	; mov ax,4c00h
	; int 21H
; code ends
; end start


;----------------------------------
; assume cs:code,ds:data,ss:stack
; code segment
; start:
	; mov ax,stack
	; mov ss,ax
	; mov sp,16
	; mov ax,data
	; mov ds,ax
	; push ds:[0]
	; push ds:[2]
	; pop ds:[2]
	; pop ds:[0]
	; mov ax,4c00h
	; int 21H
; code ends
; data segment
	; dw 0123H,0456H
; data ends

; stack segment
	; dw 0,0
; stack ends
; end start


;------------------------------
;把a和b地址里面的数据加起来放到C里面
; assume cs:code
; a segment
	; db 1,2,3,4,5,6,7,8
; a ends

; b segment
	; db 1,2,3,4,5,6,7,8
; b ends

; c segment
	; db 0,0,0,0,0,0,0,0
; c ends

; code segment
	; start:		
		; mov bx,0
		; mov cx,8
		; mov dx,0
	; s:	mov ax,a
		; mov ds,ax
		; add dl,ds:[bx]
		; mov ax,b
		; mov ds,ax
		; add dl,ds:[bx]
		; mov ax,c
		; mov ds,ax
		; mov ds:[bx],dl
		; inc bx
		; mov dl,0
		; loop s
		; mov ax,4c00h
		; int 21H	
; code ends
; end start

;--------------------------
;
assume cs:code
a segment
	dw 1,2,3,4,5,6,7,8
a ends

b segment
	dw 0,0,0,0,0,0,0,0
b ends

code segment
	start:		
		mov ax,b
		mov ss,ax
		mov ax,26
		mov sp,ax
		mov cx,8
		mov dx,0
		mov ax,a
		mov ds,ax
	s:	push ds:[bx]
		add bx,2
		loop s
		mov bx,0
	s0:	pop ds:[bx]
		add bx,2
		loop s0
		mov ax,4c00h
		int 21H	
code ends
end start


