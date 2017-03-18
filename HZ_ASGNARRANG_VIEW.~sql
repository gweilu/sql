CREATE OR REPLACE VIEW HZ_ASGNARRANG_VIEW AS
SELECT T.ORGID,
       T.ORGNAME,
       T.ROUTEID,
       T.ROUTENAME,
       T.BUSSELFID,
       T.SHIFTNUM,
     /*  FIRST_VALUE(A.SHIFTDETAILTYPE) OVER(PARTITION BY A.EMPNAME ORDER BY A.YYMILE DESC) SH,*/
       to_char(wm_concat(t.DRIVEID1)) DRIVEID1,
     /*  T.DRIVENAME1,*/
       to_char(wm_concat(t.DRIVENAME1)) DRIVENAME1,
      /* T.STEWARDID,*/
       to_char(wm_concat(t.STEWARDID)) STEWARDID,
     /*  T.STEWARDNAME,*/
       to_char(wm_concat(t.STEWARDNAME)) STEWARDNAME,
      /* t.ACTIONSTARTTIME,*/
       to_char(wm_concat(to_char(t.ACTIONSTARTTIME,'yyyy-mm-dd hh24:mi:ss'))) ACTIONSTARTTIME,
       /*T.DRIVEID2,*/
       to_char(wm_concat(t.DRIVEID2)) DRIVEID2,
     /*  T.DRIVENAME2,*/
       to_char(wm_concat(t.DRIVENAME2)) DRIVENAME2,
       /*T.STEWARDID2,*/
       to_char(wm_concat(t.STEWARDID2)) STEWARDID2,
      /* T.STEWARDNAME2,*/
       to_char(wm_concat(t.STEWARDNAME2)) STEWARDNAME2,
      /* t.ACTIONSTARTTIME2,*/
       to_char(wm_concat(to_char(t.ACTIONSTARTTIME2,'yyyy-mm-dd hh24:mi:ss'))) ACTIONSTARTTIME2,
       t.execdate
  FROM (SELECT DISTINCT * FROM (SELECT A.EXECDATE,
               A.ORGID,
               O.ORGNAME,
               A.ROUTEID,
               R.ROUTENAME,
               B.BUSSELFID,
               AW.SHIFTNUM,
               AW.SHIFTTYPE,
               AW.GROUPNUM,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E.CARDID
               /*                 WHEN aw.groupnum=2 AND aw.shifttype=2 THEN
               e.cardid*/
                 ELSE
                  NULL
               END DRIVEID1,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E.EMPNAME
               /*                  WHEN aw.groupnum=2 AND aw.shifttype=2 THEN
               E.EMPNAME*/
                 ELSE
                   NULL
               END DRIVENAME1,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E1.CARDID
               /*                   WHEN aw.groupnum=2 AND aw.shifttype=2 THEN
               E1.CARDID*/
                 ELSE
                   NULL
               END STEWARDID,
               CASE
                 WHEN AW.GROUPNUM = 1 THEN
                  E1.EMPNAME
               /*                   WHEN aw.groupnum=2 AND aw.shifttype=2 THEN
               E1.EMPNAME*/
                 ELSE
                   NULL
               END STEWARDNAME,
               CASE
                 WHEN AW.GROUPNUM = 1  THEN
                  MIN(au.actionstarttime) OVER(PARTITION BY a.routeid,aw.shiftnum,aw.groupnum,a.execdate )
                /*  AU.ACTIONSTARTTIME*/
               /*                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E1.EMPNAME*/
                 ELSE
                   NULL
               END ACTIONSTARTTIME,
               CASE
                 WHEN AW.GROUPNUM = 2  THEN
                  E.CARDID
               /*                  WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E.CARDID*/
                 ELSE
                  NULL
               END DRIVEID2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E.EMPNAME
               /*                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E.EMPNAME*/
                 ELSE
                  NULL
               END DRIVENAME2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E1.CARDID
               /*                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E1.CARDID*/
                 ELSE
                   NULL
               END STEWARDID2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  E1.EMPNAME
               /*                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E1.EMPNAME*/
                 ELSE
                   NULL
               END STEWARDNAME2,
               CASE
                 WHEN AW.GROUPNUM = 2 THEN
                  MIN(au.actionstarttime) OVER(PARTITION BY a.routeid,aw.shiftnum,aw.groupnum,a.execdate )
               /*                   WHEN aw.groupnum=1 AND aw.shifttype=2 THEN
               E1.EMPNAME*/
                 ELSE
                  NULL
               END ACTIONSTARTTIME2
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
           AND AU.ACTIONTYPE IN (0,9)
           AND A.STATUS = 'd') disti ) T
 GROUP BY T.ORGID,
          T.ORGNAME,
          T.ROUTEID,
          T.ROUTENAME,
          T.BUSSELFID,
          T.SHIFTNUM,
          t.execdate;
