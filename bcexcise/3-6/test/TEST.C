
#include "includes.h"

#define  TASK_STK_SIZE   512			//�����ջ����

OS_STK   TaskStartStk[TASK_STK_SIZE];		//���������ջ��
INT16S   key;					//�����˳�uCOS_II�ļ�	
INT8U	 x=0,y=0;				//�ַ���ʾλ��

void  MyTask(void *data);			//����һ������
/************************������*********************************************/
void  main (void)
{
    char* s="M";				//����Ҫ��ʾ���ַ�

    OSInit();					//��ʼ��uCOS_II

    PC_DOSSaveReturn();				//����Dos����
    PC_VectSet(uCOS, OSCtxSw);			//��װuCOS_II�ж�

    OSTaskCreate(MyTask,			//��������MyTask
		s,				//�����񴫵ݲ���
		&TaskStartStk[TASK_STK_SIZE - 1],//���������ջջ��ָ��
		0);				//ʹ����MyTask�����ȼ���Ϊ0
    OSStart();					//����uCOS_II�Ķ��������
}


void  MyTask (void *pdata)
{
#if OS_CRITICAL_METHOD == 3
    OS_CPU_SR  cpu_sr;
#endif

    pdata = pdata; 

    OS_ENTER_CRITICAL();
    PC_VectSet(0x08, OSTickISR);	//��װuCOS_IIʱ���ж�����
    PC_SetTickRate(OS_TICKS_PER_SEC);	//����uCOS_IIʱ��Ƶ��
    OS_EXIT_CRITICAL();

    OSStatInit();			//��ʼ��uCOS_II��ͳ������

    for (;;) 
	{        
        if (x>10) 
		{
		   x=0;
		   y+=2; 
		}
                                                 
        PC_DispChar(x, y,		//��x��yλ����ʾs�е��ַ�
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

        OSTimeDlyHMSM(0, 0, 1, 0);	//�ȴ�
    }
}
