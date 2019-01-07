/*
实验：建立三个任务，分别显示一个字母，有不同的延迟时间。

实验：一个任务查询另外两个任务，并显示出来。

实验：当计数达到要求，删除两个任务

实验：显示当前的tcb指针,但是后两个任务的tcb相同？？？？
*/
#include "includes.h"

#define  TASK_STK_SIZE   512			//任务堆栈长度

OS_STK   MyTaskStk[TASK_STK_SIZE];       //定义任务堆栈区
OS_STK   YouTaskStk[TASK_STK_SIZE];		//定义任务堆栈区
OS_STK   You2TaskStk[TASK_STK_SIZE];     //定义任务堆栈区
INT16S   key;					//用于退出uCOS_II的键	
INT8U	 x=0,y=0;				//字符显示位置

void conver_string(OS_TCB* num, char* str);

void  YouTask2(void *data);			//声明一个任务

void  MyTask(void *data);           //声明一个任务，它调用下面的函数
void  YouTask(void *data);          //声明一个任务
/************************主函数*********************************************/
void  main (void)
{
    //这个函数能够调用一个任务。----------------------------------------
    char* s="M";                //定义要显示的字符

    OSInit();                   //初始化uCOS_II

    PC_DOSSaveReturn();         //保存Dos环境
    PC_VectSet(uCOS, OSCtxSw);  //安装uCOS_II中断

    OSTaskCreate(MyTask,        //创建任务MyTask
        s,              //给任务传递参数
        &MyTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
        0);             //使任务MyTask的优先级别为0

    OSStart();                  //启动uCOS_II的多任务管理

    
}


/**
*-------------------------------------------------------------
 这个任务调度另外一个任务。3-7
*/

void  MyTask (void *pdata)
{
    char *s = "Y";
    char *s2 = "T";
    INT8U count = 0;
    OS_TCB tmp_tcb;
    char tmp_str[33];
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    OS_ENTER_CRITICAL();
    PC_VectSet(0x08, OSTickISR);    //安装uCOS_II时钟中断向量
    PC_SetTickRate(OS_TICKS_PER_SEC);   //设置uCOS_II时钟频率
    OS_EXIT_CRITICAL();

    OSStatInit();           //初始化uCOS_II的统计任务

    OSTaskCreate(
        YouTask,
        s,
        &YouTaskStk[TASK_STK_SIZE - 1],
        2
        );
    /**
    建立另外一个任务
    */
    OSTaskCreate(
        YouTask2,
        s2,
        &You2TaskStk[TASK_STK_SIZE - 1],
        3
        );

    for (;;) 
    {        
        //显示当前任务的tcb指针
        conver_string(OSTCBCur,tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;

        //显示当前任务的tcb指针
        conver_string(OSTCBPrioTbl[0],tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;

        if (x>50) 
        {
           x=0;
           y+=2; 
        }
        // //删除任务
        // if(count == 3)
        // {
        //     OSTaskDelReq(2);
        // }
        // if(count == 6)
        // {
        //     OSTaskDelReq(3);
        // }

                                                 
        PC_DispChar(x, y,       //在x，y位置显示s中的字符
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
            x += 1;                         

        //如果按下Esc键则退出uCOS_II
        if (PC_GetKey(&key) == TRUE) 
        {
            if (key == 0x1B) 
        {
                PC_DOSReturn();
            }
        }
        //查询任务
        // if(OSTaskQuery(2,&tmp_tcb) == OS_NO_ERR)
        // {
        //     PC_DispChar(x, y,       //在x，y位置显示s中的字符
        // (INT8U)(tmp_tcb.OSTCBPrio+0x30), 
        // DISP_BGND_BLACK+DISP_FGND_WHITE );
        //     x++;
        // }

        // //查询任务
        //  if(OSTaskQuery(3,&tmp_tcb) == OS_NO_ERR)
        // {
        //     PC_DispChar(x, y,       //在x，y位置显示s中的字符
        // (INT8U)(tmp_tcb.OSTCBPrio+0x30), 
        // DISP_BGND_BLACK+DISP_FGND_WHITE );
        //     x++;
        // }

        OSTimeDlyHMSM(0, 0, 3, 0);  //等待
        count++;

    }
}

void  YouTask (void *pdata)
{
    char tmp_str[33];
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    for (;;) 
	{        
        //显示当前任务的tcb指针
        conver_string(OSTCBCur,tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;


          //显示当前任务的tcb指针
        conver_string(OSTCBPrioTbl[2],tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;

        if (x>50) 
		{
		   x=0;
		   y+=2; 
		}
        //检测是否需要删除自己
        if(OSTaskDelReq(OS_PRIO_SELF) == OS_TASK_DEL_REQ)
        {
            OSTaskDel(OS_PRIO_SELF);
        }
                                  
        PC_DispChar(x, y,		//在x，y位置显示s中的字符
		*(char*)pdata, 
		DISP_BGND_BLACK+DISP_FGND_WHITE );
       	x += 1;                            

        if(OSTaskDelReq(OS_PRIO_SELF) == OS_TASK_DEL_REQ)
        {
            OSTaskDel(OS_PRIO_SELF);
        }

        OSTimeDlyHMSM(0, 0, 3, 0);  //等待
    }
}


void  YouTask2 (void *pdata)
{

    char tmp_str[33];
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    for (;;) 
    {   

        //显示当前任务的tcb指针
        conver_string(OSTCBCur,tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;

        //显示当前任务的tcb指针
        conver_string(OSTCBPrioTbl[3],tmp_str);
        PC_DispStr(x, y,       //在x，y位置显示s中的字符
        tmp_str, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x = 0;
        y += 1;

        if(OSTaskDelReq(OS_PRIO_SELF) == OS_TASK_DEL_REQ)
        {
            OSTaskDel(OS_PRIO_SELF);
        }

        if (x>50) 
        {
           x=0;
           y+=2; 
        }
                                  
        PC_DispChar(x, y,       //在x，y位置显示s中的字符
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
        x += 1;                            
        
        

        if(OSTaskDelReq(OS_PRIO_SELF) == OS_TASK_DEL_REQ)
        {
            OSTaskDel(OS_PRIO_SELF);
        }

        OSTimeDlyHMSM(0, 0, 3, 0);  //等待
    }
}
/*把一个32位指针转换成字符串*/
void conver_string(OS_TCB* num, char* str)
{
    int*  num_int = (int *)num;
    int num_cp = *num_int;
    int n = 0;
    int tmp = 0, index = 0;
    while(n<8)
    {
        tmp = ((num_cp & 0xF0000000) >> 28);
        if(tmp < 10)
        {
            str[index++] = 0x30 + tmp;
        }else{
            str[index++] = 0x37 + tmp;
        }
        n++;
        num_cp <<= 4;
    }
    str[index] = '\0';
}
