select to_char(trunc(sysdate,'MONTH'),'yyyy-mm-dd') First_DayOfMonth
       ,to_char(last_day(trunc(sysdate,'MONTH')),'yyyy-mm-dd') Last_DayOfMonth 
from dual
--增减月份
select to_char(add_months(to_date('&tdate','yyyy-mm'),-1),'yyyy'),
to_char(add_months(to_date('&tdate','yyyy-mm'),-1),'mm')  from dual;
---本月最后一天
select last_day(trunc(to_date('&tdate','yyyy-mm'),'month')) from dual;
---上月最后一天
select last_day(trunc(add_months(to_date('&tdate','yyyy-mm'),-1),'month'))  from dual;

---本月第一天
select trunc(to_date('&tdate','yyyy-mm'),'month') from dual;
---下月份第一天
select add_months(to_date('&tdate','yyyy-mm'),1) from dual;
日期和字符转换函数用法（to_date,to_char）
        
select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') as nowTime from dual;   //日期转化为字符串  
select to_char(sysdate,'yyyy') as nowYear   from dual;   //获取时间的年  
select to_char(sysdate,'mm')    as nowMonth from dual;   //获取时间的月  
select to_char(sysdate,'dd')    as nowDay    from dual;   //获取时间的日  
select to_char(sysdate,'hh24') as nowHour   from dual;   //获取时间的时  
select to_char(sysdate,'mi')    as nowMinute from dual;   //获取时间的分  
select to_char(sysdate,'ss')    as nowSecond from dual;   //获取时间的秒 
