select * from mcemployeeinfogs e; --人员信息表
select * from EMPEXTENDINFO ex; --人员信息扩展表
select * from typeentry t where t.itemkey in ('男','内退人员','离异');
select * from user_tables tb where tb.TABLE_NAME like '%118%';
select * from a_emp1118 a
update a_emp1118 a set a.婚姻状况='离异' where a.婚姻状况='离婚'

update empextendinfo ex set ex.ismarry=(select t3.itemvalue from a_emp1118 a,typeentry t3 
where a.婚姻状况=t3.itemkey(+) and t3.typename='MARRYFLAG' and a.empid=ex.empid)

select o.*,level from mcorginfogs o start with o.orgid='070402000917000' connect by prior o.orgid=o.parentorgid --测试 

select e.cardid,
       op.orgname,
       o.orgname,
       e.empname,
       t1.itemkey,
       e.idcard,
       ex.workstartdate,
       e.startdate,
       t2.itemkey,
       t3.itemkey
  from mcemployeeinfogs e, empextendinfo ex, mcorginfogs o,mcorginfogs op,
  typeentry t1,typeentry t2,typeentry t3
 where e.empid = ex.empid(+)
   and e.orgid = o.orgid(+)
   and o.parentorgid=op.orgid(+)
   and e.sex=t1.itemvalue(+) and t1.typename='SEX' and t1.isactive='1'
   and e.empkind2=t2.itemvalue(+) and t2.typename='POSITIONTYPE' and t2.isactive='1'
   and ex.ismarry=t3.itemvalue(+) and t3.typename='MARRYFLAG' and t3.isactive='1'


