select distinct t.轮胎类型 from tyre_temp t where t.轮胎类型
 
select * from BM_TIRESINFOGD t2 where t2.tiresno in ('9999','25159-33')
select * from BM_TIRESTYPEGD
select distinct t4.轮胎类型 from tyre_temp t4 group by t4.轮胎类型
select * from mcbusinfogs

update tyre_temp t3 set t3.组织id=(select b.orgid from mcbusinfogs b where b.busselfid=t3.车号)

select * from tyre_temp tt where tt.车号=16206 for update
select tt.轮胎编号,count(1) from tyre_temp tt group by tt.轮胎编号 having count(tt.轮胎编号)>1;
update BM_TIRESINFOGD t1 set t1.orgid=(select b1.组织id from tyre_temp b1 where b1.轮胎编号=t1.tiresno)
update tyre_temp tt set tt.轮胎编号='16206-18' where tt.轮胎编号='12161-14'

select * from BM_TIRESINFOGD t  where t.tiresno in ('16206-12',
'16206-13',
'12048-9',
'12110-12',
'12161-14',
'16206-15'
) for update
where t.orgid is null 

select distinct tt.车号 from tyre_temp tt
where tt.轮胎编号 in (select  t.tiresno from BM_TIRESINFOGD t 
where t.orgid is null );


/*delete from BM_TIRESINFOGD
insert into bm_tiresinfogd t (t.tiresid,t.tiresno,t.initializedate,t.startmile,price) 
select  pzh_seq.nextval,t1.轮胎编号,to_date(t1.开始计算日期,'yyyy-mm-dd'),t1.已使用里程,t1.价格 from tyre_temp t1*/

/*select pzh_seq.nextval,t1.轮胎编号 from tyre_temp t1
update tyre_temp ty set ty.已使用里程=0 where ty.已使用里程<0*/
select * from mcbusinfogs b where b.busselfid like '15%'
select b.cardid,substr(b.cardid,3) from mcbusinfogs b where b.busselfid like '%柯斯达%';
update mcbusinfogs b set b.busselfid=substr(b.cardid,3) where b.busselfid like '%柯斯达%';
select t.车号 from  tyre_temp t group by t.车号 having count(t.车号)<6 and count(t.车号)>4
select * from tyre_temp t where t.车号 in ('16306',
'25151'
);

update BM_TIRESINFOGD t set t.retain1=(select t1.车号 from tyre_temp t1 where t1.轮胎编号=t.tiresno);
update BM_TIRESINFOGD t set t.retain2=(select b.busid from mcbusinfogs b where b.busselfid=t.retain1);
select * from BM_TIRESINFOGD
select * from BM_RBUSTIRESGD;
insert into BM_RBUSTIRESGD t (t.bustinesid,t.busid,t.tiresid) select pzh_seq.nextval,t1.retain2,t1.tiresid from BM_TIRESINFOGD t1
