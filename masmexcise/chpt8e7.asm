assume cs:codesg,ds:datasg,ds:table,ds:params

datasg segment
	db '1975','1876','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1885','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
datasg ends

;0b64
table segment
	db 21 dup ('year summ ne ?? ')
table ends

params segment
	dw 0,0,0
params ends

codesg segment
start:
	;这个函数使用了ss堆栈的赋值！！！如果要使用堆栈，那么需要自己保存先。
	;--------------------------------------
	;把年份拷贝到第一列，占4字节
	mov ax,my_ret

	mov ax,params
	mov ds,ax
	;mov ds:[1],cx
	mov bx,0
	mov bp,0
	mov si,0
	mov di,0

	mov cx,21
s1:	
	mov ds:[0],cx
	mov cx,2
s0:	
	mov ax,datasg
	mov ds,ax
	mov dx,[bx+si];read the year data
	mov ax,table
	mov ss,ax		;bp use ss segment
	mov [bp+si],dx;put the year in table
	add si,2
	loop s0
	
	add bp,16
	add bx,4
	mov si,0
	mov ax,params
	mov ds,ax
	mov cx,ds:[0]
	loop s1

	;--------------------------------------
	;再把年份拷贝过来
	mov ax,params
	mov ds,ax
	;mov ds:[1],cx
	mov bx,0
	mov bp,0
	mov si,0
	mov di,0

	mov cx,21
s3:	
	mov ds:[0],cx
	mov cx,2
s2:	
	mov ax,datasg
	mov ds,ax
	mov dx,[bx+si+84];read the year data
	mov ax,table
	mov ss,ax		;bp use ss segment
	mov [bp+si+5],dx;put the year in table
	add si,2
	loop s2
	
	add bp,16
	add bx,4
	mov si,0
	mov ax,params
	mov ds,ax
	mov cx,ds:[0]
	loop s3

	;----------------------------------
	;再拷贝过人数来
	mov ax,params
	mov ds,ax
	;mov ds:[1],cx
	mov bx,0
	mov bp,0
	mov si,0
	mov di,0

	mov cx,21
s5:	
	mov ds:[0],cx
	mov cx,1
s4:	
	mov ax,datasg
	mov ds,ax
	mov dx,[bx+si+168];read the year data
	mov ax,table
	mov ss,ax		;bp use ss segment
	mov [bp+si+10],dx;put the year in table
	loop s4
	
	add bp,16
	add bx,2
	mov si,0
	mov ax,params
	mov ds,ax
	mov cx,ds:[0]
	loop s5

	;----------------------------------
	;计算平均数值
	mov ax,table
	mov ds,ax
	mov bx,0
	mov cx,21
s6:	
	mov ax,ds:[bx+5]
	mov dx,ds:[bx+7]
	div word ptr ds:[bx+10]
	mov ds:[bx+13],ax
	add bx,16
	loop s6
my_ret:
	mov ax,4c00H
	int 21H

codesg ends

end start
