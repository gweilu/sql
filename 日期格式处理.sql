select to_char(trunc(sysdate,'MONTH'),'yyyy-mm-dd') First_DayOfMonth
       ,to_char(last_day(trunc(sysdate,'MONTH')),'yyyy-mm-dd') Last_DayOfMonth 
from dual
--�����·�
select to_char(add_months(to_date('&tdate','yyyy-mm'),-1),'yyyy'),
to_char(add_months(to_date('&tdate','yyyy-mm'),-1),'mm')  from dual;
---�������һ��
select last_day(trunc(to_date('&tdate','yyyy-mm'),'month')) from dual;
---�������һ��
select last_day(trunc(add_months(to_date('&tdate','yyyy-mm'),-1),'month'))  from dual;

---���µ�һ��
select trunc(to_date('&tdate','yyyy-mm'),'month') from dual;
---���·ݵ�һ��
select add_months(to_date('&tdate','yyyy-mm'),1) from dual;
���ں��ַ�ת�������÷���to_date,to_char��
        
select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') as nowTime from dual;   //����ת��Ϊ�ַ���  
select to_char(sysdate,'yyyy') as nowYear   from dual;   //��ȡʱ�����  
select to_char(sysdate,'mm')    as nowMonth from dual;   //��ȡʱ�����  
select to_char(sysdate,'dd')    as nowDay    from dual;   //��ȡʱ�����  
select to_char(sysdate,'hh24') as nowHour   from dual;   //��ȡʱ���ʱ  
select to_char(sysdate,'mi')    as nowMinute from dual;   //��ȡʱ��ķ�  
select to_char(sysdate,'ss')    as nowSecond from dual;   //��ȡʱ����� 
