----驾驶员考勤信息，按月为单位，列出每一天详细的出勤信息
SELECT DISTINCT FI.EMPID,fi.empname,fi.cardid,fi.routename,fi.routeids,
                substr(FI.DATES,9,2) fdates,
                MAX(FI.KQ) OVER(PARTITION BY FI.EMPID, FI.DATES) KQ
  FROM (SELECT ASG.ITEMKEY,
               C.EMPID,
               c.empname,
               c.cardid,
               asg.routename,
               asg.routeids,
               C.DATES,
               CASE
                 WHEN TO_DATE(C.DATES, 'yyyy-mm-dd') >= ASG.STARTDATE AND
                      TO_DATE(C.DATES, 'yyyy-mm-dd') <= TRUNC(ASG.ENDDATE) THEN
                  ASG.ITEMKEY
                 ELSE
                  NULL
               END KQ
          FROM (SELECT ASGS.*, T.ITEMKEY,r.routename,r.routeid routeids
                  FROM ASGNREMPSTATELD ASGS, TYPEENTRY T,mcrouteinfogs r
                 WHERE ASGS.STARTDATE >=
                       TRUNC(ADD_MONTHS(LAST_DAY(TO_DATE('&dates' || '01',
                                                         'yyyy-mm-dd')) + 1,
                                        -1))
                   AND ASGS.ENDDATE <=
                       TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(TO_DATE('&dates' || '01',
                                                                  'yyyy-mm-dd')) + 1,
                                                 -1)))
                   AND ASGS.EMPSID = T.ITEMVALUE(+)
                   AND T.TYPENAME = 'SUBEMPSTATETYPE'
                   AND asgs.routeid=r.routeid(+)) ASG,
               (SELECT A.EMPID, B.DATES,a.empname,a.cardid
                  FROM (SELECT E.EMPID,e.empname,e.cardid
                          FROM MCEMPLOYEEINFOGS E
                         WHERE E.ORGID IN (&ORGID)
                           AND E.ISACTIVE = 1) A,
                       (SELECT TO_CHAR(ADD_MONTHS(LAST_DAY(TO_DATE('&dates' || '01',
                                                                   'yyyy-mm-dd')) + 1,
                                                  -1) + (LEVEL - 1),
                                       'yyyy/mm/dd') DATES
                          FROM DUAL
                        CONNECT BY TRUNC(ADD_MONTHS(LAST_DAY(TO_DATE('&dates' || '01',
                                                                     'yyyy-mm-dd')) + 1,
                                                    -1)) + LEVEL - 1 <=
                                   TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(TO_DATE('&dates' || '01',
                                                                              'yyyy-mm-dd')) + 1,
                                                             -1)))) B) C
         WHERE C.EMPID = ASG.EMPID(+)) FI ORDER BY fi.routeids,fi.cardid,fdates;

         ---------备份测试用
SELECT DISTINCT FI.EMPID,
                FI.DATES,
                MAX(FI.KQ) OVER(PARTITION BY FI.EMPID, FI.DATES) KQ
  FROM (SELECT /*T.ITEMKEY,*/
         C.EMPID,
         /*   ASG.STARTDATE,
         ASG.ENDDATE,*/
         C.DATES /*,
                       CASE
                         WHEN TO_DATE(C.DATES, 'yyyy-mm-dd') >= ASG.STARTDATE AND
                              TO_DATE(C.DATES, 'yyyy-mm-dd') <= TRUNC(ASG.ENDDATE) THEN
                          T.ITEMKEY
                         ELSE
                          NULL
                       END KQ*/
          FROM (SELECT '20151130001138000529' EMPID,
                       14 EMPSID,
                       DATE '2017-1-1' STARTDATE,
                       DATE '2017-1-4' ENDDATE
                  FROM DUAL) ASG,
               /*     TYPEENTRY T,*/
               (SELECT A.EMPID, B.DATES
                  FROM (SELECT E.EMPID
                          FROM MCEMPLOYEEINFOGS E
                         WHERE E.ORGID IN (&ORGID)
                           AND E.ISACTIVE = 1) A,
                       (SELECT TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1) +
                                       (LEVEL - 1),
                                       'yyyy/mm/dd') DATES
                          FROM DUAL
                        CONNECT BY TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) +
                                   LEVEL - 1 <=
                                   TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(SYSDATE) + 1,
                                                             -1)))) B) C
         WHERE C.EMPID = ASG.EMPID(+)
        /* AND ASG.EMPSID = T.ITEMVALUE(+)
        AND T.TYPENAME = 'SUBEMPSTATETYPE'*/
        /*           AND ASG.STARTDATE >= TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1))
        AND ASG.ENDDATE <=
            TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)))*/
        /*      AND ASG.EMPID = '20151130001138000529'*/
        ) FI;
-----
SELECT * FROM ASGNREMPSTATELD ASG ORDER BY asg.startdate DESC;
SELECT TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) FROM DUAL;
SELECT TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1))) FROM DUAL;
SELECT COUNT(1) * 31
  FROM MCEMPLOYEEINFOGS E
 WHERE E.ORGID = '55151104152205122063'
   AND E.ISACTIVE = 1;
SELECT * FROM MCORGINFOGS O WHERE O.ORGID IN ('55151104152205122063');
