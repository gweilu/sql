select * from mcemployeeinfogs e where e.cardid='100597';--人员信息表
select * from BFARETKACNT b where b.operator='55150410164100826' and b.paydate=date'2015-12-16';--票房流水账
select * from BFARETKACNTDETAIL bd where bd.tkacntid='55151216121645231478';--票房流水账明细
select * from mcorginfogs o where o.orgid='55150213101909182001';--组织表
select * from mcrorgroutegs;--组织线路关系表

select ro b.routeid,bd.tkclasscode,to_char(b.paydate,'dd'),sum(bd.money) 
from BFARETKACNT b,BFARETKACNTDETAIL bd,mcorginfogs o ,mcrouteinfogs ro
where bd.tkacntid=b.tkacntid(+) 
and b.orgid=o.orgid(+)
and b.routeid=ro.routeid(+)
and b.paydate=date'2015-12-06'
group by b.routeid,bd.tkclasscode,b.paydate
order by b.routeid;
