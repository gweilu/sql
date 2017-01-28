CREATE OR REPLACE VIEW HZ_FDISDISPLAN_VIEW AS
SELECT o.orgcode,
       F.RUNDATE,
       E.CARDID,
       F.DRIVERNAME,
       CASE WHEN f.rectype=2 AND f.bussid=14 THEN 999
         ELSE f.routeid
           END routeid,
           CASE WHEN f.rectype=2 AND f.bussid=14 THEN 999
         ELSE r.routecode
           END routecode,
           f.busselfid,
       CASE
         WHEN F.GROUPNUM = 1 AND F.SHIFTTYPE = 2 THEN
          '1'
         WHEN F.GROUPNUM = 2 AND F.SHIFTTYPE = 2 THEN
          '2'
         ELSE
          F.SHIFTDETAILTYPE
       END SHIFTDETAILTYPE,
     sst.stationno sst,
     est.stationno est,
       SSt.STATIONNAME sstn,
       ESt.STATIONNAME estn,
       F.LEAVETIME,
       F.ARRIVETIME,
       seg.rundirection,
       f.shiftnum,
       seg.sngmile,
      CASE
             WHEN f.RECTYPE = 1 OR f.recstate=24 THEN
              f.MILENUM
             ELSE
              0
           END YYMILE,
       CASE
             WHEN f.RECTYPE != 1 AND f.BUSID != 14 THEN
              f.MILENUM
             ELSE
              0
           END FYYMILE
  FROM FDISDISPLANLD    F,
       MCEMPLOYEEINFOGS E,
       MCSTATIONINFOGS  SSt,
       MCSTATIONINFOGS  ESt,
       mcsegmentinfogs seg,
       mcorginfogs o,
       mcrouteinfogs r
 WHERE F.ISACTIVE = 1
   AND F.ISCONFIRM = 1
   AND F.DRIVERID = E.EMPID(+)
   AND F.Startstationid = SSt.STATIONID(+)
   AND F.Endstationid = ESt.STATIONID(+)
   AND f.segmentid=seg.segmentid(+)
   AND f.orgid=o.orgid(+)
   AND f.routeid=r.routeid(+);
