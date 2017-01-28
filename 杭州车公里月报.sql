select * from typeentry t where t.typename like '%BUSSID%';
--实际运行车辆公里
select f.routeid,
       f.busselfid,
       sum(f.milenum) summile,
       sum(case
             when f.rectype = 1 or f.busid = '14' then
              f.milenum
             else
              0
           end) opmile,
       sum(f.gpsmile) sumgps,
       sum(case
             when f.rectype = 1 or f.busid = '14' then
              f.gpsmile
             else
              0
           end) opgps
  from fdisdisplanld f
 where f.rundate between date '2016-4-1' and date '2016-4-30'
   and f.isconfirm = 1
 group by f.routeid, f.busselfid;

/*select * from fdisdisplanld f where f.rectype=2 and f.bussid!=14 and  f.rundate between date '2016-4-1' and date '2016-4-30' and f.isconfirm=1
*/

---计划车辆公里

select t1.routeid, t1.busid, t1.opsum, t2.uopsum, t1.opsum + t2.uopsum
  from (select a.routeid, a.busid, sum(a.mileage) opsum
          from ASGNARRANGESEQGD a, asgnarrangegd s
         where a.arrangeid = s.arrangeid(+)
           and s.execdate between trunc(date'&dates', 'month') and date
         '2016-5-30'
           and s.status = 'd'
           and s.routeid = '320030'
         group by a.routeid, a.busid) t1,
       (select aun.routeid, aw.busid, sum(aun.actionmile) uopsum
          from asgnarrangesequntrancegd aun, asgnarrangewshiftld aw
         where aun.arrangewshiftid = aw.arrangewsid(+)
           and aun.execdate between trunc(date'&dates', 'month') and date
         '2016-5-30'
           and aun.routeid = '320030'
         group by aun.routeid, aw.busid) t2
 where t1.routeid = t2.routeid
   and t1.busid = t2.busid

