/*
project:p_safemilecount
describe��������ʻԱ��ȫ���ͳ�Ƽ���
create by:robert.wei
create time:2017-3-14
memo:�½����ÿ�°�ȫ������½�ת�����½�棬����������ȫ��̣����¿ۼ���ȫ���д��
CREATE TABLE FY_SAFEMAIL_COUNT(SMID NUMBER(20, 0), --���
                               SETTLDATE VARCHAR(15), --��¼����
                               EMPID VARCHAR(25), --��Աid
                               SMILE NUMBER(15, 2), --��ȫ���
                               MSMILE NUMBER(12, 2), --�°�ȫ���
                               MTMILE NUMBER(12, 2), --���¹����
                               lmsmile number(12,2) --���½�ת���
                               );
*/

--�������
SELECT * FROM FY_SAFEMAIL_COUNT;
DELETE FROM FY_SAFEMAIL_COUNT F
 WHERE F.SETTLDATE =
       TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm');

--��������
INSERT INTO FY_SAFEMAIL_COUNT
  (SMID, SETTLDATE, EMPID, MSMILE, MTMILE, LMSMILE, SMILE)
  SELECT FY_SEQ.NEXTVAL,
         TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm'),
         E.EMPID,
         CASE
           WHEN SM.SMPMILE IS NULL THEN
            0
           ELSE
            SM.SMPMILE
         END SMPMILE,
         CASE
           WHEN P.PMAIL IS NULL THEN
            0
           ELSE
            P.PMAIL
         END PMILE,
         CASE
           WHEN FSC.SMILE IS NULL THEN
            0
           ELSE
            FSC.SMILE
         END SMILE,
         0
    FROM MCEMPLOYEEINFOGS E,
         (SELECT EMPID, SMILE
            FROM FY_SAFEMAIL_COUNT
           WHERE SETTLDATE =
                 TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm')) FSC,
         (SELECT DRIVERID, MONTHSAFEMILE SMPMILE
            FROM SS_DRIVERSAFEMILEMONTHRECGD
           WHERE RECMONTH = TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -2) + 1)) SM,
         (SELECT S.EMPID, SUM(SP.SAFTYMILES) PMAIL
            FROM SS_ACCIDENTPUNISHDETAILGD SP, SS_ACCIDENTGD S
           WHERE SP.ACCIDENTID = S.ACCIDENTID(+)
             AND S.ACCIDENTTIME BETWEEN
                 TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -2) + 1) AND
                 TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1))
           GROUP BY S.EMPID) P
   WHERE E.ISACTIVE = 1
     AND E.EMPID = P.EMPID(+)
     AND E.EMPID = SM.DRIVERID(+)
     AND E.EMPID = FSC.EMPID(+);
----���±��°�ȫ���
UPDATE FY_SAFEMAIL_COUNT F
   SET F.SMILE = F.LMSMILE + F.MSMILE - F.MTMILE
 WHERE F.SETTLDATE =
       TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm');
----���·�д��Ա����  ע��ִ��ǰһ�����ݣ�����ִ��
/*UPDATE HR_EMPLEVELGD HL
   SET HL.LEVELID =
       (SELECT f.empid, CASE WHEN f.smile<=50000 THEN 1
       WHEN f.smile>50000 AND f.smile<=100000 THEN 2
          WHEN f.smile>100000 AND f.smile<=200000 THEN 3
             WHEN f.smile>200000 AND f.smile<=500000 THEN 4
                WHEN f.smile>500000 AND f.smile<=800000 THEN 5
                  WHEN f.smile>800000 AND f.smile<=1000000 THEN 6
                    WHEN f.smile>1000000 THEN 7
                      ELSE NULL END eLEVEL
        FROM FY_SAFEMAIL_COUNT F
         WHERE  F.SETTLDATE =
                    TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm') AND hl.empid=f.empid);*/
                    SELECT * FROM HR_EMPLEVELGD
SELECT TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm') FROM dual;
