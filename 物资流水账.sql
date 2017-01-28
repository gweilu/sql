------商品流水账
select * from mm_stockbillgd;--库存交易单
select * from mm_stockbilldetailgd;---库存交易单详情
select * from Mm_Outpricegd;--计划价

select temp.stockbillno,temp.verifydate,temp.outprice,temp.materialid,temp.materialname,temp.standardinfo,
temp.unit,temp.ckcount,temp.rkcount,temp.historycount,
case when temp.lp-temp.op>=0 then (temp.lp-temp.op)*temp.historycount else null end dr,
case when temp.op-temp.lp>=0 then (temp.op-temp.lp)*temp.historycount else null end dc,
  temp.suppliername,temp.empname
from 
(select s.stockbillno stockbillno,--库存单号
s.verifydate verifydate,--业务日期
p.outprice outprice,--计划价格
sd.materialid materialid,--物资编码
m.materialname materialname,--物资名称
m.standardinfo standardinfo,--规格型号
m.unit unit,--单位
case when s.billtype=1 then sd.count else 0 end ckcount,--出库数量
case when s.billtype=2 then sd.count else 0 end rkcount,--入库数量
sd.historycount historycount,--历史库存
case when (select p.outprice from mm_outpricegd p 
  where p.enddate>=date'&edate' and p.startdate<=date'&edate' and p.materialid='&mid' and p.verifystatus=2) is not null
  then (select p.outprice from mm_outpricegd p 
    where p.enddate>=date'&edate' and p.startdate<=date'&edate' and p.materialid='&mid' and p.verifystatus=2) else null end lp,--最新价格如果不在所选期间则为空
case when (select p.outprice from mm_outpricegd p 
  where p.enddate>=date'&edate' and p.startdate<=date'&edate'and p.materialid='&mid' and p.verifystatus=2) is not null
  then (select t.price from（select dense_rank() over (order by p.enddate desc) dates,p.outprice price,p.enddate from mm_outpricegd p 
where p.materialid='&mid' and p.verifystatus=2）t where t.dates=2) else null end op,--上次价格如果不在所选期间则为空
s.supplierid supplierid,--供应商id
sp.suppliername suppliername,--供应商名称 如果不启用批次则为空
s.businessman businessman,--业务人员id
e.empname empname--业务人员姓名
from mm_stockbillgd s,
mm_stockbilldetailgd sd,
mm_outpricegd p,
mm_suppliergd sp,
mm_materialgd m,
mcemployeeinfogs e
where sd.stockbillid=s.stockbillid(+) and
sd.materialid=p.materialid(+) and
sd.supplierid=sp.supplierid(+) and
sd.materialid=m.materialid(+) and
s.businessman=e.empid(+) and
sd.materialid='&mid' and 
s.verifydate between date'&sdate' and date'&edate' and
s.issuewarehouse='&warehouse' or s.acceptwarehouse='&warehouse' and
p.outprice=(select p.outprice from mm_outpricegd p 
where p.enddate>=date'&edate' and p.startdate<=date'&edate'  and p.materialid='&mid' and p.verifystatus=2)) temp --基础数据;
order by temp.verifydate

select p.outprice from mm_outpricegd p where p.enddate>=date'&edate' and p.startdate<=date'&edate'
select t.price from（select dense_rank() over (order by p.enddate desc) dates,p.outprice price,p.enddate from mm_outpricegd p 
where p.materialid='&mid' and p.verifystatus=2）t where t.dates=2

select * from mm_warehousegd
