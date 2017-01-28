create or replace package PKG_FY_SALARY_DRIVE is
  PROCEDURE P_DRIVE_GANGWEI(V_STARTDATE DATE,
                           V_ENDDATE   DATE,
                           V_RECDATE   DATE,
                           V_MONTH     VARCHAR2,
                           V_EMPIDS    VARCHAR2,
                           V_SSGID     VARCHAR2,
                           V_ITEMVALUE VARCHAR2,
                           V_ITEMKEY   VARCHAR2);
  PROCEDURE P_DRIVE_GONGLING(V_STARTDATE DATE,
                             V_ENDDATE   DATE,
                             V_RECDATE   DATE,
                             V_MONTH     VARCHAR2,
                             V_EMPIDS    VARCHAR2,
                             V_SSGID     VARCHAR2,
                             V_ITEMVALUE VARCHAR2,
                             V_ITEMKEY   VARCHAR2);
  PROCEDURE P_DRIVE_ROUTE(V_STARTDATE DATE,
                          V_ENDDATE   DATE,
                          V_RECDATE   DATE,
                          V_MONTH     VARCHAR2,
                          V_EMPIDS    VARCHAR2,
                          V_SSGID     VARCHAR2,
                          V_ITEMVALUE VARCHAR2,
                          V_ITEMKEY   VARCHAR2);
  PROCEDURE P_DRIVE_EXCESS(V_STARTDATE DATE,
                           V_ENDDATE   DATE,
                           V_RECDATE   DATE,
                           V_MONTH     VARCHAR2,
                           V_EMPIDS    VARCHAR2,
                           V_SSGID     VARCHAR2,
                           V_ITEMVALUE VARCHAR2,
                           V_ITEMKEY   VARCHAR2);
  PROCEDURE P_DRIVE_OVERTIME(V_STARTDATE DATE,
                             V_ENDDATE   DATE,
                             V_RECDATE   DATE,
                             V_MONTH     VARCHAR2,
                             V_EMPIDS    VARCHAR2,
                             V_SSGID     VARCHAR2,
                             V_ITEMVALUE VARCHAR2,
                             V_ITEMKEY   VARCHAR2);
  procedure P_DRIVER_MILECOUNT(months varchar2);
