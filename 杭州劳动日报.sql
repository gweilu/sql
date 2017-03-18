----杭州劳动日报
SELECT * FROM ASGNARRANGEGD;
SELECT * FROM ASGNARRANGESEQGD;
SELECT A.SHIFTNUM, A.SHIFTTYPE, A.SHIFTDETAILTYPE, A.GROUPNUM
  FROM ASGNARRANGEWSHIFTLD A
 WHERE A.ROUTEID = '320030'
   AND A.EXECDATE = DATE '2016-11-19'
   AND NVL(A.SHIFTDETAILTYPE, 99) NOT IN (3, 5, 6)
   AND A.DRIVERID IS NOT NULL;
--劳动班次表
SELECT * FROM TYPEENTRY T WHERE T.TYPENAME LIKE '%EMPS%';
-------------
SELECT ASG.ARRANGEID,
       ASG.ROUTEID,
       ASGS.BUSID,
       ASGS.DRIVERID,
       ASGS.SHIFTTYPE
  FROM ASGNARRANGEGD ASG, ASGNARRANGESEQGD ASGS
 WHERE ASGS.ARRANGEID = ASG.ARRANGEID(+)
   AND ASG.STATUS = 'd'
   AND ASG.ROUTEID = '320030'
   AND ASG.EXECDATE = DATE '2016-7-18';

----------------人员劳动信息及车辆信息
----过滤重复人员并进行计数统计
SELECT BC.NROUTEID, SUM(BC.COUNTS) PCOUNTS
  FROM (SELECT PB.driverid,
               PB.ROUTEID,
               FIRST_VALUE(PB.ROUTEID) OVER(PARTITION BY PB.driverid ORDER BY PB.MILES DESC) NROUTEID,
               CASE
                 WHEN PB.ROUTEID = FIRST_VALUE(PB.ROUTEID)
                  OVER(PARTITION BY PB.driverid ORDER BY PB.MILES DESC) THEN
                  1
                 ELSE
                  0
               END COUNTS
          FROM (SELECT db.driverid,db.routeid,SUM(db.mileage) miles,db.sdt FROM (SELECT ASEQ.driverid, A.ROUTEID,ASEQ.MILEAGE,
          CASE WHEN aw.shifttype=1 AND aw.groupnum=1 THEN '1'
            WHEN aw.shifttype=1 AND aw.groupnum=2 THEN '2'
              ELSE aw.shiftdetailtype END sdt
                  FROM ASGNARRANGESEQGD ASEQ, ASGNARRANGEGD A,asgnarraNGEWSHIFTLD aw
                 WHERE A.EXECDATE = DATE '2017-3-9'
                   AND A.STATUS = 'd'
                   AND ASEQ.ARRANGEID = A.ARRANGEID(+)
                   AND aseq.arrangeid=aw.arrangeid(+)
                   AND aseq.shiftnum=aw.shiftnum(+)
                   AND aseq.groupnum=aw.groupnum(+)
                   AND ASEQ.driverid IS NOT NULL)db GROUP BY db.driverid,db.routeid,db.sdt ) PB) BC
 GROUP BY BC.NROUTEID;
----
SELECT SUM(CASE
             WHEN NVL(ASS.SHIFTDETAILTYPE, 99) NOT IN (3, 5, 6) THEN
              1
             ELSE
              0
           END) DSH,
       SUM(CASE
             WHEN ASS.SHIFTDETAILTYPE = 3 THEN
              1
             ELSE
              0
           END)/2 SSH,
       SUM(CASE
             WHEN ASS.SHIFTDETAILTYPE = 5 OR ASS.SHIFTDETAILTYPE = 6 THEN
              1
             ELSE
              0
           END) NSH,
       COUNT(DISTINCT ASS.BUSID) BUSNUM/*,
       r.routename*/
  FROM ASGNARRANGEWSHIFTLD ASS,mcrouteinfogs r
 WHERE ass.routeid=r.routeid(+)
   AND ASS.ROUTEID ='320030'  /*IN (&routeid)*/
   AND ASS.DRIVERID IS NOT NULL
   AND ASS.EXECDATE = DATE'&dates'
 GROUP BY ASS.ROUTEID;
---------------------
---人员休假信息查询
--人员假事管理
SELECT COUNT(1), T.ITEMKEY
  FROM ASGNREMPSTATELD A, TYPEENTRY T
 WHERE A.EMPSID = T.ITEMVALUE(+)
   AND A.STARTDATE <= DATE '&dates'
   AND A.ENDDATE >= DATE '&dates'
   AND A.ROUTEID = IN (&ROUTEID)
   AND T.TYPENAME = 'SUBEMPSTATETYPE'
 GROUP BY T.ITEMKEY;
--车辆维修情况
SELECT * FROM BM_BUSSTATEINFOGD bb WHERE bb.routeid='320030';
SELECT * FROM asgnrbusrouteld;
SELECT COUNT(1), T.ITEMKEY
  FROM BM_BUSSTATEINFOGD BB, TYPEENTRY T, ASGNRBUSROUTELD BR
 WHERE BB.DEFENDTYPE = T.ITEMVALUE(+)
   AND BR.ROUTEID IN (&ROUTEID)
   AND BB.STARTDATE <= DATE '&dates'
   AND BB.ENDDATE >= DATE '&dates'
   AND BB.BUSID = BR.BUSID(+)
   AND T.TYPENAME = 'DEFENDTYPE'
 GROUP BY T.ITEMKEY;


SELECT * FROM TYPEENTRY T WHERE T.TYPENAME LIKE '%DEFENDTYPE%';
