select to_char(dis.rundate,'yyyy-mm-dd'),
       e.cardid,
       e.empname,
       dis.busselfid,
       replace(r.routename,'·','') routename,
        CASE
         WHEN DIS.GROUPNUM = 1 AND dis.shifttype=2 THEN
          '1'
         WHEN DIS.GROUPNUM = 2 AND dis.shifttype=2 THEN
          '2'
         ELSE
          DIS.SHIFTDETAILTYPE
       END SHIFTDETAILTYPE,
       sum(case
             when dis.rectype = 1 or dis.bussid = 14 then
              dis.seqnum
             else
              0
           end) seqnum,
       sum(case
             when dis.rectype = 1 or dis.bussid = 14 then
              dis.milenum
             else
              0
           end) yymile,
       sum(case
             when dis.rectype != 1 and dis.busid != 14 then
              dis.milenum
             else
              0
           end) fyymile
  from fdisdisplanld dis, mcemployeeinfogs e, mcrouteinfogs r
 where dis.driverid = e.empid(+)
   and dis.routeid = r.routeid(+)
   and dis.isactive=1
   and dis.isconfirm=1
   and dis.rundate >= date '&sdates'
   and dis.rundate <= date '&edates'
   and dis.routeid in (&routeid)
   and dis.driverid=nvl('&empid',dis.driverid)
   and dis.busid=nvl('&busselfid',dis.busid)
 group by dis.rundate,
          e.cardid,
          e.empname,
          dis.busselfid,
          r.routename,
           DIS.GROUPNUM,
          dis.shifttype,
          DIS.SHIFTDETAILTYPE
