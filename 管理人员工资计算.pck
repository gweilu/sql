create or replace package PKG_PZH_CALC_SALARY_ADMIN is

  -- Author  : LU
  -- Created : 2016/1/9 10:46:00
  -- Purpose : ��������Ա���ʼ���
  
  -- Public type declarations
   
  -- Public constant declarations

  -- Public variable declarations

  -- Public function and procedure declarations
  PROCEDURE P_HR_ADMIN_GANGWEI(V_STARTDATE DATE,V_ENDDATE DATE,V_RECDATE DATE,V_MONTH   VARCHAR2,V_EMPIDS  VARCHAR2,V_SSGID   VARCHAR2,V_ITEMVALUE VARCHAR2,V_ITEMKEY VARCHAR2);
  PROCEDURE P_HR_ADMIN_SERVICEAGE(V_STARTDATE DATE,V_ENDDATE DATE,V_RECDATE DATE,V_MONTH   VARCHAR2,V_EMPIDS  VARCHAR2,V_SSGID   VARCHAR2,V_ITEMVALUE VARCHAR2,V_ITEMKEY VARCHAR2);
  PROCEDURE P_HR_ADMIN_JIABAN(V_STARTDATE DATE,V_ENDDATE DATE,V_RECDATE DATE,V_MONTH   VARCHAR2,V_EMPIDS  VARCHAR2,V_SSGID   VARCHAR2,V_ITEMVALUE VARCHAR2,V_ITEMKEY VARCHAR2);
  PROCEDURE P_HR_ADMIN_JIXIAO(V_STARTDATE DATE,V_ENDDATE DATE,V_RECDATE DATE,V_MONTH   VARCHAR2,V_EMPIDS  VARCHAR2,V_SSGID   VARCHAR2,V_ITEMVALUE VARCHAR2,V_ITEMKEY VARCHAR2);
