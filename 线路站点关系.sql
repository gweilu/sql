SELECT SES.ROUTEID,
       SES.SUBROUTEID,
       SES.SEGMENTID,
       SE.RUNDIRECTION,
       s1.stationno,
       s1.stationname,
       s2.stationno,
       s2.stationname,
       SES.STATIONID,
       S.STATIONNO,
       SES.STATIONNAME,
       S.LONGITUDE,
       S.LATITUDE,
       SES.SNGSERIALID,
       SES.DUALSERIALID
  FROM MCRSEGMENTSTATIONGS SES, MCSEGMENTINFOGS SE, MCSTATIONINFOGS S,mcstationinfogs s1,mcstationinfogs s2
 WHERE SES.SEGMENTID = SE.SEGMENTID(+)
   AND SES.STATIONID = S.STATIONID(+)
   AND SE.FSTSTATIONID = S1.STATIONID(+)
   AND SE.LSTSTATIONID = S2.STATIONID(+)
   AND SES.ROUTEID = '320220'
 AND s.stationno IN
(SELECT s5.stationno FROM mcstationinfogs s5 WHERE s5.stationname LIKE '%市公交集团%');
SELECT * FROM mcstationinfogs s5 WHERE s5.stationname LIKE '%市公交集团%';
SELECT * FROM MCROUTEINFOGS R WHERE R.ROUTENAME LIKE '22%';
SELECT * FROM MCSEGMENTINFOGS SE;