end PKG_FY_SALARY_DRIVE;
/
create or replace package body PKG_FY_SALARY_DRIVE is

  ------------------------------------------------------
  PROCEDURE P_DRIVE_GANGWEI(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                            V_ENDDATE   DATE, --ͳ�ƽ�������
                            V_RECDATE   DATE, --��¼����
                            V_MONTH     VARCHAR2, --ͳ���·� 
                            V_EMPIDS    VARCHAR2, --��Ա���
                            V_SSGID     VARCHAR2, --���ױ��
                            V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                            V_ITEMKEY   VARCHAR2) IS
    --��ͨ������
    /*****************************************************************************
    ���ƣ�P_HR_GANGWEI
    ��;�������λ����(��ʻԱ)
    CREATE�� Robert CREATETIME: 2016-5-6
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               sl.postsaraly,
               V_ITEMVALUE,
               V_ITEMKEY
          from hr_salarylevelgd         sl,
               hr_emplevelgd            el,
               HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = el.EMPID
           AND S.SSGID = V_SSGID
           and el.levelid = sl.levelid
           and el.departid = sl.departid
           and p_month between el.begindate and el.enddate
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE
           AND INSTR(',' || V_EMPIDS || ',', ',' || S.EMPID || ',') > 0;
    END IF;
    --2 ������������
    IF V_SSGID IS NOT NULL AND V_EMPIDS IS NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE M.EMPID IN
             (SELECT EMPID
                FROM HR_STAFFSALARYSETSETUPGD S
               WHERE S.SSGID = V_SSGID
                 AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE)
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               sl.postsaraly,
               V_ITEMVALUE,
               V_ITEMKEY
          from hr_salarylevelgd         sl,
               hr_emplevelgd            el,
               HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = el.EMPID
           AND S.SSGID = V_SSGID
           and el.levelid = sl.levelid
           and el.departid = sl.departid
           and p_month between el.begindate and el.enddate
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_DRIVE_GANGWEI;

  ---------------------------------------------------------------------------------
  PROCEDURE P_DRIVE_GONGLING(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                             V_ENDDATE   DATE, --ͳ�ƽ�������
                             V_RECDATE   DATE, --��¼����
                             V_MONTH     VARCHAR2, --ͳ���·� 
                             V_EMPIDS    VARCHAR2, --��Ա���
                             V_SSGID     VARCHAR2, --���ױ��
                             V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                             V_ITEMKEY   VARCHAR2) IS
    --��ͨ������
    /*****************************************************************************
    ���ƣ�P_DRIVE_GONGLING
    ��;����ʻԱ���乤��(��ʻԱ�������)
    CREATE�� Robert  CREATETIME:2016-5-6
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               e.serviceage * 50,
               V_ITEMVALUE,
               V_ITEMKEY
          from mcemployeeinfogs e, HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = e.EMPID
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
         AND M.ITEMVALUE = v_itemvalue;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               e.serviceage * 50,
               V_ITEMVALUE,
               V_ITEMKEY
          from mcemployeeinfogs e, HR_STAFFSALARYSETSETUPGD S
         WHERE S.EMPID = e.EMPID
           AND S.SSGID = V_SSGID
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_DRIVE_GONGLING;

  ---------------------------------------------------------------------------------

  PROCEDURE P_DRIVE_ROUTE(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                          V_ENDDATE   DATE, --ͳ�ƽ�������
                          V_RECDATE   DATE, --��¼����
                          V_MONTH     VARCHAR2, --ͳ���·� 
                          V_EMPIDS    VARCHAR2, --��Ա���
                          V_SSGID     VARCHAR2, --���ױ��
                          V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                          V_ITEMKEY   VARCHAR2) IS
    --��ͨ������
    /*****************************************************************************
    ���ƣ�P_DRIVE_ROUTE
    ��;����ʻԱ��·��Ч�湤��
    CREATE��Robert  CREATETIME��2016-5-6
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    insert into salary_temp (t1,t2,t3,t4,t5,t6,t7,t8) values (V_STARTDATE,V_ENDDATE,V_RECDATE,V_MONTH,V_EMPIDS,V_SSGID,V_ITEMVALUE,V_ITEMKEY);
    --1���� ׷�ӻ����������ɲ�����Ա
    IF V_EMPIDS IS NOT NULL THEN
      DELETE FROM HRMONTHLYRECGD M
       WHERE INSTR(',' || V_EMPIDS || ',', ',' || M.EMPID || ',') > 0
         AND M.SALARYDATE = P_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --1.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               (select sum(a.sumlc * a.proute * a.pmodel * a.pservice *
                           a.pother)
                  from sa_dr_mile a
                 where a.driverid = s.empid
                   and a.rundate = substr(V_MONTH,1,4)||'-'||substr(V_MONTH,5,2)),
               V_ITEMVALUE,
               V_ITEMKEY
          from HR_STAFFSALARYSETSETUPGD S
         WHERE S.SSGID = V_SSGID
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
         AND M.SALARYDATE = V_MONTH
         AND M.ITEMVALUE = v_itemvalue;
      --2.1 INSERT ������
      INSERT INTO HRMONTHLYRECGD
        (SEQID, SALARYDATE, RECDATE, EMPID, REAL, ITEMVALUE, ITEMKEY)
        select s_hrmonthlyrecgd.nextval,
               V_MONTH,
               sysdate,
               s.empid,
               (select sum(a.sumlc * a.proute * a.pmodel * a.pservice *
                           a.pother)
                  from sa_dr_mile a
                 where a.driverid = s.empid
                   and a.rundate = substr(V_MONTH,1,4)||'-'||substr(V_MONTH,5,2)),
               V_ITEMVALUE,
               V_ITEMKEY
          from HR_STAFFSALARYSETSETUPGD S
         WHERE S.SSGID = V_SSGID
           AND P_MONTH BETWEEN S.BEGINDATE AND S.ENDDATE;
    END IF;
    COMMIT;
  END P_DRIVE_ROUTE;

  ------------------------------------------------------------------------------

  PROCEDURE P_DRIVE_EXCESS(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                           V_ENDDATE   DATE, --ͳ�ƽ�������
                           V_RECDATE   DATE, --��¼����
                           V_MONTH     VARCHAR2, --ͳ���·� 
                           V_EMPIDS    VARCHAR2, --��Ա���
                           V_SSGID     VARCHAR2, --���ױ��
                           V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                           V_ITEMKEY   VARCHAR2) IS --��ͨ������
    /*****************************************************************************
    ���ƣ�P_DRIVE_EXCESS
    ��;����ʻԱ���˹��ʼ��� ��ʱû�з��� ���õ��뷽ʽ
    CREATE��Robert CREATETIME:2016-5-6
    *****************************************************************************/
  BEGIN
    commit;
  END P_DRIVE_EXCESS;

  -------------------------------------------------------------------------------
  PROCEDURE P_DRIVE_OVERTIME(V_STARTDATE DATE, --ͳ�ƿ�ʼ����
                             V_ENDDATE   DATE, --ͳ�ƽ�������
                             V_RECDATE   DATE, --��¼����
                             V_MONTH     VARCHAR2, --ͳ���·� 
                             V_EMPIDS    VARCHAR2, --��Ա���
                             V_SSGID     VARCHAR2, --���ױ��
                             V_ITEMVALUE VARCHAR2, --��ͨ��ֵ
                             V_ITEMKEY   VARCHAR2) IS
    /*****************************************************************************
    ���ƣ�P_DRIVE_OVERTIME
    ��;����ʻԱ�Ӱ๤�ʼ���
    CREATE��Robert  CREATETIME��2016-5-6
    *****************************************************************************/
    P_MONTH VARCHAR2(20) := REPLACE(V_MONTH, '-');
  BEGIN
    commit;
  END P_DRIVE_OVERTIME;
  
  ---------------------------------------------------------------------------------

  procedure P_DRIVER_MILECOUNT(months varchar2 ) --��Ҫ���ݴ���ͳ�Ƶ��·�
    is
     /*****************************************************************************
    ���ƣ�P_DRIVER_MILECOUNT
    ��;����ʻԱ�������ݻ���ͳ��
    CREATE��Robert CREATETIME:2016-5-6
    *****************************************************************************/
  begin
    delete from Sa_Dr_Mile s
     where s.rundate = to_char(to_date(months, 'yyyy-mm-dd'), 'yyyy-mm');
    insert into Sa_Dr_Mile s
      (s.coid,
       s.driverid,
       s.drivername,
       s.routeid,
       s.busselfid,
       s.bustid,
       s.yylc,
       s.fyylc,
       s.sumlc,
       s.sumzslc,
       s.proute,
       s.pmodel,
       s.pservice,
       s.pother,
       s.rundate)
      select fy_seq.nextval,
             t.driverid,
             e.empname,
             t.routeid,
             t.busselfid,
             b.bustid,
             t.yylc,
             t.fyylc,
             t.yylc + t.fyylc sumlc,
             t.yylc + t.fyylc * 0.8 sumzslc,
             p.route_xs,
             p.model_xs,
             t.itemstrvalue,
             p.other_xs,
             to_char(to_date(months, 'yyyy-mm-dd'), 'YYYY-MM')
        from (select f.driverid,
                     f.routeid,
                     f.busselfid,
                     sum(case
                           when (f.rectype = 1 or f.bussid in (61, 14, 82, 83)) then
                            f.milenum
                           else
                            0
                         end) yylc,
                     sum(case
                           when f.rectype = 2 and
                                f.bussid not in (61, 14, 82, 83) then
                            f.milenum
                           else
                            0
                         end) fyylc
                from fdisbusrunrecgd f
               where f.rundatadate between
                     trunc(to_date(months, 'yyyy-mm-dd'), 'MONTH') and
                     last_day(trunc(to_date(months, 'yyyy-mm-dd'), 'MONTH'))
                 and f.isavailable=1
               group by f.driverid, f.routeid, f.busselfid) t,
             mcemployeeinfogs e,
             mcbusinfogs b,
             MCROUTEANDMODEL p,
             typeentry t
       where t.driverid = e.empid(+)
         and t.busselfid = b.busselfid(+)
         and t.routeid = p.routeid
         and b.bustid = p.modelid
         and p.service_xs = t.itemvalue
         and t.typename = 'ROUTERATE';
        
  INSERT INTO MCPROCEDURELOGLD  ----�洢����ִ�����
          (LOGID,PROCEDURENAME,EXECSTARTTIME,EXECENDTIME,ISFINISH,PROGRESS,MEMOS)
          VALUES(fy_seq.nextval,'PKG_FY_SALARY_DRIVE.P_DRIVER_MILECOUNT',
               SYSDATE,'','0','�������', months||'����ʻԱ�������ݻ��ܡ��������');
  end P_DRIVER_MILECOUNT;
end PKG_FY_SALARY_DRIVE;
/
