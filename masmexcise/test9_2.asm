; ;利用jcxz指令，实现内存2000H段中查找第一个值为0的字节
; ;找到以后，把它的偏移地址存储在dx中。
; assume cs:code
; code segment
; 	start:	mov ax,2000H
; 			mov ds,ax
; 			mov bx,0
; 		s:	
; 			mov cx,[bx]
; 			jcxz ok
; 			inc bx

; 			jmp short s
; 		ok:	mov dx,bx
; 			mov ax,4c00H
; 			int 21H
; code ends
; end start



;利用loop指令，实现内存2000H段中查找第一个值为0的字节
;找到以后，把它的偏移地址存储在dx中。
assume cs:code
code segment
	start:	mov ax,2000H
			mov ds,ax
			mov bx,0
		s:	mov cl,[bx]
			mov ch,0
			inc cx
			inc bx
			loop s
		ok:	dec bx
			mov dx,bx
			mov ax,4c00H
			int 21H
code ends
end start