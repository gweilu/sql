CREATE OR REPLACE PACKAGE PKG_FY_SALARY_ADMIN IS
  PROCEDURE P_ADMIN_GONGLING(V_STARTDATE DATE,
                             V_ENDDATE   DATE,
                             V_RECDATE   DATE,
                             V_MONTH     VARCHAR2,
                             V_EMPIDS    VARCHAR2,
                             V_SSGID     VARCHAR2,
                             V_ITEMVALUE VARCHAR2,
                             V_ITEMKEY   VARCHAR2);
  PROCEDURE P_ADMIN_JIXIAO(V_STARTDATE DATE,
                           V_ENDDATE   DATE,
                           V_RECDATE   DATE,
                           V_MONTH     VARCHAR2,
                           V_EMPIDS    VARCHAR2,
                           V_SSGID     VARCHAR2,
                           V_ITEMVALUE VARCHAR2,
                           V_ITEMKEY   VARCHAR2);
  PROCEDURE P_ADMIN_OVERTIME(V_STARTDATE DATE,
                             V_ENDDATE   DATE,
                             V_RECDATE   DATE,
                             V_MONTH     VARCHAR2,
                             V_EMPIDS    VARCHAR2,
                             V_SSGID     VARCHAR2,
                             V_ITEMVALUE VARCHAR2,
                             V_ITEMKEY   VARCHAR2);
  PROCEDURE P_ADMIN_GANGWEI(V_STARTDATE DATE,
                            V_ENDDATE   DATE,
                            V_RECDATE   DATE,
                            V_MONTH     VARCHAR2,
                            V_EMPIDS    VARCHAR2,
                            V_SSGID     VARCHAR2,
                            V_ITEMVALUE VARCHAR2,
                            V_ITEMKEY   VARCHAR2);

END PKG_FY_SALARY_ADMIN;
/
CREATE OR REPLACE PACKAGE BODY PKG_FY_SALARY_ADMIN IS

  PROCEDURE P_ADMIN_GONGLING(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                             V_ENDDATE   DATE, --ͳ�ƽ�������
                             V_RECDATE   DATE, --��¼����
                             V_MONTH     VARCHAR2, --ͳ���·� 
                             V_EMPIDS    VARCHAR2, --��Ա���
                             V_SSGID     VARCHAR2, --���ױ��
                             V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                             V_ITEMKEY   VARCHAR2) IS
    --������Ա�������
    /*****************************************************************************
    ���ƣ�P_ADMIN_GONGLING
    ��;������Ա�������
    CREATE�� Robert  CREATETIME:2016-11-24
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               E.SERVICEAGE * 10,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM MCEMPLOYEEINFOGS E, HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = E.EMPID
           AND S.SSGID = V_SSGID
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               E.SERVICEAGE * 10,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM MCEMPLOYEEINFOGS E, HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = E.EMPID
           AND S.SSGID = V_SSGID
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_ADMIN_GONGLING;
  -------------------------------------------------------------------------------
  PROCEDURE P_ADMIN_OVERTIME(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                             V_ENDDATE   DATE, --ͳ�ƽ�������
                             V_RECDATE   DATE, --��¼����
                             V_MONTH     VARCHAR2, --ͳ���·� 
                             V_EMPIDS    VARCHAR2, --��Ա���
                             V_SSGID     VARCHAR2, --���ױ��
                             V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                             V_ITEMKEY   VARCHAR2) IS
    --������Ա�Ӱ๤��
    /*****************************************************************************
    ���ƣ�P_ADMIN_OVERTIEM
    ��;��������Ա�Ӱ๤��
    CREATE�� Robert  CREATETIME:2016-11-24
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
    V_COUNT number := 0;
    V_WORKDAY number := 21.75;
  BEGIN
     --��ȡ��׼
      select count(1) into V_COUNT
    FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'SAL_WORKDAY'; 
     if V_COUNT>0 
       then select value into V_WORKDAY
         FROM HR_SALARY_CONFIGS C
     WHERE C.SECTION = 'SAL_WORKDAY';  
     end if;
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.postsaraly*t.v1*3/V_WORKDAY,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.postsaraly*t.v1*3/V_WORKDAY,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_ADMIN_OVERTIME;
  -------------------------------------------------------------------------------
  PROCEDURE P_ADMIN_JIXIAO(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                           V_ENDDATE   DATE, --ͳ�ƽ�������
                           V_RECDATE   DATE, --��¼����
                           V_MONTH     VARCHAR2, --ͳ���·� 
                           V_EMPIDS    VARCHAR2, --��Ա���
                           V_SSGID     VARCHAR2, --���ױ��
                           V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                           V_ITEMKEY   VARCHAR2) IS
    --������Ա��Ч����
    /*****************************************************************************
    ���ƣ�P_ADMIN_JIXIAO
    ��;��������Ա��Ч���ʼ���
    CREATE�� Robert  CREATETIME:2016-11-24
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.dutysalary*t.v2,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
         SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.dutysalary*t.v2,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_ADMIN_JIXIAO;
  -------------------------------------------------------------------------------
  PROCEDURE P_ADMIN_GANGWEI(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                            V_ENDDATE   DATE, --ͳ�ƽ�������
                            V_RECDATE   DATE, --��¼����
                            V_MONTH     VARCHAR2, --ͳ���·� 
                            V_EMPIDS    VARCHAR2, --��Ա���
                            V_SSGID     VARCHAR2, --���ױ��
                            V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                            V_ITEMKEY   VARCHAR2) IS
    --������Ա��λ����
    /*****************************************************************************
    ���ƣ�P_ADMIN_GANGWEI
    ��;��������Ա��λ���ʼ���
    CREATE�� Robert  CREATETIME:2016-11-24
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
         SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.postsaraly*t.v2,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = V_ITEMVALUE;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
         SELECT S_HRMONTHLYRECGD.NEXTVAL,
               V_MONTH,
               SYSDATE,
               S.EMPID,
               sl.postsaraly*t.v2,
               V_ITEMVALUE,
               V_ITEMKEY
          FROM HR_STAFFSALARYSETSETUPGD S,
               HR_SALARYIMPORTDATAGD    T,
               HR_EMPLEVELGD            EP,
               HR_SALARYLEVELGD         SL
         WHERE S.SSGID = V_SSGID
           AND S.EMPID = T.EMPID
           AND S.EMPID = EP.EMPID
           AND T.MONTH = P_MONTH
           AND EP.DEPARTID = SL.DEPARTID
           AND EP.LEVELID = SL.LEVELID
           AND ep.isactive=1
           AND ep.begindate<P_MONTH
           and ep.enddate>P_MONTH
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_ADMIN_GANGWEI;
END PKG_FY_SALARY_ADMIN;
/
