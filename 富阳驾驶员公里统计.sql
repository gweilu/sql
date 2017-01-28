select *
  from MCROUTEANDMODEL
       
       -----驾驶员公里统计及核算
         select t.driverid,
                e.empname,
                t.routeid,
                t.busselfid,
                b.bustid,
                t.yylc,
                t.fyylc,
                t.yylc + t.fyylc sumlc,
                t.yylc + t.fyylc * 0.8 sumzslc,
                p.route_xs,
                p.model_xs,
                tp.itemstrvalue,
                p.other_xs,
                to_char(date'2016-3-2','YYYY-MM')
           from (select f.driverid,
                        f.routeid,
                        f.busselfid,
                        sum(case
                              when (f.rectype = 1 or f.bussid in (61, 14, 82, 83)) then
                               f.milenum
                              else
                               0
                            end) yylc,
                        sum(case
                              when f.rectype = 2 and
                                   f.bussid not in (61, 14, 82, 83) then
                               f.milenum
                              else
                               0
                            end) fyylc
                   from fdisbusrunrecgd f
                  where f.rundatadate between trunc(date '2016-3-1', 'MONTH') and
                        last_day(trunc(date '2016-3-1', 'MONTH'))
                    and f.isconfirm = 1
                  group by f.driverid, f.routeid, f.busselfid) t,
                mcemployeeinfogs e,
                mcbusinfogs b,
                MCROUTEANDMODEL p,
                typeentry tp
          where t.driverid = e.empid(+)
            and t.busselfid = b.busselfid(+)
            and t.routeid=p.routeid
            and b.bustid=p.modelid
            and p.service_xs=tp.itemvalue
            and tp.typename='ROUTERATE'
            and e.empname like '%钱星火%'
            order by t.driverid,t.routeid,t.busselfid
            
         --------------
           select *
                   from typeentry t
                  where t.typename like '%ROUTERATE%'
                 ------------------
                   select trunc(date '2016-3-2', 'MONTH') First_DayOfMonth,
                          last_day(trunc(date '2016-3-2', 'MONTH')) Last_DayOfMonth
                           from dual
                           
                           select to_char(date'2016-3-2','YYYY-MM') from dual
                          ------------------
                            select sum(f.milenum)
                              from fdisbusrunrecgd f
                             where f.rundatadate between
                                   trunc(date '2016-3-2', 'MONTH') and
                                   last_day(trunc(date '2016-3-1',
                                                  'MONTH'))
                               and f.isconfirm = 1
                               and f.driverid = '11130417093349895002'
                               and /*(f.rectype = 2 and
                                   f.bussid not in (61, 14, 82, 83))*/
                               (f.rectype = 1
                                or f.bussid in (61, 14, 82, 83))

select distinct(m.modelid) from MCROUTEANDMODEL m 
select distinct (b.bustid) from mcbusinfogs b
