------��Ʒ��ˮ��
select * from mm_stockbillgd;--��潻�׵�
select * from mm_stockbilldetailgd;---��潻�׵�����
select * from Mm_Outpricegd;--�ƻ���

select temp.stockbillno,temp.verifydate,temp.outprice,temp.materialid,temp.materialname,temp.standardinfo,
temp.unit,temp.ckcount,temp.rkcount,temp.historycount,
case when temp.lp-temp.op>=0 then (temp.lp-temp.op)*temp.historycount else null end dr,
case when temp.op-temp.lp>=0 then (temp.op-temp.lp)*temp.historycount else null end dc,
  temp.suppliername,temp.empname
from 
(select s.stockbillno stockbillno,--��浥��
s.verifydate verifydate,--ҵ������
p.outprice outprice,--�ƻ��۸�
sd.materialid materialid,--���ʱ���
m.materialname materialname,--��������
m.standardinfo standardinfo,--����ͺ�
m.unit unit,--��λ
case when s.billtype=1 then sd.count else 0 end ckcount,--��������
case when s.billtype=2 then sd.count else 0 end rkcount,--�������
sd.historycount historycount,--��ʷ���
case when (select p.outprice from mm_outpricegd p 
  where p.enddate>=date'&edate' and p.startdate<=date'&edate' and p.materialid='&mid' and p.verifystatus=2) is not null
  then (select p.outprice from mm_outpricegd p 
    where p.enddate>=date'&edate' and p.startdate<=date'&edate' and p.materialid='&mid' and p.verifystatus=2) else null end lp,--���¼۸����������ѡ�ڼ���Ϊ��
case when (select p.outprice from mm_outpricegd p 
  where p.enddate>=date'&edate' and p.startdate<=date'&edate'and p.materialid='&mid' and p.verifystatus=2) is not null
  then (select t.price from��select dense_rank() over (order by p.enddate desc) dates,p.outprice price,p.enddate from mm_outpricegd p 
where p.materialid='&mid' and p.verifystatus=2��t where t.dates=2) else null end op,--�ϴμ۸����������ѡ�ڼ���Ϊ��
s.supplierid supplierid,--��Ӧ��id
sp.suppliername suppliername,--��Ӧ������ ���������������Ϊ��
s.businessman businessman,--ҵ����Աid
e.empname empname--ҵ����Ա����
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
where p.enddate>=date'&edate' and p.startdate<=date'&edate'  and p.materialid='&mid' and p.verifystatus=2)) temp --��������;
order by temp.verifydate

select p.outprice from mm_outpricegd p where p.enddate>=date'&edate' and p.startdate<=date'&edate'
select t.price from��select dense_rank() over (order by p.enddate desc) dates,p.outprice price,p.enddate from mm_outpricegd p 
where p.materialid='&mid' and p.verifystatus=2��t where t.dates=2

select * from mm_warehousegd
