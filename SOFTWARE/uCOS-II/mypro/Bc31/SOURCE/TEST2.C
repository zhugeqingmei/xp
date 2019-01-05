/*
我们这个程序完成的是实验3-8。
youtask运行20次之后，挂起任务mytask;youtask运行40次之后，
恢复任务mytask。

实验3-9
mytask运行10次时使用函数osschedlock对调度器进行加锁，
当任务运行到第80次的时候，用函数osschedunlock进行解锁

实验3-10，
任务mytask删除youtask任务。

*/
#include "includes.h"

#define  TASK_STK_SIZE   512			//任务堆栈长度

OS_STK   MyTaskStk[TASK_STK_SIZE];       //定义任务堆栈区
OS_STK   YouTaskStk[TASK_STK_SIZE];		//定义任务堆栈区
INT16S   key;					//用于退出uCOS_II的键	
INT8U	 x=0,y=0;				//字符显示位置

void  MyTask2(void *data);           //声明一个任务

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
    INT8U count = 0;
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

    for (;;) 
    {        
        if (x>50) 
        {
           x=0;
           y+=2; 
        }

        // if(count == 10)
        // {
        //     OSSchedLock();
        // }

        // if(count == 80)
        // {
        //   OSSchedUnlock();
        // }
        
        while(OSTaskDelReq(2) != OS_TASK_NOT_EXIST)
        {
            OSTimeDly(1);
        }
                                                 
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

        count++;
        OSTimeDlyHMSM(0, 0, 3, 0);  //等待

    }
}

void  YouTask (void *pdata)
{
    INT8U count = 0;

#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    for (;;) 
	{        

        if (x>50) 
		{
		   x=0;
		   y+=2; 
		}

        /*-----------------------------
            实验3-8
        *------------------------------
        */

        // if(count == 20)
        // {
        //     OSTaskSuspend(0);
        // }

        // if(count == 40)
        // {
        //     OSTaskResume(0);
        // }
                                                 
        PC_DispChar(x, y,		//在x，y位置显示s中的字符
		*(char*)pdata, 
		DISP_BGND_BLACK+DISP_FGND_WHITE );
       	x += 1;                            

        if(OSTaskDelReq(OS_PRIO_SELF) == OS_TASK_DEL_REQ)
        {
            OSTaskDel(OS_PRIO_SELF);
        }
        
        count++;
        OSTimeDlyHMSM(0, 0, 1, 0);  //等待
    }
}

