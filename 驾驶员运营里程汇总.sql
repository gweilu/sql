---驾驶员运营公里查询
select (select r.routename from mcrouteinfogs r where r.routeid = f.routeid) routename,
       f.drivername,
       f.BUSSELFID,
       sum(case
             when f.rectype = 1 and f.shiftdetailtype = 11 and
                  f.rundatadate = to_date('&tdate', 'yyyy-mm-dd') then
              f.milenum
             else
              0
           end) yy_rq_milenum,
       sum(case
             when f.rectype = 1 and f.shiftdetailtype <> 11 and
                  f.rundatadate = to_date('&tdate', 'yyyy-mm-dd') then
              f.milenum
             else
              0
           end) yy_zb_milenum,
       sum(case
             when f.rectype = 2 and f.shiftdetailtype = 11 and
                  f.rundatadate = to_date('&tdate', 'yyyy-mm-dd') then
              f.milenum
             else
              0
           end) fyy_rq_milenum,
       sum(case
             when f.rectype = 2 and f.shiftdetailtype <> 11 and
                  f.rundatadate = to_date('&tdate', 'yyyy-mm-dd') then
              f.milenum
             else
              0
           end) fyy_zb_milenum,
       sum(case
             when f.rectype = 1 and f.shiftdetailtype = 11 then
              f.milenum
             else
              0
           end) yy_rq_milenum_sum,
       sum(case
             when f.rectype = 1 and f.shiftdetailtype <> 11 then
              f.milenum
             else
              0
           end) yy_zb_milenum_sum,
       sum(case
             when f.rectype = 2 and f.shiftdetailtype = 11 then
              f.milenum
             else
              0
           end) fyy_rq_milenum_sum,
       sum(case
             when f.rectype = 2 and f.shiftdetailtype <> 11 then
              f.milenum
             else
              0
           end) fyy_zb_milenum_sum
  from fdisbusrunrecgd f
where f.rundatadate >= to_date(substr('&tdate', 0, 7), 'yyyy-mm')
   and f.rundatadate <= to_date('&tdate', 'yyyy-mm-dd')
   and f.routeid in (&orgids)
   and f.isavailable = 1
 group by  f.driverid, f.drivername,f.BUSSELFID,f.routeid
 order by f.routeid

