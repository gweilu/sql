/*
名称：      定时批量删除表分区
描述：      定时删除某个段时间之前的数据（即删除表分区），例如删除5天前或5个月之前的数据。
            1、需要配合job使用。
            2、对不同的表分区日期间隔要了解，是按照天分的表分区还是按月分的，格式要确认。
      
            特别注意：使用一定要谨慎！！！！！
创建人：    Robert.wei
创建时间：  2017-2-20
*/
CREATE OR REPLACE PROCEDURE DEL_TABLE_PARTITION IS
  VARPAR VARCHAR2(20);
  STR    VARCHAR2(1000);
  CURSOR MYCUR IS
    SELECT TP.PARTITION_NAME
      FROM USER_TAB_PARTITIONS TP
     WHERE TP.TABLE_NAME = UPPER('bsvcbusrundatald5')
       AND TP.PARTITION_NAME != 'P_MAX'
       AND TO_DATE(TRIM(SUBSTR(TP.PARTITION_NAME, 3)), 'yyyy-mm-dd') <
           TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -4)), 'yyyy-mm-dd'),  
                   'yyyy-MM-dd');
  --4代表4个月前的数据
BEGIN
  OPEN MYCUR;
  LOOP
    STR := '';
    FETCH MYCUR
      INTO VARPAR;
    EXIT WHEN MYCUR%NOTFOUND;
    STR := 'ALTER TABLE BSVCBUSRUNDATALD5 DROP PARTITION ' || VARPAR;
    EXECUTE IMMEDIATE STR;
  END LOOP;
  CLOSE MYCUR;
END;
--注意：使用trunc会出现年份值介于4713 到9999的错误，建议使用to_char（xxxx-xx-xx，'yyyy-mm-dd'）
  --同时做to_date之前建议使用trim去除空格否则也会出现上述错误
  /*ALTER TABLE BSVCBUSRUNDATALD5 DROP PARTITION s;
  SELECT tp.*
    FROM USER_TAB_PARTITIONS TP
   WHERE TP.TABLE_NAME = UPPER('bsvcbusrundatald5')
  AND tp.partition_name!='P_MAX'
  AND  to_date(SUBSTR(tp.partition_name,3),'yyyy-mm-dd')<trunc(add_months(sysdate,-4));*/
/
