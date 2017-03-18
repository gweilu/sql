/*
project:p_safemilecount
describe：富阳驾驶员安全里程统计计算
create by:robert.wei
create time:2017-3-14
memo:新建表格将每月安全里程上月结转，本月结存，本月新增安全里程，本月扣减安全里程写入
CREATE TABLE FY_SAFEMAIL_COUNT(SMID NUMBER(20, 0), --序号
                               SETTLDATE VARCHAR(15), --记录日期
                               EMPID VARCHAR(25), --人员id
                               SMILE NUMBER(15, 2), --安全里程
                               MSMILE NUMBER(12, 2), --月安全里程
                               MTMILE NUMBER(12, 2), --月事故里程
                               lmsmile number(12,2) --上月结转里程
                               );
*/

--清空数据
SELECT * FROM FY_SAFEMAIL_COUNT;
DELETE FROM FY_SAFEMAIL_COUNT F
 WHERE F.SETTLDATE =
       TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm');

--插入数据
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
----更新本月安全里程
UPDATE FY_SAFEMAIL_COUNT F
   SET F.SMILE = F.LMSMILE + F.MSMILE - F.MTMILE
 WHERE F.SETTLDATE =
       TO_CHAR(TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE), -1)), 'yyyy-mm');
----更新反写人员级别  注意执行前一定备份，谨慎执行
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
