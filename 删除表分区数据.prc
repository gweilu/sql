/*
���ƣ�      ��ʱ����ɾ�������
������      ��ʱɾ��ĳ����ʱ��֮ǰ�����ݣ���ɾ���������������ɾ��5��ǰ��5����֮ǰ�����ݡ�
            1����Ҫ���jobʹ�á�
            2���Բ�ͬ�ı�������ڼ��Ҫ�˽⣬�ǰ�����ֵı�������ǰ��·ֵģ���ʽҪȷ�ϡ�
      
            �ر�ע�⣺ʹ��һ��Ҫ��������������
�����ˣ�    Robert.wei
����ʱ�䣺  2017-2-20
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
  --4����4����ǰ������
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
--ע�⣺ʹ��trunc��������ֵ����4713 ��9999�Ĵ��󣬽���ʹ��to_char��xxxx-xx-xx��'yyyy-mm-dd'��
  --ͬʱ��to_date֮ǰ����ʹ��trimȥ���ո����Ҳ�������������
  /*ALTER TABLE BSVCBUSRUNDATALD5 DROP PARTITION s;
  SELECT tp.*
    FROM USER_TAB_PARTITIONS TP
   WHERE TP.TABLE_NAME = UPPER('bsvcbusrundatald5')
  AND tp.partition_name!='P_MAX'
  AND  to_date(SUBSTR(tp.partition_name,3),'yyyy-mm-dd')<trunc(add_months(sysdate,-4));*/
/
