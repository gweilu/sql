/*oracle 两个时间相减默认的是天数
Oracle 两个时间相减默认的是天数*24 为相差的小时数
oracle 两个时间相减默认的是天数*24*60 为相差的分钟数
oracle 两个时间相减默认的是天数*24*60*60 为相差的秒数*/
---------------按照时间点计算年间隔
SELECT EXTRACT(YEAR FROM TRUNC(SYSDATE)) -
       EXTRACT(YEAR FROM TO_DATE('2016-04-30', 'yyyy-mm-dd'))
  FROM DUAL;
--MONTHS_BETWEEN(date2,date1) 
给出date2-date1的月份 
SQL> select months_between('19-12月-1999','19-3月-1999') mon_between from dual; 

MON_BETWEEN 
----------- 
  9 
SQL>select months_between(to_date('2000.05.20','yyyy.mm.dd'),to_date('2005.05.20','yyyy.dd')) mon_betw from dual; 

MON_BETW 
--------- 
-60 

Oracle计算时间差表达式 

--获取两时间的相差豪秒数 
select ceil((To_date('2008-05-02 00:00:00' , 'yyyy-mm-dd hh24-mi-ss') - To_date('2008-04-30 23:59:59' , 'yyyy-mm-dd hh24-mi-ss')) * 24 * 60 * 60 * 1000) 相差豪秒数 FROM DUAL; 
/* 
相差豪秒数 
---------- 
  86401000 
1 row selected 
*/ 

--获取两时间的相差秒数 
select ceil((To_date('2008-05-02 00:00:00' , 'yyyy-mm-dd hh24-mi-ss') - To_date('2008-04-30 23:59:59' , 'yyyy-mm-dd hh24-mi-ss')) * 24 * 60 * 60) 相差秒数 FROM DUAL; 
/* 
相差秒数 
---------- 
     86401 
1 row selected 
*/ 

--获取两时间的相差分钟数 
select ceil(((To_date('2008-05-02 00:00:00' , 'yyyy-mm-dd hh24-mi-ss') - To_date('2008-04-30 23:59:59' , 'yyyy-mm-dd hh24-mi-ss'))) * 24 * 60)  相差分钟数 FROM DUAL; 
/* 
相差分钟数 
---------- 
      1441 
1 row selected 
*/ 

--获取两时间的相差小时数 
select ceil((To_date('2008-05-02 00:00:00' , 'yyyy-mm-dd hh24-mi-ss') - To_date('2008-04-30 23:59:59' , 'yyyy-mm-dd hh24-mi-ss')) * 24)  相差小时数 FROM DUAL; 
/* 
相差小时数 
---------- 
        25 
1 row selected 
*/ 

--获取两时间的相差天数 
select ceil((To_date('2008-05-02 00:00:00' , 'yyyy-mm-dd hh24-mi-ss') - To_date('2008-04-30 23:59:59' , 'yyyy-mm-dd hh24-mi-ss')))  相差天数 FROM DUAL; 
/* 
相差天数 
---------- 
         2 
1 row selected 
*/ 

