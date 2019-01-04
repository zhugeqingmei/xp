;有三个子程序
assume cs:code

data segment
	db 'Welcome to masm!',0
	DIS1 dw 123,12666,1,8,3,38
	tmp1 dw 0;保存旧的cx
	tmp2 dw 0
	tmp3 dw 0
	tmp4 db 16 dup (0)
data ends

stack segment stack
	db 32 dup (0)
stack ends

code segment
start:
		; mov dh,8
		; mov dl,8
		; mov cl,4
		; mov ax,data
		; mov ds,ax
		; mov si,0
		; call show_str
		;call mytest

		;12341234H/10H=1234123H..4
		; mov dx,1234H
		; mov ax,1234H
		; mov cx,10H
		; call divdw

		mov ax,12366
		call dtoc
		mov ax,4c00H
		int 21H	


;显示字符串问题:在指定的位置，用指定的颜色，显示一个用0结束的字符串
;传入参数：dh=行号0-24。dl=列号0-79。cl=颜色。ds:si指向字符串首地址
;无返回数值
;使用到的寄存器：
;背景知识：一行160字节，那么我们要写入的首地址：160*((dh))*2*(dl)
;
show_str:
		
		push ax
		push di
		push bx

		mov ax,data
		mov ds,ax
		mov tmp1,cx	;保存旧的cl

		mov al,160
		mul dh
		mov tmp2,ax
		mov dh,0
		mov al,2	;这里需要2的乘法
		mul dl
		add ax,tmp2
		mov di,ax;得到首地址

	s:	;需要改变4次ds
		mov ax,data
		mov ds,ax
		mov cl,[si]		;字母地址
		mov ch,0
		jcxz ok
		mov ax,0b800H
		mov ds,ax
		mov [di],cl		;屏幕地址
		mov ax,data
		mov ds,ax
		mov bx,tmp1
		mov ax,0b800H
		mov ds,ax
		mov [di+1],bl	;属性
		inc si
		add di,2
		loop s
	ok:	
		pop bx
		pop di
		pop ax
	a:
		in al,60H
		cmp al,81H
		je b
		jmp a
	b:	
		ret

mytest:
		mov ax,tmp2
		
	test_a:
		in al,60H
		cmp al,81H
		je test_b
		jmp test_a
	test_b:	
		ret

;进行除法运算，dword除以word，得到dword。
;(ax)=dword.(dx)=word.(cx)=除数
;结果放入dx高位，ax放入低位，cx保存余数。
divdw:
		push si
		push di

		mov si,ax	;保存低字
		mov ax,data
		mov ds,ax
		mov ax,0
		xchg dx,ax	;把高位数据表示成32位
		div cx
		mov di,ax	;把商保存起来
		mov ax,si 	;把低字恢复
		div cx
		mov cx,dx	;余数放入cx
		mov dx,di
		
		pop di
		pop si
		ret

;数字显示，把数字以10进制的方式显示在屏幕上面
;把Word型数据以10进制的字符串形式显示在屏幕上。
;(ax)=word。ds:si字符串首地址。
;使用上面自己定义的两个函数：防止出发的时候溢出，字符。
;
dtoc:
		push bx
		push cx
		push dx

		mov bx,0	;计算位数
		mov dx,0
	dtoc_s:
		mov cx,10
		call divdw		;16bit/8bit
		add cx,30H
		push cx
		inc bx
		cmp ax,0
		jz dtoc_s1
		jmp dtoc_s
	dtoc_s1:;A5
		mov cx,bx
		mov si,0
	dtoc_s2:
		pop bx
		mov ds:[tmp4+si],bl
		inc si
		loop dtoc_s2
		mov ds:[tmp4+si],0

		lea si,tmp4
		mov dx,0
		mov cl,2
		call show_str
		
		pop dx
		pop cx
		pop bx
		ret

code ends
end start

