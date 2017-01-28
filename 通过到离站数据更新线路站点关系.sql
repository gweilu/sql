/******************************************************************************

功能描述：当线路和单程分配的站点信息错误时，现场线路使用的配置文件是正确的时候，
          用车载机上传的到离站信息来更新线路和单程的站点信息。

参数描述：Routeid（线路id）

作者：Robert.Wei

处理表：  bsvcbusarrlftld5(到离站)
          mcrroutestationgs（线路站点关系，双程）
          mcrsegmentstationgs（单程站点关系，单程）

处理过程:从bsvcbusarrlftld5中查找线路的报站信息，按照

创建日期：2016-10-29

完成日期：2016-0-29

*********************************************************************************

修改目的：

修改内容描述：

修改人：

修改日期：

完成日期：

*************************************************************************************/
SELECT * FROM MCSUBROUTEINFOGS S WHERE S.SUBROUTENAME LIKE '%90%';
---------通过游标从单程线路关系中找到和到离站数据部分和的站点并进行更新
DECLARE
  VARSUBID  VARCHAR2(20);
  VARDUID   VARCHAR2(20);
  VARSTANUM VARCHAR2(20);
  varstid   VARCHAR2(20);
  CURSOR MYCUR IS
    SELECT RSS.SUBROUTEID, RSS.DUALSERIALID, S.STATIONNO,s.stationid
      FROM MCRSEGMENTSTATIONGS RSS, MCSTATIONINFOGS S
     WHERE RSS.SUBROUTEID = '620900'
       AND RSS.STATIONID = S.STATIONID(+)
       AND S.STATIONNO IS NOT NULL
       AND s.stationid NOT IN (select DISTINCT s.stationid
  from bsvcbusarrlftld5 b, mcstationinfogs s
 where b.stationnum = s.stationno(+)
   and b.subrouteid = '620900'
   and b.actdatetime > trunc(sysdate)
   and b.datatype=4
   and b.bussid in (4,5,6)
   and b.stationnum is not NULL
   AND s.stationid IS NOT NULL
   and b.stationnum!=0)
     ORDER BY RSS.DUALSERIALID;
BEGIN
  OPEN MYCUR;
  LOOP
    FETCH MYCUR
      INTO VARSUBID, VARDUID, VARSTANUM,varstid;
    EXIT WHEN MYCUR%NOTFOUND;
    UPDATE MCRSEGMENTSTATIONGS RSS
       SET RSS.STATIONID =
           (SELECT max(DISTINCT NVL(S.STATIONID,varstid))
              FROM BSVCBUSARRLFTLD5 B, MCSTATIONINFOGS S
             WHERE B.STATIONNUM = S.STATIONNO(+)
               AND B.SUBROUTEID = varsubid
               AND B.ACTDATETIME > TRUNC(SYSDATE)
               AND B.DATATYPE = 4
               AND B.BUSSID IN (4, 5, 6)
               AND B.STATIONNUM IS NOT NULL
               AND B.STATIONNUM != 0
               AND B.STATIONSEQNUM = varduid)
     WHERE RSS.ROUTEID = varsubid AND rss.dualserialid=varduid;
  END LOOP;
  CLOSE MYCUR;
END;

-------------------------------------------------

/*SELECT DISTINCT B.ROUTEID,
                B.SUBROUTEID,
                B.STATIONSEQNUM,
                s.stationid,
                B.STATIONNUM,
                S.STATIONNAME
  FROM BSVCBUSARRLFTLD5 B, MCSTATIONINFOGS S
 WHERE B.STATIONNUM = S.STATIONNO(+)
   AND B.SUBROUTEID = '220080'
   AND B.ACTDATETIME > TRUNC(SYSDATE)
   AND B.DATATYPE = 4
   AND B.BUSSID IN (4, 5, 6)
   AND B.STATIONNUM IS NOT NULL
   AND B.STATIONNUM != 0
 ORDER BY B.STATIONSEQNUM; --到离站站点关系
SELECT RSS.ROUTEID,
       RSS.SUBROUTEID,
       RSS.DUALSERIALID,
       s.stationid,
       S.STATIONNO,
       S.STATIONNAME
  FROM MCRSEGMENTSTATIONGS RSS, MCSTATIONINFOGS S
 WHERE RSS.SUBROUTEID = '220080'
   AND RSS.STATIONID = S.STATIONID(+)
   AND S.STATIONNO IS NOT NULL
 ORDER BY RSS.DUALSERIALID; --单程站点关系*/
