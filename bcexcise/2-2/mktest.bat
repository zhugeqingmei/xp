ECHO OFF
ECHO **********************************************
ECHO *批处理文件
ECHO **********************************************
ECHO ON

MD ..\\WORK
MD ..\\OBJ
CD ..\\WORK
COPY ..\\TEST\\MAKEFILE TEST.MAK
E:\\BC\BIN\MAKE -F TEST.MAK
CD ..\
DEL WORK
DEL OBJ
RD .\WORD
RD .\OBJ
