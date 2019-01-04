BORDLAND=e:\\bc
CC=$(BORDLAND)\\bin\\bcc
LINK=$(BORDLAND)\\bin\\tlink
# -c:生成.obj文件
# -ml：large memory内存模式
# -l：80286实模式代码
# -k-采用标准栈帧
# -I：头文件路径
# -L：库文件路径
# -n：目标文件的位置
C_FLAGS=-c -ml -l -n.\\ -k- -I$(BORDLAND)\\include -L$(BORDLAND)\\lib

LINK_FLAGS=

TEST.EXE: tcb.obj
	$(LINK) $(LINK_FLAGS) @mylink
tcb.OBJ:
	$(CC) $(C_FLAGS) tcb.c
CLEAN:
	del *.obj
	del *.exe
	del *.map