-----------合并
select *
  from (select t1.routeid,
               t1.busid,
               t1.tdopsum,
               t1.mopsum,
               t1.tdopsum + t2.tduopsum,  --计划总里程
               t1.mopsum + t2.muopsum  --计划总里程月累计
          from (select a.routeid,
                       a.busid,
                       sum(case
                             when s.execdate = date'&dates' then
                              a.mileage
                             else
                              0
                           end) tdopsum,  --计划载客里程
                       sum(case
                             when s.execdate between trunc(date'&dates', 'month') and date'&dates' then
                              a.mileage
                             else
                              0
                           end) mopsum  --计划载客里程月累计
                  from ASGNARRANGESEQGD a, asgnarrangegd s
                 where a.arrangeid = s.arrangeid(+)
                   and s.execdate between trunc(date'&dates', 'month') and date'&dates'
                   and s.status = 'd'
                   and s.routeid in ('&routeid')
                 group by a.routeid, a.busid) t1,
               (select aun.routeid,
                       aw.busid,
                       sum(case
                             when aun.execdate = date'&dates' then
                              aun.actionmile
                             else
                              0
                           end) tduopsum,  --计划非运营里程
                       sum(case
                             when aun.execdate between trunc(date'&dates', 'month') and date'&dates' then
                              aun.actionmile
                             else
                              0
                           end) muopsum  --计划非运营里程月累计
                  from asgnarrangesequntrancegd aun, asgnarrangewshiftld aw
                 where aun.arrangewshiftid = aw.arrangewsid(+)
                   and aun.execdate between trunc(date'&dates', 'month') and date'&dates'
                   and aun.routeid in (&routeid)
                 group by aun.routeid, aw.busid) t2
         where t1.routeid = t2.routeid
           and t1.busid = t2.busid) a,
       (select r.routename,f.busselfid,
       f.routeid,
               f.busid,
               sum(case
                     when f.rundate = date'&dates' then
                      f.milenum
                     else
                      0
                   end) tdsummile,    ---今日实际总里程
               sum(case
                     when f.rundate between trunc(date'&dates', 'month') and date'&dates' then
                      f.milenum
                     else
                      0
                   end) msummile,  --实际总里程月累计
               sum(case
                     when f.rectype = 1 or
                          f.busid = '14' and f.rundate = date'&dates' then
                      f.milenum
                     else
                      0
                   end) tdopmile,   ---实际营运今日里程
               sum(case
                     when f.rectype = 1 or
                          f.busid = '14' and
                          (f.rundate between trunc(date'&dates', 'month') and date'&dates') then
                      f.milenum
                     else
                      0
                   end) mopmile,  --营运里程月累计
               sum(case
                     when f.rundate = date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) tdgpsmile,  --总gps里程今日
               sum(case
                     when f.rundate between trunc(date'&dates', 'month') and date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) mgpsmile,  --总gps里程月累计
               sum(case
                     when f.rectype = 1 or f.busid = '14' and f.rundate = date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) tdopgps,  --营运gps里程日
               sum(case
                     when f.rectype = 1 or
                          f.busid = '14' and
                          (f.rundate between trunc(date'&dates', 'month') and date'&dates') then
                      f.gpsmile
                     else
                      0
                   end) mopgps   --营运gps里程月累计
          from fdisdisplanld f,mcrouteinfogs r
         where f.routeid=r.routeid(+) and
         f.rundate between trunc(date'&dates', 'month') and date'&dates'
           and f.isconfirm = 1 and f.routeid in (&routeid)
         group by f.routeid, f.busid) b
 where b.busid = a.busid(+) and b.busid = nvl('&busid',b.busid)
 ----------------------------------------------------------------------------------------------------
 select *
  from (select t1.routeid,
               t1.busid,
               t1.tdopsum,
               t1.mopsum,
               t1.tdopsum + t2.tduopsum,
               t1.mopsum + t2.muopsum
          from (select a.routeid,
                       a.busid,
                       sum(case
                             when s.execdate = date'&dates' then
                              a.mileage
                             else
                              0
                           end) tdopsum,
                       sum(case
                             when s.execdate between trunc(date'&dates', 'month') and date'&dates' then
                              a.mileage
                             else
                              0
                           end) mopsum
                  from ASGNARRANGESEQGD a, asgnarrangegd s
                 where a.arrangeid = s.arrangeid(+)
                   and s.execdate between trunc(date'&dates', 'month') and date'&dates'
                   and s.status = 'd'
                   and s.routeid in ('&routeid')
                 group by a.routeid, a.busid) t1,
               (select aun.routeid,
                       aw.busid,
                       sum(case
                             when aun.execdate = date'&dates' then
                              aun.actionmile
                             else
                              0
                           end) tduopsum,
                       sum(case
                             when aun.execdate between trunc(date'&dates', 'month') and date'&dates' then
                              aun.actionmile
                             else
                              0
                           end) muopsum
                  from asgnarrangesequntrancegd aun, asgnarrangewshiftld aw
                 where aun.arrangewshiftid = aw.arrangewsid(+)
                   and aun.execdate between trunc(date'&dates', 'month') and date'&dates'
                   and aun.routeid in ('&routeid')
                 group by aun.routeid, aw.busid) t2
         where t1.routeid = t2.routeid
           and t1.busid = t2.busid) a,
       (select r.routename,
	       f.routeid,
               f.busid,
	       f.busselfid,
               sum(case
                     when f.rundate = date'&dates' then
                      f.milenum
                     else
                      0
                   end) tdsummile,
               sum(case
                     when f.rundate between trunc(date'&dates', 'month') and date'&dates' then
                      f.milenum
                     else
                      0
                   end) msummile,
               sum(case
                     when (f.rectype = 1 or
                          f.busid = '14') and f.rundate = date'&dates' then
                      f.milenum
                     else
                      0
                   end) tdopmile,
               sum(case
                     when f.rectype = 1 or
                          f.busid = '14' and
                          (f.rundate between trunc(date'&dates', 'month') and date'&dates') then
                      f.milenum
                     else
                      0
                   end) mopmile,
               sum(case
                     when f.rundate = date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) tdgpsmile,
               sum(case
                     when f.rundate between trunc(date'&dates', 'month') and date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) mgpsmile,
               sum(case
                     when (f.rectype = 1 or f.busid = '14') and f.rundate = date'&dates' then
                      f.gpsmile
                     else
                      0
                   end) tdopgps,
               sum(case
                     when f.rectype = 1 or
                          f.busid = '14' and
                          (f.rundate between trunc(date'&dates', 'month') and date'&dates') then
                      f.gpsmile
                     else
                      0
                   end) mopgps
          from fdisdisplanld f,mcrouteinfogs r
         where f.routeid=r.routeid(+) and f.rundate between trunc(date'&dates', 'month') and date'&dates'
           and f.isconfirm = 1 and f.routeid in ('&routeid')
         group by f.routeid, f.busid,f.busselfid,r.routename) b
 where b.busid = a.busid(+) and b.busid = nvl('&busid',b.busid)
 ----------------------------------------------------------------------------------------------------       
          select *
                  from mcrouteinfogs r
                 where r.routeid = '320030';
                select trunc(date'&dates', 'month') from dual
                select date'&dates' from dual
                  select * from schplansequntrancegd; --非营运计划表
select * from asgnarrangegd s where s.routeid = '329820'; --排班表
select * from ASGNARRANGESEQGD a where a.routeid = '329820'; --排班详细表
select * from asgnarrangesequntrancegd ass where ass.routeid = '329820'; --非营运排班表
select *
  from asgnarrangewshiftld aw
 where aw.arrangewsid = '16051511594059690552'; ----劳动班次表 存储班次对应的人车信息
