;课程设计1：把实验7的数据显示出来，以10进制的形式显示出来。
;使用了数值转换，字符的显示，除法溢出。
;问题1：为何返回的程序不对

assume cs:codesg,ss:stk,ds:datasg

datasg segment
	years	db 	'1975','1876','1977','1978','1979','1980','1981','1982','1983'
			db	'1984','1885','1986','1987','1988','1989','1990','1991','1992'
			db	'1993','1994','1995'

	income	dd 	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	   		dd 	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	poeple	dw 	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	   		dw	11542,14430,15257,17800
	
	aver	dw 21 dup (0)

	var_y dw 0
	var_i dw 0
	var_p dw 0
	var_a dw 0
	
	var_r dw 0	;行号
	var_c dw 0	;列号
	attr db 3	;属性
	index dw 0	;显存的坐标
	tmp1 dw 0	;10b
	tmp2 dd 0	;把要进行转换的数据放到这里
	tmp3 db 10 dup (0)	;转换完成后的数据在这里。
datasg ends

stk segment stack
	dw 100 dup (0)
stk ends

codesg segment
;---------------------------------------------------------
;主函数的入口
;---------------------------------------------------------
start:
	mov ax,datasg
	mov ds,ax
	call compute

	;计算初始的内存显示的位置，这个数值仅仅计算一次就可以。
	mov ax,var_r
	mov bx,160
	mul bx
	mov dx,ax
	mov ax,var_c
	mov bx,2
	mul bx
	add ax,dx
	mov index,ax

	call dis1
	mov ax,4c00H
	int 21H
;----------------------------------------------
;计算平均数
;----------------------------------------------
compute:
	mov cx,21
	mov ax,datasg
	mov ds,ax
	mov si,0
	mov di,0
	compute_s0:
	mov tmp1,cx
	lea bx,income
	mov ax,[bx+si]
	mov dx,[bx+si+2]	;被除数
	lea bx,poeple
	mov cx,[bx+di]		;除数
	div cx
	lea bx,aver
	mov [bx+di],ax
	add si,4
	add di,2
	mov cx,tmp1
	loop compute_s0
	ret
;--------------------------------------------
;显示函数，显示字符串和数字,一次显示一行数据，21循环。
;--------------------------------------------
dis1:
	mov cx,1
	mov ax,datasg
	mov ds,ax
	;------------------------------------
	dis_s0:
	mov tmp1,cx		;tmp1不再允许使用

	;传送四个年份的字符
	mov cx,4
	mov si,var_y
	dis_s1:
	lea bx,years	;这个数值会在后面被改变，需要进入循环
	mov dl,[bx+si]	;得到一个ascii码
	mov dh,attr		;得到属性
	mov bx,index	;得到显存地址
	mov ax,0b800H
	mov ds,ax
	mov	[bx],dl		;传送字符
	mov [bx+1],dh	;传送属性

	add bx,2
	mov ax,datasg
	mov ds,ax
	mov index,bx	;改变index
	inc si
	loop dis_s1
	mov var_y,si
	;-------------------------------------
	call spaces		;插入空格

	;-------------------------------------
	;计算10进制的数据。
	mov si,var_i
	lea bx,income
	mov ax,[bx+si]	;低字
	mov dx,[bx+si+2];高字
	lea bx,tmp2
	mov [bx],ax
	mov [bx+2],dx	;把dd放入tmp2
	call deci 		;把tmp2中的数据转换成10进制放入tmp3中。

	mov cx,tmp1
	loop dis_s0

	a:
	in al,60H
	cmp al,81H
	je b
	jmp a
	b:	

	ret

;-------------------------------------------------
;显示空格的函数
;-------------------------------------------------
spaces:
	;对显存的空格设置
	mov cx,4
	dis_s2:
	mov dl,20H		;得到一个ascii码
	mov dh,0		;得到属性
	mov bx,index	;得到显存地址
	mov ax,0b800H
	mov ds,ax
	mov	[bx],dl		;传送字符
	mov [bx+1],dh	;传送属性

	add bx,2
	mov ax,datasg
	mov ds,ax
	mov index,bx	;改变index
	loop dis_s2
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
	jmp deci_s1		;如果商不是0
deci_ret:
	mov cx,si		;如果商是0，把堆栈里面的数据弹出到tmp3
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
