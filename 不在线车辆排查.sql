SELECT E.EMPID, E.EMPNAME, O.ORGNAME, E.ISACTIVE
  FROM MCEMPLOYEEINFOGS E, MCORGINFOGS O
 WHERE E.ORGID = O.ORGID(+)
   AND E.EMPNAME LIKE '%�Ӵ�%';

SELECT E.ISACTIVE
  FROM MCEMPLOYEEINFOGS E
 WHERE E.EMPID = 201602231658000750
   FOR UPDATE;

------------------------------------
SELECT * FROM MCRBUSBUSMACHINEGS;
----------------------------
SELECT B.BUSSELFID, O.ORGNAME
  FROM MCBUSINFOGS B, MCORGINFOGS O
 WHERE B.ORGID = O.ORGID(+)
   AND B.BUSID NOT IN
       (SELECT DISTINCT RBM.BUSID
          FROM BSVCBUSRUNDATALD5 G, MCRBUSBUSMACHINEGS RBM
         WHERE G.ACTDATETIME > DATE '2016-7-28'
           AND G.ACTDATETIME < DATE'2016-7-30'
           AND G.PRODUCTID = RBM.PRODUCTID(+) AND rbm.busid IS NOT NULL);
---------------------------------
SELECT B.BUSSELFID
  FROM   (SELECT DISTINCT RBM.BUSID
          FROM BSVCBUSRUNDATALD5 G, MCRBUSBUSMACHINEGS RBM
         WHERE G.ACTDATETIME > DATE '2016-7-20'
           AND G.ACTDATETIME < DATE'2016-7-30'
           AND G.PRODUCTID = RBM.PRODUCTID(+) AND rbm.busid IS NOT NULL) a RIGHT OUTER JOIN MCBUSINFOGS B  
           ON a.busid=b.busid
 WHERE a.busid IS NULL;


SELECT  FROM mcbusinfogs  
CREATE TABLE bus_temp
(
busselfid VARCHAR2(15)
)
INSERT INTO bus_temp SELECT B.BUSSELFID
  FROM   (SELECT DISTINCT RBM.BUSID
          FROM BSVCBUSRUNDATALD5 G, MCRBUSBUSMACHINEGS RBM
         WHERE G.ACTDATETIME > DATE '2016-7-20'
           AND G.ACTDATETIME < DATE'2016-7-30'
           AND G.PRODUCTID = RBM.PRODUCTID(+) AND rbm.busid IS NOT NULL) a RIGHT OUTER JOIN MCBUSINFOGS B  
           ON a.busid=b.busid
 WHERE a.busid IS NULL;
 
 SELECT t.busselfid,o.orgname FROM bus_temp t,mcbusinfogs b,mcorginfogs o 
 WHERE t.busselfid=b.busselfid(+) AND b.orgid=o.orgid(+)
