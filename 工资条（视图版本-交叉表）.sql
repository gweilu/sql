----Project name :工资总表（工资条）
----create by :Robert.Wei
----create tiem :2017-1-14
----describe :从工资总表中取出数据用于工资报表，使用交叉表
SELECT HV.SALARYDATE,
       HV.ORGNAME,
       HV.EMPNAME,
       HV.CARDID,
       HV.SATUS,
       HV.PTYPE,
       HV.SSGNAME,
       HV.SSGENAME,
       HV.VALUE2
  FROM HR_SALARY_BASEVW HV
 WHERE HV.EMPID = NVL('&empid', Hv.EMPID)
   AND HV.SALARYDATE = REPLACE('&dates', '-', '')
   AND HV.EMPPTYPE = NVL('&empptype', Hv.EMPPTYPE)
   AND HV.SSGID = '&ssgid'
   AND HV.ORGID IN (&ORGID)
   ORDER BY hv.Sortno;
-----测试数据
SELECT * FROM HR_SALARY_BASEVW;
--salarydate  :201612
--emptype     :null
--ssgid       :55161011084804287162
--empid       :11130509100129756097
--orgid       :55161114105213246357
