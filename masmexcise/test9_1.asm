;程序执行完以后指向第一条指令
;就是计算相对的偏移地址，jmp后面的指令地址-标号地址。
; assume cs:code
; data segment
; dw 10
; data ends

; code segment
; start:	mov ax,data
; 		mov ds,ax
; 		mov bx,0
; 		jmp word ptr [bx+1]
; code ends
; end start


;jmp执行以后，CS：IP指向程序的第一条指令
; assume cs:code
; data segment
; 	dd 12345678H
; data ends

; code segment
; 	start:	mov ax,data
; 			mov ds,ax
; 			mov bx,0
; 			mov [bx],bx
; 			mov [bx+2],cs
; 			jmp dword ptr ds:[0]
; 			mov ax,4c00H
; 			int 21H
; code ends
; end start


;
;
assume cs:codesg
codesg segment
	start:	mov ax,2000H
			mov ds,ax
			mov word ptr ds:[1000H],00BEH
			mov word ptr ds:[1002H],0006H
			mov ax,2000H
			mov es,ax
			jmp dword ptr es:[1000H]
	mov ax,4c00H
	int 21H
codesg ends
end start