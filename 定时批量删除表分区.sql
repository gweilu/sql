/*
���ƣ�      ��ʱ����ɾ�������
������      ��ʱɾ��ĳ����ʱ��֮ǰ�����ݣ���ɾ���������������ɾ��5��ǰ��5����֮ǰ�����ݡ�
            1����Ҫ���jobʹ�á�
            2���Բ�ͬ�ı�������ڼ��Ҫ�˽⣬�ǰ�����ֵı�������ǰ��·ֵģ���ʽҪȷ�ϡ�
      
            �ر�ע�⣺ʹ��һ��Ҫ��������������
�����ˣ�    Robert.wei
����ʱ�䣺  2017-2-20
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
