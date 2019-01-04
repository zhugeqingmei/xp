;课程设计1：把实验7的数据显示出来，以10进制的形式显示出来。
;使用了数值转换，字符的显示，除法溢出。
;问题1：为何返回的程序不对

assume cs:codesg,ss:stk

datasg segment
	tmp2 dd 0	;把要进行转换的数据放到这里
	tmp3 db 10 dup (0)	;转换完成后的数据在这里。
	tmp4 dw 1,2
	count equ $-tmp4
	mstr db 'HELLO!',0dh,0ah,'$'	;观测定义的变量在内存里面的排列。
	mstr2 dw 'ok'
	mstr3 dd 'ok'
	mstr4 db 'ok'
datasg ends

stk segment stack
	dw 100 dup (0)
stk ends

codesg segment
;---------------------------------------------------------
;主函数的入口
;测试10进制转换的函数，我们发现能够正常运作
;---------------------------------------------------------
start:	

	mov ax,count	;这里得到的是以字节为单位的个数统计

	call my_test

	;-----------------------------------------
	;这是检测design的函数
	mov ax,datasg
	mov ds,ax
	mov ax,1234
	lea bx,tmp2
	mov [bx],ax
	call deci
	mov ax,4c00H
	int 21H
;---------------------------------------------------------
;测试各种语句
;---------------------------------------------------------
my_test:
	mov ax,datasg
	mov ds,ax

	mov ax,10H
	and ax,10000B

	;使用dos中断来显示字符串
	;dx存放字符串首地址，ax是中断程序号码。字符串需要一个$结束。
	lea dx,mstr
	mov ax,900H
	int 21H
	ret


;-----------------------------------------------------
;计算10进制的数据。
;-----------------------------------------------------
deci:
	mov si,0		;计算一共几个10进制数据

	lea bx,tmp2
	mov ax,datasg
	mov ds,ax
	mov ax,[bx]
	mov dx,[bx+2]
deci_s1:
	mov cx,10
	call divdw
	inc si
	push cx
	cmp dx,0		;对结果进行判断，如果两个是0才进行处理。
	jnz deci_s0
	cmp ax,0
	jz deci_ret
deci_s0:
	jmp deci_s1
deci_ret:
	mov cx,si
	lea bx,tmp3
	mov si,0
deci_s2:
	pop dx
	mov [bx+si],dl
	inc si
	loop deci_s2

	ret
;-----------------------------------------------------
;;进行除法运算，dword除以word，得到dword。
;(ax)=dword.(dx)=word.(cx)=除数
;结果放入dx高位，ax放入低位，cx保存余数。
;-----------------------------------------------------

divdw:
		push si
		push di

		mov si,ax	;保存低字
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

codesg ends
end start
