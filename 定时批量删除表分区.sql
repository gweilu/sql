/*
名称：      定时批量删除表分区
描述：      定时删除某个段时间之前的数据（即删除表分区），例如删除5天前或5个月之前的数据。
            1、需要配合job使用。
            2、对不同的表分区日期间隔要了解，是按照天分的表分区还是按月分的，格式要确认。
      
            特别注意：使用一定要谨慎！！！！！
创建人：    Robert.wei
创建时间：  2017-2-20
*/

DECLARE s='P_20151016';
str='select '||s||' from dual;'
EXECUTE IMMEDIATE str;
ALTER TABLE BSVCBUSRUNDATALD5 DROP PARTITION s;
SELECT tp.*
  FROM USER_TAB_PARTITIONS TP
 WHERE TP.TABLE_NAME = UPPER('bsvcbusrundatald5')
AND tp.partition_name!='P_MAX'
AND  to_date(SUBSTR(tp.partition_name,3),'yyyy-mm-dd')<trunc(add_months(sysdate,-4));
