---杭州车辆故障统计
SELECT * FROM FDISBUSTRUBLELD
SELECT FT.RUNDATE, O.ORGNAME, R.ROUTENAME, FT.BUSSELFID,e.empname,ft.troubletypeid,ft.troublecause,ft.recdate
  FROM FDISBUSTRUBLELD FT, MCORGINFOGS O, MCROUTEINFOGS R,mcemployeeinfogs e
 WHERE FT.ORGID = O.ORGID(+)
   AND ft.routeid=r.routeid(+)
   AND ft.driverid=e.empid(+)
   AND ft.rundate>=DATE'&bdate' AND ft.rundate<=DATE'&edate';
   and ft.routeid in (&routeid)
   AND ft.busid=NVL('&busid',ft.busid)
   AND ft.driverid=NVL('&driverid',ft.driverid)
   AND ft.troubletypeid=NVL('&trid',ft.troubletypeid);
   
   SELECT * FROM typeentry t WHERE t.typename LIKE '%PTROUBLETYPE%' OR t.typename LIKE '%MTROUBLETYPE%';
