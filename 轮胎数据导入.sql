select distinct t.��̥���� from tyre_temp t where t.��̥����
 
select * from BM_TIRESINFOGD t2 where t2.tiresno in ('9999','25159-33')
select * from BM_TIRESTYPEGD
select distinct t4.��̥���� from tyre_temp t4 group by t4.��̥����
select * from mcbusinfogs

update tyre_temp t3 set t3.��֯id=(select b.orgid from mcbusinfogs b where b.busselfid=t3.����)

select * from tyre_temp tt where tt.����=16206 for update
select tt.��̥���,count(1) from tyre_temp tt group by tt.��̥��� having count(tt.��̥���)>1;
update BM_TIRESINFOGD t1 set t1.orgid=(select b1.��֯id from tyre_temp b1 where b1.��̥���=t1.tiresno)
update tyre_temp tt set tt.��̥���='16206-18' where tt.��̥���='12161-14'

select * from BM_TIRESINFOGD t  where t.tiresno in ('16206-12',
'16206-13',
'12048-9',
'12110-12',
'12161-14',
'16206-15'
) for update
where t.orgid is null 

select distinct tt.���� from tyre_temp tt
where tt.��̥��� in (select  t.tiresno from BM_TIRESINFOGD t 
where t.orgid is null );


/*delete from BM_TIRESINFOGD
insert into bm_tiresinfogd t (t.tiresid,t.tiresno,t.initializedate,t.startmile,price) 
select  pzh_seq.nextval,t1.��̥���,to_date(t1.��ʼ��������,'yyyy-mm-dd'),t1.��ʹ�����,t1.�۸� from tyre_temp t1*/

/*select pzh_seq.nextval,t1.��̥��� from tyre_temp t1
update tyre_temp ty set ty.��ʹ�����=0 where ty.��ʹ�����<0*/
select * from mcbusinfogs b where b.busselfid like '15%'
select b.cardid,substr(b.cardid,3) from mcbusinfogs b where b.busselfid like '%��˹��%';
update mcbusinfogs b set b.busselfid=substr(b.cardid,3) where b.busselfid like '%��˹��%';
select t.���� from  tyre_temp t group by t.���� having count(t.����)<6 and count(t.����)>4
select * from tyre_temp t where t.���� in ('16306',
'25151'
);

update BM_TIRESINFOGD t set t.retain1=(select t1.���� from tyre_temp t1 where t1.��̥���=t.tiresno);
update BM_TIRESINFOGD t set t.retain2=(select b.busid from mcbusinfogs b where b.busselfid=t.retain1);
select * from BM_TIRESINFOGD
select * from BM_RBUSTIRESGD;
insert into BM_RBUSTIRESGD t (t.bustinesid,t.busid,t.tiresid) select pzh_seq.nextval,t1.retain2,t1.tiresid from BM_TIRESINFOGD t1
