---查看驾驶员的未确认车次信息，排除了GPS数据为0的异常数据，
SELECT f.driverid,f.routeid,f.rectype,f.rundate,f.seqnum,f.milenum,f.gpsmile,f.leavetime,f.arrivetime,f.isactive,f.isconfirm
  FROM FDISDISPLANLD F
 WHERE F.RUNDATE >= DATE '2016-8-1'
   AND F.RUNDATE <= DATE '2016-8-25'
   AND F.DRIVERID = '20150921223010000139' AND  f.isactive=1 AND f.gpsmile IS NOT NULL AND f.gpsmile!=0;
  SELECT * FROM MCEMPLOYEEINFOGS E WHERE E.CARDID = '321668';
  ----安装线路查看未确认车次信息，排除了GPS数据为0的异常数据，
  SELECT 
       E.CARDID,
       E.EMPNAME,
       DIS.BUSSELFID,
       SUM(CASE
             WHEN DIS.RECTYPE = 1 OR DIS.BUSSID = 14 THEN
              DIS.MILENUM
             ELSE
              0
           END) YYMILE,
       SUM(CASE
             WHEN DIS.RECTYPE != 1 AND DIS.BUSID != 14 THEN
              DIS.MILENUM
             ELSE
              0
           END) FYYMILE
  FROM FDISDISPLANLD DIS, MCEMPLOYEEINFOGS E, MCROUTEINFOGS R
 WHERE DIS.DRIVERID = E.EMPID(+)
   AND DIS.ROUTEID = R.ROUTEID(+)
   AND DIS.ISACTIVE = 1
   AND DIS.ISCONFIRM !=1
   AND dis.gpsmile IS NOT NULL
   AND dis.gpsmile !=0
   AND DIS.RUNDATE >= DATE'2016-8-1'
   AND dis.rundate<=DATE'2016-8-25'
   AND DIS.ROUTEID IN ('320570')
   AND DIS.DRIVERID = NVL('&empid', DIS.DRIVERID)
   AND DIS.BUSID = NVL('&busselfid', DIS.BUSID)
 GROUP BY 
          E.CARDID,
          E.EMPNAME,
          DIS.BUSSELFID,
          R.ROUTENAME



          
          SELECT * FROM mcrouteinfogs r WHERE r.routename LIKE '%58%';
