;程序从start开始执行，所以，开头的那个退出是不作用的
;假设jmp short s1是两个字节，把他；复制到s开头。
;通过s0跳转到s。这里自己理解的“相对位置”出错了。
;再跳转到s1


assume cs:codesg
codesg segment
	mov ax,4c00H
	int 21H

	start:	mov ax,0
		s:	nop
			nop
			mov di,offset s
			mov si,offset s2
			mov ax,cs:[si]
			mov cs:[di],ax
		s0:	jmp short s

		s1:	mov ax,0
			int 21H
			mov ax,0

		s2:	jmp short s1
			nop
codesg ends
end start
