/******************************************************************************

��������������·�͵��̷����վ����Ϣ����ʱ���ֳ���·ʹ�õ������ļ�����ȷ��ʱ��
          �ó��ػ��ϴ��ĵ���վ��Ϣ��������·�͵��̵�վ����Ϣ��

����������Routeid����·id��

���ߣ�Robert.Wei

�����  bsvcbusarrlftld5(����վ)
          mcrroutestationgs����·վ���ϵ��˫�̣�
          mcrsegmentstationgs������վ���ϵ�����̣�

�������:��bsvcbusarrlftld5�в�����·�ı�վ��Ϣ������

�������ڣ�2016-10-29

������ڣ�2016-0-29

*********************************************************************************

�޸�Ŀ�ģ�

�޸�����������

�޸��ˣ�

�޸����ڣ�

������ڣ�

*************************************************************************************/
SELECT * FROM MCSUBROUTEINFOGS S WHERE S.SUBROUTENAME LIKE '%90%';
---------ͨ���α�ӵ�����·��ϵ���ҵ��͵���վ���ݲ��ֺ͵�վ�㲢���и���
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
 ORDER BY B.STATIONSEQNUM; --����վվ���ϵ
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
 ORDER BY RSS.DUALSERIALID; --����վ���ϵ*/
