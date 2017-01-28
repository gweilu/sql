SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     '201512',
                     SYSDATE,
                     S.EMPID,
                    case when e.orgid in (select o.orgid from mcorginfogs o start with o.orgid='55150213092542050000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092857160000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150203175953844320'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092919062000'
connect by prior o.orgid=o.parentorgid) then 
                      t.v22*1.1*sl.retain1+t.v23
                      else
                        t.v22*1.08*sl.retain1+t.v23
                        end,
                     33,
                     '(管服)绩效工资'               
          FROM HR_EMPLEVELGD          ep,
               HR_SALARYLEVELGD       sl,
               HR_SALARYIMPORTDATAGD  t,
               mcemployeeinfogs       e,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = ep.EMPID
           and s.empid=t.empid
           and t.month='201512'
           and s.empid=e.empid
           and ep.departid=sl.departid 
           and ep.levelid=sl.levelid
           AND S.SSGID = '55160110162142199127'
           AND '201512' BETWEEN S.BEGINDATE AND S.ENDDATE
           and INSTR(',' || '55150410164100637' || ',', ',' || s.EMPID || ',') > 0;
           
select sl.retain1 from  HR_EMPLEVELGD          ep,
               HR_SALARYLEVELGD       sl/*,
               HR_SALARYIMPORTDATAGD  t,
               mcemployeeinfogs       e,
               HR_STAFFSALARYSETSETUPGD S*/
               where ep.departid=sl.departid 
           and ep.levelid=sl.levelid
           
           select * from HR_EMPLEVELGD a where a.empid='55150410164100637';
           select * from HR_SALARYLEVELGD b where b.levelid=2 and b.departid=11 for update;
               
select * from HR_SALARYIMPORTDATAGD t where t.empid='55150410164100637'

select * from mcemployeeinfogs e where e.empid='55150410164100637'

select * from HRMONTHLYRECGD h where h.empid='55150410164100637'
