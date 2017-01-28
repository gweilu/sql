/*
分析函数OVER()
作用：专门用于解决复杂报表统计需求的功能强大的函数，
它可以在数据中进行分组然后计算基于组的某种统计值，并且每一组的每一行都可以返回一个统计值。
*/
--示例：以每一个驾驶员为一小组数据，找出这组数据中gpsmile最大值， 
---max，sum，rank，first_value等函数都可以组合使用
SELECT f.routeid,f.busselfid,f.drivername,
MAX(f.gpsmile) OVER(PARTITION BY f.busselfid ) mile
  FROM FDISDISPLANLD F
 WHERE F.RUNDATE = TRUNC(SYSDATE)
   AND F.ROUTEID = '320030' AND f.isactive=1 AND f.rectype=1;
