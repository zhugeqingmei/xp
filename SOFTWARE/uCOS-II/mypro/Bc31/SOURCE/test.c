/*

第4章，在3-6的基础上（建立MyTask，每秒显示M）修改,问题：
中文显示的问题，这个实验实际是在3-7基础上进行的。

4-2，建立三个任务，第三个任务使用函数OSTimeTickHook()中断了
10000次时使用一个信号变量InterKey激活的。

4-3,任务的延时和恢复。

4-4，显示节拍变量和设定节拍

*/
#include "includes.h"

#define  TASK_STK_SIZE   512			//任务堆栈长度

OS_STK   MyTaskStk[TASK_STK_SIZE];       //定义任务堆栈区
OS_STK   YouTaskStk[TASK_STK_SIZE];     //定义任务堆栈区
OS_STK   InterTaskStk[TASK_STK_SIZE];		//定义任务堆栈区
INT16S   key;					//用于退出uCOS_II的键	
INT8U	 x=0,y=0;				//字符显示位置
BOOLEAN  InterKey = FALSE;
INT8U    count = 0;                         //记录时间
INT32U   stime = 0;                     //记录系统节拍，

char *ss = "running the task InterTask.";
void  MyTask(void *data);           //声明一个任务，它调用下面的函数
void YouTask(void *data);
void InterTask(void *pdata);
/************************主函数*********************************************/
void  main (void)
{
   
    /*--------------------------------------
    *我们定义了优先级，但是优先级并没有产生作用，但是：第一个任务不断对
    我们的系统一般的参数进行设置，这个是有问题的。
    */
    char* s_m="M";                //定义要显示的字符
    OSInit();					//初始化uCOS_II

    PC_DOSSaveReturn();				//保存Dos环境
    PC_VectSet(uCOS, OSCtxSw);			//安装uCOS_II中断

    OSTaskCreate(MyTask,            //创建任务MyTask
        s_m,              //给任务传递参数
        &MyTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
        0);             //使任务MyTask的优先级别为0
    OSStart();					//启动uCOS_II的多任务管理
}

/**
*-------------------------------------------------------------
 这个任务调度另外一个任务。
*/

void  MyTask (void *pdata)
{
    char s[5];
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    OS_ENTER_CRITICAL();
    PC_VectSet(0x08, OSTickISR);    //安装uCOS_II时钟中断向量
    PC_SetTickRate(OS_TICKS_PER_SEC);   //设置uCOS_II时钟频率
    OS_EXIT_CRITICAL();

    OSStatInit();           //初始化uCOS_II的统计任务

    OSTaskCreate(YouTask,            //创建任务MyTask
        "Y",              //给任务传递参数
        &YouTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
        3);             //使任务MyTask的优先级别为0

    // OSTaskCreate(InterTask,            //创建任务MyTask
    //     "H",              //给任务传递参数
    //     &InterTaskStk[TASK_STK_SIZE - 1],//设置任务堆栈栈顶指针
    //     2);             //使任务MyTask的优先级别为0

    for (;;) 
    {        
        if (x>50) 
        {
           x=0;
           y+=2; 
        }
                  
        //if(y>1) OSTimeDlyResume(3);   //唤醒优先级是3的任务

        if(count == 10)
        {
            OSTimeSet(10);
        }

        stime = OSTimeGet();
        sprintf(s,"%5d",stime); //这个技巧很厉害
        PC_DispStr(5, 10,       //在x，y位置显示s中的字符
            s, 
            DISP_BGND_BLACK+DISP_FGND_WHITE );


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
        OSTimeDlyHMSM(0, 0, 1, 0);  //等待
        //OSTimeDly(100);
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
                                                 
        PC_DispChar(x, y,       //在x，y位置显示s中的字符
            *(char*)pdata, 
            DISP_BGND_BLACK+DISP_FGND_WHITE );
        x += 1;                         

        //OSTimeDlyHMSM(0, 0, 1, 0);  //等待
        OSTimeDly(400);
    }
}



// void  InterTask (void *pdata)
// {
// #if OS_CRITICAL_METHOD == 3
//     OS_CPU_SR  cpu_sr;
// #endif

//     pdata = pdata; 

//     for (;;) 
//     {    
//         if(InterKey)
//         {
//             if (x>50) 
//             {
//                x=0;
//                y+=2; 
//             }
                                                     
//             PC_DispChar(x, y,       //在x，y位置显示s中的字符
//                 *(char*)pdata, 
//                 DISP_BGND_BLACK+DISP_FGND_WHITE );

//             PC_DispStr(5,6,ss,
//                 DISP_BGND_BLACK+DISP_FGND_WHITE);
//             x += 1;                       
//         }    

//         InterKey = FALSE;
//         //OSIntNesting--;
//         OSTimeDlyHMSM(0, 0, 1, 0);  //等待
//     }
// }

