/*
��������OVER()
���ã�ר�����ڽ�����ӱ���ͳ������Ĺ���ǿ��ĺ�����
�������������н��з���Ȼ�����������ĳ��ͳ��ֵ������ÿһ���ÿһ�ж����Է���һ��ͳ��ֵ��
*/
--ʾ������ÿһ����ʻԱΪһС�����ݣ��ҳ�����������gpsmile���ֵ�� 
---max��sum��rank��first_value�Ⱥ������������ʹ��
SELECT f.routeid,f.busselfid,f.drivername,
MAX(f.gpsmile) OVER(PARTITION BY f.busselfid ) mile
  FROM FDISDISPLANLD F
 WHERE F.RUNDATE = TRUNC(SYSDATE)
   AND F.ROUTEID = '320030' AND f.isactive=1 AND f.rectype=1;
