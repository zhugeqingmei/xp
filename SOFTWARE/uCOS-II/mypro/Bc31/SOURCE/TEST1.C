//我们这个程序完成的是实验3-6,3-7
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
void  TaskInit(void);
/************************主函数*********************************************/
void  main (void)
{
    //这个函数能够调用一个任务。----------------------------------------
    // char* s="M";                //定义要显示的字符

    // OSInit();                   //初始化uCOS_II

    // PC_DOSSaveReturn();             //保存Dos环境
    // PC_VectSet(uCOS, OSCtxSw);          //安装uCOS_II中断

    // OSTaskCreate(MyTask2,            //创建任务MyTask
    //     s,              //给任务传递参数
    //     &MyTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
    //     0);             //使任务MyTask的优先级别为0

    // OSStart();                  //启动uCOS_II的多任务管理

    /*--------------------------------------
    *我们定义了优先级，但是优先级并没有产生作用，但是：第一个任务不断对
    我们的系统一般的参数进行设置，这个是有问题的。
    */
    char* s_m="M";                //定义要显示的字符
    char* s_y="Y";				//定义要显示的字符

    OSInit();					//初始化uCOS_II

    PC_DOSSaveReturn();				//保存Dos环境
    PC_VectSet(uCOS, OSCtxSw);			//安装uCOS_II中断

    //TaskInit();
    OSTaskCreate(YouTask2,            //创建任务MyTask
        s_y,              //给任务传递参数
        &YouTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
        2);             //使任务YouTask的优先级别为2

    OSTaskCreate(MyTask2,            //创建任务MyTask
        s_m,              //给任务传递参数
        &MyTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
        3);             //使任务MyTask的优先级别为0
    OSStart();					//启动uCOS_II的多任务管理
}

/*
仅仅把初始化的工作拿出来
*/
void TaskInit()
{
    #if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
    #endif
    OS_ENTER_CRITICAL(); 
    PC_VectSet(0x08, OSTickISR);    //安装uCOS_II时钟中断向量
    PC_SetTickRate(OS_TICKS_PER_SEC);   //设置uCOS_II时钟频率
    OS_EXIT_CRITICAL();

    OSStatInit();           //初始化uCOS_II的统计任务
}


/**
* 
*/

void  MyTask2 (void *pdata)
{
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    TaskInit();
    for (;;) 
    {        
        if (x>50) 
        {
           x=0;
           y+=2; 
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

        OSTimeDlyHMSM(0, 0, 1, 0);  //等待
    }
}


void  YouTask2 (void *pdata)
{
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 
    TaskInit();
    for (;;) 
    {        
        if (x>50) 
        {
           x=0;
           y+=2; 
        }
                                                 
        PC_DispChar(x, y,       //在x，y位置显示s中的字符
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
            x += 1;                         

        OSTimeDlyHMSM(0, 0, 1, 0);  //等待
    }
}


/**
*-------------------------------------------------------------
 这个任务调度另外一个任务。
*/

void  MyTask (void *pdata)
{
    char *s = "Y";
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

        OSTimeDlyHMSM(0, 0, 3, 0);  //等待
    }
}

void  YouTask (void *pdata)
{
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
                                                 
        PC_DispChar(x, y,		//在x，y位置显示s中的字符
		*(char*)pdata, 
		DISP_BGND_BLACK+DISP_FGND_WHITE );
       		x += 1;                         

        OSTimeDlyHMSM(0, 0, 1, 0);	//等待
    }
}

