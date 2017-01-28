SELECT * FROM HZ_ASGNARRANG_VIEW;
SELECT * FROM ASGNARRANGEWSHIFTLD;
------------------
SELECT A.EXECDATE,
       A.ORGID,
       O.ORGNAME,
       A.ROUTEID,
       R.ROUTENAME,
       B.BUSSELFID,
       AW.SHIFTNUM,
       CASE
         WHEN AW.GROUPNUM = 1 THEN
          e.cardid
         ELSE
          NULL
       END DRIVEID1,
       CASE
         WHEN AW.GROUPNUM = 1 THEN
          E.EMPNAME
         ELSE
          NULL
       END DRIVENAME1,
       CASE
         WHEN AW.GROUPNUM = 1 THEN
          e1.cardid
         ELSE
          NULL
       END STEWARDID,
       CASE
         WHEN AW.GROUPNUM = 1 THEN
          E1.EMPNAME
         ELSE
          NULL
       END STEWARDNAME,
       CASE
         WHEN AW.GROUPNUM = 2 THEN
          e.cardid
         ELSE
          NULL
       END DRIVEID2,
       CASE
         WHEN AW.GROUPNUM = 2 THEN
          E.EMPNAME
         ELSE
          NULL
       END DRIVENAME2,
       CASE
         WHEN AW.GROUPNUM = 2 THEN
          e1.cardid
         ELSE
          NULL
       END STEWARDID2,
       CASE
         WHEN AW.GROUPNUM = 2 THEN
          E1.EMPNAME
         ELSE
          NULL
       END STEWARDNAME2,
       au.actionstarttime,
       au.actionendtime
  FROM ASGNARRANGESEQUNTRANCEGD AU,
       ASGNARRANGEWSHIFTLD      AW,
       ASGNARRANGEGD            A,
       MCORGINFOGS              O,
       MCROUTEINFOGS            R,
       MCBUSINFOGS              B,
       MCEMPLOYEEINFOGS         E,
       MCEMPLOYEEINFOGS         E1
 WHERE AU.ARRANGEWSHIFTID = AW.ARRANGEWSID(+)
   AND AU.ARRANGEID = A.ARRANGEID(+)
   AND A.ORGID = O.ORGID(+)
   AND A.ROUTEID = R.ROUTEID(+)
   AND AW.BUSID = B.BUSID(+)
   AND AW.DRIVERID = E.EMPID(+)
   AND AW.STEWARDID = E1.EMPID(+)
   AND AU.ACTIONTYPE IN (0, 9)
   AND A.STATUS = 'd'
     AND A.ROUTEID = '320030'
           AND A.EXECDATE = DATE '2016-12-5';
-------------------
SELECT T.ORGID,
       T.ORGNAME,
       T.ROUTEID,
       T.ROUTENAME,
       T.BUSSELFID,
       T.SHIFTNUM,
   /*    t.shifttype,
       t.groupnum,*/
       T.DRIVEID1,
       T.DRIVENAME1,
       T.STEWARDID,
       T.STEWARDNAME,
       T.DRIVEID2,
       T.DRIVENAME2,
       T.STEWARDID2,
       T.STEWARDNAME2,
       MIN(CASE WHEN t.shifttype=2 AND t.groupnum=2 THEN NULL ELSE t.ACTIONSTARTTIME END ),
       MAX(CASE WHEN t.shifttype=2 AND t.groupnum=1 THEN NULL ELSE t.ACTIONENDTIME END )
  FROM (SELECT A.EXECDATE,
               A.ORGID,
               O.ORGNAME,
               A.ROUTEID,
               R.ROUTENAME,
               B.BUSSELFID,
               AW.SHIFTNUM,
               aw.shifttype,
               aw.groupnum,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E.CARDID
                 WHEN aw.groupnum=2 AND aw.shifttype=2 THEN 
                   e.cardid
                   ELSE
                     NULL
               END DRIVEID1,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E.EMPNAME
                  WHEN aw.groupnum=2 AND aw.shifttype=2 THEN 
                   E.EMPNAME
                 ELSE
                  NULL
               END DRIVENAME1,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E1.CARDID
                   WHEN aw.groupnum=2 AND aw.shifttype=2 THEN 
                   E1.CARDID
                 ELSE
                  NULL
               END STEWARDID,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E1.EMPNAME
                   WHEN aw.groupnum=2 AND aw.shifttype=2 THEN 
                   E1.EMPNAME
                 ELSE
                  NULL
               END STEWARDNAME,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E.CARDID
                  WHEN aw.groupnum=1 AND aw.shifttype=2 THEN 
                   E.CARDID
                 ELSE
                  NULL
               END DRIVEID2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E.EMPNAME
                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN 
                   E.EMPNAME
                 ELSE
                  NULL
               END DRIVENAME2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E1.CARDID
                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN 
                   E1.CARDID
                 ELSE
                  NULL
               END STEWARDID2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E1.EMPNAME
                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN 
                   E1.EMPNAME
                 ELSE
                  NULL
               END STEWARDNAME2,
               AU.ACTIONSTARTTIME,
               AU.ACTIONENDTIME
          FROM ASGNARRANGESEQUNTRANCEGD AU,
               ASGNARRANGEWSHIFTLD      AW,
               ASGNARRANGEGD            A,
               MCORGINFOGS              O,
               MCROUTEINFOGS            R,
               MCBUSINFOGS              B,
               MCEMPLOYEEINFOGS         E,
               MCEMPLOYEEINFOGS         E1
         WHERE AU.ARRANGEWSHIFTID = AW.ARRANGEWSID(+)
           AND AU.ARRANGEID = A.ARRANGEID(+)
           AND A.ORGID = O.ORGID(+)
           AND A.ROUTEID = R.ROUTEID(+)
           AND AW.BUSID = B.BUSID(+)
           AND AW.DRIVERID = E.EMPID(+)
           AND AW.STEWARDID = E1.EMPID(+)
           AND AU.ACTIONTYPE IN (0, 9)
           AND A.STATUS = 'd'
           AND A.ROUTEID = '320030'
           AND A.EXECDATE = DATE '2016-12-5') T
 GROUP BY T.ORGID,
          T.ORGNAME,
          T.ROUTEID,
          T.ROUTENAME,
          T.BUSSELFID,
          T.SHIFTNUM,
          T.DRIVEID1,
          T.DRIVENAME1,
          T.STEWARDID,
          T.STEWARDNAME,
          T.DRIVEID2,
          T.DRIVENAME2,
          T.STEWARDID2,
          T.STEWARDNAME2/*,
          t.shifttype,
       t.groupnum*/;