end PKG_PZH_CALC_SALARY_ADMIN;
/
create or replace package body PKG_PZH_CALC_SALARY_ADMIN is

  ---�����������Ա��λ����
  PROCEDURE P_HR_ADMIN_GANGWEI(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                              V_ENDDATE   DATE, --ͳ�ƽ�������
                              V_RECDATE   DATE, --��¼����
                              V_MONTH     VARCHAR2, --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                              V_EMPIDS    VARCHAR2, --��Ա���
                              V_SSGID     VARCHAR2, --���ױ��
                              V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                              V_ITEMKEY   VARCHAR2) IS
    /*****************************************************************************
    1��
    ���ƣ�P_HR_GANGWEI
    ��;����ʻԱ��λ����
    ˵�������乤�ʶ�Ӧ�ֵ��� HRSALARYDVM=    
     Create��   CoICE    20151223
    *****************************************************************************/
    P_MONTH VARCHAR2(20):= REPLACE(V_MONTH,'-');
    V_COUNT number := 0;
    v_Average_days number := 21.75;
  BEGIN
    -- ��ȡ��׼
     SELECT COUNT(1) INTO V_COUNT
           FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'Average_days';
     IF V_COUNT>0 THEN
          SELECT VALUE INTO v_Average_days
                 FROM HR_SALARY_CONFIGS C
           WHERE C.SECTION = 'Average_days';
      END IF;
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS is not null then
      --1.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                     ROUND(CASE WHEN v_Average_days-p.v9-p.v10-p.v11>0 THEN p.v8/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                                         ELSE  0
                                  END ,2),
                     v_itemvalue,
                     v_itemkey               
          FROM HR_SALARYIMPORTDATAGD    P,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = P.EMPID
           AND S.SSGID = V_SSGID
           AND P.MONTH=P_MONTH
           AND p.v8>0
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL AND V_EMPIDS IS NULL THEN
      --2.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                     ROUND(CASE WHEN v_Average_days-p.v9-p.v10-p.v11>0 THEN p.v8/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                                         ELSE  0
                                  END ,2),
                     v_itemvalue,
                     v_itemkey               
          FROM HR_SALARYIMPORTDATAGD    P,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = P.EMPID
           AND S.SSGID = V_SSGID
           AND P.MONTH=P_MONTH
           AND NVL(p.v8,0)>0
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF; 
    COMMIT;
    end P_HR_ADMIN_GANGWEI;
  -----------------------------------------------------------------------------------  
    --������Ա���乤��
  PROCEDURE P_HR_ADMIN_SERVICEAGE(V_STARTDATE DATE, --���乤��
                            V_ENDDATE   DATE, --ͳ�ƽ�������
                            V_RECDATE   DATE, --��¼����
                            V_MONTH     VARCHAR2, --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                            V_EMPIDS    VARCHAR2, --��Ա���
                            V_SSGID     VARCHAR2, --���ױ��
                            V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                            V_ITEMKEY   VARCHAR2) IS
    /*****************************************************************************
    1��
    ���ƣ�P_HR_SERVICEAGE
    ��;�����������Ա���乤��
    ˵�������乤�ʶ�Ӧ�ֵ��� HRSALARYDVM=7
          ����*12
          ���䵼��
     Create��   CoICE    20151127
    *****************************************************************************/  
    P_MONTH VARCHAR2(20):= REPLACE(V_MONTH,'-');
    V_SERVICEAGE_SALARY_STD1 number := 1;
    V_SERVICEAGE_SALARY_STD2 number := 3;
    v_Average_days number := 21.75;
    --v_itemvalue number:=7;
    --v_itemkey VARCHAR2(64):='���乤��';
  BEGIN
    -- ��ȡ��׼
    SELECT VALUE
      INTO v_Average_days
      FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'Average_days';
    SELECT VALUE
      INTO V_SERVICEAGE_SALARY_STD1
      FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'SERVICEAGE_SALARY_STD1';
    SELECT VALUE
      INTO V_SERVICEAGE_SALARY_STD2
      FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'SERVICEAGE_SALARY_STD2';
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS is not null then
      --1.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               P_MONTH,
               SYSDATE,
               E.EMPID,
               (CASE WHEN NVL(E.SERVICEAGE, 0)<=5 and v_Average_days-p.v9-p.v10-p.v11>0
                            THEN V_SERVICEAGE_SALARY_STD1/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                     WHEN NVL(E.SERVICEAGE, 0)>5 and v_Average_days-p.v9-p.v10-p.v11>0
                            THEN V_SERVICEAGE_SALARY_STD2/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                       else 0
                END),               
               v_itemvalue,
               v_itemkey
          FROM MCEMPLOYEEINFOGS E,HR_SALARYIMPORTDATAGD P
         WHERE INSTR(',' || V_EMPIDS || ',', ',' || E.EMPID || ',') > 0
          AND  P.EMPID=E.EMPID AND P.MONTH=P_MONTH;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL AND V_EMPIDS IS NULL THEN
      --2.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, EMPID, RECDATE, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               P_MONTH,
               E.EMPID,
               SYSDATE,
                 (CASE WHEN NVL(E.SERVICEAGE, 0)<=5 and v_Average_days-p.v9-p.v10-p.v11>0
                            THEN V_SERVICEAGE_SALARY_STD1/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                     WHEN NVL(E.SERVICEAGE, 0)>5 and v_Average_days-p.v9-p.v10-p.v11>0
                            THEN V_SERVICEAGE_SALARY_STD2/v_Average_days*(v_Average_days-p.v9-p.v10-p.v11)
                       else 0
                END),
               v_itemvalue,
               v_itemkey
          FROM MCEMPLOYEEINFOGS E, HR_STAFFSALARYSETSETUPGD S,HR_SALARYIMPORTDATAGD P
         WHERE E.EMPID = S.EMPID
           AND S.SSGID = V_SSGID
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND  P.EMPID=E.EMPID AND P.MONTH=P_MONTH;
    END IF;
    COMMIT;
  END P_HR_ADMIN_SERVICEAGE;
 -------------------------------------------------------------------------------------- 
 
 ---������Ա��Ч���ʼ���
 PROCEDURE P_HR_ADMIN_JIXIAO (V_STARTDATE DATE, --
                              V_ENDDATE   DATE, --ͳ�ƽ�������
                              V_RECDATE   DATE, --��¼����
                              V_MONTH     VARCHAR2, --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                              V_EMPIDS    VARCHAR2, --��Ա���
                              V_SSGID     VARCHAR2, --���ױ��
                              V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                              V_ITEMKEY   VARCHAR2) IS
    /*****************************************************************************
    1��
    ���ƣ�P_HR_Minimum_Wage
    ��;����ȡ��͹��ʱ�׼
    ˵�������乤�ʶ�Ӧ�ֵ��� HRSALARYDVM=
    
     Create��   CoICE    20151127
    *****************************************************************************/
    P_MONTH VARCHAR2(20):= REPLACE(V_MONTH,'-');
    V_COUNT number := 0;
    V_admin_meritpay_average number := 1;
    V_admin_meritpay_operating number :=1.1;
    V_admin_meritpay_nonoperating number :=1.08;
    --v_itemvalue number:=7;
    --v_itemkey VARCHAR2(64):='���乤��';
  BEGIN
    -- ��ȡ��׼
    select count(1) into V_COUNT
    FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_average'; 
     if V_COUNT>0 
       then select value into V_admin_meritpay_average
         FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_average';  
     end if;
     select count(1) into V_COUNT
    FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_operating'; 
     if V_COUNT>0 
       then select value into V_admin_meritpay_operating
         FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_operating'; 
     end if;
     select count(1) into V_COUNT
    FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_non-operating'; 
     if V_COUNT>0 
       then select value into V_admin_meritpay_nonoperating
         FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'admin_meritpay_non-operating'; 
     end if;
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS is not null then
      --1.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
         
      --1.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                    case when e.orgid in (select o.orgid from mcorginfogs o start with o.orgid='55150213092542050000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092857160000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150203175953844320'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092919062000'
connect by prior o.orgid=o.parentorgid) then 
                      V_admin_meritpay_average*V_admin_meritpay_operating*sl.retain1
                      else
                        V_admin_meritpay_average*V_admin_meritpay_nonoperating*sl.retain1
                        end,
                     v_itemvalue,
                     v_itemkey               
          FROM HR_EMPLEVELGD          ep,
               HR_SALARYLEVELGD       sl,
               mcemployeeinfogs       e,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = ep.EMPID
           and  s.empid=e.empid
           and ep.departid=sl.departid 
           and ep.levelid=sl.levelid
           AND S.SSGID = V_SSGID
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL AND V_EMPIDS IS NULL THEN
      --2.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                    case when e.orgid in (select o.orgid from mcorginfogs o start with o.orgid='55150213092542050000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092857160000'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150203175953844320'
connect by prior o.orgid=o.parentorgid union
select o.orgid from mcorginfogs o start with o.orgid='55150213092919062000'
connect by prior o.orgid=o.parentorgid) then 
                      V_admin_meritpay_average*V_admin_meritpay_operating*sl.retain1
                      else
                        V_admin_meritpay_average*V_admin_meritpay_nonoperating*sl.retain1
                        end,
                     v_itemvalue,
                     v_itemkey               
          FROM HR_EMPLEVELGD          ep,
               HR_SALARYLEVELGD       sl,
               mcemployeeinfogs       e,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = ep.EMPID
           and  s.empid=e.empid
           and ep.departid=sl.departid 
           and ep.levelid=sl.levelid
           AND S.SSGID = V_SSGID
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF; 
    ------��ʱ��ض�ɾ��
    COMMIT;
  END P_HR_ADMIN_JIXIAO;
  ------------------------------------------------------------------------------------
  --������Ա�Ӱ๤�ʼ���
  PROCEDURE P_HR_ADMIN_JIABAN(V_STARTDATE DATE, --
                              V_ENDDATE   DATE, --ͳ�ƽ�������
                              V_RECDATE   DATE, --��¼����
                              V_MONTH     VARCHAR2, --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                              V_EMPIDS    VARCHAR2, --��Ա���
                              V_SSGID     VARCHAR2, --���ױ��
                              V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                              V_ITEMKEY   VARCHAR2) IS
    /*****************************************************************************
    1��
    ���ƣ�P_HR_JIABAN
    ��;��������Ա�Ӱ๤��
    *****************************************************************************/
    P_MONTH VARCHAR2(20):= REPLACE(V_MONTH,'-');
    V_COUNT number := 0;
    V_Average_days number := 21.75;
    V_Minimum_Wage_STD number:=1380;
    BEGIN
    -- ��ȡ��׼ 
    select COUNT(1) into v_count
    from hr_salary_configs c
    where c.section='Minimum_Wage_STD';
    if v_count>0 then 
      select value into V_Minimum_Wage_STD
      from hr_salary_configs c
      where c.section='Minimum_Wage_STD';
      end if; 
      
     SELECT COUNT(1) INTO V_COUNT
           FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'Average_days';   
    IF V_COUNT>0 THEN  
        SELECT VALUE  INTO V_Average_days
               FROM HR_SALARY_CONFIGS C
         WHERE C.SECTION = 'Average_days';
          END IF;
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS is not null then
      --1.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                     ROUND(case when p.v18>0 or p.v19>0
                     then V_Minimum_Wage_STD/V_Average_days*(p.v18*2+p.v19*3)
                       else 0 end,2),
                     v_itemvalue,
                     v_itemkey               
          FROM HR_SALARYIMPORTDATAGD    P,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = P.EMPID
           AND S.SSGID = V_SSGID
           AND P.MONTH=P_MONTH
           and (p.v18>0 or p.v19>0)
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL AND V_EMPIDS IS NULL THEN
      --2.1 delete ԭ������
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.2 insert ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
          SELECT S_HRMONTHLYRECGD.NEXTVAL,
                     P_MONTH,
                     SYSDATE,
                     S.EMPID,
                     ROUND(case when p.v18>0 or p.v19>0
                     then V_Minimum_Wage_STD/V_Average_days*(p.v18*2+p.v19*3)
                       else 0 end,2),
                     v_itemvalue,
                     v_itemkey               
          FROM HR_SALARYIMPORTDATAGD    P,
               HR_STAFFSALARYSETSETUPGD S
         WHERE  S.EMPID = P.EMPID
           AND S.SSGID = V_SSGID
           AND P.MONTH=P_MONTH
           and (p.v18>0 or p.v19>0)
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF; 
    COMMIT;
  END P_HR_ADMIN_JIABAN;
  
end PKG_PZH_CALC_SALARY_ADMIN;
/
