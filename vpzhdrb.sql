create or replace view vpzhdrb as
select rb.orgname ��λ,
       rb.routename ·��,
       to_number(rb.routelength) ��·����,
       rb.routestname || '-' || rb.routeedname  ��ֹ��,
       round(rb.busnumber,0)  �䳵,
       round(rb.planpbzb,1�� �ռƻ��䳵����,
       round(rb.planpbrq,1) �ռƻ��䳵����,
       round(rb.planpbzb,1)+round(rb.planpbrq,1)  �ռƻ��䳵�ϼƣ�
       round(rb.clnum,1)  Ȧ��,
       round(rb.planbczb,1)  �ռƻ��������,
       round(rb.planbcrq,1)  �ռƻ��������,
       round(rb.planbczb+ rb.planbcrq,1)  �ռƻ���κϼ�,
       round(rb.realbczb,1)  ��ʵ�ʰ������,
       round(rb.realbcrq,1)  ��ʵ�ʰ������,
       round((rb.realbczb+rb.realbcrq),1)  ��ʵ�ʰ�κϼ�,
       round((rb.realbczb-rb.planbczb),1)  ʵ�ʽϼƻ���������,
       round((rb.realbcrq-rb.planbcrq),1)  ʵ�ʽϼƻ���������,
       round((rb.realbczb-rb.planbczb),1)+round((rb.realbcrq-rb.planbcrq),1)ʵ�ʽϼƻ������ϼ�,
       round((select sum(r.realbczb) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),1) �ۼư������,
       round((select sum(r.realbcrq) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),1) �ۼư������,
       round((select sum(r.realbczb) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),2) +round((select sum(r.realbcrq) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),2) �ۼư�κϼ�,
       rb.mails �չ���,
       (select sum(r.mails) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate) �ۼƹ���,
       ys.kpje ���տ�Ʊ,
       ys.dhjje ����IC��,
       ys.kpje+ys.dhjje ���պϼ�,
       (select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) �ۼƿ�Ʊ,
       (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) �ۼ�IC��,
       (select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate)+ (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) �ۼƺϼ�,
       round((ys.kpje+ys.dhjje)/rb.mails*100,2) ���յ�λ����,
       round(((select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate)+ (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate))/(select sum(r.mails) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(r.recorddate,'mm') and rb.recorddate)*100,2) ƽ����λ����,

       rb.recorddate ��¼����
  from pzhdrb rb,  pzhys ys
  where rb.routeid=ys.routeid(+) and to_date(rb.recorddate)=to_date(ys.operationdate(+))
    order by rb.orgid, rb.routename;
