SELECT S.RUNDATE,
       S.CARDID,
       S.EMPNAME,
       S.BUSSELFID,
       S.ROUTENAME,
       S.SH,
       SUM(S.SEQNUM),
       SUM(S.YYMILE),
       SUM(S.FYYMILE)
  FROM (SELECT A.RUNDATE,
               A.CARDID,
               A.EMPNAME,
               A.BUSSELFID,
               A.ROUTENAME,
               FIRST_VALUE(A.SHIFTDETAILTYPE) OVER(PARTITION BY A.EMPNAME ORDER BY A.YYMILE DESC) SH,
               A.SEQNUM,
               A.YYMILE,
               A.FYYMILE
          FROM (SELECT TO_CHAR(DIS.RUNDATE, 'yyyy-mm-dd') RUNDATE,
                       E.CARDID,
                       E.EMPNAME,
                       DIS.BUSSELFID,
                       REPLACE(R.ROUTENAME, '·', '') ROUTENAME,
                       CASE
                         WHEN DIS.GROUPNUM = 1 AND DIS.SHIFTTYPE = 2 THEN
                          '1'
                         WHEN DIS.GROUPNUM = 2 AND DIS.SHIFTTYPE = 2 THEN
                          '2'
                         ELSE
                          DIS.SHIFTDETAILTYPE
                       END SHIFTDETAILTYPE,
                       SUM(CASE
                             WHEN DIS.RECTYPE = 1 OR DIS.BUSSID = 14 THEN
                              DIS.SEQNUM
                             ELSE
                              0
                           END) SEQNUM,
                       SUM(CASE
                             WHEN DIS.RECTYPE = 1 THEN
                              DIS.MILENUM
                             ELSE
                              0
                           END) YYMILE,
                       SUM(CASE
                             WHEN DIS.BUSSID = 14 THEN
                              DIS.MILENUM
                             ELSE
                              0
                           END) BCMILE,
                       SUM(CASE
                             WHEN DIS.RECTYPE <> 1 AND DIS.BUSSID <> 14 AND
                                  DIS.RECSTATE = 24 THEN
                              DIS.MILENUM
                             ELSE
                              0
                           END) FYYMILE
                  FROM FDISDISPLANLD DIS, MCEMPLOYEEINFOGS E, MCROUTEINFOGS R
                 WHERE DIS.DRIVERID = E.EMPID(+)
                   AND DIS.ROUTEID = R.ROUTEID(+)
                   AND DIS.ISACTIVE = 1
                   AND DIS.ISCONFIRM = 1
                   AND DIS.RUNDATE = DATE
                 '&dates'
                   AND DIS.ROUTEID IN (&ROUTEID)
                   AND DIS.DRIVERID = NVL('&empid', DIS.DRIVERID)
                   AND DIS.BUSID = NVL('&busselfid', DIS.BUSID)
                 GROUP BY DIS.RUNDATE,
                          E.CARDID,
                          E.EMPNAME,
                          DIS.BUSSELFID,
                          R.ROUTENAME,
                          DIS.GROUPNUM,
                          DIS.SHIFTTYPE,
                          DIS.SHIFTDETAILTYPE) A) S
 GROUP BY S.RUNDATE, S.CARDID, S.EMPNAME, S.BUSSELFID, S.ROUTENAME, S.SH
