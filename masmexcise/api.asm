;本来要对《接口》里面的例题进行复习，但是发现自己还是无法做到。
assume ds:data,ss:stack1
data segment
BUFFER	DW 789AH
		DW 1234H
		DD 0
K1 DB 5AH
K2 DW 2354H
K3 DD 2A004455H

ONE DB 'HOW ARE YOU'
TWO DW 'OK'
copy LABEL WORD
THREE DB 'NOOOO'
data ends

extra segment
 mch db 11 dup (?)
extra ends

stack1 segment
	sta db 16 dup (0)
	top equ length sta
stack1 ends

code segment
assume cs:code,ss:stack1
	;计算789AH/1234H


START:	
		call test_stack
		mov ax,4c00h
		int 21h

test_stack:
		mov ax,stack1
		mov ss,ax
		mov sp,top
		ret

;进行串操作的实验
;默认条件：
;源串地址：ds:si.目的地址：es:di.数量在cx里面。设置DF位。

string:
		MOV AX,DATA
		MOV DS,AX
		MOV AX,EXTRA
		MOV ES,AX
		LEA SI,ONE
		LEA DI,mch
		MOV CX,11
		CLD
		REP MOVSB
		ret
sub3:
		mov al,'7'
		sub al,'5'
		aas
		;pusha
		mov ax,data
		mov ds,ax
		mov bl,K1
		ret

sub2:
		mov ax,data
		mov ds,ax
		MOV BX,OFFSET BUFFER
		MOV AX,[BX]
		CWD

		IDIV word ptr 2[BX]
		MOV 4[BX],AX
		MOV 6[BX],DX
		ret

sub1:
	;立即寻址
	mov bl,56h
	mov ax,2056h
	
	;register addressing
	inc cl
	mov ax,bx
	
	;direct addressing
	mov ax,ds:[2000h]
	mov ax,es:[2000h]
	
	;register indirect addressing
	mov ax,ds:[bx]
	mov ax,ss:[bp]
	mov ax,es:[bx]
	mov ax ,ds:[bp]
	
	mov ax,ds:[bx+2040h]

	mov ax,ds:[bx+si]
	mov ax,ds:[bx][si]

	mov ax,ds:[1234h][bx][di]
	mov ax,ds:[bx+di+1234h]
	
	mov ax,100h
	mov ds,ax
	
	xchg ax,bx
	xchg ax,ds:[bx]
	xchg ds:[bx+20h],ax
	
	in al,0fah
	in ax,28h
	mov dx,3aeh
	in ax,dx
	out 21h,al
	out dx,ax
	
	dollar dw 7580h
	;lea cx,[dollar][si*4+dx];??
	ret

code ends
end start
