select * from fdisbusrunrecgd f where f.rundatadate=date'2015-12-17' and f.routeid=1;--车次表
select f.isconfirm from fdisdisplanld f where f.rundate=date'2015-12-17' and f.routeid=27 and f.bussid in ('9','41','42','43')
select * from mcrouteinfogs;--线路表
select * from typeentry t where t.typename like '%BUSSID%';

select b.busselfid,b.cardid,b.startmile,s.mile,s.gpsmile,b.startmile+s.mile from (select f.busselfid busselfid,sum(f.milenum) mile,sum(f.gpsmile) gpsmile  from fdisbusrunrecgd f
where f.rundatadate between date'2015-11-1' and date'2015-11-30' group by f.busselfid) s,mcbusinfogs b 
where b.busselfid=s.busselfid(+)


select temp.cardid,
       temp.drivername,
       temp.routename,
       temp.jccsj,
       temp.yysj,
       temp.gzsj-temp.jccsj-temp.yysj-temp.jysj-temp.qtsj jxsj,
       temp.jysj,
       temp.qtsj
 from (select e.cardid cardid,
       r.routename routename,
       f.drivername drivername,
       sum(case when t.itemkey='进场' or t.itemkey='出场' then f.realarrivettime-f.realleavetime else 0 end)*24*60 jccsj,
       sum(case when t.itemkey='上行' or t.itemkey='下行' then f.realarrivettime-f.realleavetime else 0 end)*24*60 yysj,
       sum(case when t.itemkey='加油' then f.realarrivettime-f.realleavetime else 0 end)*24*60 jysj,
       sum(case when t.itemkey not in ('进场','出场','上行','下行','加油') then f.realarrivettime-f.realleavetime else 0 end)*24*60 qtsj,
       (max(f.realarrivettime)-min(f.realleavetime))*24*60 gzsj
  from fdisdisplanld f, mcemployeeinfogs e, mcrouteinfogs r, typeentry t
 where f.routeid = r.routeid(+)
   and f.driverid = e.empid(+)
   and f.bussid = t.itemvalue(+)
   and t.typename = 'BUSSID'
   and f.routeid = 27
   and f.isconfirm = 1
   and f.rundate = date '2015-12-17'
   group by e.cardid,
       r.routename,
       f.drivername) temp
          --全部车次表
