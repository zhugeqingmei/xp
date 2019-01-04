#include <stdio.h>
#include <string.h>

typedef struct tcb
{
	char * code_name;
	int p;
	int v_num;
	void (*fun)(void);
}TCB;

//被管理的代码F1
void function_1()
{
	int i;
	for(i = 0; i < 10; i++)
	{
		printf("111\n");
	}
}

//被管理的代码F2
void function_2()
{
	int i;
	for(i = 0; i < 10; i++)
	{
		printf("222\n");
	}
}

//被管理的代码F3
void function_3()
{
	int i;
	for(i = 0; i < 10; i++)
	{
		printf("333\n");
	}
}
/**
创建一个TCB。
name:名称
pp:优先级
vnum:版本号
void(*f)():函数指针
*/
TCB CreateTCB(char* name, int pp, int vnum, void (*f)(void))
{
	TCB tcb;
	tcb.code_name = name;
	tcb.p = pp;
	tcb.v_num = vnum;
	tcb.fun = f;
	return tcb;
}

void main()
{
	char code_name[10];
	int t, i;
	TCB tcbTbl[3];
	tcbTbl[0] = CreateTCB("F1", 2, 1, function_1);
	tcbTbl[1] = CreateTCB("F2", 2, 4, function_2);
	tcbTbl[2] = CreateTCB("F3", 4, 5, function_3);
	printf("Input CodeName:");
	scanf("%s",code_name);
	t = 0;
	for(i = 0; i < 3; i++)
	{
		if(strcmp(tcbTbl[i].code_name, code_name) == 0)
		{
			tcbTbl[i].fun();
			t = 1;
		}
		if(i == 2 && t == 0)
			printf("No %s\n", code_name);
	}
}