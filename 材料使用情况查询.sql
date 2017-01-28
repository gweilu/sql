-------------材料使用情况明细
select * from MM_STOCKBILLGD s where s.stockbillno='CK1512040002' is not null;---仓库交易单
select * from mm_stockbilldetailgd;--仓库交易单明细
select * from bm_workordergd w where w.stockbillid is not null;----工单表
select * from BM_WKMATERIALSGD--工单发料管理表
select * from BM_WKMATERIALSITEMGD--用料单详细信息表
select * from typeentry t where t.itemkey like '%维修%'---字典项表

select s.stockbillno,s.verifydate,
case when s.workorderno is null then (select o1.orgname from mcorginfogs o1 where o1.orgid=s.recorgid) else o.orgname end,
case when s.workorderno is null then (select b1.busselfid||b1.cardid from mcbusinfogs b1 where b1.busid=s.busid) else b.busselfid||b.cardid end bus,
case when s.workorderno is null then (select b1.busid from mcbusinfogs b1 where b1.busid=s.busid) else s.busid end busid,
m.materialno,m.materialname,m.standardinfo,mu.measureunitname,sd.count,sd.price,sd.totalsum
from mm_stockbillgd s,
mm_stockbilldetailgd sd,
bm_workordergd w,
mcbusinfogs b,
mm_materialgd m,
MM_MEASUREUNITGD mu,
mcorginfogs o
where s.stockbillid=sd.stockbillid(+)
and s.workorderno=w.workorderno(+) 
and w.busid=b.busid(+)
and sd.materialid=m.materialid(+)
and sd.unit=mu.measureunitid(+)
and w.assignworkshop=o.orgid(+)
and s.billfrom=3
and s.verifydate between date'&sdate' and '&edate'
and sd.supplierid='&supply'
and s.issuewarehouse='&warehose'
and bus='&busid'
and m.materialno='&m'
