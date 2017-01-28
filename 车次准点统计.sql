--车辆准点查询,只统计已确认的营运车次
SELECT R.ROUTENAME,
       f.shiftnum,
       f.busselfid,
       f.drivername,
       s1.stationname,
       s2.stationname,
       f.segmentname,
        seg.sngtime,
       f.realleavetime,
       f.realarrivettime,
       f.arrivetime,
       ROUND((f.realarrivettime-f.arrivetime)*24*60)
  FROM FDISDISPLANLD   F,
       MCROUTEINFOGS   R,
       MCSTATIONINFOGS S1,
       MCSTATIONINFOGS S2,
       mcsegmentinfogs seg
 WHERE F.ROUTEID = R.ROUTEID(+)
 AND f.startstationid=s1.stationid(+)
 AND f.endstationid=s2.stationid(+)
 AND f.segmentid=seg.segmentid(+)
   AND F.ISACTIVE = 1
   AND F.ISCONFIRM = 1
   AND F.RECTYPE = 1
   AND f.rundate BETWEEN DATE'&sdate' AND DATE'&edate'
   AND f.routeid IN (&routeid);
