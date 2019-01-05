//�������������ɵ���ʵ��3-6,3-7
#include "includes.h"

#define  TASK_STK_SIZE   512			//�����ջ����

OS_STK   MyTaskStk[TASK_STK_SIZE];       //���������ջ��
OS_STK   YouTaskStk[TASK_STK_SIZE];		//���������ջ��
INT16S   key;					//�����˳�uCOS_II�ļ�	
INT8U	 x=0,y=0;				//�ַ���ʾλ��

void  MyTask2(void *data);           //����һ������

void  YouTask2(void *data);			//����һ������

void  MyTask(void *data);           //����һ����������������ĺ���
void  YouTask(void *data);          //����һ������
void  TaskInit(void);
/************************������*********************************************/
void  main (void)
{
    //��������ܹ�����һ������----------------------------------------
    // char* s="M";                //����Ҫ��ʾ���ַ�

    // OSInit();                   //��ʼ��uCOS_II

    // PC_DOSSaveReturn();             //����Dos����
    // PC_VectSet(uCOS, OSCtxSw);          //��װuCOS_II�ж�

    // OSTaskCreate(MyTask2,            //��������MyTask
    //     s,              //�����񴫵ݲ���
    //     &MyTaskStk[TASK_STK_SIZE - 1],//���������ջջ��ָ��
    //     0);             //ʹ����MyTask�����ȼ���Ϊ0

    // OSStart();                  //����uCOS_II�Ķ��������

    /*--------------------------------------
    *���Ƕ��������ȼ����������ȼ���û�в������ã����ǣ���һ�����񲻶϶�
    ���ǵ�ϵͳһ��Ĳ����������ã������������ġ�
    */
    char* s_m="M";                //����Ҫ��ʾ���ַ�
    char* s_y="Y";				//����Ҫ��ʾ���ַ�

    OSInit();					//��ʼ��uCOS_II

    PC_DOSSaveReturn();				//����Dos����
    PC_VectSet(uCOS, OSCtxSw);			//��װuCOS_II�ж�

    //TaskInit();
    OSTaskCreate(YouTask2,            //��������MyTask
        s_y,              //�����񴫵ݲ���
        &YouTaskStk[TASK_STK_SIZE - 1],//���������ջջ��ָ��
        2);             //ʹ����YouTask�����ȼ���Ϊ2

    OSTaskCreate(MyTask2,            //��������MyTask
        s_m,              //�����񴫵ݲ���
        &MyTaskStk[TASK_STK_SIZE - 1],//���������ջջ��ָ��
        3);             //ʹ����MyTask�����ȼ���Ϊ0
    OSStart();					//����uCOS_II�Ķ��������
}

/*
�����ѳ�ʼ���Ĺ����ó���
*/
void TaskInit()
{
    #if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
    #endif
    OS_ENTER_CRITICAL(); 
    PC_VectSet(0x08, OSTickISR);    //��װuCOS_IIʱ���ж�����
    PC_SetTickRate(OS_TICKS_PER_SEC);   //����uCOS_IIʱ��Ƶ��
    OS_EXIT_CRITICAL();

    OSStatInit();           //��ʼ��uCOS_II��ͳ������
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
                                                 
        PC_DispChar(x, y,       //��x��yλ����ʾs�е��ַ�
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
            x += 1;                         

        //�������Esc�����˳�uCOS_II
        if (PC_GetKey(&key) == TRUE) 
        {
            if (key == 0x1B) 
        {
                PC_DOSReturn();
            }
        }

        OSTimeDlyHMSM(0, 0, 1, 0);  //�ȴ�
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
                                                 
        PC_DispChar(x, y,       //��x��yλ����ʾs�е��ַ�
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
            x += 1;                         

        OSTimeDlyHMSM(0, 0, 1, 0);  //�ȴ�
    }
}


/**
*-------------------------------------------------------------
 ��������������һ������
*/

void  MyTask (void *pdata)
{
    char *s = "Y";
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    OS_ENTER_CRITICAL();
    PC_VectSet(0x08, OSTickISR);    //��װuCOS_IIʱ���ж�����
    PC_SetTickRate(OS_TICKS_PER_SEC);   //����uCOS_IIʱ��Ƶ��
    OS_EXIT_CRITICAL();

    OSStatInit();           //��ʼ��uCOS_II��ͳ������

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
                                                 
        PC_DispChar(x, y,       //��x��yλ����ʾs�е��ַ�
        *(char*)pdata, 
        DISP_BGND_BLACK+DISP_FGND_WHITE );
            x += 1;                         

        //�������Esc�����˳�uCOS_II
        if (PC_GetKey(&key) == TRUE) 
        {
            if (key == 0x1B) 
        {
                PC_DOSReturn();
            }
        }

        OSTimeDlyHMSM(0, 0, 3, 0);  //�ȴ�
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
                                                 
        PC_DispChar(x, y,		//��x��yλ����ʾs�е��ַ�
		*(char*)pdata, 
		DISP_BGND_BLACK+DISP_FGND_WHITE );
       		x += 1;                         

        OSTimeDlyHMSM(0, 0, 1, 0);	//�ȴ�
    }
}
