SELECT TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1) + (LEVEL - 1),
               'yyyy/mm/dd') DATES
  FROM DUAL
CONNECT BY TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) + LEVEL - 1 <=
           TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)));

SELECT EMPID,
       CASE
         WHEN TO_DATE(TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1) + (LEVEL - 1),
               'yyyy/mm/dd'), 'yyyy-mm-dd') >= STARTDATE AND
              TO_DATE(TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1) + (LEVEL - 1),
               'yyyy/mm/dd'), 'yyyy-mm-dd') <= STARTDATE THEN
          EMPSID
         ELSE
          NULL
       END KQ,
       EMPSID,
       startdate,
       enddate,
       TO_CHAR(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1) + (LEVEL - 1),
               'yyyy/mm/dd') DATES
  FROM (SELECT ROWNUM RN, ASG.EMPID, ASG.EMPSID, ASG.STARTDATE, ASG.ENDDATE
          FROM ASGNREMPSTATELD ASG
         WHERE ASG.STARTDATE >= DATE '2017-1-1'
           AND TRUNC(ASG.ENDDATE) <= DATE
         '2017-1-31'
           AND ASG.EMPID = '20151130001138000529') T
CONNECT BY TRUNC(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)) + LEVEL - 1 <=
           TRUNC(LAST_DAY(ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)))
       AND PRIOR RN = RN
       AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL;
