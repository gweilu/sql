select *
  from mcrouteinfogs r
 where r.routename like '%3%';
 
 select * from mcsegmentinfogs se where se.routeid='320030',
 
 select * from fdisdisplanld d
 
  select se.segmentname,count(1) 总班次,
         count(case
           when dis.isconfirm = 1 then
            1
           else
           null
         end) 确认班次,
         count(case
           when dis.ismanusend=1 then
            1
           else
           null
         end) 手动发车,
         count(case
           when dis.ismanufinish=1 then
            1
           else
           null
         end) 手动完成
          from fdisdisplanld dis,mcsegmentinfogs se
         where dis.segmentid=se.segmentid(+) and dis.rundate = date '2016-5-18'
           and dis.routeid in ('320030')
           group by se.segmentname,dis.routeid

select se.segmentname,
       dis.busselfid,
       dis.drivername,
       dis.leavetime,
       dis.realleavetime,
       dis.realarrivettime,
       dis.memos
  from fdisdisplanld dis, mcsegmentinfogs se
 where dis.segmentid=se.segmentid(+) and 
       dis.rundate = date '2016-5-18'
   and dis.routeid = '320030'
       order by se.segmentname,dis.realleavetime
