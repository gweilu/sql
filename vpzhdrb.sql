create or replace view vpzhdrb as
select rb.orgname 单位,
       rb.routename 路别,
       to_number(rb.routelength) 线路长度,
       rb.routestname || '-' || rb.routeedname  起止地,
       round(rb.busnumber,0)  配车,
       round(rb.planpbzb,1） 日计划配车正班,
       round(rb.planpbrq,1) 日计划配车日勤,
       round(rb.planpbzb,1)+round(rb.planpbrq,1)  日计划配车合计，
       round(rb.clnum,1)  圈数,
       round(rb.planbczb,1)  日计划班次正班,
       round(rb.planbcrq,1)  日计划班次日勤,
       round(rb.planbczb+ rb.planbcrq,1)  日计划班次合计,
       round(rb.realbczb,1)  日实际班次正班,
       round(rb.realbcrq,1)  日实际班次日勤,
       round((rb.realbczb+rb.realbcrq),1)  日实际班次合计,
       round((rb.realbczb-rb.planbczb),1)  实际较计划增减正班,
       round((rb.realbcrq-rb.planbcrq),1)  实际较计划增减日勤,
       round((rb.realbczb-rb.planbczb),1)+round((rb.realbcrq-rb.planbcrq),1)实际较计划增减合计,
       round((select sum(r.realbczb) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),1) 累计班次正班,
       round((select sum(r.realbcrq) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),1) 累计班次日勤,
       round((select sum(r.realbczb) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),2) +round((select sum(r.realbcrq) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate),2) 累计班次合计,
       rb.mails 日公里,
       (select sum(r.mails) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(rb.recorddate,'mm') and rb.recorddate) 累计公里,
       ys.kpje 当日客票,
       ys.dhjje 当日IC卡,
       ys.kpje+ys.dhjje 当日合计,
       (select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) 累计客票,
       (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) 累计IC卡,
       (select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate)+ (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate) 累计合计,
       round((ys.kpje+ys.dhjje)/rb.mails*100,2) 当日单位收入,
       round(((select sum(y.kpje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate)+ (select sum(y.dhjje) from pzhys y where y.routeid=ys.routeid and y.operationdate between trunc(y.operationdate,'mm') and ys.operationdate))/(select sum(r.mails) from pzhdrb r where r.routeid=rb.routeid and r.recorddate between trunc(r.recorddate,'mm') and rb.recorddate)*100,2) 平均单位收入,

       rb.recorddate 记录日期
  from pzhdrb rb,  pzhys ys
  where rb.routeid=ys.routeid(+) and to_date(rb.recorddate)=to_date(ys.operationdate(+))
    order by rb.orgid, rb.routename;
