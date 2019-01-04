# test.exe: pa.obj pb.obj test2.obj
# 	tlink @tlink
# pa.obj:
# 	bcc -c -ml -Ie:\\bc\\include -Le:\\bc\\lib pa.c
# pb.obj:
# 	bcc -c -ml -Ie:\\bc\\include -Le:\\bc\\lib pb.c
# test2.obj:
# 	bcc -c -ml -Ie:\\bc\\include -Le:\\bc\\lib test2.c
# CLEAN:
# 	del *.obj
# 	del *.map

#第二个版本
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

TEST.EXE: PA.OBJ PB.OBJ TEST2.OBJ
	$(LINK) $(LINK_FLAGS) @mylink
PA.OBJ: PA.C PA.H
	$(CC) $(C_FLAGS) PA.C
PB.OBJ: PB.C PB.H
	$(CC) $(C_FLAGS) PB.C
TEST2.OBJ: TEST2.C PA.H PB.H
	$(CC) $(C_FLAGS) TEST2.C
CLEAN:
	del *.obj
	del *.exe
	del *.map