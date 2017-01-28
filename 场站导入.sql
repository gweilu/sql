SELECT * FROM MCSITEINFOGS; --非营运场所信息表
SELECT * FROM MCRSITESITEGS FOR UPDATE; --场所关系信息表
SELECT * FROM MCROUTEINFOGS R WHERE R.ROUTENAME LIKE '%331%';
SELECT *
  FROM BSVCBUSRUNDATALD5 B
 WHERE B.ACTDATETIME > DATE '2016-4-1'
   AND B.ACTDATETIME < DATE '2016-4-30'
   AND B.ROUTEID = '723310';
SELECT * FROM TYPEENTRY T WHERE T.TYPENAME LIKE '%MILETYPE%';

CREATE TABLE CZXX_TEMP(CZID VARCHAR2(30),
                       CZNAME VARCHAR2(30),
                       LO VARCHAR2(15),
                       LA VARCHAR2(15),
                       STYPE VARCHAR2(15)); --场站信息临时表
CREATE TABLE RCZXL_TEMP(CZID VARCHAR2(30),
                        CZNAME VARCHAR2(30),
                        ROUTENAME VARCHAR(15),
                        ROUTEID VARCHAR(15)); --场站线路关系临时表
CREATE TABLE RCZCZ_TEMP(SCZNAME VARCHAR2(30),
                        SCZID VARCHAR2(30),
                        ECZNAME VARCHAR2(30),
                        ECZID VARCHAR2(30),
                        ROUTEID VARCHAR2(15),
                        MILENUM VARCHAR2(10),
                        RTIME VARCHAR2(10),
                        RTYPE VARCHAR2(10)); --场站关系临时表

SELECT * FROM CZXX_TEMP;
SELECT * FROM MCSITEINFOGS;
SELECT * FROM MCRSITESITEGS; --场所关系信息表
SELECT * FROM RCZXL_TEMP FOR UPDATE;
SELECT * FROM RCZCZ_TEMP FOR UPDATE;
SELECT * FROM USER_TABLES T WHERE T.TABLE_NAME LIKE '%MCRSITE%';
/*
INSERT INTO MCRSITESITEGS RS
  (RS.RSITESITEID,
   RS.SITEID1,
   RS.SITEID2,
   RS.ROUTEID,
   RS.STDMILE,
   RS.STDTIME,
   RS.MILETYPEID,
   RS.ISACTIVE)
  SELECT HZ_SEQ.NEXTVAL,
         RT.SCZID,
         RT.ECZID,
         RT.ROUTEID,
         RT.MILENUM,
         RT.RTIME,
         RT.RTYPE,
         1
    FROM RCZCZ_TEMP RT*/
SELECT * FROM MCRSITEROUTEGS FOR UPDATE;
INSERT INTO MCRSITEROUTEGS RSR
  (RSR.RSITEROUTEID, RSR.SITEID, RSR.ROUTEID, RSR.SITETYPE)
  SELECT HZ_SEQ.NEXTVAL, RT.CZID, RT.ROUTEID, 1
    FROM RCZXL_TEMP RT
         /*DELETE FROM MCRSITEROUTEGS a WHERE a.routeid='120240'*/
     /*    
          UPDATE MCRSITEROUTEGS RS SET RS.SITETYPE = (SELECT MS.SITETYPE
                                                                                  FROM MCSITEINFOGS MS
                                                                                 WHERE MS.SITEID =
                                                                                       RS.SITEID)
                                                                                       
                                                                                      
*/
SELECT hz_seq.nextval FROM dual;10000050390
SELECT * FROM MCRSITEBUSGS msb WHERE msb.busid='20151113165228000283'
INSERT INTO MCRSITEBUSGS msb (msb.rsitebusid,msb.siteid,msb.busid) SELECT FROM  
UPDATE MCRSITEBUSGS msb SET msb.busid=(SELECT b.busid FROM mcbusinfogs b where b.busselfid='1-7493')
