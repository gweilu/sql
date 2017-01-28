/*
��ͼ���ƣ�hz_asgnarrang_view
��ͼ˵���������Ű�Խ�����ͼ
�����ˣ�Robert.Wei
����ʱ�䣺2016-11-12
*/
CREATE OR REPLACE VIEW hz_asgnarrang_view AS
----------------------���Ͷ���α���ȡֵ
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
   AND A.STATUS = 'd';
---------------------------------------------------------------------------

