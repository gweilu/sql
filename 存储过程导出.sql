---------------------------------------------
-- Export file for user APTSPZH@APTS_LOCAL --
-- Created by lu on 2016/3/14, 15:09:03 -----
---------------------------------------------

set define off
spool �洢���̵���.log

prompt
prompt Creating procedure CLEAR_PERMISSIONS
prompt ====================================
prompt
create or replace procedure aptspzh.Clear_Permissions
(v_routeid in nvarchar2)
is
begin
update mcrusersubroutegs a set islogin=0
where a.logintime>trunc(sysdate)  and a.islogin=1 and a.routeid=v_routeid;
commit;
end Clear_Permissions;
/

prompt
prompt Creating procedure PROPZHDRB
prompt ============================
prompt
create or replace procedure aptspzh.propzhdrb is
begin
delete from PZHDRB where recorddate=trunc(sysdate-1);
commit;
  --------------��������
  insert into pzhdrb (orgid,orgname,routeid,routename,busnumber,subroutename,routelength,routestid,routeedid,routestname,routeedname,planpbrq,planpbzb,planbcrq,planbczb,clnum,realbczb,realbcrq,mails,recorddate)
  select o.parentorgid,ogp.orgname,a.routeid,a.routename,a.busnumber,b.subroutename,b.routenetlength,c.fststationid,c.lststationid,d.stationname ft,e.stationname lt,
sum(case
             when f.shiftdetailtype = 11 and f.shifttype = 1  then
              1
             else
              0
           end) riqin,
       sum(case
             when  f.shifttype=2  then
              2
             when f.shifttype=1 and f.shiftdetailtype!=11  then
              1
              else
                0
           end) zhengban,
           sum(case
             when f.shiftdetailtype = 11 and f.shifttype = 1  then
              f.seqnum1+f.seqnum2
             else
              0
           end) riqinbc,
       sum(case
             when f.shiftdetailtype != 11 and f.shifttype=1  then
              f.seqnum1
              when f.shifttype=2  then
                f.seqnum1+f.seqnum2
             else
              0
           end) zhengbanbc,
             round(sum(
              f.seqnum1+f.seqnum2
            )/sum(f.shifttype)/2,1) quanshu,
           h.realzb,h.realrq,h.miles,to_date(sysdate-1)
from mcrouteinfogs a,mcsubrouteinfogs b,mcsegmentinfogs c,mcstationinfogs d,mcstationinfogs e,SCHPLANGD g, SCHPLANSHIFTGD f,mcorginfogs o,
mcrorgroutegs ro,mcorginfogs ogp,
(select routeid,sum(case
           when shiftdetailtype!=11 and rectype=1 then
           seqnum
           else
              0
           end) realzb,
           sum(case
           when shiftdetailtype=11 and rectype=1 then
           seqnum
           else
              0
           end) realrq,
           sum(milenum��miles
             from fdisbusrunrecgd
           where  to_char(rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and isavailable=1 group by routeid) h
where a.routeid=b.routeid(+) and b.subrouteid=c.subrouteid(+) and c.fststationid=d.stationid(+) and c.lststationid=e.stationid(+)
and a.routeid=g.routeid(+) and g.planid=f.planid(+) and a.routeid=h.routeid(+) and a.routeid=ro.routeid(+) and ro.orgid=o.orgid(+)
and o.parentorgid=ogp.orgid(+) and
 g.planid in (select ASGNARRANGEGD.planid from ASGNARRANGEGD where
to_char(ASGNARRANGEGD.execdate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ASGNARRANGEGD.status='d' /*and ASGNARRANGEGD.routeid=4*/)
and c.rundirection!=2 and b.isactive=1
group by a.orgid,a.routeid,a.routename,a.busnumber,b.subroutename,b.routenetlength,c.fststationid,c.lststationid,
d.stationname,e.stationname,h.realzb,h.realrq,h.miles,o.orgname,ogp.orgname,o.parentorgid
order by o.parentorgid;
commit;
---�ϲ�102
update pzhdrb a set /*a.routelength=a.routelength+(select routelength from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),*/
a.busnumber=a.busnumber+(select busnumber from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.planpbzb=a.planpbzb+(select planpbzb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.planpbrq=a.planpbrq+(select planpbrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.planbczb=a.planbczb+(select planbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.planbcrq=a.planbcrq+(select planbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.realbczb=a.realbczb+(select realbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.realbcrq=a.realbcrq+(select realbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201),
a.mails=a.mails+(select mails from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=10201)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and a.routeid=102;
commit;
update pzhdrb a set a.clnum=(a.planbczb+a.planbcrq)/((a.planpbzb+a.planpbrq)*2)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and a.routeid=102;
 commit;
--�ϲ�111
update pzhdrb a set a.routename='111·',
/*a.routelength=a.routelength+(select routelength from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),*/
a.busnumber=a.busnumber+(select busnumber from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.planpbzb=a.planpbzb+(select planpbzb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.planpbrq=a.planpbrq+(select planpbrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.planbczb=a.planbczb+(select planbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.planbcrq=a.planbcrq+(select planbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.realbczb=a.realbczb+(select realbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.realbcrq=a.realbcrq+(select realbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.mails=a.mails+(select mails from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid=111001),
a.clnum=(a.planbczb+a.planbcrq)/(a.planpbzb+a.planpbrq)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and a.routeid=111;
---����102·�ƻ���ࣨ����Ҫ���Ϊ���⣬һ�㲻��Ҫ�޸ģ�
commit;
update pzhdrb a set a.planpbzb=3.5,a.clnum=13 where routeid=108 and to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd');
----����25·��С������
commit;
update pzhdrb p
set p.routename='25��',
p.realbczb=(select sum(case
           when ff.shiftdetailtype!=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realzb
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����')��
p.realbcrq=(select
           sum(case
           when ff.shiftdetailtype=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realrq
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����'),
p.mails=(select
           sum(ff.milenum��miles
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����')
where p.subroutename='25' and to_char(p.recorddate,'yyyy-mm-dd')=to_char(sysdate-1,'yyyy-mm-dd');

commit;
------------------------------------
update pzhdrb p
set p.routename='25С',p.routeid=2501��
p.realbczb=(select sum(case
           when ff.shiftdetailtype!=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realzb
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����')��
p.realbcrq=(select
           sum(case
           when ff.shiftdetailtype=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realrq
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����'),
p.mails=(select
           sum(ff.milenum��miles
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����')
where p.subroutename='25B' and to_char(p.recorddate,'yyyy-mm-dd')=to_char(sysdate-1,'yyyy-mm-dd');
commit;
--------
--ɾ����������
delete pzhdrb a where to_char(recorddate,'yyyy/mm/dd')=to_char(sysdate-1,'yyyy/mm/dd') and routeid in (10201,111001);
commit;
end propzhdrb;
/

prompt
prompt Creating procedure P_ACCMANAGER_CHANGE_PROCESS
prompt ==============================================
prompt
create or replace procedure aptspzh.P_ACCMANAGER_CHANGE_PROCESS is
  /***********************************************************************************
  ���ƣ�P_ACCMANAGER_CHANGE_PROCESS
  ��;���¹ʰ�ȫԱ����
  ������¹ʹ����SS_ACCIDENTGD
          ��ȫԱ���ӹ����SS_ACCMANAGERCHANGEGD
          ��ȫԱ������������SS_ACCMANAGERCHANGEDETAILGD
  ***********************************************************************************/
  V_COUNT NUMBER := 0;
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ACCMANAGERCHANGE T_CURSOR;
  V_ACCMANAGERCHANGEID VARCHAR2(20);
  V_ACCIDENTID         VARCHAR2(20);
  V_NEWACCMANAGERID    VARCHAR2(20);
begin
  -- ��ѯ�Ƿ����δִ�е���Ч��ȫԱ���Ӽ�¼
  SELECT COUNT(1)
    INTO V_COUNT
    FROM SS_ACCMANAGERCHANGEGD
   WHERE TRUNC(CHANGEDATE) = TRUNC(SYSDATE)
     AND INSTANCEID IS NOT NULL
     AND STATUS = '3'
     AND ISOBSOLETE <> '1';
  --1 ����δִ�е���ЧԤ�ż�¼ʱ
  IF V_COUNT > 0 THEN
    BEGIN
      --OPEN CUR_ACCMANAGERCHANGE
      OPEN CUR_ACCMANAGERCHANGE FOR
        SELECT ACCMANAGERCHANGEINFO.ACCMANAGERCHANGEID,
               ACCMANAGERCHANGEDETAILINFO.ACCIDENTID,
               ACCMANAGERCHANGEDETAILINFO.NEWACCMANAGERID
          FROM SS_ACCMANAGERCHANGEGD       ACCMANAGERCHANGEINFO,
               SS_ACCMANAGERCHANGEDETAILGD ACCMANAGERCHANGEDETAILINFO
         WHERE TRUNC(ACCMANAGERCHANGEINFO.CHANGEDATE) = TRUNC(SYSDATE)
           AND ACCMANAGERCHANGEINFO.INSTANCEID IS NOT NULL
           AND ACCMANAGERCHANGEINFO.STATUS = '3'
           AND ACCMANAGERCHANGEINFO.ISOBSOLETE <> '1'
           AND ACCMANAGERCHANGEINFO.ACCMANAGERCHANGEID =
               ACCMANAGERCHANGEDETAILINFO.ACCMANAGERCHANGEID;
      LOOP
        FETCH CUR_ACCMANAGERCHANGE
          INTO V_ACCMANAGERCHANGEID, V_ACCIDENTID, V_NEWACCMANAGERID;
        BEGIN
          --1.1 �����¹ʹ�����ACCIDENTMANAGER�ֶ�Ϊ�°�ȫԱ
          UPDATE SS_ACCIDENTGD
             SET SS_ACCIDENTGD.ACCIDENTMANAGER = V_NEWACCMANAGERID
           WHERE SS_ACCIDENTGD.ACCIDENTID = V_ACCIDENTID;
          COMMIT;
          --1.2 ���°�ȫԱ���ӹ�����STATUS�ֶ�Ϊ4��ִ����ɣ�
          UPDATE SS_ACCMANAGERCHANGEGD
             SET SS_ACCMANAGERCHANGEGD.STATUS = '4'
           WHERE SS_ACCMANAGERCHANGEGD.ACCMANAGERCHANGEID =
                 V_ACCMANAGERCHANGEID;
          COMMIT;
        END;
        EXIT WHEN CUR_ACCMANAGERCHANGE%NOTFOUND;
      END LOOP;
      CLOSE CUR_ACCMANAGERCHANGE;
      --CLOSE CUR_ACCMANAGERCHANGE
    END;
  END IF;
end P_ACCMANAGER_CHANGE_PROCESS;
/

prompt
prompt Creating procedure P_ARRANGEANDEMP_CUMPRO
prompt =========================================
prompt
create or replace procedure aptspzh.P_ARRANGEANDEMP_CumPRO(v_routeid   in VARCHAR2,
                                                   v_begintime in VARCHAR2) is
  /***************************************************
  ���ƣ�    P_ARRANGEANDEMP_PROCESS
  ��;��    ��ˮ����������Ա������Ϣ��
            ��fdisarrangesequencedetailview��ͼ��ѯ�����Ŀ�����Ϣ
            д���fdisarrangedetailld��fdisempdutyld
  �����:   fdisempdutyld
            fdisarrangedetailld
            fdisarrangesequencedetailview
  ������̣��ٲ�ѯfdisarrangesequencedetailview��ͼ��ȡ������������ID��
              ͬʱ�����fdisempdutyld����ID
            �ڱ���fdisarrangesequencedetailview��ͼ����ID��
            �����fdisarrangesequencedetailview��ͼ����ID���ڣ�
              д���fdisempdutyld��fdisarrangedetailld��
              ����ͨ��fdisempdutyld����ID����
  ***************************************************/
  v_substr     varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_arrangeid  NVARCHAR2(20); --fdisarrangesequencedetailview����
  v_empdutyid  NVARCHAR2(20); --fdisempdutyld����
  v_empptype   NVARCHAR2(10); --Ա������
  v_todayptype NVARCHAR2(10); --Ա������
  v_Empid      NVARCHAR2(20); --Ա������
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ARRANGEID T_CURSOR;
BEGIN
  --��ձ�fdisarrangedetailld
  v_substr := 'delete from fdisarrangedetailld where routeid in (' ||
              v_routeid || ') and EXECDATE = to_date(''' || v_begintime ||
              ''',''yyyy-mm-dd hh24:mi:ss'')';
  EXECUTE IMMEDIATE v_substr;
  --��ձ�fdisempdutyld
  v_substr := 'delete from fdisempdutyld where routeid in (' || v_routeid ||
              ') and  EXECDATE = to_date(''' || v_begintime ||
              ''',''yyyy-mm-dd hh24:mi:ss'')';
  EXECUTE IMMEDIATE v_substr;
  --��ȡfdisarrangesequencedetailview�����е�����ID��ͬʱ����fdisempdutyld�������ID
  BEGIN
    OPEN CUR_ARRANGEID FOR
      SELECT arrangesid, S_EMPDUTY.Nextval, empptype, todayemptype, empid
        FROM fdisarrangesequencedetailview
       WHERE (busid IS NOT NULL)
         AND (empid IS NOT NULL)
         and isyuan = '0'
         and routeid in (v_routeid)
         AND EXECDATE = to_date(v_begintime, 'yyyy-mm-dd hh24:mi:ss');
    --ѭ��������д��������
    LOOP
      FETCH CUR_ARRANGEID
        INTO v_arrangeid, v_empdutyid, v_empptype, v_todayptype, v_Empid;
      EXIT WHEN CUR_ARRANGEID%NOTFOUND;
      IF v_arrangeid IS NOT NULL THEN
        --v_empdutyid := S_EMPDUTY.Nextval;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        if v_todayptype = '1' then
          v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum,shiftdetailtype,shiftnumstring, empptype, busselfid,
                  executestate, memo, issave,issync, validmark, rowaddversion,
                  rowupdateversion, detailid, insiteid,outsiteid,planseqnum,dutyid)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnumstring,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,shiftdetailtype,shiftnumstring,  empptype,  busselfid,
                   0,  null,  0, 0, 0, 0, 0, S_ArrangeDetail.Nextval, insiteid,
                   outsiteid,planseqnum,' ||
                      v_empdutyid || '
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid ||
                      ''' AND todayemptype=' || v_todayptype || '
                AND empid=' || v_Empid || ' and busid is not null';
          EXECUTE IMMEDIATE v_substr;
        else
          v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum,shiftdetailtype,shiftnumstring, empptype, busselfid,
                  executestate, memo, issave,issync, validmark, rowaddversion,
                  rowupdateversion, detailid, insiteid,outsiteid,planseqnum,dutyid)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnumstring,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,shiftdetailtype,shiftnumstring,  empptype,  busselfid,
                   0,  null,  0, 0, 0, 0, 0, S_ArrangeDetail.Nextval, insiteid,
                   outsiteid,planseqnum,' ||
                      v_empdutyid || '
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid ||
                      ''' AND todayemptype=' || v_todayptype || '
                AND empid=' || v_Empid || ' and busid is not null';
          EXECUTE IMMEDIATE v_substr;
        end if;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        v_substr := 'insert into fdisempdutyld
                 (dutyid, arrangesid,routeid, empid, empname,  execdate, onworktime,
                   offworktime, executestate, instationid, outstationid,
                   onworkdisparitytime, offworkdisparitytime,
                   onworkaddress, offworkaddress, onworkstatus, offworkstatus,
                   onworkoperationtype,writetime,writeid,detailid,rowaddversion,
                   rowupdateversion,clientcode, memo, isactive,
                   offworkoperationtype,validmark,orgid,
                   sendplantodaytime,sendplannextdaytime,explain, avoidchecktype)
               select
                   ' || v_empdutyid ||
                    ',arrangesid, routeid, empid,empname, execdate,onworktime,
                   offworktime,0,insiteid,outsiteid,
                   null,null,
                   null,null,null,null,
                   null,sysdate,null,null,null,
                   null,null,null,1,
                   null,null,null,
                   null,null,null,null
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid ||
                    ''' AND todayemptype=' || v_todayptype || '
                AND empid=' || v_Empid || '';
        EXECUTE IMMEDIATE v_substr;
      END IF;
    END LOOP;
  END;
  COMMIT;
END P_ARRANGEANDEMP_CumPRO;
/

prompt
prompt Creating procedure P_GETROWVERSION
prompt ==================================
prompt
create or replace procedure aptspzh.P_GETROWVERSION(tablename     in NVARCHAR2,
                                            optype        in INTEGER,
                                            currowversion out INTEGER) is
begin

  currowversion := -2;

  if (optype = 1) then
    begin
      select ROWADDVERSION
        into currowversion
        from AD_ROWVERSION
       where upper(AD_TABLENAME) = upper(tablename);
      if (currowversion >= 0) then
        update AD_ROWVERSION set ROWADDVERSION = currowversion + 1 where upper(AD_TABLENAME) = upper(tablename);
        commit;
      end if;
    exception
      when no_data_found then
        currowversion := -2;
        DBMS_OUTPUT.PUT_LINE('û���ҵ��ñ��Ӧ��¼');
    end;
  else
    if (optype = 2) then
      begin
        select ROWUPDATEVERSION
          into currowversion
          from AD_ROWVERSION
         where upper(AD_TABLENAME) = upper(tablename);
        if (currowversion >= 0) then
          update AD_ROWVERSION set ROWUPDATEVERSION = currowversion + 1 where upper(AD_TABLENAME) = upper(tablename);
          commit;
        end if;
      exception
        when no_data_found then
          currowversion := -2;
          DBMS_OUTPUT.PUT_LINE('û���ҵ��ñ��Ӧ��¼');
      end;
    else
      currowversion := -1;
      DBMS_OUTPUT.PUT_LINE('����������Ͳ���,1-ADD,2-UPDATE');
    end if;
  end if;
  --return(Result);
end P_GETROWVERSION;
/

prompt
prompt Creating procedure P_ARRANGEANDEMP_IMPPRO
prompt =========================================
prompt
create or replace procedure aptspzh.P_ARRANGEANDEMP_IMPPRO(v_routeid   in NVARCHAR2,
                                                   v_begintime in NVARCHAR2) is
  /***************************************************
  ���ƣ�    P_ARRANGEANDEMP_IMPPRO
  ��;��    ������Ա������Ϣ���롣
            ��fdisarrangesequencedetailview��ͼ��ѯ�����Ŀ�����Ϣ
            д���fdisarrangedetailld��fdisempdutyld
  �����:   fdisempdutyld
            fdisarrangedetailld
            fdisarrangesequencedetailview
  ������̣��ٲ�ѯfdisarrangesequencedetailview��ͼ��ȡ������������ID��
              ͬʱ�����fdisempdutyld����ID
            �ڱ���fdisarrangesequencedetailview��ͼ����ID��
            �����fdisarrangesequencedetailview��ͼ����ID���ڣ�
              д���fdisempdutyld��fdisarrangedetailld��
              ����ͨ��fdisempdutyld����ID����
  ***************************************************/
  v_substr      varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_arrangeid   NVARCHAR2(20); --fdisarrangesequencedetailview����
  v_empdutyid   NVARCHAR2(20); --fdisempdutyld����
  v_empptype    NVARCHAR2(10); --Ա������
  v_todayptype  NVARCHAR2(10); --Ա������
  v_Empid       NVARCHAR2(20); --Ա������
  currowversion INTEGER; --�޸İ汾��
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ARRANGEID T_CURSOR;
  TYPE T_CURSORDELARR IS REF CURSOR;
  CUR_DELARRANGE T_CURSORDELARR;
  TYPE T_CURSORDELDUTY IS REF CURSOR;
  CUR_DELEMPDUTY T_CURSORDELDUTY;
BEGIN
  --�߼�ɾ����fdisarrangedetailld������
  begin
    OPEN CUR_DELARRANGE FOR
      SELECT DETAILID
        FROM fdisarrangedetailld
       where routeid in (v_routeid)
         and EXECDATE = to_date(v_begintime, 'yyyy-mm-dd hh24:mi:ss');
    LOOP
      FETCH CUR_ARRANGEID
        INTO v_arrangeid;
      IF v_arrangeid IS NOT NULL THEN
        p_getrowversion('FDISARRANGEDETAILLD', 2, currowversion);
        update fdisarrangedetailld
           set isactive = '0'
         where detailid = v_arrangeid;
      END IF;
      EXIT WHEN CUR_DELARRANGE%NOTFOUND;
    END LOOP;
  END;
  --�߼�ɾ����FDISEMPDUTYLD������
  begin
    OPEN CUR_DELEMPDUTY FOR
      SELECT DUTYID
        FROM FDISEMPDUTYLD
       where routeid in (v_routeid)
         and EXECDATE = to_date(v_begintime, 'yyyy-mm-dd hh24:mi:ss');
    LOOP
      FETCH CUR_DELEMPDUTY
        INTO v_empdutyid;
      IF v_empdutyid IS NOT NULL THEN
        p_getrowversion('FDISEMPDUTYLD', 2, currowversion);
        update FDISEMPDUTYLD set isactive = '0' where DUTYID = v_empdutyid;
      END IF;
      EXIT WHEN CUR_DELARRANGE%NOTFOUND;
    END LOOP;
  END;
  --�����¼ƻ�������
  BEGIN
    v_empdutyid := null;
    v_arrangeid := null;
    OPEN CUR_ARRANGEID FOR
      SELECT arrangesid, S_EMPDUTY.Nextval, empptype, todayemptype, empid
        FROM fdisarrangesequencedetailview
       WHERE (busid IS NOT NULL)
         AND (empid IS NOT NULL)
         and isyuan = '0'
         and routeid in (v_routeid)
         AND EXECDATE = to_date(v_begintime, 'yyyy-mm-dd hh24:mi:ss');
    --ѭ��������д��������
    LOOP
      FETCH CUR_ARRANGEID
        INTO v_arrangeid, v_empdutyid, v_empptype, v_todayptype, v_Empid;
      EXIT WHEN CUR_ARRANGEID%NOTFOUND;
      IF v_arrangeid IS NOT NULL THEN
        --v_empdutyid := S_EMPDUTY.Nextval;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        if v_todayptype = '1' then
          v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum,shiftdetailtype,shiftnumstring, empptype, busselfid,
                  executestate, memo, issave,issync, validmark, rowaddversion,
                  rowupdateversion, detailid, insiteid,outsiteid,planseqnum,dutyid)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnumstring,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,shiftdetailtype,shiftnumstring,  empptype,  busselfid,
                   0,  null,  0, 0, 0, 0, 0, S_ArrangeDetail.Nextval, insiteid,
                   outsiteid,planseqnum,' ||
                      v_empdutyid || '
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid ||
                      ''' AND todayemptype=' || v_todayptype || '
                AND empid=' || v_Empid || '';
          EXECUTE IMMEDIATE v_substr;
        end if;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        v_substr := 'insert into fdisempdutyld
                 (dutyid, routeid, empid, empname,  execdate, onworktime,
                   offworktime, executestate, instationid, outstationid,
                   onworkdisparitytime, offworkdisparitytime,
                   onworkaddress, offworkaddress, onworkstatus, offworkstatus,
                   onworkoperationtype,writetime,writeid,detailid,rowaddversion,
                   rowupdateversion,clientcode, memo, isactive,
                   offworkoperationtype,validmark,orgid,
                   sendplantodaytime,sendplannextdaytime,explain, avoidchecktype)
               select
                   ' || v_empdutyid ||
                    ', routeid, empid,empname, execdate,onworktime,
                   offworktime,0,insiteid,outsiteid,
                   null,null,
                   null,null,null,null,
                   null,sysdate,null,null,null,
                   null,null,null,1,
                   null,null,null,
                   null,null,null,null
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid ||
                    ''' AND todayemptype=' || v_todayptype || '
                AND empid=' || v_Empid || '';
        EXECUTE IMMEDIATE v_substr;
      END IF;
    END LOOP;
  END;
  commit;
END P_ARRANGEANDEMP_IMPPRO;
/

prompt
prompt Creating procedure P_ARRANGEANDEMP_PROCESS
prompt ==========================================
prompt
create or replace procedure aptspzh.P_ARRANGEANDEMP_PROCESS(v_routeid   in NVARCHAR2,
                                                    v_begintime in NVARCHAR2) is
  /***************************************************
  ���ƣ�    P_ARRANGEANDEMP_PROCESS
  ��;��    ������Ա������Ϣ��
            ��fdisarrangesequencedetailview��ͼ��ѯ�����Ŀ�����Ϣ
            д���fdisarrangedetailld��fdisempdutyld
  �����:   fdisempdutyld
            fdisarrangedetailld
            fdisarrangesequencedetailview
  ������̣��ٲ�ѯfdisarrangesequencedetailview��ͼ��ȡ������������ID��
              ͬʱ�����fdisempdutyld����ID
            �ڱ���fdisarrangesequencedetailview��ͼ����ID��
            �����fdisarrangesequencedetailview��ͼ����ID���ڣ�
              д���fdisempdutyld��fdisarrangedetailld��
              ����ͨ��fdisempdutyld����ID����
  ***************************************************/
  v_substr    varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_arrangeid NVARCHAR2(20); --fdisarrangesequencedetailview����
  v_empdutyid NVARCHAR2(20); --fdisempdutyld����
  v_empptype NVARCHAR2(10);--Ա������
  v_todayptype NVARCHAR2(10);--Ա������
  v_Empid NVARCHAR2(20);--Ա������
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ARRANGEID T_CURSOR;
BEGIN
  --��ձ�fdisarrangedetailld
  v_substr := 'delete from fdisarrangedetailld where routeid in ('||
              v_routeid||') and EXECDATE = to_date('''||v_begintime||
              ''',''yyyy-mm-dd hh24:mi:ss'')';
  EXECUTE IMMEDIATE v_substr;
  --��ձ�fdisempdutyld
  v_substr := 'delete from fdisempdutyld where routeid in ('|| v_routeid ||
              ') and  EXECDATE = to_date('''||v_begintime||
              ''',''yyyy-mm-dd hh24:mi:ss'')';
  EXECUTE IMMEDIATE v_substr;
  --��ȡfdisarrangesequencedetailview�����е�����ID��ͬʱ����fdisempdutyld�������ID
  BEGIN
    OPEN CUR_ARRANGEID FOR
      SELECT arrangesid, S_EMPDUTY.Nextval, empptype,todayemptype,empid
        FROM fdisarrangesequencedetailview
       WHERE (busid IS NOT NULL)
         AND (empid IS NOT NULL)
         and isyuan='0'
         and routeid in (v_routeid)
         AND EXECDATE = to_date(v_begintime, 'yyyy-mm-dd hh24:mi:ss');
    --ѭ��������д��������
    LOOP
      FETCH CUR_ARRANGEID
        INTO v_arrangeid, v_empdutyid, v_empptype,v_todayptype,v_Empid;
      EXIT WHEN CUR_ARRANGEID%NOTFOUND;
      IF v_arrangeid IS NOT NULL THEN
        --v_empdutyid := S_EMPDUTY.Nextval;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum,shiftdetailtype,shiftnumstring, empptype, busselfid,
                  executestate, memo, issave,issync, validmark, rowaddversion,
                  rowupdateversion, detailid, insiteid,outsiteid,planseqnum,dutyid,orgid)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnumstring,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,shiftdetailtype,shiftnumstring,  empptype,  busselfid,
                   0,  null,  0, 0, 0, 0, 0, S_ArrangeDetail.Nextval, insiteid,
                   outsiteid,planseqnum,' || v_empdutyid || ',orgid
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid || ''' AND todayemptype='||v_todayptype||'
                AND empid='||v_Empid||'';
        EXECUTE IMMEDIATE v_substr;
        --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
        v_substr := 'insert into fdisempdutyld
                 (dutyid,ARRANGESID, routeid, empid, empname,  execdate, onworktime,
                   offworktime, executestate, instationid, outstationid,
                   onworkdisparitytime, offworkdisparitytime,
                   onworkaddress, offworkaddress, onworkstatus, offworkstatus,
                   onworkoperationtype,writetime,writeid,detailid,rowaddversion,
                   rowupdateversion,clientcode, memo, isactive,
                   offworkoperationtype,validmark,orgid,
                   sendplantodaytime,sendplannextdaytime,explain, avoidchecktype)
               select
                   ' || v_empdutyid ||
                    ', ARRANGESID,routeid, empid,empname, execdate,onworktime,
                   offworktime,0,insiteid,outsiteid,
                   null,null,
                   null,null,null,null,
                   null,sysdate,null,null,null,
                   null,null,null,1,
                   null,null,null,
                   null,null,null,null
               from fdisarrangesequencedetailview
               where  arrangesid =''' || v_arrangeid || ''' AND todayemptype='||v_todayptype||'
                AND empid='||v_Empid||'';
        EXECUTE IMMEDIATE v_substr;
        END IF;
    END LOOP;
  END;
  COMMIT;
END P_ARRANGEANDEMP_PROCESS;
/

prompt
prompt Creating procedure P_ARRANGEANDEMP_PROCESSTWO
prompt =============================================
prompt
create or replace procedure aptspzh.P_ARRANGEANDEMP_PROCESSTWO(v_routeid   in NVARCHAR2,
                                                       v_begintime in NVARCHAR2) is

  v_substr     varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_arrangeid  NVARCHAR2(20); --fdisarrangesequencedetailview����
  v_empdutyid  NVARCHAR2(20); --fdisempdutyld����
  v_empptype   NVARCHAR2(10); --Ա������
  v_todayptype NVARCHAR2(10); --Ա������
  v_Empid      NVARCHAR2(20); --Ա������

BEGIN
  --��ձ�fdisarrangedetailld
  v_substr := 'delete from fdisarrangedetailld where routeid in (' ||
              v_routeid || ') and EXECDATE = to_date(''' || v_begintime ||
              ''',''yyyy-mm-dd'')';
  EXECUTE IMMEDIATE v_substr;
  --��ձ�fdisempdutyld
  v_substr := 'delete from fdisempdutyld where routeid in (' || v_routeid ||
              ') and  EXECDATE = to_date(''' || v_begintime ||
              ''',''yyyy-mm-dd'')';
  EXECUTE IMMEDIATE v_substr;
  --��ȡfdisarrangesequencedetailview�����е�����ID��ͬʱ����fdisempdutyld�������ID
  BEGIN
    v_substr := 'insert into fdisarrangedetailld
                            (arrangesid,
                             arrangeid,
                             routeid,
                             subrouteid,
                             shiftnum,
                             shifttype,
                             busid,
                             empid,
                             empname,
                             execdate,
                             onworktime,
                             offworktime,
                             writetime,
                             writeid,
                             groupnum,
                             shiftdetailtype,
                             shiftnumstring,
                             empptype,
                             busselfid,
                             executestate,
                             memo,
                             issave,
                             issync,
                             validmark,
                             rowaddversion,
                             rowupdateversion,
                             detailid,
                             insiteid,
                             outsiteid,
                             planseqnum,
                             dutyid,
                             orgid)
                            select arrangesid,
                                   arrangeid,
                                   routeid,
                                   0,
                                   shiftnum,
                                   shifttype,
                                   busid,
                                   empid,
                                   empname,
                                   execdate,
                                   onworktime,
                                   offworktime,
                                   sysdate,
                                   null,
                                   groupnum,
                                   shiftdetailtype,
                                   shiftnumstring,
                                   empptype,
                                   busselfid,
                                   0,
                                   null,
                                   0,
                                   0,
                                   0,
                                   0,
                                   0,
                                   S_ArrangeDetail.Nextval,
                                   insiteid,
                                   outsiteid,
                                   planseqnum,
                                  '''',
                                   orgid
                   from  ArrangedetailView
                  where  routeid in (' || v_routeid ||
                ') and EXECDATE = to_date(''' || v_begintime ||
                ''',''yyyy-mm-dd'')';
                  EXECUTE IMMEDIATE v_substr;
    --������ͼfdisarrangesequencedetailview��д��fdisarrangedetailld
    v_substr := 'insert into fdisempdutyld
                 (dutyid, routeid, empid, empname,  execdate, onworktime,
                   offworktime, executestate, instationid, outstationid,
                   onworkdisparitytime, offworkdisparitytime,
                   onworkaddress, offworkaddress, onworkstatus, offworkstatus,
                   onworkoperationtype,writetime,writeid,detailid,rowaddversion,
                   rowupdateversion,clientcode, memo, isactive,
                   offworkoperationtype,validmark,orgid,
                   sendplantodaytime,sendplannextdaytime,explain, avoidchecktype)
               select
                    S_EMPDUTY.Nextval, routeid, empid,empname, execdate,onworktime,
                   offworktime,0,insiteid,outsiteid,
                   null,null,
                   null,null,null,null,
                   null,sysdate,null,null,null,
                   null,null,null,1,
                   null,null,null,
                   null,null,null,null
               from ArrangedetailView
               where  routeid in (' || v_routeid ||
                ') and EXECDATE = to_date(''' || v_begintime ||
                ''',''yyyy-mm-dd'')';
    EXECUTE IMMEDIATE v_substr;
  END;
  COMMIT;
END P_ARRANGEANDEMP_PROCESSTWO;
/

prompt
prompt Creating procedure P_ARRANGEDETAILSYNC
prompt ======================================
prompt
create or replace procedure aptspzh.P_ArrangeDetailSYNC(v_routeid   in NVARCHAR2,
                                          v_begintime in NVARCHAR2,
                                          v_endtime   NVARCHAR2) is

  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
begin

  v_substr := 'delete from fdisarrangedetailld where routeid in (' || v_routeid ||
              ') and onworktime >=' || v_begintime || ' and onworktime < ' || v_endtime;
  execute immediate v_substr;

  v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum, empptype, busselfid, executestate, memo, issave,
                  issync, validmark, rowaddversion, rowupdateversion, detailid)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnum,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,  empptype,  busselfid,  0,  null,  0,
                   0, 0, 0, 0, S_ArrangeDetail.Nextval
               from fdisarrangesequencedetailview
               where  (busid is not null) and (empid is not null) and
                  routeid in (' || v_routeid || ') and  onworktime >= ' || v_begintime ||
                  ' and onworktime < ' || v_endtime;

  execute immediate v_substr;

  commit;

end P_ArrangeDetailSYNC;
/

prompt
prompt Creating procedure P_ARRANGEDETAILSYNC2
prompt =======================================
prompt
create or replace procedure aptspzh.P_ArrangeDetailSYNC2(v_routeid   in NVARCHAR2,
                                          v_begintime in NVARCHAR2,
                                          v_endtime   NVARCHAR2) is
  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
begin
  v_substr := 'delete from fdisarrangedetailld where routeid in (' || v_routeid ||
              ') and EXECDATE =TRUNC(' || v_begintime ||')';
  execute immediate v_substr;
  v_substr := 'insert into fdisarrangedetailld
                 (arrangesid, arrangeid, routeid, subrouteid, shiftnum, shifttype,
                  busid, empid, empname, execdate, onworktime, offworktime, writetime,
                  writeid, groupnum,shiftdetailtype,shiftnumstring, empptype, busselfid,

executestate, memo, issave,
                  issync, validmark, rowaddversion, rowupdateversion, detailid, insiteid,

outsiteid,planseqnum)
               select
                   arrangesid,  arrangeid,  routeid,  0,  shiftnum,  shifttype,
                   busid,  empid,  empname,  execdate,  onworktime,  offworktime,  sysdate,
                   null,  groupnum,shiftdetailtype,shiftnumstring,  empptype,  busselfid,

0,  null,  0,
                   0, 0, 0, 0, S_ArrangeDetail.Nextval, insiteid, outsiteid,planseqnum
               from fdisarrangesequencedetailview
               where  (busid is not null) and (empid is not null) and
                  routeid in (' || v_routeid || ') and  execdate = TRUNC(' ||

v_begintime||')';
  execute immediate v_substr;
  commit;
end P_ArrangeDetailSYNC2;
/

prompt
prompt Creating procedure P_AVAILABILITY
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_AVAILABILITY is

  v_devtimes         NUMBER(10, 2);
  v_devmaltimes      NUMBER(10, 2);
  v_dvrnovideonum    NUMBER(6);
  v_devnum           NUMBER(6);
  v_offlinebuslonger NUMBER(4, 2); --δӪ�˳���Ĭ��ʱ��
  v_repirtnum1       NUMBER(6); --������
  v_repirtnum2       NUMBER(6); --������
  v_repirtnum4       NUMBER(6); --������
  v_repirtnum6       NUMBER(6); --������
  v_repirtnum9       NUMBER(6); --������

BEGIN
  -- δӪ�˳���Ĭ��ʱ��
  select t.value
    into v_offlinebuslonger
    from configs t
   where t.section = 'OMFOFFLINEBUSLONGER';
  select t.value
    into v_repirtnum1
    from configs t
   where t.section = 'OMMAL1REPIRTNUM';
  select t.value
    into v_repirtnum2
    from configs t
   where t.section = 'OMMAL2REPIRTNUM';
  select t.value
    into v_repirtnum4
    from configs t
   where t.section = 'OMMAL4REPIRTNUM';
  select t.value
    into v_repirtnum6
    from configs t
   where t.section = 'OMMAL6REPIRTNUM';
  select t.value
    into v_repirtnum9
    from configs t
   where t.section = 'OMMAL9REPIRTNUM';
  -- ���ػ�����ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when (ds.eventsign is null and ds.longer is not null) or
                    ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid,
                 event.productid eventsign,
                 mal.productid malsign,
                 longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_busmachine mac,
                 (select t.productid
                    from bsvcbusrundatald5 t
                   where t.actdatetime > trunc(sysdate - 1)
                     and t.actdatetime < trunc(sysdate)
                   group by t.productid) event,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '1'
                   group by t.productid) mal
           where mac.productid = event.productid(+)
             and mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  --������ñ���
  insert into om_availability
    (AVAILABILITY_ID,
     TARGET_CATEGORY_EN_NAME,
     DEVICETYPE_ID,
     DEVICETYPE_NAME,
     STATIS_DATE,
     ONLINE_NUM,
     FAULT_NUM,
     ISSYNSTATUS)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     'SYS_AVAILABILITY_RATE_SUM',
     '1',
     '���ػ�',
     sysdate - 1,
     v_devtimes,
     v_devmaltimes,
     '0');
  commit;
  -- DVR ����ʱ��������ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid, mal.productid malsign, longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_dvr mac,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '41'
                   group by t.productid) mal
           where mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  --������ñ���
  insert into om_availability
    (AVAILABILITY_ID,
     TARGET_CATEGORY_EN_NAME,
     DEVICETYPE_ID,
     DEVICETYPE_NAME,
     STATIS_DATE,
     ONLINE_NUM,
     FAULT_NUM,
     ISSYNSTATUS)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     'SYS_AVAILABILITY_RATE_SUM',
     '41',
     'DVR',
     sysdate - 1,
     v_devtimes,
     v_devmaltimes,
     '0');
  commit;
  --DVR¼��
  select count(1) into v_devnum from om_view_dvr t;
  select count(distinct dvr.dvrselfid)
    into v_dvrnovideonum
    from (select t.dvrselfid, t.errorcode, count(1) repirtnum
            from dvr_errorloggs t
           where t.errortype = '1'
             and (t.errorchannel <> '5' or t.errorchannel is null)
             and t.errortime >= trunc(sysdate) - 1
             and t.errortime < trunc(sysdate)
             and t.errorcode in (1, 2, 4, 6, 9)
           group by t.dvrselfid, t.errorcode, t.errorchannel) mal,
         om_view_dvr dvr
   where mal.dvrselfid = dvr.dvrselfid
     and ((mal.errorcode = '1' and mal.repirtnum > v_repirtnum1) or
         (mal.errorcode = '2' and mal.repirtnum > v_repirtnum2) or
         (mal.errorcode = '4' and mal.repirtnum > v_repirtnum4) or
         (mal.errorcode = '6' and mal.repirtnum > v_repirtnum6) or
         (mal.errorcode = '9' and mal.repirtnum > v_repirtnum9));
  --������ñ���
  insert into om_availability
    (AVAILABILITY_ID,
     TARGET_CATEGORY_EN_NAME,
     DEVICETYPE_ID,
     DEVICETYPE_NAME,
     STATIS_DATE,
     ONLINE_NUM,
     FAULT_NUM,
     ISSYNSTATUS)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     'DVR_VIDEO_RATE',
     '41',
     'DVR',
     sysdate - 1,
     v_devnum,
     v_dvrnovideonum,
     '0');
  commit;

END P_AVAILABILITY;
/

prompt
prompt Creating procedure P_BACKUPBASEDATA
prompt ===================================
prompt
create or replace procedure aptspzh.P_BACKUPBASEDATA
IS
  /***************************************************
  ���ƣ�P_BACKBUSEMPBASEDATA
  ��;�� �µױ�����Ա��֯��· ��ϵ  ������֯��·��ϵ
   �����:   MC_BACKUPBUSBASEGD
            ASGNRBUSROUTELD
            mcbusinfogs
            EMPEXTENDINFO
  ��д��coice 20110915
  �޸ģ�**************************************************/
BEGIN
DELETE FROM MC_BACKUPBUSBASEGD B
WHERE B.RUNDATE=TRUNC(SYSDATE-1);
COMMIT;
insert into MC_BACKUPBUSBASEGD
  select s_ds_bus.nextval,
         TRUNC(SYSDATE - 1),
         B.ORGID,AR.ROUTEID,B.busid,
         sysdate,'HISEN','',''
    from mcbusinfogs B, ASGNRBUSROUTELD AR
   WHERE (B.STATUS <> '4' OR
         B.BUSID IN (SELECT BUSID
                        FROM BM_BUSOFFGD BO
                       WHERE BO.OFFDATE BETWEEN trunc(sysdate - 1, 'month') AND
                             TRUNC(SYSDATE - 1)))
     AND B.BUSID = AR.BUSID(+);
COMMIT;
DELETE FROM MC_BACKUPEMPBASEGD WHERE RUNDATE=TRUNC(SYSDATE-1);
COMMIT;
INSERT INTO MC_BACKUPEMPBASEGD
select s_ds_driver.nextval,TRUNC(SYSDATE - 1),
       E.ORGID,AR.ROUTEID,E.empid,
       sysdate,'HISEN','',''
  from mcemployeeinfogs e,
       (SELECT EMPID, MIN(ROUTEID) ROUTEID
          FROM ASGNREMPROUTELD
         GROUP BY EMPID) AR
 WHERE E.EMPID = AR.EMPID(+)
   AND (E.ISACTIVE = 1 OR
       E.EMPID IN
       (SELECT ET.EMPID
           FROM MCEMPTRANSFERGD ET
          WHERE ET.TRANSFERDATE BETWEEN trunc(sysdate - 1, 'month') AND
                TRUNC(SYSDATE - 1)));
COMMIT;
DELETE FROM mc_backuporgbasegd B
WHERE B.RUNDATE=TRUNC(SYSDATE-1);
COMMIT;
insert into mc_backuporgbasegd
  (backuporgbase,
   rundate,
   orgid,
   orgname,
   orgtype,
   parentorgid,
   isactive,
   memos,
   orgtname,
   isoperationunit,
   ismaintainunit,
   isstockunit,
   orgcode,
   isadminunit,
   flag,
   isoperationsubcompany,
   retain1,
   retain2,
   retain3,
   retain4,
   retain5,
   retain6,
   retain7,
   retain8,
   retain9,
   retain10,
   CREATED,
   CREATEBY)
  select s_ds_bus.nextval,
         TRUNC(SYSDATE - 1),
         orgid,
         orgname,
         orgtype,
         parentorgid,
         isactive,
         memos,
         orgtname,
         isoperationunit,
         ismaintainunit,
         isstockunit,
         orgcode,
         isadminunit,
         flag,
         isoperationsubcompany,
         retain1,
         retain2,
         retain3,
         retain4,
         retain5,
         retain6,
         retain7,
         retain8,
         retain9,
         retain10,
         sysdate,
         'hisen'
    from mcorginfogs;
COMMIT;
END;
/

prompt
prompt Creating procedure P_BUSDEFFLAG
prompt ===============================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH."P_BUSDEFFLAG" is

  V_FIRSTDATE   DATE; -- ָ���µ�һ��
  V_LASTDATE    DATE; -- ָ�������һ��
  V_DEFJUDGE    VARCHAR2(2); --�������0:*  1:#��[�ж���]
  V_DEFFLAG     VARCHAR2(2); --�������0:*  1:#��
  V_YEARINSPECT VARCHAR2(2); --�����־
  V_DEFENDTYPE  VARCHAR2(2); --��������
  V_JUDGECOUNT  NUMBER := 0;

BEGIN

  -- ���µ�һ������һ��
  SELECT TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH'),
                         'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- �α괦������
  DECLARE
    CURSOR GET_REC IS
    -- ��ȡ�����
      SELECT T.BUSID, T.DEFENDTYPE, T.BUSDEFASSID, T.DEFDATE
        FROM BM_TEMBUSDEFASS T
       WHERE 1 = 1
         AND (T.DEFENDTYPE = '2' OR
             (T.DEFENDTYPE = '1' AND T.DEFENDLEVEL = '1'))
         AND T.DEFPLANDATE >= V_FIRSTDATE
         AND T.DEFPLANDATE <= V_LASTDATE;
  BEGIN
    FOR REC IN GET_REC LOOP
      -- ��ѯ������Ϣ����
      V_JUDGECOUNT := 0;
      SELECT COUNT(1) JUDGECOUNT
        INTO V_JUDGECOUNT
        FROM BM_TEMBUSDEFASS T
       WHERE 1 = 1
         AND T.AUDITSTATUS = '1'
         AND T.BUSID = REC.BUSID
         AND (T.DEFENDTYPE = '2' OR
             (T.DEFENDTYPE = '1' AND T.DEFENDLEVEL = '1'))
         AND T.DEFPLANDATE < REC.DEFDATE;

      -- �ж��Ƿ�������
      IF V_JUDGECOUNT > 0 THEN
        -- ��ȡ�����ϴα�������
        SELECT TT.DEFFLAG, TT.YEARINSPECT, TT.DEFENDTYPE
          INTO V_DEFFLAG, V_YEARINSPECT, V_DEFENDTYPE
          FROM (SELECT T.DEFFLAG, T.YEARINSPECT, T.DEFENDTYPE
                  FROM BM_TEMBUSDEFASS T
                 WHERE 1 = 1
                   AND T.AUDITSTATUS = '1'
                   AND T.BUSID = REC.BUSID
                   AND (T.DEFENDTYPE = '2' OR
                       (T.DEFENDTYPE = '1' AND T.DEFENDLEVEL = '1'))
                   AND T.DEFPLANDATE < REC.DEFDATE
                 ORDER BY T.DEFPLANDATE DESC) TT
         WHERE ROWNUM = 1;
        -- �ж��ϴα�������
        IF V_DEFENDTYPE = '2' THEN
          V_DEFJUDGE := '1';
        ELSE
          IF V_DEFFLAG = '0' THEN
            V_DEFJUDGE := '1';
          ELSE
            V_DEFJUDGE := '0';
          END IF;
        END IF;
      ELSE
        V_DEFJUDGE := '1';
      END IF;
      -- ��������
      UPDATE BM_TEMBUSDEFASS T
         SET T.DEFFLAG = V_DEFJUDGE
       WHERE T.BUSDEFASSID = REC.BUSDEFASSID;
    END LOOP;
  END;

  COMMIT;

END P_BUSDEFFLAG;
/

prompt
prompt Creating procedure P_BUSDEFIINFO
prompt ================================
prompt
create or replace procedure aptspzh.P_BUSDEFIINFO is

  v_substr varchar2(8000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
begin

  v_substr := 'DELETE FROM BM_TEMBUSDEFASS T WHERE T.JUDGEFLG = 0 ';
  execute immediate v_substr;

  v_substr := 'INSERT INTO BM_TEMBUSDEFASS
    (BUSDEFASSID,
     BUSID,
     DAYMILE,
     DEFENDTYPE,
     DEFENDLEVEL,
     DEFENDPERIOD,
     PLANDAYCOUNT,
     ALARMDAYCOUNT,
     DEFAULTWARE,
     BUSTYPE,
     BUSORG,
     WORKORDERTYPE,
     STOPMIDDAY,
     DEFPLANDATE,
     PLANFLG,
     ALARMFLG
     )
    SELECT S_FDISDISPLANGD.Nextval AS BUSDEFASSID,
       AVGINFO.BUSID,
       AVGINFO.DAYMILE,
       DEFBUSINFO.DEFENDTYPE,
       DEFBUSINFO.DEFENDLEVEL,
       DEFBUSINFO.DEFENDPERIOD,
       DEFBUSINFO.PLANDAYCOUNT,
       DEFBUSINFO.ALARMDAYCOUNT,
       DEFBUSINFO.DEFAULTWARE,
       DEFBUSINFO.BUSTYPE,
       DEFBUSINFO.ORGID AS BUSORG,
       DEFBUSINFO.WORKORDERTYPE,
       DEFBUSINFO.STOPMIDDAY,
       AVGINFO.PREDEFDATE +
       ROUND(DEFBUSINFO.DEFENDPERIOD / AVGINFO.DAYMILE, 0) AS DEFPLANDATE,
       SIGN(ROUND(DEFBUSINFO.DEFENDPERIOD -
                  AVGINFO.DAYMILE * (trunc(SYSDATE - AVGINFO.PREDEFDATE)),
                  3) / AVGINFO.DAYMILE - DEFBUSINFO.PLANDAYCOUNT) AS PLANFLG,
       SIGN(ROUND(DEFBUSINFO.DEFENDPERIOD -
                  AVGINFO.DAYMILE * (trunc(SYSDATE - AVGINFO.PREDEFDATE)),
                  3) / AVGINFO.DAYMILE -
            (DEFBUSINFO.PLANDAYCOUNT + DEFBUSINFO.ALARMDAYCOUNT)) AS ALARMFLG
  FROM (SELECT BUS_DAYMILE_V.Busid AS BUSID,
               SUM(BUS_DAYMILE_V.Mile) AS Summile,
               COUNT(BUS_DAYMILE_V.RUNDATE) AS daycount,
               trunc(SUM(BUS_DAYMILE_V.Mile) /
                     COUNT(BUS_DAYMILE_V.RUNDATE),
                     3) AS DAYMILE,
               DEFDATE.PREDEFDATE AS PREDEFDATE
          FROM BUS_DAYMILE_V,
               (SELECT BUS_DAYMILE_V.BUSID,
                       (NVL(MAX(W.Completedate), Min(BUS_DAYMILE_V.RUNDATE))) AS PREDEFDATE
                  FROM BM_WORKORDERGD W, BUS_DAYMILE_V
                 WHERE BUS_DAYMILE_V.BUSID = W.Busid(+)
                 GROUP BY BUS_DAYMILE_V.BUSID) DEFDATE
         WHERE BUS_DAYMILE_V.RUNDATE >= DEFDATE.PREDEFDATE
           AND BUS_DAYMILE_V.RUNDATE <= sysdate
           AND BUS_DAYMILE_V.Busid = DEFDATE.busid
         GROUP BY BUS_DAYMILE_V.BUSID, DEFDATE.PREDEFDATE) AVGINFO,
       (SELECT BUSINFO.BUSID, BUSINFO.ORGID, BUSDEF.*
          FROM BM_BUSDEFENDGD BUSDEF, mcbusinfogs BUSINFO
         WHERE BUSDEF.BUSTYPE = BUSINFO.BUSTID) DEFBUSINFO
 WHERE AVGINFO.BUSID = DEFBUSINFO.BUSID';

  execute immediate v_substr;

  commit;

end P_BUSDEFIINFO;
/

prompt
prompt Creating procedure P_BUSDEFIINFO_WEEK_PZH
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_BUSDEFIINFO_WEEK_PZH IS
  /***************************************************
  ���ƣ�P_BUSDEFIINFO_WEEK_PZH
  ��;������ÿ���������ܵı����ƻ�
  �����:   BM_TEMBUSDEFASS
  ��д��    ������    201501218
  ��ע��
  1:һ��
  2:��ǿһ��
  3������
  4����ǿ����
  0���߱�
  ***************************************************/

  V_FIRSTDATE        DATE; -- ָ���µ�һ��
  V_LASTDATE         DATE; -- ָ�������һ��
  V_ALARMDAYCOUNT    number; --Ԥ������
  V_STANDARDMILE     number; --��׼���
  V_DEVIATIONMILE    number; --ƫ�����
  V_MINSTANDARDMILE  number; --��С��׼���
  V_MAXSTANDARDMILE  number; --����׼���
  V_STANDARDMILE1    number; --��׼���
  V_DEVIATIONMILE1   number; --ƫ�����
  V_MINSTANDARDMILE1 number; --��С��׼���
  V_MAXSTANDARDMILE1 number; --����׼���

BEGIN
  V_ALARMDAYCOUNT    := 5;
  V_STANDARDMILE     := 3000;
  V_DEVIATIONMILE    := 500;
  V_MINSTANDARDMILE  := V_STANDARDMILE - V_DEVIATIONMILE;
  V_MAXSTANDARDMILE  := V_STANDARDMILE + V_DEVIATIONMILE;
  V_STANDARDMILE1    := 2500;
  V_DEVIATIONMILE1   := 500;
  V_MINSTANDARDMILE1 := V_STANDARDMILE1 - V_DEVIATIONMILE1;
  V_MAXSTANDARDMILE1 := V_STANDARDMILE1 + V_DEVIATIONMILE1;
  -- ���ܵ�һ������һ��
  SELECT TO_DATE(TO_CHAR((SYSDATE + V_ALARMDAYCOUNT), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR((SYSDATE + V_ALARMDAYCOUNT + 7), 'YYYY-MM-DD'), 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- ɾ����������
  DELETE FROM BM_TEMBUSDEFASS T
   WHERE T.AUDITSTATUS IN ('0', '2');
  COMMIT;
  INSERT INTO BM_TEMBUSDEFASS
    (BUSDEFASSID, --������������
     BUSID,
     DEFENDTYPE, --��������
     DEFENDLEVEL, --��������
     DAYMILE, --��ƽ�����
     DEFENDPERIOD, --������̣���׼��
     REALMILE, --ʵ�����
     plansummile, --Ԥ�Ʊ������
     THENSUMMILE, --Ԥ�ᵱʱ���
     STANDARDDEFENDPERIOD, --��׼�������
     SPECIALDEFENDTYPE, --�ϴη�һ������
     SPECIALREALMILE, --�ϴη�һ�����
     PLANDAYCOUNT,
     ALARMDAYCOUNT,
     BUSORG, --��֯
     BUSTYPE, --�����ͺ�
     WORKORDERTYPE,
     STOPMIDDAY, --ͣ�˰���
     DEFPLANDATE, --�ƻ���������
     DEFDATE, --ָ������
     PREDEFDATE, --�ϴα�������
     PLANFLG,
     ALARMFLG,
     JUDGEFLG,
     AUDITSTATUS,
     DEFAULTWARE, --Ĭ��ά�޵�Ԫ
     WORKSHOPID, --ά�޳�����
     ROUTEID,
     DEFFLAG, --��������(0:* 1:#)
     CREATED)
    select S_FDISDISPLANGD.NEXTVAL AS BUSDEFASSID, --������������
           BUSDEFINFO.busid,
           case
             when busdefinfo.lastpredeftype <> '1' or
                  busdefinfo.lastpredeftype is null or
                  (busdefinfo.lastpredeftype = '1' and
                  (BUSDEFINFO.lastpredeflevel is null or
                  BUSDEFINFO.lastpredeflevel = '' or
                  BUSDEFINFO.lastpredeflevel in (1, 2, 5, 6))) then
              '1' --һ��
             when BUSDEFINFO.lastpredeflevel = '3' then
              '2' --ǿһ
             when BUSDEFINFO.lastpredeflevel = '7' and
                  (BUSDEFINFO.specialpredeftype is null or
                  BUSDEFINFO.specialpredeftype = '' or
                  (BUSDEFINFO.specialpredeftype = '2' and
                  (BUSDEFINFO.specialpredeftype2 = '4' or
                  BUSDEFINFO.specialpredeftype2 = '' or
                  BUSDEFINFO.specialpredeftype2 is null))) then
              '3' --����
             when BUSDEFINFO.lastpredeflevel = '7' and
                  BUSDEFINFO.specialpredeftype = '2' and
                  BUSDEFINFO.specialpredeftype2 = '3' then
              '4' --ǿ��
           end as predeftype, --��������
           case
             when BUSDEFINFO.lastpredeftype is null or
                  BUSDEFINFO.lastpredeftype in (3, 4, 0) then
              '1'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '1' then
              '2'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '2' then
              '3'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '3' then
              '4'
             when BUSDEFINFO.lastpredeftype = '2' then
              '5'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '5' then
              '6'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '6' then
              '7'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '7' then
              '8'
           end as predeflevel, --��������
           BUSDEFINFO.DAYMILE, --��ƽ�����
           V_STANDARDMILE, --������̣���׼��
           BUSDEFINFO.plansummile, --ʵ����̣�����ʱΪԤ�Ʊ�����̣�
           BUSDEFINFO.plansummile, --Ԥ�Ʊ������
           BUSDEFINFO.THENSUMMILE, --Ԥ�ᵱʱ���
           decode(BUSDEFINFO.LASTSTANDARDDEFENDPERIOD,
                  0,
                  BUSDEFINFO.LASTREALMILE,
                  BUSDEFINFO.LASTSTANDARDDEFENDPERIOD) + V_STANDARDMILE as STANDARDDEFENDPERIOD, --��׼�������
           BUSDEFINFO.specialpredeftype as SPECIALDEFENDTYPE, --�ϴη�һ������
           BUSDEFINFO.LASTSPECIALREALMILE, --�ϴη�һ�����
           10 AS PLANDAYCOUNT,
           V_ALARMDAYCOUNT as ALARMDAYCOUNT, --Ԥ������
           BUSDEFINFO.orgid, --��֯
           BUSDEFINFO.bustid, --�����ͺ�
           '0' AS WORKORDERTYPE,
           case
             when BUSDEFINFO.lastpredeflevel is null or
                  BUSDEFINFO.lastpredeflevel = '' or
                  BUSDEFINFO.lastpredeflevel in (1, 2) then
              1
             else
              2
           end as STOPMIDDAY, --ͣ�˰���
           CASE
             WHEN V_STANDARDMILE - NVL(BUSDEFINFO.SUMMILE, 0) > 0 AND
                  (TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE <
                  (V_MAXSTANDARDMILE - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE) + 1
             WHEN V_STANDARDMILE - BUSDEFINFO.SUMMILE > 0 AND
                  (TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE >=
                  (V_MAXSTANDARDMILE - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE)
             ELSE
              V_FIRSTDATE
           END DEFPLANDATE, --�ƻ���������
           CASE
             WHEN V_STANDARDMILE - NVL(BUSDEFINFO.SUMMILE, 0) > 0 AND
                  (TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE <
                  (V_MAXSTANDARDMILE - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE) + 1
             WHEN V_STANDARDMILE - BUSDEFINFO.SUMMILE > 0 AND
                  (TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE >=
                  (V_MAXSTANDARDMILE - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE)
             ELSE
              V_FIRSTDATE
           END DEFDATE, --ָ�����ڣ�Ĭ��Ϊ�ƻ��������ڣ�
           BUSDEFINFO.PREDEFDATE, --�ϴα�������
           '0' PLANFLG,
           '1' ALARMFLG,
           '0' JUDGEFLG,
           '0' AUDITSTATUS,
           MAINWAREORG.MAINTAINCELL DEFAULTWARE,
           MAINWAREORG.MAINTAINORGID WORKSHOPID,
           RBUSROUTE.ROUTEID,
           '0' DEFFLAG,
           sysdate
      from (select lastdef.BUSID,
                   lastdef.orgid,
                   lastdef.bustid,
                   lastdef.lastpredeftype,
                   lastdef.lastpredeflevel,
                   lastdef.specialpredeftype, --�ϴη�һ������
                   Lastdef.LASTSPECIALREALMILE, --�ϴη�һ��ʵ�����
                   lastdef.specialpredeftype2,
                   Lastdef.lastREALMILE,
                   Lastdef.LASTSTANDARDDEFENDPERIOD,
                   mile.PREDEFDATE,
                   mile.DAYMILE,
                   mile.RUNDATECOUNT,
                   Lastdef.lastREALMILE + mile.THENSUMMILE +
                   V_ALARMDAYCOUNT * mile.DAYMILE as plansummile, --Ԥ�Ʊ������(�ϴα���ʵ�����+�˺��ۼ����+Ԥ�����)
                   Lastdef.lastREALMILE + mile.THENSUMMILE as THENSUMMILE, --Ԥ�ᵱʱ���(�ϴα���ʵ�����+�˺��ۼ����)
                   case
                     when lastdef.LASTSTANDARDDEFENDPERIOD > 0 then
                      mile.THENSUMMILE + 5 * mile.DAYMILE -
                      (lastdef.LASTSTANDARDDEFENDPERIOD -
                      Lastdef.lastREALMILE)

                     else
                      mile.THENSUMMILE + 5 * mile.DAYMILE
                   end as summile --�����ϴα�׼������̺�ʵ����̵�ƫ����
              from (
                    --�Ӳ�ѯlastdef����ȡ�����ϴα�����Ϣ�������������Ᵽ������Ϣ
                    SELECT BUSINFO.BUSID,
                            businfo.orgid,
                            businfo.bustid,
                            DEFLEVEL.predeftype as lastpredeftype,
                            DEFLEVEL.predeflevel as lastpredeflevel,
                            nvl(DEFLEVEL.STANDARDDEFENDPERIOD, 0) as LASTSTANDARDDEFENDPERIOD, --�ϴα�׼�������
                            nvl(DEFLEVEL.REALMILE, 0) as lastREALMILE, --�ϴ�ʵ�����
                            DEFLEVEL.specialpredeftype, --���һ�����Ᵽ��
                            DEFLEVEL.LASTSPECIALREALMILE,
                            DEFLEVEL.specialpredeftype2 --�����ڶ������Ᵽ��
                      FROM view_businfo BUSINFO,
                            (select def.*,
                                    special.PREDEFTYPE as specialpredeftype,
                                    special.REALMILE as LASTSPECIALREALMILE,
                                    special2.PREDEFTYPE as specialpredeftype2
                               from (
                                     --�Ӳ�ѯdef����ȡ�ϴα�����Ϣ
                                     SELECT T.BUSID,
                                             T.DEFENDTYPE AS PREDEFTYPE,
                                             T.DEFENDLEVEL AS PREDEFLEVEL,
                                             t.STANDARDDEFENDPERIOD,
                                             t.REALMILE as REALMILE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE,
                                                     TEMBUSDEF.DEFENDLEVEL,
                                                     TEMBUSDEF.DEFENDPERIOD,
                                                     TEMBUSDEF.STANDARDDEFENDPERIOD,
                                                     TEMBUSDEF.REALMILE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM <= 1) def,
                                    (
                                     --�Ӳ�ѯspecial����ȡ�ϴη�һ����Ϣ
                                     SELECT T.BUSID,
                                             T.DEFENDTYPE AS PREDEFTYPE,
                                             T.REALMILE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE,
                                                     TEMBUSDEF.REALMILE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.DEFENDTYPE != '1'
                                                 and TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM = 1) special,
                                    (
                                     --�Ӳ�ѯspecial2����ȡ�����ڶ��η�һ����Ϣ
                                     SELECT T.BUSID, T.DEFENDTYPE AS PREDEFTYPE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.DEFENDTYPE != '1'
                                                 and TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM = 2) special2
                              where def.busid = special.busid(+)
                                and def.busid = special2.busid(+)) DEFLEVEL
                     WHERE BUSINFO.BUSID = DEFLEVEL.BUSID(+)
                          --sign:��41·��102·�������ר�ߡ�17·��44·��2·��110·�Լ�2007��1����ǰ������ĳ���
                       and BUSINFO.sign is null) lastdef,
                   (
                    --�Ӳ�ѯmile����ȡ���ϴα�����ĿǰΪֹ�����
                    SELECT TEMBUSDEFINFO.BUSID,
                            TEMBUSDEFINFO.PREDEFDATE,
                            TRUNC(SUM(BUS_DAYMILE_V.MILE) /
                                  COUNT(BUS_DAYMILE_V.RUNDATE),
                                  3) DAYMILE,
                            COUNT(BUS_DAYMILE_V.RUNDATE) RUNDATECOUNT,
                            SUM(BUS_DAYMILE_V.MILE) as THENSUMMILE
                      FROM BUS_DAYMILE_V,
                            (SELECT BUSINFO.BUSID,
                                    (NVL(TEMBUSDEFINFO.DEFDATE,
                                         BUSINFO.INITIALIZEDATE)) AS PREDEFDATE
                               FROM view_businfo BUSINFO,
                                    (SELECT TEMBUSDEF.BUSID,
                                            MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                       FROM BM_TEMBUSDEFASS TEMBUSDEF
                                      WHERE TEMBUSDEF.AUDITSTATUS = '1'
                                      GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                              WHERE BUSINFO.BUSID = TEMBUSDEFINFO.BUSID(+)
                                   --sign:��41·��102·�������ר�ߡ�17·��44·��2·��110·�Լ�2007��1����ǰ������ĳ���
                                and BUSINFO.sign is null) TEMBUSDEFINFO
                     WHERE 1 = 1
                       AND TEMBUSDEFINFO.BUSID = BUS_DAYMILE_V.BUSID
                       AND BUS_DAYMILE_V.RUNDATE >= TEMBUSDEFINFO.PREDEFDATE
                       AND BUS_DAYMILE_V.RUNDATE <= V_FIRSTDATE
                     GROUP BY TEMBUSDEFINFO.BUSID, TEMBUSDEFINFO.PREDEFDATE) mile,
                   (
                    --�Ӳ�ѯisactivebus����ȡ5��������̵ĳ���
                    SELECT DISTINCT busrun.BUSID
                      FROM BUS_DAYMILE_V busrun
                     WHERE busrun.RUNDATE > sysdate - 5
                       AND busrun.MILE > 0) isactivebus
             where lastdef.busid = mile.busid
               and lastdef.busid = isactivebus.busid) BUSDEFINFO,
           BM_RMAINTAINWAREORGGD MAINWAREORG,
           (SELECT RBUSROUTE.BUSID, RBUSROUTE.ROUTEID
              FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY ROUTEID ASC) RBUSROUTENUM,
                           RBUSROUTE.BUSID,
                           RBUSROUTE.ROUTEID
                      FROM ASGNRBUSROUTELD RBUSROUTE) RBUSROUTE
             WHERE RBUSROUTE.RBUSROUTENUM = 1) RBUSROUTE
     where BUSDEFINFO.orgid = MAINWAREORG.ORGID(+)
       AND BUSDEFINFO.BUSID = RBUSROUTE.BUSID(+)
       and BUSDEFINFO.summile > V_MINSTANDARDMILE;
  COMMIT;

  INSERT INTO BM_TEMBUSDEFASS
    (BUSDEFASSID, --������������
     BUSID,
     DEFENDTYPE, --��������
     DEFENDLEVEL, --��������
     DAYMILE, --��ƽ�����
     DEFENDPERIOD, --������̣���׼��
     REALMILE, --ʵ�����
     plansummile, --Ԥ�Ʊ������
     THENSUMMILE, --Ԥ�ᵱʱ���
     STANDARDDEFENDPERIOD, --��׼�������
     SPECIALDEFENDTYPE, --�ϴη�һ������
     SPECIALREALMILE, --�ϴη�һ�����
     PLANDAYCOUNT,
     ALARMDAYCOUNT,
     BUSORG, --��֯
     BUSTYPE, --�����ͺ�
     WORKORDERTYPE,
     STOPMIDDAY, --ͣ�˰���
     DEFPLANDATE, --�ƻ���������
     DEFDATE, --ָ������
     PREDEFDATE, --�ϴα�������
     PLANFLG,
     ALARMFLG,
     JUDGEFLG,
     AUDITSTATUS,
     DEFAULTWARE, --Ĭ��ά�޵�Ԫ
     WORKSHOPID, --ά�޳�����
     ROUTEID,
     DEFFLAG, --��������(0:* 1:#)
     CREATED)
    select S_FDISDISPLANGD.NEXTVAL AS BUSDEFASSID, --������������
           BUSDEFINFO.busid,
           case
             when busdefinfo.lastpredeftype <> '1' or
                  busdefinfo.lastpredeftype is null or
                  (busdefinfo.lastpredeftype = '1' and
                  (BUSDEFINFO.lastpredeflevel is null or
                  BUSDEFINFO.lastpredeflevel = '' or
                  BUSDEFINFO.lastpredeflevel in (1, 2, 5, 6))) then
              '1' --һ��
             when BUSDEFINFO.lastpredeflevel = '3' then
              '2' --ǿһ
             when BUSDEFINFO.lastpredeflevel = '7' and
                  (BUSDEFINFO.specialpredeftype is null or
                  BUSDEFINFO.specialpredeftype = '' or
                  (BUSDEFINFO.specialpredeftype = '2' and
                  (BUSDEFINFO.specialpredeftype2 = '4' or
                  BUSDEFINFO.specialpredeftype2 = '' or
                  BUSDEFINFO.specialpredeftype2 is null))) then
              '3' --����
             when BUSDEFINFO.lastpredeflevel = '7' and
                  BUSDEFINFO.specialpredeftype = '2' and
                  BUSDEFINFO.specialpredeftype2 = '3' then
              '4' --ǿ��
           end as predeftype, --��������
           case
             when BUSDEFINFO.lastpredeftype is null or
                  BUSDEFINFO.lastpredeftype in (3, 4, 0) then
              '1'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '1' then
              '2'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '2' then
              '3'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '3' then
              '4'
             when BUSDEFINFO.lastpredeftype = '2' then
              '5'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '5' then
              '6'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '6' then
              '7'
             when BUSDEFINFO.lastpredeftype = '1' and
                  BUSDEFINFO.lastpredeflevel = '7' then
              '8'
           end as predeflevel, --��������
           BUSDEFINFO.DAYMILE, --��ƽ�����
           V_STANDARDMILE1, --������̣���׼��
           BUSDEFINFO.plansummile, --ʵ����̣�����ʱΪԤ�Ʊ�����̣�
           BUSDEFINFO.plansummile, --Ԥ�Ʊ������
           BUSDEFINFO.THENSUMMILE, --Ԥ�ᵱʱ���
           decode(BUSDEFINFO.LASTSTANDARDDEFENDPERIOD,
                  0,
                  BUSDEFINFO.LASTREALMILE,
                  BUSDEFINFO.LASTSTANDARDDEFENDPERIOD) + V_STANDARDMILE1 as STANDARDDEFENDPERIOD, --��׼�������
           BUSDEFINFO.specialpredeftype as SPECIALDEFENDTYPE, --�ϴη�һ������
           BUSDEFINFO.LASTSPECIALREALMILE, --�ϴη�һ�����
           10 AS PLANDAYCOUNT,
           V_ALARMDAYCOUNT as ALARMDAYCOUNT, --Ԥ������
           BUSDEFINFO.orgid, --��֯
           BUSDEFINFO.bustid, --�����ͺ�
           '0' AS WORKORDERTYPE,
           case
             when BUSDEFINFO.lastpredeflevel is null or
                  BUSDEFINFO.lastpredeflevel = '' or
                  BUSDEFINFO.lastpredeflevel in (1, 2) then
              1
             else
              2
           end as STOPMIDDAY, --ͣ�˰���
           CASE
             WHEN V_STANDARDMILE1 - NVL(BUSDEFINFO.SUMMILE, 0) > 0 AND
                  (TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE <
                  (V_MAXSTANDARDMILE1 - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE) + 1
             WHEN V_STANDARDMILE1 - BUSDEFINFO.SUMMILE > 0 AND
                  (TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE >=
                  (V_MAXSTANDARDMILE1 - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE)
             ELSE
              V_FIRSTDATE
           END DEFPLANDATE, --�ƻ���������
           CASE
             WHEN V_STANDARDMILE1 - NVL(BUSDEFINFO.SUMMILE, 0) > 0 AND
                  (TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE <
                  (V_MAXSTANDARDMILE1 - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE) + 1
             WHEN V_STANDARDMILE1 - BUSDEFINFO.SUMMILE > 0 AND
                  (TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                         BUSDEFINFO.DAYMILE) + 1) * BUSDEFINFO.DAYMILE >=
                  (V_MAXSTANDARDMILE1 - BUSDEFINFO.SUMMILE) THEN
              V_FIRSTDATE + TRUNC((V_STANDARDMILE1 - BUSDEFINFO.SUMMILE) /
                                  BUSDEFINFO.DAYMILE)
             ELSE
              V_FIRSTDATE
           END DEFDATE, --ָ�����ڣ�Ĭ��Ϊ�ƻ��������ڣ�
           BUSDEFINFO.PREDEFDATE, --�ϴα�������
           '0' PLANFLG,
           '1' ALARMFLG,
           '0' JUDGEFLG,
           '0' AUDITSTATUS,
           MAINWAREORG.MAINTAINCELL DEFAULTWARE,
           MAINWAREORG.MAINTAINORGID WORKSHOPID,
           RBUSROUTE.ROUTEID,
           '0' DEFFLAG,
           sysdate
      from (select lastdef.BUSID,
                   lastdef.orgid,
                   lastdef.bustid,
                   lastdef.lastpredeftype,
                   lastdef.lastpredeflevel,
                   lastdef.specialpredeftype, --�ϴη�һ������
                   Lastdef.LASTSPECIALREALMILE, --�ϴη�һ��ʵ�����
                   lastdef.specialpredeftype2,
                   Lastdef.lastREALMILE,
                   Lastdef.LASTSTANDARDDEFENDPERIOD,
                   mile.PREDEFDATE,
                   mile.DAYMILE,
                   mile.RUNDATECOUNT,
                   Lastdef.lastREALMILE + mile.THENSUMMILE +
                   V_ALARMDAYCOUNT * mile.DAYMILE as plansummile, --Ԥ�Ʊ������(�ϴα���ʵ�����+�˺��ۼ����+Ԥ�����)
                   Lastdef.lastREALMILE + mile.THENSUMMILE as THENSUMMILE, --Ԥ�ᵱʱ���(�ϴα���ʵ�����+�˺��ۼ����)
                   case
                     when lastdef.LASTSTANDARDDEFENDPERIOD > 0 then
                      mile.THENSUMMILE + 5 * mile.DAYMILE -
                      (lastdef.LASTSTANDARDDEFENDPERIOD -
                      Lastdef.lastREALMILE)

                     else
                      mile.THENSUMMILE + 5 * mile.DAYMILE
                   end as summile --�����ϴα�׼������̺�ʵ����̵�ƫ����
              from (
                    --�Ӳ�ѯlastdef����ȡ�����ϴα�����Ϣ�������������Ᵽ������Ϣ
                    SELECT BUSINFO.BUSID,
                            businfo.orgid,
                            businfo.bustid,
                            DEFLEVEL.predeftype as lastpredeftype,
                            DEFLEVEL.predeflevel as lastpredeflevel,
                            nvl(DEFLEVEL.STANDARDDEFENDPERIOD, 0) as LASTSTANDARDDEFENDPERIOD, --�ϴα�׼�������
                            nvl(DEFLEVEL.REALMILE, 0) as lastREALMILE, --�ϴ�ʵ�����
                            DEFLEVEL.specialpredeftype, --���һ�����Ᵽ��
                            DEFLEVEL.LASTSPECIALREALMILE,
                            DEFLEVEL.specialpredeftype2 --�����ڶ������Ᵽ��
                      FROM view_businfo BUSINFO,
                            (select def.*,
                                    special.PREDEFTYPE as specialpredeftype,
                                    special.REALMILE as LASTSPECIALREALMILE,
                                    special2.PREDEFTYPE as specialpredeftype2
                               from (
                                     --�Ӳ�ѯdef����ȡ�ϴα�����Ϣ
                                     SELECT T.BUSID,
                                             T.DEFENDTYPE AS PREDEFTYPE,
                                             T.DEFENDLEVEL AS PREDEFLEVEL,
                                             t.STANDARDDEFENDPERIOD,
                                             t.REALMILE as REALMILE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE,
                                                     TEMBUSDEF.DEFENDLEVEL,
                                                     TEMBUSDEF.DEFENDPERIOD,
                                                     TEMBUSDEF.STANDARDDEFENDPERIOD,
                                                     TEMBUSDEF.REALMILE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM <= 1) def,
                                    (
                                     --�Ӳ�ѯspecial����ȡ�ϴη�һ����Ϣ
                                     SELECT T.BUSID,
                                             T.DEFENDTYPE AS PREDEFTYPE,
                                             T.REALMILE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE,
                                                     TEMBUSDEF.REALMILE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.DEFENDTYPE != '1'
                                                 and TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM = 1) special,
                                    (
                                     --�Ӳ�ѯspecial2����ȡ�����ڶ��η�һ����Ϣ
                                     SELECT T.BUSID, T.DEFENDTYPE AS PREDEFTYPE
                                       FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                     TEMBUSDEF.BUSID,
                                                     TEMBUSDEF.DEFENDTYPE
                                                FROM BM_TEMBUSDEFASS TEMBUSDEF
                                               WHERE TEMBUSDEF.DEFENDTYPE != '1'
                                                 and TEMBUSDEF.AUDITSTATUS != '3'
                                                 AND TEMBUSDEF.DEFPLANDATE <=
                                                     V_FIRSTDATE) T
                                      WHERE T.DEFNUM = 2) special2
                              where def.busid = special.busid(+)
                                and def.busid = special2.busid(+)) DEFLEVEL
                     WHERE BUSINFO.BUSID = DEFLEVEL.BUSID(+)
                          --sign:41·��102·�������ר�ߡ�17·��44·��2·��110·�Լ�2007��1����ǰ������ĳ���
                       and BUSINFO.sign is not null) lastdef,
                   (
                    --�Ӳ�ѯmile����ȡ���ϴα�����ĿǰΪֹ�����
                    SELECT TEMBUSDEFINFO.BUSID,
                            TEMBUSDEFINFO.PREDEFDATE,
                            TRUNC(SUM(BUS_DAYMILE_V.MILE) /
                                  COUNT(BUS_DAYMILE_V.RUNDATE),
                                  3) DAYMILE,
                            COUNT(BUS_DAYMILE_V.RUNDATE) RUNDATECOUNT,
                            SUM(BUS_DAYMILE_V.MILE) as THENSUMMILE
                      FROM BUS_DAYMILE_V,
                            (SELECT BUSINFO.BUSID,
                                    (NVL(TEMBUSDEFINFO.DEFDATE,
                                         BUSINFO.INITIALIZEDATE)) AS PREDEFDATE
                               FROM view_businfo BUSINFO,
                                    (SELECT TEMBUSDEF.BUSID,
                                            MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                       FROM BM_TEMBUSDEFASS TEMBUSDEF
                                      WHERE TEMBUSDEF.AUDITSTATUS = '1'
                                      GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                              WHERE BUSINFO.BUSID = TEMBUSDEFINFO.BUSID(+)
                                   --sign:41·��102·�������ר�ߡ�17·��44·��2·��110·�Լ�2007��1����ǰ������ĳ���
                                and BUSINFO.sign is not null) TEMBUSDEFINFO
                     WHERE 1 = 1
                       AND TEMBUSDEFINFO.BUSID = BUS_DAYMILE_V.BUSID
                       AND BUS_DAYMILE_V.RUNDATE >= TEMBUSDEFINFO.PREDEFDATE
                       AND BUS_DAYMILE_V.RUNDATE <= V_FIRSTDATE
                     GROUP BY TEMBUSDEFINFO.BUSID, TEMBUSDEFINFO.PREDEFDATE) mile,
                   (
                    --�Ӳ�ѯisactivebus����ȡ5��������̵ĳ���
                    SELECT DISTINCT busrun.BUSID
                      FROM BUS_DAYMILE_V busrun
                     WHERE busrun.RUNDATE > sysdate - 5
                       AND busrun.MILE > 0) isactivebus
             where lastdef.busid = mile.busid
               and lastdef.busid = isactivebus.busid) BUSDEFINFO,
           BM_RMAINTAINWAREORGGD MAINWAREORG,
           (SELECT RBUSROUTE.BUSID, RBUSROUTE.ROUTEID
              FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY ROUTEID ASC) RBUSROUTENUM,
                           RBUSROUTE.BUSID,
                           RBUSROUTE.ROUTEID
                      FROM ASGNRBUSROUTELD RBUSROUTE) RBUSROUTE
             WHERE RBUSROUTE.RBUSROUTENUM = 1) RBUSROUTE
     where BUSDEFINFO.orgid = MAINWAREORG.ORGID(+)
       AND BUSDEFINFO.BUSID = RBUSROUTE.BUSID(+)
       and BUSDEFINFO.summile > V_MINSTANDARDMILE1;
  COMMIT;
END;
/

prompt
prompt Creating procedure P_BUSDEFIINFO_WX
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH."P_BUSDEFIINFO_WX" is

  V_FIRSTDATE DATE; -- ָ���µ�һ��
  V_LASTDATE  DATE; -- ָ�������һ��
  v_substr    VARCHAR2(100); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  V_SETMILE   NUMBER := 1200; -- ƫ�Ʊ�׼���
  --V_PARAMETER NUMBER(1, 1) := 0; -- ���ڶ����׼��

BEGIN

  -- ɾ����ʱ������
  v_substr := 'DELETE FROM  BM_TEMBUSDEFASSTEST';
  execute immediate v_substr;
  COMMIT;

  -- ���µ�һ������һ��
  SELECT TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH'),
                         'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- ��������
  INSERT INTO BM_TEMBUSDEFASSTEST
    (BUSID,
     DAYMILE,
     DEFENDTYPE,
     DEFENDLEVEL,
     DEFENDPERIOD,
     PLANDAYCOUNT,
     ALARMDAYCOUNT,
     BUSTYPE,
     BUSORG,
     WORKORDERTYPE,
     STOPMIDDAY,
     DEFPLANDATE,
     PLANFLG,
     ALARMFLG,
     JUDGEFLG,
     PREDEFDATE,
     AUDITSTATUS,
     DEFAULTWARE,
     WORKSHOPID,
     BUSDEFASSID)
    SELECT BUSDEFEND.*,
           MAINWAREORG.MAINTAINCELL  DEFAULTWARE,
           MAINWAREORG.MAINTAINORGID WORKSHOPID,
           S_FDISDISPLANGD.NEXTVAL   AS BUSDEFASSID
      FROM (SELECT DEFFIRST.BUSID,
                   DEFFIRST.DAYMILE,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      '2'
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         '1'
                        ELSE
                         '2'
                      END)
                   END DEFENDTYPE,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      DEFSEC.DEFENDLEVEL
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         DEFFIRST.DEFENDLEVEL
                        ELSE
                         DEFSEC.DEFENDLEVEL
                      END)
                   END DEFENDLEVEL,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      DEFSEC.DEFENDPERIOD
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         DEFFIRST.DEFENDPERIOD
                        ELSE
                         DEFSEC.DEFENDPERIOD
                      END)
                   END DEFENDPERIOD,
                   10 AS PLANDAYCOUNT,
                   5 AS ALARMDAYCOUNT,
                   BUSINFO.BUSTID BUSTYPE,
                   BUSINFO.ORGID BUSORG,
                   '0' AS WORKORDERTYPE,
                   1 AS STOPMIDDAY,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      DEFSEC.DEFPLANDATE
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         DEFFIRST.DEFPLANDATE
                        ELSE
                         DEFSEC.DEFPLANDATE
                      END)
                   END DEFPLANDATE,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      SIGN(DEFSEC.DEFPLANDATE - V_LASTDATE)
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         SIGN(DEFFIRST.DEFPLANDATE - V_LASTDATE)
                        ELSE
                         SIGN(DEFSEC.DEFPLANDATE - V_LASTDATE)
                      END)
                   END PLANFLG,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      SIGN(DEFSEC.DEFPLANDATE - 5 - V_FIRSTDATE)
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         SIGN(DEFFIRST.DEFPLANDATE - 5 - V_FIRSTDATE)
                        ELSE
                         SIGN(DEFSEC.DEFPLANDATE - 5 - V_FIRSTDATE)
                      END)
                   END ALARMFLG,
                   '0' JUDGEFLG,
                   CASE
                     WHEN SIGN(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) <= 0 THEN
                      DEFSEC.PREDEFDATE
                     ELSE
                      (CASE
                        WHEN SIGN(ABS(DEFSEC.DEFPLANDATE - DEFFIRST.DEFPLANDATE) -
                                  DEFFIRST.DISDAY) >= 0 THEN
                         DEFFIRST.PREDEFDATE
                        ELSE
                         DEFSEC.PREDEFDATE
                      END)
                   END PREDEFDATE,
                   '0' AUDITSTATUS
              FROM (SELECT BUSDEFINFO.BUSID,
                           BUSDEFINFO.DEFENDTYPE,
                           BUSDEFINFO.DEFENDLEVEL,
                           BUSDEFINFO.DEFENDPERIOD,
                           CASE
                             WHEN BUSDEFINFO.DEFENDPERIOD -
                                  NVL(BUSMILEINFO.SUMMILE, 0) > 0 THEN
                              SYSDATE + ROUND((BUSDEFINFO.DEFENDPERIOD -
                                              NVL(BUSMILEINFO.SUMMILE, 0)) /
                                              AVGINFO.DAYMILE,
                                              0)
                             ELSE
                              SYSDATE
                           END DEFPLANDATE,
                           AVGINFO.DAYMILE,
                           PREDEFINFO.PREDEFDATE,
                           ROUND(V_SETMILE / AVGINFO.DAYMILE, 0) AS DISDAY
                      FROM (SELECT AVGINFO.BUSID,
                                   CASE
                                     WHEN AVGINFO.DAYMILE < 1 THEN
                                      1
                                     ELSE
                                      AVGINFO.DAYMILE
                                   END DAYMILE
                              FROM (SELECT BUS_DAYMILE_V.BUSID,
                                           TRUNC(SUM(BUS_DAYMILE_V.MILE) / 30,
                                                 3) AS DAYMILE
                                      FROM BUS_DAYMILE_V
                                     WHERE BUS_DAYMILE_V.RUNDATE >=
                                           (SYSDATE - 30)
                                       AND BUS_DAYMILE_V.RUNDATE <= SYSDATE
                                     GROUP BY BUS_DAYMILE_V.BUSID) AVGINFO) AVGINFO,
                           (SELECT TEMBUSDEFINFO.BUSID,
                                   SUM(BUS_DAYMILE_V.MILE) SUMMILE
                              FROM BUS_DAYMILE_V,
                                   (SELECT BUSINFO.BUSID,
                                           (NVL(TEMBUSDEFINFO.DEFDATE,
                                                DATE '2010-01-01')) AS PREDEFDATE
                                      FROM MCBUSINFOGS BUSINFO,
                                           (SELECT TEMBUSDEF.BUSID,
                                                   MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                              FROM BM_TEMBUSDEFASS TEMBUSDEF
                                             WHERE 1 = 1
                                               AND TEMBUSDEF.AUDITSTATUS = '1'
                                             GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                                     WHERE BUSINFO.ISACTIVE = '1'
                                       AND BUSINFO.STATUS NOT IN ('2', '4')
                                       AND BUSINFO.BUSID =
                                           TEMBUSDEFINFO.BUSID(+)) TEMBUSDEFINFO
                             WHERE 1 = 1
                               AND BUS_DAYMILE_V.BUSID = TEMBUSDEFINFO.BUSID
                               AND BUS_DAYMILE_V.RUNDATE >=
                                   TEMBUSDEFINFO.PREDEFDATE
                               AND BUS_DAYMILE_V.RUNDATE <= SYSDATE
                             GROUP BY TEMBUSDEFINFO.BUSID) BUSMILEINFO,
                           (SELECT BUSINFO.BUSID,
                                   BUSINFO.ORGID,
                                   (NVL(TEMBUSDEFINFO.DEFDATE,
                                        DATE '2010-01-01')) AS PREDEFDATE
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT TEMBUSDEF.BUSID,
                                           MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                      FROM BM_TEMBUSDEFASS TEMBUSDEF
                                     WHERE 1 = 1
                                       AND TEMBUSDEF.AUDITSTATUS = '1'
                                     GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                             WHERE BUSINFO.ISACTIVE = '1'
                               AND BUSINFO.STATUS NOT IN ('2', '4')
                               AND BUSINFO.BUSID = TEMBUSDEFINFO.BUSID(+)) PREDEFINFO,
                           (SELECT BUSINFO.BUSID,
                                   BUSINFO.ORGID,
                                   '1' AS DEFENDTYPE,
                                   DEFLEVEL.PREDEFTYPE,
                                   DEFLEVEL.PREDEFLEVEL,
                                   CASE
                                     WHEN DEFLEVEL.PREDEFTYPE = '2' THEN
                                      '0'
                                     WHEN DEFLEVEL.PREDEFTYPE = '4' THEN
                                      '0'
                                     WHEN DEFLEVEL.PREDEFLEVEL = '0' THEN
                                      '1'
                                     ELSE
                                      '0'
                                   END DEFENDLEVEL,
                                   CASE
                                     WHEN BUSINFO.BUSTID =
                                          '11090628103015222103' THEN
                                      10000
                                     ELSE
                                      5000
                                   END DEFENDPERIOD
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT T.BUSID,
                                           T.DEFENDTYPE  AS PREDEFTYPE,
                                           T.DEFENDLEVEL AS PREDEFLEVEL
                                      FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                   TEMBUSDEF.BUSID,
                                                   TEMBUSDEF.DEFENDTYPE,
                                                   TEMBUSDEF.DEFENDLEVEL
                                              FROM BM_TEMBUSDEFASS TEMBUSDEF
                                             WHERE 1 = 1
                                               AND TEMBUSDEF.AUDITSTATUS = '1') T
                                     WHERE T.DEFNUM <= 1) DEFLEVEL
                             WHERE BUSINFO.ISACTIVE = '1'
                               AND BUSINFO.STATUS NOT IN ('2', '4')
                               AND BUSINFO.BUSID = DEFLEVEL.BUSID(+)) BUSDEFINFO
                     WHERE BUSDEFINFO.BUSID = AVGINFO.BUSID(+)
                       AND BUSDEFINFO.BUSID = BUSMILEINFO.BUSID(+)
                       AND BUSDEFINFO.BUSID = PREDEFINFO.BUSID(+)
                       AND AVGINFO.DAYMILE IS NOT NULL) DEFFIRST,
                   (SELECT BUSDEFINFO.BUSID,
                           BUSDEFINFO.DEFENDTYPE,
                           BUSDEFINFO.DEFENDLEVEL,
                           BUSDEFINFO.DEFENDPERIOD,
                           CASE
                             WHEN BUSDEFINFO.DEFENDPERIOD -
                                  NVL(BUSMILEINFO.SUMMILE, 0) > 0 THEN
                              SYSDATE + ROUND((BUSDEFINFO.DEFENDPERIOD -
                                              NVL(BUSMILEINFO.SUMMILE, 0)) /
                                              AVGINFO.DAYMILE,
                                              0)
                             ELSE
                              SYSDATE
                           END DEFPLANDATE,
                           AVGINFO.DAYMILE,
                           PREDEFINFO.PREDEFDATE
                      FROM (SELECT AVGINFO.BUSID,
                                   CASE
                                     WHEN AVGINFO.DAYMILE < 1 THEN
                                      1
                                     ELSE
                                      AVGINFO.DAYMILE
                                   END DAYMILE
                              FROM (SELECT BUS_DAYMILE_V.BUSID,
                                           TRUNC(SUM(BUS_DAYMILE_V.MILE) / 30,
                                                 3) AS DAYMILE
                                      FROM BUS_DAYMILE_V
                                     WHERE BUS_DAYMILE_V.RUNDATE >=
                                           (SYSDATE - 30)
                                       AND BUS_DAYMILE_V.RUNDATE <= SYSDATE
                                     GROUP BY BUS_DAYMILE_V.BUSID) AVGINFO) AVGINFO,
                           (SELECT BUSINFO.BUSID,
                                   BUSINFO.ORGID,
                                   (NVL(TEMBUSDEFINFO.DEFDATE,
                                        DATE '2010-01-01')) AS PREDEFDATE
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT TEMBUSDEF.BUSID,
                                           MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                      FROM BM_TEMBUSDEFASS TEMBUSDEF
                                     WHERE 1 = 1
                                       AND TEMBUSDEF.DEFENDTYPE = '2'
                                       AND TEMBUSDEF.AUDITSTATUS = '1'
                                     GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                             WHERE BUSINFO.ISACTIVE = '1'
                               AND BUSINFO.STATUS NOT IN ('2', '4')
                               AND BUSINFO.BUSID = TEMBUSDEFINFO.BUSID(+)) PREDEFINFO,
                           (SELECT TEMBUSDEFINFO.BUSID,
                                   SUM(BUS_DAYMILE_V.MILE) SUMMILE
                              FROM BUS_DAYMILE_V,
                                   (SELECT BUSINFO.BUSID,
                                           (NVL(TEMBUSDEFINFO.DEFDATE,
                                                DATE '2010-01-01')) AS PREDEFDATE
                                      FROM MCBUSINFOGS BUSINFO,
                                           (SELECT TEMBUSDEF.BUSID,
                                                   MAX(TEMBUSDEF.DEFDATE) DEFDATE
                                              FROM BM_TEMBUSDEFASS TEMBUSDEF
                                             WHERE 1 = 1
                                               AND TEMBUSDEF.DEFENDTYPE = '2'
                                               AND TEMBUSDEF.AUDITSTATUS = '1'
                                             GROUP BY TEMBUSDEF.BUSID) TEMBUSDEFINFO
                                     WHERE BUSINFO.ISACTIVE = '1'
                                       AND BUSINFO.STATUS NOT IN ('2', '4')
                                       AND BUSINFO.BUSID =
                                           TEMBUSDEFINFO.BUSID(+)) TEMBUSDEFINFO
                             WHERE 1 = 1
                               AND BUS_DAYMILE_V.BUSID = TEMBUSDEFINFO.BUSID
                               AND BUS_DAYMILE_V.RUNDATE >=
                                   TEMBUSDEFINFO.PREDEFDATE
                               AND BUS_DAYMILE_V.RUNDATE <= SYSDATE
                             GROUP BY TEMBUSDEFINFO.BUSID) BUSMILEINFO,
                           (SELECT BUSINFO.BUSID,
                                   '2' AS DEFENDTYPE,
                                   CASE
                                     WHEN NVL(DEFLEVEL.PREDEFLEVEL, '1') = '0' THEN
                                      '1'
                                     ELSE
                                      '0'
                                   END DEFENDLEVEL,
                                   CASE
                                     WHEN MONTHS_BETWEEN(SYSDATE,
                                                          BUSINFO.USEDATE) > 108 THEN
                                      20000
                                     WHEN BUSINFO.BUSTID =
                                          '11090628103015222103' THEN
                                      30000
                                     WHEN (BUSINFO.ISRETARDER = '1' AND
                                          MONTHS_BETWEEN(SYSDATE,
                                                          BUSINFO.USEDATE) <= 60) THEN
                                      30000
                                     WHEN (BUSINFO.ISRETARDER = '1' AND
                                          MONTHS_BETWEEN(SYSDATE,
                                                          BUSINFO.USEDATE) > 60) THEN
                                      25000
                                     WHEN ((BUSINFO.ISRETARDER = '0' OR
                                          BUSINFO.ISRETARDER IS NULL) AND
                                          MONTHS_BETWEEN(SYSDATE,
                                                          BUSINFO.USEDATE) <= 36) THEN
                                      25000
                                     WHEN ((BUSINFO.ISRETARDER = '0' OR
                                          BUSINFO.ISRETARDER IS NULL) AND
                                          MONTHS_BETWEEN(SYSDATE,
                                                          BUSINFO.USEDATE) > 36) THEN
                                      20000
                                   END DEFENDPERIOD
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT T.BUSID,
                                           T.DEFENDLEVEL AS PREDEFLEVEL
                                      FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFDATE DESC) DEFNUM,
                                                   TEMBUSDEF.BUSID,
                                                   TEMBUSDEF.DEFENDLEVEL
                                              FROM BM_TEMBUSDEFASS TEMBUSDEF
                                             WHERE TEMBUSDEF.DEFENDTYPE = '2'
                                               AND TEMBUSDEF.AUDITSTATUS = '1') T
                                     WHERE T.DEFNUM <= 1) DEFLEVEL
                             WHERE BUSINFO.BUSID = DEFLEVEL.BUSID(+)
                               AND BUSINFO.ISACTIVE = '1'
                               AND BUSINFO.STATUS NOT IN ('2', '4')) BUSDEFINFO
                     WHERE BUSDEFINFO.BUSID = AVGINFO.BUSID(+)
                       AND BUSDEFINFO.BUSID = BUSMILEINFO.BUSID(+)
                       AND BUSDEFINFO.BUSID = PREDEFINFO.BUSID(+)
                       AND AVGINFO.DAYMILE IS NOT NULL) DEFSEC,
                   MCBUSINFOGS BUSINFO
             WHERE BUSINFO.ISACTIVE = '1'
               AND BUSINFO.STATUS NOT IN ('2', '4')
               AND BUSINFO.BUSID = DEFFIRST.BUSID(+)
               AND BUSINFO.BUSID = DEFSEC.BUSID(+)
               AND DEFFIRST.BUSID IS NOT NULL
               AND DEFSEC.BUSID IS NOT NULL) BUSDEFEND,
           BM_RMAINTAINWAREORGGD MAINWAREORG
     WHERE 1 = 1
       AND BUSDEFEND.PLANFLG = '-1'
       AND BUSDEFEND.BUSORG = MAINWAREORG.ORGID(+);

  COMMIT;

  -- �������һά����
  INSERT INTO BM_TEMBUSDEFASSTEST
    (BUSID,
     DAYMILE,
     DEFENDTYPE,
     DEFENDLEVEL,
     DEFENDPERIOD,
     PLANDAYCOUNT,
     ALARMDAYCOUNT,
     BUSTYPE,
     BUSORG,
     WORKORDERTYPE,
     STOPMIDDAY,
     DEFPLANDATE,
     PLANFLG,
     ALARMFLG,
     JUDGEFLG,
     PREDEFDATE,
     AUDITSTATUS,
     DEFAULTWARE,
     WORKSHOPID,
     BUSDEFASSID)
    SELECT BUSDEFINFO.*,
           MAINWAREORG.MAINTAINCELL  DEFAULTWARE,
           MAINWAREORG.MAINTAINORGID WORKSHOPID,
           S_FDISDISPLANGD.NEXTVAL   AS BUSDEFASSID
      FROM (SELECT DISTINCT DEFFIRST.BUSID,
                            DEFFIRST.DAYMILE,
                            '1' DEFENDTYPE,
                            DEFFIRST.DEFENDLEVEL,
                            DEFFIRST.DEFENDPERIOD,
                            10 AS PLANDAYCOUNT,
                            5 AS ALARMDAYCOUNT,
                            DEFFIRST.BUSTYPE,
                            DEFFIRST.ORGID BUSORG,
                            '0' AS WORKORDERTYPE,
                            1 AS STOPMIDDAY,
                            DEFFIRST.DEFPLANDATE,
                            SIGN(DEFFIRST.DEFPLANDATE - V_LASTDATE) PLANFLG,
                            SIGN(DEFFIRST.DEFPLANDATE - 5 - V_FIRSTDATE) ALARMFLG,
                            '0' JUDGEFLG,
                            DEFFIRST.PREDEFDATE,
                            '0' AUDITSTATUS
              FROM (SELECT DEFINFO.BUSID,
                           DEFINFO.ORGID,
                           DEFINFO.BUSTYPE,
                           '1' AS DEFENDTYPE,
                           CASE
                             WHEN DEFINFO.DEFENDTYPE = '2' THEN
                              '0'
                             WHEN DEFINFO.DEFENDTYPE = '4' THEN
                              '0'
                             WHEN DEFINFO.DEFENDLEVEL = '0' THEN
                              '1'
                             ELSE
                              '0'
                           END DEFENDLEVEL,
                           CASE
                             WHEN DEFINFO.BUSTYPE = '11090628103015222103' THEN
                              10000
                             ELSE
                              5000
                           END DEFENDPERIOD,
                           CASE
                             WHEN DEFINFO.DAYMILE = 0 THEN
                              DEFINFO.DEFPLANDATE
                             WHEN DEFINFO.BUSTYPE = '11090628103015222103' THEN
                              DEFINFO.DEFPLANDATE +
                              ROUND(10000 / DEFINFO.DAYMILE, 0)
                             ELSE
                              DEFINFO.DEFPLANDATE +
                              ROUND(5000 / DEFINFO.DAYMILE, 0)
                           END DEFPLANDATE,
                           DEFINFO.DAYMILE,
                           DEFINFO.DEFPLANDATE PREDEFDATE
                      FROM (SELECT T.BUSID,
                                   T.ORGID,
                                   T.BUSTYPE,
                                   T.DEFENDTYPE,
                                   T.DEFENDLEVEL,
                                   T.DAYMILE,
                                   T.DEFPLANDATE
                              FROM (SELECT RANK() OVER(PARTITION BY BUSID ORDER BY DEFPLANDATE DESC) DEFNUM,
                                           TEMBUSDEFASS.BUSID,
                                           TEMBUSDEFASS.BUSORG AS ORGID,
                                           TEMBUSDEFASS.BUSTYPE,
                                           TEMBUSDEFASS.DAYMILE,
                                           TEMBUSDEFASS.DEFENDTYPE,
                                           TEMBUSDEFASS.DEFENDLEVEL,
                                           TEMBUSDEFASS.DEFPLANDATE
                                      FROM BM_TEMBUSDEFASSTEST TEMBUSDEFASS
                                     WHERE 1 = 1
                                       AND TEMBUSDEFASS.DEFPLANDATE <=
                                           V_LASTDATE) T
                             WHERE T.DEFNUM <= 1) DEFINFO) DEFFIRST) BUSDEFINFO,
           BM_RMAINTAINWAREORGGD MAINWAREORG
     WHERE BUSDEFINFO.BUSID IS NOT NULL
       AND BUSDEFINFO.PREDEFDATE >= V_FIRSTDATE
       AND BUSDEFINFO.PREDEFDATE <= V_LASTDATE
       AND BUSDEFINFO.DEFPLANDATE >= V_FIRSTDATE
       AND BUSDEFINFO.DEFPLANDATE <= V_LASTDATE - 5
       AND BUSDEFINFO.BUSORG = MAINWAREORG.ORGID(+);

  COMMIT;

END P_BUSDEFIINFO_WX;
/

prompt
prompt Creating procedure P_BUSPOSITION_PROCESS
prompt ========================================
prompt
create or replace procedure aptspzh.P_BUSPOSITION_PROCESS(P_DATE in DATE) is
  /***************************************************
  ���ƣ�    P_BUSPOSITION_PROCESS
  ��;��    �����������ͨѶ��Ϣ��
            ��������ʱ��������һ�ε�ͨѶ��Ϣд���fdisbusposition
  �����:   fdisbusposition
            bsvcbusrundatald5
  ***************************************************/
  V_ROUTEID number;
  v_Btime  date;
  v_etime  date;
  v_rundate date;
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ROUTEID T_CURSOR;
begin
  v_Btime :=TRUNC(P_DATE-1)+2.5/24;
  v_Etime :=TRUNC(P_DATE)+2.5/24;
  v_rundate :=TRUNC(P_DATE);
--------------------------------------
OPEN CUR_ROUTEID FOR
      SELECT ROUTEID
        FROM MCROUTEINFOGS ;
    --ѭ��������д��������I
    LOOP
      FETCH CUR_ROUTEID
        INTO V_ROUTEID;
      EXIT WHEN CUR_ROUTEID%NOTFOUND;
           delete from fdisbusposition a
            where a.rundate = v_rundate
              and a.routeid = v_routeid;
           commit;
            INSERT INTO fdisbusposition
              (buspositionid,
               routeid,
               subrouteid,
               productid,
               longitude,
               latitude,
               gpsspeed,
               bussid,
               actdatetime,
               recdatetime,
               rundate)
              SELECT S_BUSPOSITION.Nextval,
                     b.routeid,
                     b.subrouteid,
                     b.productid,
                     b.longitude,
                     b.latitude,
                     b.gpsspeed,
                     b.bussid,
                     b.actdatetime,
                     sysdate,
                     v_rundate
                FROM bsvcbusrundatald5 b,
                     (select a.productid, a.routeid, max(a.actdatetime) actdatetime
                        from bsvcbusrundatald5 a
                       where a.actdatetime <= v_etime
                         and a.actdatetime > v_Btime
                         and routeid = V_ROUTEID
                         and a.datatype = 3
                        -- and a.longitude<>0
                       group by a.productid, a.routeid) aa
               where aa.routeid = b.routeid
                 and b.productid = aa.productid
                 and b.actdatetime = aa.actdatetime
                 and b.datatype = 3
                 and b.actdatetime <= v_etime
                 and b.actdatetime > v_Btime
                 and b.routeid=V_ROUTEID;
            commit;
       END LOOP;
    CLOSE CUR_ROUTEID;
    INSERT INTO fdisbusposition
      (buspositionid,
       routeid,
       subrouteid,
       productid,
       longitude,
       latitude,
       gpsspeed,
       bussid,
       actdatetime,
       recdatetime,
       rundate)
      SELECT S_BUSPOSITION.NEXTVAL,
             routeid,
             subrouteid,
             productid,
             longitude,
             latitude,
             gpsspeed,
             bussid,
             actdatetime,
             sysdate,
             v_rundate
        from fdisbusposition a1
       where a1.productid in
             (select m.productid
                from mcbusmachineinfogs m
               where m.productid not in
                     (select a.productid
                        from fdisbusposition a
                       where a.rundate = v_rundate))
         and a1.rundate = v_rundate-1;
    commit;
    DELETE FROM FDISBUSPOSITION
     WHERE RUNDATE = v_rundate
       AND BUSPOSITIONID IN
           (SELECT B.BUSPOSITIONID
              FROM FDISBUSPOSITION B,
                   (select A.PRODUCTID, MAX(A.ACTDATETIME) ACTDATETIME
                      FROM FDISBUSPOSITION A
                     WHERE A.RUNDATE = v_rundate
                     GROUP BY A.PRODUCTID
                    HAVING COUNT(1) > 1) AA
             WHERE B.RUNDATE = v_rundate
               AND B.PRODUCTID = AA.PRODUCTID
               AND B.ACTDATETIME <> AA.ACTDATETIME);
    COMMIT;
    DELETE FROM FDISBUSPOSITION
     WHERE RUNDATE = v_rundate
       AND BUSPOSITIONID IN
           (SELECT B.BUSPOSITIONID
              FROM FDISBUSPOSITION B,
                   (select A.PRODUCTID, MAX(a.buspositionid) buspositionid
                      FROM FDISBUSPOSITION A
                     WHERE A.RUNDATE = v_rundate
                     GROUP BY A.PRODUCTID
                    HAVING COUNT(1) > 1) AA
             WHERE B.RUNDATE = v_rundate
               AND B.PRODUCTID = AA.PRODUCTID
               AND B.buspositionid <> AA.buspositionid);
   commit;
end ;
/

prompt
prompt Creating procedure P_BUSQUOTA
prompt =============================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH."P_BUSQUOTA" is

  V_BUSRUNDATE    DATE := SYSDATE - 1; -- �սῪʼ����
  V_BUSRUNDATEEND DATE; -- �ս��������
  V_ORGID         VARCHAR2(20); --��֯ID
  V_TOTALBUS      NUMBER(8); -- �����ܳ���
  V_PASTDAYBUS    NUMBER(8); -- ��ҹ����
  V_SECDEFBUS     NUMBER(8); -- ��ά����
  V_SPECIALREPBUS NUMBER(8); -- ���޳���
  V_WORKBUS       NUMBER(8); -- ��������Ӫ�˳�+������
  V_BUSRUNNUM     NUMBER(8); -- �з�����¼������
  V_BUSTROUBLENUM NUMBER(8); -- �������ϵ�����
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ORGINFO T_CURSOR; -- ��֯��Ϣ

BEGIN

  -- �ս��������
  SELECT TRUNC(V_BUSRUNDATE, 'DD') + 1 - 1 / (24 * 60 * 60)
    INTO V_BUSRUNDATEEND
    FROM DUAL;

  -- ��ѯ��ЧӪ����֯��Ϣ
  -- ���α�
  OPEN CUR_ORGINFO FOR
    SELECT T.ORGID
      FROM MCORGINFOGS T
     WHERE T.ISOPERATIONUNIT = '1'
       AND T.ISACTIVE = '1';
  LOOP
    FETCH CUR_ORGINFO
      INTO V_ORGID;
    -- û������ʱ�˳�
    EXIT WHEN CUR_ORGINFO%NOTFOUND;

    -- ��ѯ����ָ���������
    SELECT TOTAL_SUM.BUSNUM             TOTALSUM,
           WORKBUS_SUM.WORKBUSNUM       WORKBUSSUM,
           BUSRUNNUM_SUM.BUSRUNNUM      BUSRUNNUM,
           PASTDAY_SUM.NIGHTBUSNUM      PASTDAYSUM,
           SECDEF_SUM.SECDEFNUM         SECDEFSUM,
           SPECIALREP_SUM.SPEBUSNUM     SPECIALREPSUM,
           BUSTROUBLE_SUM.BUSTROUBLENUM BUSTROUBLENUM
      INTO V_TOTALBUS,
           V_WORKBUS,
           V_BUSRUNNUM,
           V_PASTDAYBUS,
           V_SECDEFBUS,
           V_SPECIALREPBUS,
           V_BUSTROUBLENUM
    -- �ܳ���
      FROM (SELECT COUNT(BUSINFO.BUSID) BUSNUM
              FROM (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO) TOTAL_SUM,
           -- �������գ�Ӫ�˳�+������
           (SELECT COUNT(BBB.BUSID) WORKBUSNUM
              FROM (SELECT DISTINCT BUSRUNREC.BUSID
                      FROM FDISBUSRUNRECGD BUSRUNREC
                     WHERE 1 = 1
                       AND BUSRUNREC.RUNDATADATE = TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSRUNREC.BUSSID IN ('4', '5', '6', '14')) BBB,
                   (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO
             WHERE 1 = 1
               AND BBB.BUSID = BUSINFO.BUSID) WORKBUS_SUM,
           -- �з�����¼������
           (SELECT COUNT(BBB.BUSID) BUSRUNNUM
              FROM (SELECT DISTINCT BUSRUNREC.BUSID
                      FROM FDISBUSRUNRECGD BUSRUNREC
                     WHERE 1 = 1
                       AND BUSRUNREC.RUNDATADATE = TRUNC(V_BUSRUNDATE, 'DD')) BBB,
                   (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO
             WHERE 1 = 1
               AND BBB.BUSID = BUSINFO.BUSID) BUSRUNNUM_SUM,
           -- ��ҹ��
           (SELECT COUNT(BM.BUSID) NIGHTBUSNUM
              FROM BM_WORKORDERGD BM,
                   BM_WORKCHECKGD BC,
                   (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO
             WHERE 1 = 1
               AND BUSINFO.BUSID = BM.BUSID
               AND BM.WORKORDERNO = BC.WORKCHECKNO
               AND (TRUNC(NVL(BM.COMPLETEDATE, SYSDATE + 1)) -
                   TRUNC(BC.CHECKDATE) > 0 OR BM.STATUS != '7')
               AND TRUNC(BC.CHECKDATE) <= TRUNC(V_BUSRUNDATE, 'DD')
               AND TRUNC(NVL(BM.COMPLETEDATE, SYSDATE + 1)) >=
                   TRUNC(V_BUSRUNDATE, 'DD') + 1
             ORDER BY BM.ORDERNO) PASTDAY_SUM,
           -- ��ά
           (SELECT COUNT(DEFINFO.BUSID) SECDEFNUM
              FROM BM_RWKORDERDEFGD DEFINFO,
                   (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO
             WHERE DEFINFO.DEFDATE = TRUNC(V_BUSRUNDATE, 'DD')
               AND DEFINFO.STATUS != '3'
               AND DEFINFO.DEFTYPE = '2'
               AND DEFINFO.BUSID = BUSINFO.BUSID) SECDEF_SUM,
           -- ����
           (SELECT COUNT(ORDERINFO.BUSID) SPEBUSNUM
              FROM BM_WORKORDERGD ORDERINFO,
                   (SELECT AA.BUSID
                      FROM (SELECT BUSINFO.BUSID, OUTBUSINFO.BUSID BUSID2
                              FROM MCBUSINFOGS BUSINFO,
                                   (SELECT BUSTRANSFER.BUSID
                                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                                     WHERE 1 = 1
                                       AND BUSTRANSFER.TRANSFERDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSTRANSFER.TRANSFERDATE <=
                                           V_BUSRUNDATEEND
                                       AND BUSTRANSFER.TRANSFLAG = '1'
                                       AND BUSTRANSFER.DEPARTOUT = V_ORGID) OUTBUSINFO
                             WHERE 1 = 1
                               AND BUSINFO.ORGID = V_ORGID
                               AND BUSINFO.BUSID NOT IN
                                   (SELECT BUSOFF.BUSID
                                      FROM BM_BUSOFFGD BUSOFF
                                     WHERE 1 = 1
                                       AND BUSOFF.OFFDATE >=
                                           TRUNC(V_BUSRUNDATE, 'DD')
                                       AND BUSOFF.OFFDATE <= V_BUSRUNDATEEND)
                               AND BUSINFO.REGISTERDATE <=
                                   TRUNC(V_BUSRUNDATE, 'DD')
                               AND BUSINFO.BUSID = OUTBUSINFO.BUSID(+)) AA
                     WHERE AA.BUSID2 IS NULL
                    UNION ALL
                    SELECT BUSTRANSFER.BUSID
                      FROM BM_BUSTRANSFERGD BUSTRANSFER
                     WHERE 1 = 1
                       AND BUSTRANSFER.TRANSFERDATE >=
                           TRUNC(V_BUSRUNDATE, 'DD')
                       AND BUSTRANSFER.TRANSFERDATE <= V_BUSRUNDATEEND
                       AND BUSTRANSFER.TRANSFLAG = '1'
                       AND BUSTRANSFER.DEPARTIN = V_ORGID) BUSINFO
             WHERE ORDERINFO.CREATETYPE = '7'
               AND ORDERINFO.FINISHDATE < TRUNC(V_BUSRUNDATE, 'DD')
               AND ORDERINFO.STATUS != '7'
               AND ORDERINFO.BUSID = BUSINFO.BUSID) SPECIALREP_SUM,
           (SELECT COUNT(T.BUSID) BUSTROUBLENUM
              FROM FDISBUSTRUBLELD T
             WHERE T.TROUBLEBEGINTIME >= TRUNC(V_BUSRUNDATE, 'DD')
               AND T.TROUBLEBEGINTIME <= V_BUSRUNDATEEND
               AND T.MADEBY = '1'
               AND T.ISACTIVE = '1'
               AND T.ORGID = V_ORGID) BUSTROUBLE_SUM;

    -- ���복��ָ���ս������
    INSERT INTO BM_BUSDAYQUOTAGD
      (BUSDAYQUOTAID,
       ORGID,
       DEALDATE,
       TOTALBUS,
       CANWORKBUS,
       PASTDAYBUS,
       SECDEFBUS,
       SPECIALREPBUS,
       WORKBUS,
       FEWORKBUS,
       BUSTROUBLENUM)
    VALUES
      (S_BUSCOSTGD.NEXTVAL,
       V_ORGID,
       TRUNC(V_BUSRUNDATE, 'DD'),
       NVL(V_TOTALBUS, 0),
       (NVL(V_TOTALBUS, 0) - NVL(V_PASTDAYBUS, 0) - NVL(V_SECDEFBUS, 0) -
       NVL(V_SPECIALREPBUS, 0)),
       NVL(V_PASTDAYBUS, 0),
       NVL(V_SECDEFBUS, 0),
       NVL(V_SPECIALREPBUS, 0),
       NVL(V_WORKBUS, 0),
       NVL(V_BUSRUNNUM, 0) - NVL(V_WORKBUS, 0),
       V_BUSTROUBLENUM);
    -- �ύ
    COMMIT;
  END LOOP;
END P_BUSQUOTA;
/

prompt
prompt Creating procedure P_BUS_TRANS_PROCESS
prompt ======================================
prompt
create or replace procedure aptspzh.P_BUS_TRANS_PROCESS IS
  /***************************************************
  ���ƣ�P_BUS_TRANS_PROCESS
  ��;�������α䶯��¼���޸ĳ�������������������ƿ����̥�����ػ�����֯
                          �޸ĳ����Ա�� �޸ĳ�������ָ��
                          ɾ��������·��ϵ��������Ա��ϵ
  �����:   BM_ENGINEINFOGD
            BM_TIRESINFOGD
            BM_BATTERYGD
            MCBUSMACHINEINFOGS
            MCBUSINFOGS
            ASGNRBUSEMPLD
            ASGNRBUSROUTELD
            BM_TEMBUSDEFASS
  ��д��    CoICE    20100520
  �޸ģ�
  ***************************************************/
  V_BUSTRANS_COUNT NUMBER := 0;
  TYPE T_CURSOR IS REF CURSOR;
  CUR_BUSTRANS    T_CURSOR;
  V_BUSID         VARCHAR2(20);
  V_OLDBUSSELFID  VARCHAR2(20);
  V_NEWBUSSELFID  VARCHAR2(20);
  V_OLDORGID      VARCHAR2(20);
  V_NEWORGID      VARCHAR2(20);
  V_ENGINEID      VARCHAR2(20);
  V_NOWORGID      VARCHAR2(20);
  V_BUSSTATUS     CHAR(1);
  V_BUSTRANSFERID VARCHAR2(20);
  V_ROUTEIN       NUMBER(8);
  v_transferdate  date;
BEGIN
  v_transferdate := trunc(sysdate);
  --v_transferdate :=date'2014-02-25';
  /***************************************************
  3��������������¼
  ***************************************************/
  --��ѯ�Ƿ���ڵ�����¼
  --���¼�¼��ϸ��¼����
  update bm_bustransfergd a
     set a.transferdate = (select transferdate
                             from bm_bustransfermaingd m
                            where m.bustransfermainid = a.bustransfermainid)
   where a.transferdate is null;
  commit;
  ---------
  SELECT COUNT(1)
    INTO V_BUSTRANS_COUNT
    FROM BM_BUSTRANSFERGD
   WHERE TRUNC(TRANSFERDATE) = v_transferdate
     AND nvl(TRANSFLAG, '0') = '0';
  --1 ���ڱ䶯��¼IF_BEGIN
  IF V_BUSTRANS_COUNT > 0 THEN
    BEGIN
      --OPEN CUR_BUSTRANS
      OPEN CUR_BUSTRANS FOR
        SELECT BUSID,
               BUSTR.NEWBUSSELFID,
               BUSTR.BUSSELFID,
               BUSTR.DEPARTOUT,
               BUSTR.DEPARTIN,
               BUSTR.BUSSTATUS,
               BUSTR.BUSTRANSFERID,
               BUSTR.ROUTEIN
          FROM BM_BUSTRANSFERGD BUSTR
         WHERE TRUNC(TRANSFERDATE) = v_transferdate
           AND nvl(TRANSFLAG, '0') = '0';
      LOOP
        FETCH CUR_BUSTRANS
          INTO V_BUSID, V_NEWBUSSELFID, V_OLDBUSSELFID, V_OLDORGID, V_NEWORGID, V_BUSSTATUS, V_BUSTRANSFERID, V_ROUTEIN;
        EXIT WHEN CUR_BUSTRANS%NOTFOUND;
        --1.1 �����֯���Ա�Ŷ���ͬ       �� �ݲ����ж�    BEGIN
        IF V_OLDORGID <> V_NEWORGID OR V_NEWBUSSELFID <> V_OLDBUSSELFID OR
           V_BUSSTATUS = '1' OR V_BUSSTATUS = '2' THEN
          BEGIN
            SELECT ORGID, ENGINEID
              INTO V_NOWORGID, V_ENGINEID
              FROM MCBUSINFOGS
             WHERE BUSID = V_BUSID;
            --1.1.1 ���·�����
            UPDATE BM_ENGINEINFOGD BE
               SET BE.ORGID = V_NEWORGID
             WHERE BE.ENGINENO = V_ENGINEID;
            --1.1.2 ������̥
            UPDATE BM_TIRESINFOGD BB
               SET BB.ORGID = V_NEWORGID
             WHERE BB.TIRESID = (SELECT MIN(RBT.TIRESID)
                                   FROM BM_RBUSTIRESGD RBT
                                  WHERE RBT.BUSID = V_BUSID);
            --1.1.3 ���µ�ƿ
            UPDATE BM_BATTERYGD BB
               SET BB.ORGID = V_NEWORGID
             WHERE BB.BATTERYID =
                   (SELECT MIN(RBB.BATTERYID)
                      FROM BM_RBUSBATTERYGD RBB
                     WHERE RBB.BUSID = V_BUSID);
            --1.1.4 ���³��ػ�
            UPDATE MCBUSMACHINEINFOGS BM
               SET BM.ORGID     = V_NEWORGID,
                   BM.Productid = TO_NUMBER('519' || V_NEWBUSSELFID)
             WHERE BM.BUSMID = (SELECT MIN(RBM.BUSMID)
                                  FROM MCRBUSBUSMACHINEGS RBM
                                 WHERE RBM.BUSID = V_BUSID);

            --1.1.4 ����DVR
            UPDATE MCDVRINFOGS DVR
               SET DVR.DVRSELFID = TO_NUMBER('519' || V_NEWBUSSELFID),
                   DVR.Productid = TO_NUMBER('519' || V_NEWBUSSELFID)
             WHERE DVR.DVRID = (SELECT MIN(RDVR.DVRID)
                                  FROM MCRBUSDVRGS RDVR
                                  WHERE RDVR.BUSID = V_BUSID);
            --1.1.4.1 ���³��ػ�������ϵ��
            UPDATE MCRBUSBUSMACHINEGS RBM
               set RBM.PRODUCTID = TO_NUMBER('519' || V_NEWBUSSELFID)
             WHERE RBM.BUSID = V_BUSID
               AND RBM.BUSMID = (SELECT MIN(RBM.BUSMID)
                                   FROM MCRBUSBUSMACHINEGS RBM
                                  WHERE RBM.BUSID = V_BUSID);

            --1.1.5 ���¸�ƿ
            UPDATE bm_pressurevesgd BB
               SET BB.ORGID = V_NEWORGID
             WHERE BB.pressurevesid =
                   (SELECT MIN(RBB.pressurevesid)
                      FROM bm_rbuspressgd RBB
                     WHERE RBB.BUSID = V_BUSID);
            --�����豸�ύ
            COMMIT;

            -- ���Ӹ��³�������״̬Ϊ1
            UPDATE BM_BUSTRANSFERGD BUSTRANS
               SET BUSTRANS.TRANSFLAG = '1'
             WHERE BUSTRANS.BUSTRANSFERID = V_BUSTRANSFERID;
            --�����ύ
            COMMIT;

            --1.1.5 ���³�����
            IF V_BUSSTATUS = '1' THEN
              UPDATE MCBUSINFOGS BUS
                 SET BUS.ORGID     = V_NEWORGID,
                     BUS.BUSSELFID = V_NEWBUSSELFID,
                     BUS.STATUS    = '1',
                     BUS.ISACTIVE  = '1'
               WHERE BUS.BUSID = V_BUSID;
            END IF;
            IF V_BUSSTATUS = '2' THEN
              UPDATE MCBUSINFOGS BUS
                 SET BUS.ORGID     = V_NEWORGID,
                     BUS.BUSSELFID = V_NEWBUSSELFID,
                     BUS.STATUS    = '2',
                     BUS.ISACTIVE  = '0'
               WHERE BUS.BUSID = V_BUSID;
            END IF;
            --�ύ���³���
            COMMIT;
            --1.1.6 ɾ��������Ա��ϵ
            DELETE FROM ASGNRBUSEMPLD b
             WHERE BUSID = V_BUSID
               and b.routeid in (select routeid
                                   from mcrorgroutegs
                                  where orgid = V_OLDORGID)
               and (b.routeid not in
                   (select routeid
                       from mcrorgroutegs
                      where orgid = V_NEWORGID) or
                   b.empid not in
                   (select empid
                       from asgnremprouteld emp
                      where emp.routeid = b.routeid));
            --1.1.7 ɾ��������·��ϵ
            DELETE FROM ASGNRBUSROUTELD b
             WHERE BUSID = V_BUSID
               and b.routeid in (select routeid
                                   from mcrorgroutegs
                                  where orgid = V_OLDORGID)
               and b.routeid not in
                   (select routeid
                      from mcrorgroutegs
                     where orgid = V_NEWORGID);
            --�ύɾ��������ϵ
            COMMIT;

            -- ���복����·��Ϣ
            IF V_ROUTEIN != 0 THEN
              INSERT INTO ASGNRBUSROUTELD
                (RBUSRID, BUSID, ROUTEID, RECDATE)
              VALUES
                (S_BUSCOSTGD.NEXTVAL, V_BUSID, V_ROUTEIN, SYSDATE);
            END IF;
            --�ύ���복����·
            COMMIT;

            -- �޸ı���ָ�ɱ��г�����֯��ָ��ʱ����ڵ��ڵ���ʱ��Ļᱻ����
            UPDATE BM_TEMBUSDEFASS S SET S.BUSORG = V_NEWORGID WHERE S.BUSID = V_BUSID AND S.DEFDATE >= v_transferdate;
            COMMIT;

          END;
        END IF;
      END LOOP;
      CLOSE CUR_BUSTRANS;
      --CLOSE CUR_BUSTRANS
    END;
  END IF;
  --1 ���ڱ䶯��¼IF����END
  update bm_bustransfermaingd m
     set m.transstatus = 1
   where TRUNC(M.TRANSFERDATE) = v_transferdate
     and m.bustransfermainid in
         (select bustransfermainid
            from bm_bustransfergd a
           where TRUNC(a.TRANSFERDATE) = v_transferdate
             and a.transflag = 1);
  commit;
END P_BUS_TRANS_PROCESS;
/

prompt
prompt Creating procedure P_CADRESERVICEAGE
prompt ====================================
prompt
create or replace procedure aptspzh.P_CadreServiceAge is
begin
  UPDATE ZZ_CADREINFOGD T
     SET T.SERVICEAGE = TRUNC(TO_CHAR(SYSDATE, 'YYYY') -
                              TO_CHAR(T.STARTDATE, 'YYYY')) + 1
   WHERE T.STARTDATE IS NOT NULL;
end P_CadreServiceAge;
/

prompt
prompt Creating procedure P_CALBUSMILERATE
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_CalBusMileRate(P_ORGID     CHAR, --��֯
                                             P_ROUTEID   CHAR, --��·
                                             P_MONTHFROM CHAR, --��ʼ����
                                             P_MONTHTO   CHAR, --��������
                                             REFLG       OUT CHAR) AS
  V_SUMMILE NUMBER(10, 2); --�����
BEGIN
  --ɾ����ǰ����
  delete from HR_BUSMILERATEGD;
  COMMIT;
  --�ж���·�Ƿ�Ϊ��
  IF P_ROUTEID IS NULL THEN
    --�����ܽ��
    select nvl(sum(nvl(bt.STANDARDUNITS, 1) * t.mile), 1)
      into V_SUMMILE
      from (select distinct t.busid
              from fdisbusrunrecgd t
             where t.rectype = '1'
               and t.rundatadate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
               and t.rundatadate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
               and t.orgid in
                   (select orgid
                      from (select orgid, orgname, orgtype, isactive
                              from mcorginfogs
                             start with orgid = P_ORGID
                            connect by prior orgid = parentorgid) t
                     where orgtype = '3'
                       and t.isactive = '1')) r,
           mcbusinfogs b,
           mcbustypeinfogs bt,
           bus_daymile_v t
     where r.busid = b.busid
       and b.busid = t.busid
       and b.bustid = bt.bustypeid(+)
       and t.rundate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
       and t.rundate <= to_date(P_MONTHTO, 'yyyy-mm-dd');
    --���㵥������
    insert into HR_BUSMILERATEGD
      select r.busid, sum(nvl(bt.STANDARDUNITS, 1) * t.mile) / V_SUMMILE
        from (select distinct t.busid
                from fdisbusrunrecgd t
               where t.rectype = '1'
                 and t.rundatadate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
                 and t.rundatadate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
                 and t.orgid in
                     (select orgid
                        from (select orgid, orgname, orgtype, isactive
                                from mcorginfogs
                               start with orgid = P_ORGID
                              connect by prior orgid = parentorgid) t
                       where orgtype = '3'
                         and t.isactive = '1')) r,
             mcbusinfogs b,
             mcbustypeinfogs bt,
             bus_daymile_v t
       where r.busid = b.busid
         and b.busid = t.busid
         and b.bustid = bt.bustypeid(+)
         and t.rundate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
         and t.rundate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
       group by r.busid;

  ELSE

    --�����ܽ��
    select nvl(sum(nvl(bt.STANDARDUNITS, 1) * t.mile), 1)
      into V_SUMMILE
      from (select distinct t.busid
              from fdisbusrunrecgd t
             where t.rectype = '1'
               and t.rundatadate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
               and t.rundatadate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
               and t.routeid = P_ROUTEID
               and t.orgid in
                   (select orgid
                      from (select orgid, orgname, orgtype, isactive
                              from mcorginfogs
                             start with orgid = P_ORGID
                            connect by prior orgid = parentorgid) t
                     where orgtype = '3'
                       and t.isactive = '1')) r,
           mcbusinfogs b,
           mcbustypeinfogs bt,
           bus_daymile_v t
     where r.busid = b.busid
       and b.busid = t.busid
       and b.bustid = bt.bustypeid(+)
       and t.rundate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
       and t.rundate <= to_date(P_MONTHTO, 'yyyy-mm-dd');
    --���㵥������
    insert into HR_BUSMILERATEGD
      select r.busid, sum(nvl(bt.STANDARDUNITS, 1) * t.mile) / V_SUMMILE
        from (select distinct t.busid
                from fdisbusrunrecgd t
               where t.rectype = '1'
                 and t.rundatadate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
                 and t.rundatadate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
                 and t.routeid = P_ROUTEID
                 and t.orgid in
                     (select orgid
                        from (select orgid, orgname, orgtype, isactive
                                from mcorginfogs
                               start with orgid = P_ORGID
                              connect by prior orgid = parentorgid) t
                       where orgtype = '3'
                         and t.isactive = '1')) r,
             mcbusinfogs b,
             mcbustypeinfogs bt,
             bus_daymile_v t
       where r.busid = b.busid
         and b.busid = t.busid
         and b.bustid = bt.bustypeid(+)
         and t.rundate >= to_date(P_MONTHFROM, 'yyyy-mm-dd')
         and t.rundate <= to_date(P_MONTHTO, 'yyyy-mm-dd')
       group by r.busid;

  END IF;
  --����ֵ����
   REFLG := '1';
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    REFLG := '0';
    rollback;
END;
/

prompt
prompt Creating procedure P_CAL_BUS_INSURANCEFEE
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_CAL_BUS_INSURANCEFEE(V_STARTDATE DATE, --�����µ�һ��
                                                   V_ENDDATE   DATE, --���������һ��
                                                   V_MONTH     DATE --������(2015-11-1)
                                                   ) IS
  /*****************************************************************************
  ���ƣ�P_CAL_BUS_INSURANCEFEE
  ��;���������շѼ���
  ˵����
  CREATE��  20151217
  *****************************************************************************/
  V_ID         VARCHAR2(20); --ID
  V_PERMONTFEE NUMBER(10, 2); --���·�̯����
BEGIN
  --ɾ�������Ѿ��������ݣ�
  DELETE FROM HR_BUSINSURANCEFEEGD T WHERE T.RECMONTH = V_MONTH;
  --��̯����
  INSERT INTO HR_BUSINSURANCEFEEGD
    (BUSINSURANCEFEEID, RECMONTH, BUSID, FEE, CREATED, POLICYID)
    SELECT BUSFEEDETAILSEQ.NEXTVAL,
           V_MONTH,
           BUSID,
           PERMONTHFEE,
           SYSDATE,
           POLICYID
      from (SELECT T.BUSID,
                   ROUND((T.INSURANCEMONEY * --�����ܶ�
                         (V_ENDDATE - STARTDATE) / INSURANCEDAYS),
                         2) AS PERMONTHFEE, --��̯��� 
                   T.POLICYID
              FROM (SELECT T.BUSID,
                           T.POLICYID,
                           T.INSURANCEMONEY,
                           DECODE(SIGN(V_STARTDATE - T.STARTDATE),
                                  -1,
                                  T.STARTDATE,
                                  V_STARTDATE) AS STARTDATE, --��Ч��ʼ����                         
                           T.ENDDATE - T.STARTDATE AS INSURANCEDAYS
                      FROM SS_POLICYGD T
                     WHERE T.VERIFYSTATUS = '2' --��˹���
                       AND V_ENDDATE <= T.ENDDATE
                       AND V_ENDDATE > T.STARTDATE) T
            UNION
            SELECT T.BUSID,
                   T.LEFTSURRENDERMONEY as PERMONTHFEE, --��̯���
                   T.POLICYID
              FROM SS_POLICYGD T
             WHERE (T.VERIFYSTATUS = '4' --�˱�
                   OR (T.ENDDATE > V_STARTDATE AND T.ENDDATE <= V_ENDDATE))
               AND T.LEFTSURRENDERMONEY > 0) H; --���½���

  --����ʣ����--------------------------------------------------------------------
  --�������
  DECLARE
    CURSOR C_CURSOR IS
      SELECT T.POLICYID,
             ROUND((T.INSURANCEMONEY * --�����ܶ�
                   (V_ENDDATE - STARTDATE) / INSURANCEDAYS),
                   2) AS PERMONTHFEE --��̯���
        FROM (SELECT T.POLICYID,
                     T.INSURANCEMONEY,
                     DECODE(SIGN(V_STARTDATE - T.STARTDATE),
                            -1,
                            T.STARTDATE,
                            V_STARTDATE) AS STARTDATE, --��Ч��ʼ����                         
                     T.ENDDATE - T.STARTDATE AS INSURANCEDAYS
                FROM SS_POLICYGD T
               WHERE T.VERIFYSTATUS = '2' --��˹���
                 AND V_ENDDATE <= T.ENDDATE
                 AND V_ENDDATE > T.STARTDATE) T;
  BEGIN
    OPEN C_CURSOR;
    LOOP
      FETCH C_CURSOR
        INTO V_ID, V_PERMONTFEE;
      Exit WHEN C_CURSOR%NOTFOUND;
      BEGIN
        --������¼ ʣ�ౣ�ն�� 
        UPDATE SS_POLICYGD T
           SET T.ISDEVIDED          = '1',
               T.LEFTSURRENDERMONEY = t.LEFTSURRENDERMONEY - V_PERMONTFEE
         WHERE T.Policyid = V_ID;
      END;
    END LOOP;
    CLOSE C_CURSOR;
  END;
  --�����˱����Ѿ���̯��ϵ�
  UPDATE SS_POLICYGD T
     SET T.LEFTSURRENDERMONEY = 0, T.ISDEVIDED = '1'
   WHERE (T.VERIFYSTATUS = '4' --�˱�
         OR (T.ENDDATE > V_STARTDATE AND T.ENDDATE <= V_ENDDATE))
     AND T.LEFTSURRENDERMONEY > 0;
  COMMIT;
END;
/

prompt
prompt Creating procedure P_CAL_BUS_PRICEFEE
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_CAL_BUS_PRICEFEE(V_STARTDATE DATE, --�����µ�һ��
                                               V_ENDDATE   DATE, --���������һ��
                                               V_MONTH     DATE --������(2015-11-1)
                                               ) IS
  /*****************************************************************************
  ���ƣ�P_CAL_BUS_PRICEFEE
  ��;�������ɱ���̯����
  ˵����
  CREATE��  201512178
  *****************************************************************************/
BEGIN
  --ɾ�������Ѿ��������ݣ�
  DELETE FROM HR_BUSPRICEFEEGD T WHERE T.RECMONTH = V_MONTH;
  --��̯����
  INSERT INTO HR_BUSPRICEFEEGD
    (BUSPRICEFEEID, RECMONTH, BUSID, FEE, CREATED, BUSCOSTID)
    SELECT BUSFEEDETAILSEQ.NEXTVAL,
           V_MONTH,
           BUSID,
           DEPRECIATIONFEE,
           SYSDATE,
           BUSCOSTID
      FROM (
            --������̯
            SELECT T.DEPRECIATIONFEE, T.BUSCOSTID, T.BUSID
              FROM HR_BUSCOSTGD T
             WHERE T.VERIFYSTATUS = '1' --�����
               AND T.BUSID NOT IN (SELECT BUSID FROM BM_BUSOFFGD F) --�Ǳ���
               AND V_ENDDATE <= NVL(T.ENDDATE, DATE '9999-12-30')
               AND V_ENDDATE > T.STARTDATE
               AND T.LEFTMONEY > 0
            UNION
            --���±���
            SELECT T.LEFTMONEY as DEPRECIATIONFEE, T.BUSCOSTID, T.BUSID
              FROM HR_BUSCOSTGD T
             WHERE T.BUSID IN (SELECT BUSID
                                 FROM BM_BUSOFFGD F
                                WHERE F.OFFDATE > V_STARTDATE
                                  AND F.OFFDATE <= V_ENDDATE) --����
               AND T.LEFTMONEY > 0
               AND T.VERIFYSTATUS = '1' --�����
            UNION
            --δ���ϵ��µ���
            SELECT T.LEFTMONEY as DEPRECIATIONFEE, T.BUSCOSTID, T.BUSID
              FROM HR_BUSCOSTGD T
             WHERE T.BUSID NOT IN (SELECT BUSID FROM BM_BUSOFFGD F) --�Ǳ���
               AND V_ENDDATE >= T.ENDDATE
               AND V_STARTDATE < T.ENDDATE
               AND T.LEFTMONEY > 0
               AND T.VERIFYSTATUS = '1' --�����
            ) H;

  --����ʣ����--------------------------------------------------------------------
  --�������
  UPDATE HR_BUSCOSTGD T
     SET T.LEFTMONEY = T.LEFTMONEY - DEPRECIATIONFEE, T.ISDEVIDED = '1'
   WHERE T.VERIFYSTATUS = '1' --�����
     AND T.BUSID NOT IN (SELECT BUSID FROM BM_BUSOFFGD F) --�Ǳ���
     AND V_ENDDATE <= NVL(T.ENDDATE, DATE '9999-12-30')
     AND V_ENDDATE > T.STARTDATE
     AND T.LEFTMONEY > 0;
  --���±���
  UPDATE HR_BUSCOSTGD T
     SET T.LEFTMONEY = 0, T.ISDEVIDED = '1'
   WHERE T.BUSID IN (SELECT BUSID
                       FROM BM_BUSOFFGD F
                      WHERE F.OFFDATE > V_STARTDATE
                        AND F.OFFDATE <= V_ENDDATE) --����
     AND T.LEFTMONEY > 0
     AND T.VERIFYSTATUS = '1'; --�����
  --δ���ϵ��½���
  UPDATE HR_BUSCOSTGD T
     SET T.LEFTMONEY = 0, T.ISDEVIDED = '1'
   WHERE T.BUSID NOT IN (SELECT BUSID FROM BM_BUSOFFGD F) --�Ǳ���
     AND V_ENDDATE >= NVL(T.ENDDATE, DATE '9999-12-30')
     AND V_STARTDATE < T.ENDDATE
     AND T.LEFTMONEY > 0
     AND T.VERIFYSTATUS = '1'; --�����
  COMMIT;
END;
/

prompt
prompt Creating procedure P_COSTSHARE_KM
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_COSTSHARE_KM(p_sumcostshare in number, --��̯�ܽ��
                                           p_stockbillid  in char --��ⵥID
                                           ) as
  /************************************************************************************************
    ��ⵥ���÷�̯���˹��̹�WEB������ã�������  ������ 2013-09-10
  ************************************************************************************************/
  v_totalsum              number(14, 6);
  v_costshareprice        number(14, 6);
  v_matercostshare        number(14, 6);
  v_totalcost             number(14, 6) := 0;
  v_matertotalcost        number(14, 6);
  v_laststockbillid       varchar2(20);
  v_sign                  number(14, 2);
  v_costsharenostrcurrval varchar2(20);
  v_costsharenocurrval    number(5);

begin
  --��Ÿ�ʽyyyyMMdd + XXXX
  --��ȡ�ϴεķ�̯���
  select decode(max(to_number(t.costshareno)),
                '',
                '0',
                SUBSTR(max(t.costshareno), 9, 4))
    into v_costsharenostrcurrval
    from mm_stockbillgd t
   where t.costshareno like '%' || to_char(sysdate, 'yyyyMMdd') || '%';
  --������λ��װ��Ϊnumber
  v_costsharenocurrval := to_number(v_costsharenostrcurrval);

  if v_costsharenocurrval < 9 then
    v_costsharenostrcurrval := to_char(sysdate, 'yyyyMMdd') || '000' ||
                               to_char(v_costsharenocurrval + 1);
  else
    if v_costsharenocurrval < 99 then
      v_costsharenostrcurrval := to_char(sysdate, 'yyyyMMdd') || '00' ||
                                 to_char(v_costsharenocurrval + 1);
    else
      if v_costsharenocurrval < 999 then
        v_costsharenostrcurrval := to_char(sysdate, 'yyyyMMdd') || '0' ||
                                   to_char(v_costsharenocurrval + 1);
      else
        v_costsharenostrcurrval := to_char(sysdate, 'yyyyMMdd') ||
                                   to_char(v_costsharenocurrval + 1);
      end if;
    end if;
  end if;
  --���½��׵���
  update mm_stockbillgd t
     set t.costshareno    = v_costsharenostrcurrval,
         t.costshareprice = p_sumcostshare
   where t.stockbillid in
         (select s.stockbillid
            from mm_stockbillgd s
           where instr(p_stockbillid, s.stockbillid) > 0);
  commit;
  --��ȡ��ⵥ�ܽ��
  select sum(d.totalsum)
    into v_totalsum
    from mm_stockbillgd s, mm_stockbilldetailgd d
   where s.stockbillid = d.stockbillid
     and s.stockbillid in
         (select s.stockbillid
            from mm_stockbillgd s
           where instr(p_stockbillid, s.stockbillid) > 0);
  --��ȡ��ⵥ�������ܽ��
  for cur_mater in (select d.materialid,
                           sum(d.totalsum) matertotalsum,
                           sum(d.count) matercount
                      from mm_stockbillgd s, mm_stockbilldetailgd d
                     where s.stockbillid = d.stockbillid
                       and s.stockbillid in
                           (select s.stockbillid
                              from mm_stockbillgd s
                             where instr(p_stockbillid, s.stockbillid) > 0)
                     group by d.materialid) loop
    --���ʷ�̯���ܽ��
    v_matercostshare := round(p_sumcostshare * cur_mater.matertotalsum /
                              v_totalsum,
                              2);
    --�������ʷ�̯�ĵ���
    v_costshareprice := round(v_matercostshare / cur_mater.matercount, 2);
    v_totalcost      := v_totalcost + v_matercostshare;
    v_matertotalcost := 0;
    -- ��ȡ��ⵥ�ļ۸�������Ϣ
    for cur_stock in (select d.stockbilldetailid,
                             d.materialid,
                             d.batchno,
                             d.price,
                             d.count,
                             d.totalsum
                        from mm_stockbillgd s, mm_stockbilldetailgd d
                       where s.stockbillid in
                             (select s.stockbillid
                                from mm_stockbillgd s
                               where instr(p_stockbillid, s.stockbillid) > 0)
                         and d.materialid = cur_mater.materialid
                         and s.stockbillid = d.stockbillid) loop
      --ͳ�Ʒ�̯������ⵥ�Ľ��֮��
      v_matertotalcost := v_matertotalcost +
                          v_costshareprice * cur_stock.count;
      --��¼��ǰѭ���Ľ��׵���ϸID
      v_laststockbillid := cur_stock.stockbilldetailid;
      --���½��׵���ϸ�еĵ��ۼ��ܽ�����֮ǰ�ĵ��ۼ��ܽ��
      update mm_stockbilldetailgd t
         set t.price       = t.price + v_costshareprice,
             t.totalsum    = t.totalsum + v_costshareprice * cur_stock.count,
             t.oldprice    = t.price,
             t.oldtotalsum = t.totalsum
       where t.stockbilldetailid = cur_stock.stockbilldetailid;
      --��ʱ�����еĵ��ۼ��ܽ��
      update mm_realtimestockgd t
         set t.price    = t.price + v_costshareprice,
             t.totalsum = t.totalsum + v_costshareprice * cur_stock.count
       where t.materialid = cur_stock.materialid
         and t.batchno = cur_stock.batchno;
      commit;
    end loop;
    --����(����)��̯�ܽ�����̯������ⵥ�����ʣ��Ľ��֮�͵Ĳ�ֵ
    v_sign := v_matercostshare - v_matertotalcost;
    --�����ֵ��Ϊ0������ֵ���µ����һ�����׵���ϸ��
    if v_sign != 0 then
      update mm_stockbilldetailgd t
         set t.totalsum = t.totalsum + v_sign
       where t.stockbilldetailid = v_laststockbillid;
      commit;
    end if;
  end loop;
  --�����̯�ܽ�����̯������ⵥ�Ľ��֮�͵Ĳ�ֵ
  v_sign := p_sumcostshare - v_totalcost;
  --�����ֵ��Ϊ0������ֵ���µ����һ�����׵���ϸ��
  if v_sign != 0 then
    update mm_stockbilldetailgd t
       set t.totalsum = t.totalsum + v_sign
     where t.stockbilldetailid = v_laststockbillid;
    commit;
  end if;
  --���½��׵���״̬
  update mm_stockbillgd t
     set t.iscostshare = '1'
   where t.stockbillid in
         (select s.stockbillid
            from mm_stockbillgd s
           where instr(p_stockbillid, s.stockbillid) > 0);
  commit;
end;
/

prompt
prompt Creating procedure P_COST_BUS_DATA_RESULT
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_COST_BUS_DATA_RESULT IS
  /*****************************************************************************
   ���ƣ�P_COST_BUS_DATA_RESULT
   ��;������������ʱ�洢����
   ˵���� Hunter
   CREATE��  20151228
  *****************************************************************************/
  V_MONTH    varchar2(20);
  V_MONTHDAY DATE := to_date(V_MONTH, 'yyyy-mm');
  S_ID       NUMBER := 0;
  --V_SERVICEAGE_SALARY_STD number := 12;
BEGIN

  SELECT S_PROCEDURELOGIDSEQ.NEXTVAL INTO S_ID FROM DUAL;
  INSERT INTO MCPROCEDURELOGLD
    (LOGID,
     PROCEDURENAME,
     EXECSTARTTIME,
     EXECENDTIME,
     ISFINISH,
     PROGRESS,
     MEMOS)
  VALUES
    (S_ID,
     'PKG_PZH_CALC_BUS_COST.P_COST_BUS_DATA_RESULT',
     SYSDATE,
     '',
     '0',
     '��ʼ����',
     V_MONTH || '��������̼��㡿�ѿ�ʼ���㣬���Ժ������鿴�Ƿ����');
  commit;
  -- ��ȡ��׼
  DELETE FROM PZH_OM_BUS_COSTDATATMP where month = V_MONTH;
  COMMIT;
  --1 ���
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.milenum)
    select r.orgid,r.routeid, r.busid, r.month, r.milenum
      from PZH_OM_BUS_RUNDATA r
     where r.month = V_MONTH;
  COMMIT;
  --2����
  --
  --�������
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.ADMINEXPENSES)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_ADMINEXPENSESDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --�������
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.FINANCEEXPENSE)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_FINANCEEXPENSEDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --Ͷ������
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.INVESTMENTINCOME)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_NETNONOPTINCOMEDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --Ӫҵ����֧����
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.NETNONOPTINCOME)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_OTHBUSINESSPROFITSDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --����Ӫ��ҵ���
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.OTHEROPTEXPENSES)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_OTHEROPTEXPENSESDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --�¹���������
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.ACCIDENTOTHERCOST)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_ACCIDENTOTHERCOSTDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --�����۾ɷ�
  insert into PZH_OM_BUS_COSTDATATMP t
    (t.orgid,t.routeid, t.busid, t.month, t.DEPCHARGE)
    select r.orgid,r.routeid, r.busid, V_MONTH, SUM(r.fee)
      from HR_DEPCHARGEDETAILGD r
     where r.RECmonth = V_MONTHDAY
     GROUP BY r.orgid,r.routeid, r.busid;
  COMMIT;
  --
  ---��������
  DELETE FROM PZH_OM_BUS_COSTDATA where month = V_MONTH;
  COMMIT;
  insert into PZH_OM_BUS_COSTDATA t
    (t.orgid,t.routeid,
     t.busid,
     t.month,
     t.milenum,
     t.ADMINEXPENSES, --�������
     t.FINANCEEXPENSE, --�������
     t.INVESTMENTINCOME, --Ͷ������
     t.NETNONOPTINCOME, --Ӫҵ����֧����
     t.OTHBUSINESSPROFIT, --����ҵ������
     t.OTHEROPTEXPENSES, --����Ӫ��ҵ���
     t.ACCIDENTOTHERCOST, --�¹���������
     t.DEPCHARGE --�����۾ɷ�
     )
    select tmp.orgid,routeid,
           tmp.busid,
           tmp.month,
           sum(tmp.milenum),
           sum(tmp.ADMINEXPENSES), --�������
           sum(tmp.FINANCEEXPENSE), --�������
           sum(tmp.INVESTMENTINCOME), --Ͷ������
           sum(tmp.NETNONOPTINCOME), --Ӫҵ����֧����
           sum(tmp.OTHBUSINESSPROFIT), --����ҵ������
           sum(tmp.OTHEROPTEXPENSES), --����Ӫ��ҵ���
           sum(tmp.ACCIDENTOTHERCOST), --�¹���������
           sum(tmp.DEPCHARGE) --�����۾ɷ�
      from PZH_OM_BUS_COSTDATATMP tmp
     where month = V_MONTH
     group by tmp.orgid,routeid, tmp.busid, tmp.month;
  commit;
  --
  --���±�̨
  UPDATE PZH_OM_BUS_COSTDATA A
     SET A.STANDARDUNITS = (SELECT NVL(STANDARDUNITS, 1)
                              FROM MCBUSTYPEINFOGS T, MCBUSINFOGS B
                             WHERE T.BUSTYPEID = B.BUSTID
                               AND B.BUSID = A.BUSID)
   WHERE A.MONTH = V_MONTH;
  COMMIT;
  update MCPROCEDURELOGLD a
     set EXECENDTIME = sysdate,
         ISFINISH    = '1',
         PROGRESS    = '�ѽ���',
         MEMOS       = V_MONTH || '��������̼��㡿�Ѽ�����ɡ�'
   where LOGID = S_ID;
  commit;
exception
  WHEN OTHERS THEN
    update MCPROCEDURELOGLD a
       set EXECENDTIME = sysdate,
           ISFINISH    = '1',
           PROGRESS    = '�쳣�˳�',
           MEMOS       = V_MONTH || '��������̼��㡿��������г����쳣�����Ų����ݻ���ϵϵͳ����Ա����'
     where LOGID = S_ID;
    commit;
END P_COST_BUS_DATA_RESULT;
--
/

prompt
prompt Creating procedure P_DAY_STATMENT_KM
prompt ====================================
prompt
create or replace procedure aptspzh.P_DAY_STATMENT_KM IS
  V_FDISBUSRUNREC_COUNT NUMBER := 0;
BEGIN
  SELECT COUNT(1) INTO V_FDISBUSRUNREC_COUNT FROM ASGNRBUSROUTELD;
  IF V_FDISBUSRUNREC_COUNT > 0 THEN
    BEGIN
      DELETE OM_DS_ASGNRBUSROUTEGD T
       WHERE TRUNC(T.DSDAY) = TRUNC(SYSDATE) - 1;
      insert into OM_DS_ASGNRBUSROUTEGD
        (RBUSRID, BUSID, ROUTEID, RECDATE, TASKTYPE, DSDAY)
        select DAY_STATMENT_KM.nextval, t.*
          from (select BUSID, ROUTEID, RECDATE, TASKTYPE, TRUNC(SYSDATE) - 1
                  from ASGNRBUSROUTELD) t;
      COMMIT;
     END;
  END IF;
END P_DAY_STATMENT_KM;
/

prompt
prompt Creating procedure P_DEFPLAN_ROUTE
prompt ==================================
prompt
create or replace procedure aptspzh.P_DEFPLAN_ROUTE is
  /***************************************************
  ���ƣ�P_DEFPLAN_ROUTE
  ��;����������������������������·��ʵ������(��ά���һ����һά�������)
  ��д��    ����    20110712
  �޸ģ�
  ***************************************************/
  V_ROUTEID        NUMBER; -- ��·ID
  V_FIRSTDATE      DATE; -- ָ���µ�һ��
  V_LASTDATE       DATE; -- ָ�������һ��
  V_WORKDATE       DATE; -- ��������
  V_MIDDATE        DATE; -- �м䴦������
  V_JUDGECOUNT     NUMBER := 0; -- �ж�������
  V_JUDGECOUNT2    NUMBER := 0; -- �ж�������
  V_BUSDEFASSID    VARCHAR2(20); -- ������������
  V_MIDBUSDEFASSID VARCHAR2(20); -- �м䱣����������
  V_FIRBUSDEFASSID VARCHAR2(20); -- һά������������
  V_BUSID          VARCHAR2(20); -- ��������ID
  V_WORKSHOPID     VARCHAR2(20); -- ά������ID
  V_SECDEFDATE     DATE; -- ��ά��������
  V_FIRDEFDATE     DATE; -- һά��������
  V_DAYMILE        NUMBER(8, 3); -- �վ����
  V_PERADDDAY      NUMBER := 1; -- �����ۼ�ֵ
  V_JUDGEFLG       VARCHAR2(2); --�жϱ�־λ
  TYPE T_CURSOR IS REF CURSOR;
  CUR_DEFINFO T_CURSOR; -- ������Ϣ
  CUR_TWODEF  T_CURSOR; -- ��һ�������α�����Ϣ

BEGIN
  -- ���µ�һ������һ��
  SELECT TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH'),
                         'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- ��ʼ������
  V_WORKDATE := V_FIRSTDATE;
  -- �����ά����
  WHILE V_WORKDATE <= V_LASTDATE LOOP
    -- ��ѯĳ��Ķ�ά��·�ظ�������Ϣ
    -- ���α�
    OPEN CUR_DEFINFO FOR
      SELECT DEFINFO.BUSDEFASSID, DEFINFO.ROUTEID, DEFINFO.WORKSHOPID
        FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM,
                     TEM.BUSDEFASSID,
                     TEM.ROUTEID,
                     TEM.WORKSHOPID
                FROM BM_TEMBUSDEFASS TEM
               WHERE TEM.DEFENDTYPE = '2'
                 AND TEM.ROUTEID IS NOT NULL
                 AND TEM.DEFPLANDATE = V_WORKDATE) DEFINFO
       WHERE DEFINFO.DEFNUM > 1;
    LOOP
      FETCH CUR_DEFINFO
        INTO V_BUSDEFASSID, V_ROUTEID, V_WORKSHOPID;
      -- û������ʱ�˳�
      EXIT WHEN CUR_DEFINFO%NOTFOUND;
      -- �ж��ظ������Ƿ��ǵ�һ��
      IF V_WORKDATE = V_LASTDATE THEN
        V_MIDDATE := V_FIRSTDATE + 20;
      ELSE
        -- ���м����ڸ�ֵ
        V_MIDDATE := V_WORKDATE + 1;
      END IF;
      -- �����ۼ�ֵ��ʼ��
      V_PERADDDAY := 1;
      -- �����ά����
      WHILE V_MIDDATE < V_LASTDATE + 1 LOOP
        -- �ж��ظ������Ƿ������һ��
        IF V_MIDDATE > V_LASTDATE THEN
          -- ���¸�ֵΪ��һ��
          V_PERADDDAY := -1;
          V_MIDDATE   := V_LASTDATE - 1;
        END IF;
        -- �жϵ����ά����֪�񳬳�
        SELECT CASE
                 WHEN T1.SECCOUNT > CEIL(AVGSEC.SECDEFAVG) THEN
                  '0'
                 ELSE
                  '1'
               END JUDGEFLG
          INTO V_JUDGEFLG
          FROM (SELECT COUNT(1) SECCOUNT
                  FROM BM_TEMBUSDEFASS TEM
                 WHERE TEM.DEFENDTYPE = '2'
                   AND TEM.DEFPLANDATE = V_MIDDATE
                   AND TEM.WORKSHOPID = V_WORKSHOPID) T1,
               (SELECT DISTINCT RMAINWARE.SECDEFAVG
                  FROM BM_RMAINTAINWAREORGGD RMAINWARE
                 WHERE RMAINWARE.MAINTAINORGID = V_WORKSHOPID) AVGSEC;

        -- �ж��Ƿ�����(ȫ��)
        SELECT COUNT(1) JUDGECOUNT
          INTO V_JUDGECOUNT
          FROM BM_WORKCAPACITYGD WORKDATEINFO
         WHERE WORKDATEINFO.RESTDATE = V_MIDDATE
           AND WORKDATEINFO.WORKSHOPID = V_WORKSHOPID
           AND WORKDATEINFO.MIDDAY = '1';

        -- �жϴ���
        IF V_JUDGEFLG = '1' AND V_JUDGECOUNT = 0 THEN

          -- �жϵ����Ƿ���ͬ����·�Ķ�ά����
          SELECT COUNT(1) JUDGECOUNT
            INTO V_JUDGECOUNT
            FROM BM_TEMBUSDEFASS TEM
           WHERE TEM.DEFENDTYPE = '2'
             AND TEM.DEFPLANDATE = V_MIDDATE
             AND TEM.ROUTEID IS NOT NULL
             AND TEM.ROUTEID != V_ROUTEID;

          -- �ж��Ƿ�������
          IF V_JUDGECOUNT > 0 THEN
            -- ��ѯ���첻ͬ�ڴ������ڵ���·��Ϣ
            SELECT COUNT(1) JUDGECOUNT
              INTO V_JUDGECOUNT
              FROM BM_TEMBUSDEFASS TEM
             WHERE TEM.DEFENDTYPE = '2'
               AND TEM.ROUTEID IS NOT NULL
               AND TEM.DEFPLANDATE = V_MIDDATE
               AND TEM.ROUTEID NOT IN
                   (SELECT DISTINCT TEM.ROUTEID
                      FROM BM_TEMBUSDEFASS TEM
                     WHERE 1 = 1
                       AND TEM.DEFENDTYPE = '2'
                       AND TEM.ROUTEID IS NOT NULL
                       AND TEM.DEFPLANDATE = V_WORKDATE);
            -- �ж��Ƿ�������
            IF V_JUDGECOUNT > 0 THEN
              SELECT TEM.BUSDEFASSID
                INTO V_MIDBUSDEFASSID
                FROM BM_TEMBUSDEFASS TEM
               WHERE TEM.DEFENDTYPE = '2'
                 AND TEM.ROUTEID IS NOT NULL
                 AND TEM.DEFPLANDATE = V_MIDDATE
                 AND TEM.ROUTEID NOT IN
                     (SELECT DISTINCT TEM.ROUTEID
                        FROM BM_TEMBUSDEFASS TEM
                       WHERE 1 = 1
                         AND TEM.DEFENDTYPE = '2'
                         AND TEM.ROUTEID IS NOT NULL
                         AND TEM.DEFPLANDATE = V_WORKDATE)
                 AND ROWNUM = 1;
              -- ������������
              -- 1�����ظ������ݵ���������
              UPDATE BM_TEMBUSDEFASS TEM
                 SET TEM.DEFPLANDATE = V_MIDDATE, TEM.DEFDATE = V_MIDDATE
               WHERE TEM.BUSDEFASSID = V_BUSDEFASSID;
              --2: ����������ݵ�������·�ظ�������
              UPDATE BM_TEMBUSDEFASS TEM
                 SET TEM.DEFPLANDATE = V_WORKDATE, TEM.DEFDATE = V_WORKDATE
               WHERE TEM.BUSDEFASSID = V_MIDBUSDEFASSID;
              -- �ύ
              COMMIT;
              -- �м�����=������ڣ�������
              V_MIDDATE := V_LASTDATE + 1;
            ELSE
              -- ���м����ڸ�ֵ
              V_MIDDATE := V_MIDDATE + V_PERADDDAY;
            END IF;
          ELSE
            -- ���м����ڸ�ֵ
            V_MIDDATE := V_MIDDATE + V_PERADDDAY;
          END IF;
        ELSE
          -- ���м����ڸ�ֵ
          V_MIDDATE := V_MIDDATE + V_PERADDDAY;
        END IF;
      END LOOP;
    END LOOP;
    CLOSE CUR_DEFINFO;
    -- �������ۼ�
    V_WORKDATE := V_WORKDATE + 1;
  END LOOP;

  -- ��ʼ������
  V_WORKDATE := V_FIRSTDATE;

  -- ����һά����
  WHILE V_WORKDATE <= V_LASTDATE LOOP
    -- ��ѯĳ���һά��·�ظ�������Ϣ��һά����2�Σ��͵�����·�Ѿ��ж�ά����
    -- ���α�
    OPEN CUR_DEFINFO FOR
      SELECT DEFINFO.BUSDEFASSID, DEFINFO.ROUTEID
        FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM,
                     TEM.BUSDEFASSID,
                     TEM.ROUTEID
                FROM BM_TEMBUSDEFASS TEM
               WHERE 1 = 1
                 AND TEM.DEFENDTYPE = '1'
                 AND TEM.ROUTEID IS NOT NULL
                 AND TEM.DEFPLANDATE = V_WORKDATE) DEFINFO
       WHERE DEFINFO.DEFNUM > 2
      UNION
      SELECT TEM.BUSDEFASSID, TEM.ROUTEID
        FROM BM_TEMBUSDEFASS TEM
       WHERE 1 = 1
         AND TEM.DEFENDTYPE = '1'
         AND TEM.ROUTEID IS NOT NULL
         AND TEM.DEFPLANDATE = V_WORKDATE
         AND TEM.ROUTEID IN
             (SELECT TEM.ROUTEID
                FROM BM_TEMBUSDEFASS TEM
               WHERE TEM.DEFENDTYPE = '2'
                 AND TEM.ROUTEID IS NOT NULL
                 AND TEM.DEFPLANDATE = V_WORKDATE);
    LOOP
      FETCH CUR_DEFINFO
        INTO V_BUSDEFASSID, V_ROUTEID;
      -- û������ʱ�˳�
      EXIT WHEN CUR_DEFINFO%NOTFOUND;
      -- �ж��ظ������Ƿ��ǵ�һ��
      IF V_WORKDATE = V_LASTDATE THEN
        V_MIDDATE := V_FIRSTDATE + 15;
      ELSE
        -- ���м����ڸ�ֵ
        V_MIDDATE := V_WORKDATE + 1;
      END IF;
      V_PERADDDAY := 1;
      -- ����һά����
      WHILE V_MIDDATE < V_LASTDATE + 1 LOOP
        -- �ж��ظ������Ƿ������һ��
        IF V_MIDDATE > V_LASTDATE THEN
          V_PERADDDAY := -1;
          -- ���¸�ֵΪ��һ��
          V_MIDDATE := V_FIRSTDATE;
        END IF;

        -- �жϵ����ά����֪�񳬳�
        SELECT CASE
                 WHEN T1.FIRCOUNT > CEIL(AVGFIR.FIRDEFAVG) THEN
                  '0'
                 ELSE
                  '1'
               END JUDGEFLG
          INTO V_JUDGEFLG
          FROM (SELECT COUNT(1) FIRCOUNT
                  FROM BM_TEMBUSDEFASS TEM
                 WHERE 1 = 1
                   AND TEM.DEFENDTYPE = '1'
                   AND TEM.DEFPLANDATE = V_MIDDATE
                   AND TEM.WORKSHOPID = V_WORKSHOPID) T1,
               (SELECT DISTINCT RMAINWARE.FIRDEFAVG
                  FROM BM_RMAINTAINWAREORGGD RMAINWARE
                 WHERE RMAINWARE.MAINTAINORGID = V_WORKSHOPID) AVGFIR;
        -- �ж��Ƿ�����(ȫ��)
        SELECT COUNT(1) JUDGECOUNT
          INTO V_JUDGECOUNT
          FROM BM_WORKCAPACITYGD WORKDATEINFO
         WHERE WORKDATEINFO.RESTDATE = V_MIDDATE
           AND WORKDATEINFO.WORKSHOPID = V_WORKSHOPID
           AND WORKDATEINFO.MIDDAY = '1';
        -- �жϴ���
        IF V_JUDGEFLG = '1' AND V_JUDGECOUNT <= 0 THEN
          -- ������ͬ����·�Ķ�ά������Ŀ
          SELECT COUNT(1) JUDGECOUNT
            INTO V_JUDGECOUNT
            FROM BM_TEMBUSDEFASS TEM
           WHERE 1 = 1
             AND TEM.DEFENDTYPE = '2'
             AND TEM.ROUTEID IS NOT NULL
             AND TEM.DEFPLANDATE = V_MIDDATE
             AND TEM.ROUTEID = V_ROUTEID;
          -- ����ͬ����·����2����·
          SELECT COUNT(1) JUDGECOUNT
            INTO V_JUDGECOUNT2
            FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM
                    FROM BM_TEMBUSDEFASS TEM
                   WHERE 1 = 1
                     AND TEM.DEFENDTYPE = '1'
                     AND TEM.ROUTEID IS NOT NULL
                     AND TEM.DEFPLANDATE = V_MIDDATE
                     AND TEM.ROUTEID = V_ROUTEID) DEFINFO
           WHERE 1 = 1
             AND DEFINFO.DEFNUM >= 2;

          -- �ж��Ƿ�������
          IF V_JUDGECOUNT = 0 AND V_JUDGECOUNT2 = 0 THEN
            -- ��ѯ���첻ͬ�ڴ������ڵ���·��Ϣ
            SELECT COUNT(1) JUDGECOUNT
              INTO V_JUDGECOUNT
              FROM (SELECT AAA.ROUTEID, MAX(AAA.DEFNUM) DEFNUM
                      FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM,
                                   TEM.BUSDEFASSID,
                                   TEM.ROUTEID
                              FROM BM_TEMBUSDEFASS TEM
                             WHERE 1 = 1
                               AND TEM.DEFENDTYPE = '1'
                               AND TEM.ROUTEID IS NOT NULL
                               AND TEM.DEFPLANDATE = V_WORKDATE
                               AND TEM.ROUTEID IN
                                   (SELECT DISTINCT TEM.ROUTEID
                                      FROM BM_TEMBUSDEFASS TEM
                                     WHERE 1 = 1
                                       AND TEM.DEFENDTYPE = '1'
                                       AND TEM.ROUTEID IS NOT NULL
                                       AND TEM.DEFPLANDATE = V_MIDDATE
                                       AND TEM.ROUTEID != V_ROUTEID)) AAA
                     GROUP BY AAA.ROUTEID) DEFINFO
             WHERE 1 = 1
               AND DEFINFO.DEFNUM < 2;
            -- ��ѯ�������ڵĶ�ά����
            SELECT COUNT(1) JUDGECOUNT
              INTO V_JUDGECOUNT2
              FROM BM_TEMBUSDEFASS TEM
             WHERE 1 = 1
               AND TEM.DEFENDTYPE = '2'
               AND TEM.ROUTEID IS NOT NULL
               AND TEM.DEFPLANDATE = V_WORKDATE
               AND TEM.ROUTEID IN
                   (SELECT DISTINCT TEM.ROUTEID
                      FROM BM_TEMBUSDEFASS TEM
                     WHERE 1 = 1
                       AND TEM.DEFENDTYPE = '1'
                       AND TEM.ROUTEID IS NOT NULL
                       AND TEM.DEFPLANDATE = V_MIDDATE
                       AND TEM.ROUTEID != V_ROUTEID);
            -- �ж��Ƿ�������
            IF V_JUDGECOUNT2 > 0 AND V_JUDGECOUNT > 0 THEN
              SELECT COUNT(1) JUDGECOUNT
                INTO V_JUDGECOUNT
                FROM BM_TEMBUSDEFASS TEM
               WHERE 1 = 1
                 AND TEM.DEFENDTYPE = '1'
                 AND TEM.ROUTEID IS NOT NULL
                 AND TEM.DEFPLANDATE = V_MIDDATE
                 AND TEM.ROUTEID NOT IN
                     (SELECT DISTINCT AAA.ROUTEID
                        FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM,
                                     TEM.ROUTEID
                                FROM BM_TEMBUSDEFASS TEM
                               WHERE 1 = 1
                                 AND TEM.DEFENDTYPE = '1'
                                 AND TEM.ROUTEID IS NOT NULL
                                 AND TEM.DEFPLANDATE = V_WORKDATE) AAA
                       WHERE 1 = 1
                         AND AAA.DEFNUM >= 2
                      UNION
                      SELECT DISTINCT TEM.ROUTEID
                        FROM BM_TEMBUSDEFASS TEM
                       WHERE 1 = 1
                         AND TEM.DEFENDTYPE = '2'
                         AND TEM.ROUTEID IS NOT NULL
                         AND TEM.DEFPLANDATE = V_WORKDATE)
                 AND ROWNUM < 2;

              IF V_JUDGECOUNT > 0 THEN
                SELECT TEM.BUSDEFASSID
                  INTO V_MIDBUSDEFASSID
                  FROM BM_TEMBUSDEFASS TEM
                 WHERE 1 = 1
                   AND TEM.DEFENDTYPE = '1'
                   AND TEM.ROUTEID IS NOT NULL
                   AND TEM.DEFPLANDATE = V_MIDDATE
                   AND TEM.ROUTEID NOT IN
                       (SELECT DISTINCT AAA.ROUTEID
                          FROM (SELECT RANK() OVER(PARTITION BY TEM.ROUTEID ORDER BY TEM.BUSDEFASSID DESC) DEFNUM,
                                       TEM.ROUTEID
                                  FROM BM_TEMBUSDEFASS TEM
                                 WHERE 1 = 1
                                   AND TEM.DEFENDTYPE = '1'
                                   AND TEM.ROUTEID IS NOT NULL
                                   AND TEM.DEFPLANDATE = V_WORKDATE) AAA
                         WHERE 1 = 1
                           AND AAA.DEFNUM >= 2
                        UNION
                        SELECT DISTINCT TEM.ROUTEID
                          FROM BM_TEMBUSDEFASS TEM
                         WHERE 1 = 1
                           AND TEM.DEFENDTYPE = '2'
                           AND TEM.ROUTEID IS NOT NULL
                           AND TEM.DEFPLANDATE = V_WORKDATE)
                   AND ROWNUM < 2;
                -- ������������
                -- 1�����ظ������ݵ���������
                UPDATE BM_TEMBUSDEFASS TEM
                   SET TEM.DEFPLANDATE = V_MIDDATE, TEM.DEFDATE = V_MIDDATE
                 WHERE TEM.BUSDEFASSID = V_BUSDEFASSID;

                --2: ����������ݵ�������·�ظ�������
                UPDATE BM_TEMBUSDEFASS TEM
                   SET TEM.DEFPLANDATE = V_WORKDATE,
                       TEM.DEFDATE     = V_WORKDATE
                 WHERE TEM.BUSDEFASSID = V_MIDBUSDEFASSID;
                -- �ύ
                COMMIT;
              END IF;
              -- �м�����=������ڣ�������
              V_MIDDATE := V_LASTDATE + 1;
            ELSE
              -- ���м����ڸ�ֵ
              V_MIDDATE := V_MIDDATE + V_PERADDDAY;
            END IF;
          ELSE
            -- ���м����ڸ�ֵ
            V_MIDDATE := V_MIDDATE + V_PERADDDAY;
          END IF;
        ELSE
          -- ���м����ڸ�ֵ
          V_MIDDATE := V_MIDDATE + V_PERADDDAY;
        END IF;
      END LOOP;
    END LOOP;
    CLOSE CUR_DEFINFO;
    -- �������ۼ�
    V_WORKDATE := V_WORKDATE + 1;
  END LOOP;

  -- ��ѯ����һ�������α���������
  -- ���α�
  OPEN CUR_TWODEF FOR
    SELECT TEMDEFINFO.BUSID, TEMDEFINFO.DEFPLANDATE, TEMDEFINFO.DAYMILE
      FROM BM_TEMBUSDEFASS TEMDEFINFO
     WHERE 1 = 1
       AND TEMDEFINFO.DEFPLANDATE >= V_FIRSTDATE
       AND TEMDEFINFO.DEFPLANDATE <= V_LASTDATE
       AND TEMDEFINFO.AUDITSTATUS != '3'
       AND TEMDEFINFO.BUSID IN
           (SELECT BUSID
              FROM (SELECT DEFINFO.BUSID,
                           DEFINFO.DEFPLANDATE,
                           DEFINFO.PREDEFDATE,
                           RANK() OVER(PARTITION BY DEFINFO.BUSID ORDER BY DEFINFO.DEFPLANDATE) DEFCOUNT
                      FROM BM_TEMBUSDEFASS DEFINFO
                     WHERE 1 = 1
                       AND DEFINFO.DEFPLANDATE >= V_FIRSTDATE
                       AND DEFINFO.DEFPLANDATE <= V_LASTDATE
                       AND DEFINFO.AUDITSTATUS != '3') DEFINFO
             WHERE DEFINFO.DEFCOUNT > 1)
       AND TEMDEFINFO.DEFENDTYPE = '2';
  LOOP
    FETCH CUR_TWODEF
      INTO V_BUSID, V_SECDEFDATE, V_DAYMILE;
    -- û������ʱ�˳�
    EXIT WHEN CUR_TWODEF%NOTFOUND;

    -- ��ѯһά������Ϣ
    SELECT COUNT(1) JUDGECOUNT
      INTO V_JUDGECOUNT
      FROM (SELECT TEM.BUSDEFASSID, TEM.DEFPLANDATE
              FROM BM_TEMBUSDEFASS TEM
             WHERE 1 = 1
               AND TEM.DEFENDTYPE = '1'
               AND TEM.DEFPLANDATE >= V_FIRSTDATE
               AND TEM.DEFPLANDATE <= V_LASTDATE
               AND TEM.AUDITSTATUS != '3'
               AND TEM.BUSID = V_BUSID);
    -- �ж��Ƿ�������
    IF V_JUDGECOUNT > 0 THEN
      SELECT TEM.BUSDEFASSID, TEM.DEFPLANDATE
        INTO V_FIRBUSDEFASSID, V_FIRDEFDATE
        FROM BM_TEMBUSDEFASS TEM
       WHERE 1 = 1
         AND TEM.DEFENDTYPE = '1'
         AND TEM.DEFPLANDATE >= V_FIRSTDATE
         AND TEM.DEFPLANDATE <= V_LASTDATE
         AND TEM.AUDITSTATUS != '3'
         AND TEM.BUSID = V_BUSID;
      -- �ж�һά�Ͷ�ά�;���
      IF ABS((V_SECDEFDATE - V_FIRDEFDATE) * V_DAYMILE) < 4000 THEN
        -- ɾ���ӽ���������
        DELETE FROM BM_TEMBUSDEFASS TEM
         WHERE TEM.BUSDEFASSID = V_FIRBUSDEFASSID;
      END IF;
    END IF;
  END LOOP;
  CLOSE CUR_TWODEF;

END P_DEFPLAN_ROUTE;
/

prompt
prompt Creating procedure P_DENPLAN_MODIFY
prompt ===================================
prompt
create or replace procedure aptspzh.P_DENPLAN_MODIFY is
  /***************************************************
  ���ƣ�P_DENPLAN_MODIFY
  ��;�����������������������ų�����Ϣ�պͽڼ���
                                ������ƽ����ÿ�죨ά�޳���������
  ��д��    ����    20110513
  �޸ģ�
  ***************************************************/
  V_FIRDEFTYPE_COUNT NUMBER := 0; -- ά�޳���һά����
  V_SECDEFTYPE_COUNT NUMBER := 0; -- ά�޳����ά����
  V_WORKDATE         DATE; -- ά������ʱ��
  TYPE T_CURSOR IS REF CURSOR;
  CUR_MAINWARE    T_CURSOR; -- ά�޳�����Ϣ
  CUR_DEFINFO     T_CURSOR; -- ά�޳��䱣����Ϣ
  V_MAINTAINORGID VARCHAR2(20); -- ά�޳���ID
  V_FIRSTDATE     DATE; -- ָ���µ�һ��
  V_LASTDATE      DATE; -- ָ�������һ��
  V_FIRAVGCOUNT   NUMBER(4, 1); -- һάƽ����
  V_SECAVGCOUNT   NUMBER(4, 1); -- ��άƽ����
  V_FIRMIDAVGNUM  NUMBER := 0; -- һάʵ��ÿ�칤����
  V_SECMIDAVGNUM  NUMBER := 0; -- ��άʵ��ÿ�칤����
  V_BUSDEFASSID   VARCHAR2(20);
  V_BUSID         VARCHAR2(20);
  V_DAYMILE       NUMBER(8, 3);
  V_DEFENDTYPE    VARCHAR2(20);
  V_DEFENDLEVEL   VARCHAR2(20);
  V_DEFENDPERIOD  NUMBER(12, 3);
  V_PLANDAYCOUNT  NUMBER(8);
  V_ALARMDAYCOUNT NUMBER(8);
  V_DEFAULTWARE   VARCHAR2(20);
  V_BUSTYPE       VARCHAR2(20);
  V_BUSORG        VARCHAR2(20);
  V_DEFPLANDATE   DATE;
  V_PLANFLG       CHAR(2);
  V_ALARMFLG      CHAR(2);
  V_WORKORDERTYPE VARCHAR2(20);
  V_STOPMIDDAY    NUMBER(3);
  V_JUDGEFLG      VARCHAR2(2);
  V_PREDEFDATE    DATE;
  V_DEFDATE       DATE;
  V_AUDITSTATUS   VARCHAR2(2);
  V_WORKSHOPID    VARCHAR2(20);
  V_MIDDAY        CHAR(1);
  V_WORKDAYNUM    NUMBER := 0; -- ��Ϣ������
  V_JUDGECOUNT    NUMBER := 0;
  --v_substr        VARCHAR2(150); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  V_SUMWORKDAY    NUMBER := 0; -- ������
  V_SUMRESTDAY    NUMBER := 0; -- ��Ϣ��
  V_FIRWORKDAYYET NUMBER := 0; -- һά�ѹ�����
  V_SECWORKDAYYET NUMBER := 0; -- ��ά�ѹ�����
  V_FIRDEFWORKYET NUMBER := 0; -- һά�Ѵ�������
  V_SECDEFWORKYET NUMBER := 0; -- ��ά�Ѵ�������
  V_RESTDAYNUM    NUMBER := 0; -- ��Ϣ��
  V_ROUTEID       NUMBER; -- ��·ID

BEGIN

  -- ���µ�һ������һ��
  SELECT TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH'),
                         'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- ��ѯά�޳�����Ϣ
  -- ���α�
  OPEN CUR_MAINWARE FOR
    SELECT DISTINCT MAINTAINORG.MAINTAINORGID,
                    RMAINWARE.FIRDEFAVG,
                    RMAINWARE.SECDEFAVG
      FROM BM_MAINTAINORGGD MAINTAINORG, BM_RMAINTAINWAREORGGD RMAINWARE
     WHERE MAINTAINORG.ORGKIND = '0'
       AND MAINTAINORG.MAINTAINORGID = RMAINWARE.MAINTAINORGID;
  LOOP
    FETCH CUR_MAINWARE
      INTO V_MAINTAINORGID, V_FIRAVGCOUNT, V_SECAVGCOUNT;

    EXIT WHEN CUR_MAINWARE%NOTFOUND;
    -- ��ѯ�ֹ�˾��ƽ�����͹���������һά����ά��
    SELECT CEIL(V_FIRAVGCOUNT * WORKDAYINFO.WORKDAY) FIRDEFALL,
           CEIL(V_SECAVGCOUNT * WORKDAYINFO.WORKDAY) SECDEFALL
      INTO V_FIRDEFTYPE_COUNT, V_SECDEFTYPE_COUNT
      FROM (SELECT TRUNC(V_LASTDATE - V_FIRSTDATE) - RESTDAY.RESTDCOUNT -
                   MIDRESTDAY.RESTMIDCOUNT * 0.5 WORKDAY
              FROM (SELECT COUNT(WORKREST.RESTDATE) RESTDCOUNT
                      FROM BM_WORKCAPACITYGD WORKREST
                     WHERE WORKREST.WORKSHOPID = V_MAINTAINORGID
                       AND WORKREST.MIDDAY = '1'
                       AND WORKREST.RESTDATE >= V_FIRSTDATE
                       AND WORKREST.RESTDATE <= V_LASTDATE) RESTDAY,
                   (SELECT COUNT(WORKREST.RESTDATE) RESTMIDCOUNT
                      FROM BM_WORKCAPACITYGD WORKREST
                     WHERE WORKREST.WORKSHOPID = V_MAINTAINORGID
                       AND WORKREST.MIDDAY = '0'
                       AND WORKREST.RESTDATE >= V_FIRSTDATE
                       AND WORKREST.RESTDATE <= V_LASTDATE) MIDRESTDAY
             WHERE 1 = 1) WORKDAYINFO;
    -- ɾ����ʱ���еĶ��ౣ������(һά)
    DELETE FROM BM_TEMBUSDEFASSTEST T
     WHERE 1 = 1
       AND T.BUSDEFASSID IN
           (SELECT TTT.BUSDEFASSID
              FROM (SELECT TT.BUSDEFASSID, ROWNUM ORDERNO
                      FROM (SELECT T.BUSDEFASSID
                              FROM BM_TEMBUSDEFASSTEST T
                             WHERE T.WORKSHOPID = V_MAINTAINORGID
                               AND T.DEFENDTYPE = '1'
                             ORDER BY T.DEFPLANDATE ASC) TT) TTT
             WHERE 1 = 1
               AND TTT.ORDERNO > V_FIRDEFTYPE_COUNT);
    COMMIT;
    -- ��ά
    DELETE FROM BM_TEMBUSDEFASSTEST T
     WHERE 1 = 1
       AND T.BUSDEFASSID IN
           (SELECT TTT.BUSDEFASSID
              FROM (SELECT TT.BUSDEFASSID, ROWNUM ORDERNO
                      FROM (SELECT T.BUSDEFASSID
                              FROM BM_TEMBUSDEFASSTEST T
                             WHERE 1 = 1
                               AND T.WORKSHOPID = V_MAINTAINORGID
                               AND T.DEFENDTYPE = '2'
                             ORDER BY T.DEFPLANDATE ASC) TT) TTT
             WHERE TTT.ORDERNO > V_SECDEFTYPE_COUNT);
    COMMIT;
    -- ��ѯά�޳���ָ���ڼ��ڵĹ�����
    -- �ж��Ƿ�����
    SELECT COUNT(1) JUDGECOUNT
      INTO V_JUDGECOUNT
      FROM BM_WORKCAPACITYGD T
     WHERE T.WORKSHOPID = V_MAINTAINORGID
       AND T.RESTDATE >= V_FIRSTDATE
       AND T.RESTDATE <= V_LASTDATE;
    -- ��Ϣ����0
    V_SUMRESTDAY := 0;
    -- �ж��Ƿ�������
    IF V_JUDGECOUNT > 0 THEN
      SELECT SUM(CASE T.MIDDAY
                   WHEN '0' THEN
                    0.5
                   ELSE
                    1
                 END) RESTDAY
        INTO V_SUMRESTDAY
        FROM BM_WORKCAPACITYGD T
       WHERE T.WORKSHOPID = V_MAINTAINORGID
         AND T.RESTDATE >= V_FIRSTDATE
         AND T.RESTDATE <= V_LASTDATE
       GROUP BY T.WORKSHOPID;
      -- ������
      V_SUMWORKDAY := V_LASTDATE - V_FIRSTDATE + 1 - V_SUMRESTDAY;
    ELSE
      -- ������
      V_SUMWORKDAY := V_LASTDATE - V_FIRSTDATE + 1;
    END IF;
    -- ��ѯ���е�����
    -- ������
    V_WORKDATE      := V_FIRSTDATE;
    V_FIRMIDAVGNUM  := V_FIRAVGCOUNT;
    V_SECMIDAVGNUM  := V_SECAVGCOUNT;
    V_FIRWORKDAYYET := 0;
    V_FIRDEFWORKYET := 0;
    V_SECWORKDAYYET := 0;
    V_SECDEFWORKYET := 0;

    -- ����һά����
    WHILE V_WORKDATE <= V_LASTDATE LOOP
      -- ��Ϣ��ֵ��0
      V_RESTDAYNUM := 0;
      -- �ж��Ƿ�����
      SELECT COUNT(1) JUDGECOUNT
        INTO V_JUDGECOUNT
        FROM BM_WORKCAPACITYGD WORKDATEINFO
       WHERE WORKDATEINFO.RESTDATE = V_WORKDATE
         AND WORKDATEINFO.WORKSHOPID = V_MAINTAINORGID;
      -- �ж��Ƿ�������
      IF V_JUDGECOUNT > 0 THEN
        SELECT WORKDATEINFO.MIDDAY, COUNT(1) WORKDAYNUM
          INTO V_MIDDAY, V_WORKDAYNUM
          FROM BM_WORKCAPACITYGD WORKDATEINFO
         WHERE WORKDATEINFO.RESTDATE = V_WORKDATE
           AND WORKDATEINFO.WORKSHOPID = V_MAINTAINORGID
         GROUP BY WORKDATEINFO.MIDDAY;
        -- �ж��Ƿ������
        IF V_MIDDAY = '0' THEN
          V_FIRMIDAVGNUM := ROUND(V_FIRAVGCOUNT / 2);
          V_SECMIDAVGNUM := ROUND(V_SECAVGCOUNT / 2);
          -- �����ռӰ���
          V_RESTDAYNUM := 0.5;
        ELSE
          V_FIRMIDAVGNUM := 0;
          V_SECMIDAVGNUM := 0;
        END IF;
      ELSE
        V_FIRMIDAVGNUM := V_FIRAVGCOUNT;
        V_SECMIDAVGNUM := V_SECAVGCOUNT;
        -- �����ռ�һ��
        V_RESTDAYNUM := 1;
      END IF;
      -- ����Ϣ��
      IF V_FIRMIDAVGNUM > 0 OR V_SECMIDAVGNUM > 0 THEN
        -- ���α�
        OPEN CUR_DEFINFO FOR
          SELECT *
            FROM (SELECT ASSTEST.BUSDEFASSID,
                         ASSTEST.BUSID,
                         ASSTEST.DAYMILE,
                         ASSTEST.DEFENDTYPE,
                         ASSTEST.DEFENDLEVEL,
                         ASSTEST.DEFENDPERIOD,
                         ASSTEST.PLANDAYCOUNT,
                         ASSTEST.ALARMDAYCOUNT,
                         ASSTEST.DEFAULTWARE,
                         ASSTEST.BUSTYPE,
                         ASSTEST.BUSORG,
                         ASSTEST.DEFPLANDATE,
                         ASSTEST.PLANFLG,
                         ASSTEST.ALARMFLG,
                         ASSTEST.WORKORDERTYPE,
                         ASSTEST.STOPMIDDAY,
                         ASSTEST.JUDGEFLG,
                         ASSTEST.PREDEFDATE,
                         ASSTEST.DEFDATE,
                         ASSTEST.AUDITSTATUS,
                         ASSTEST.WORKSHOPID,
                         RBUSROUTE.ROUTEID
                    FROM BM_TEMBUSDEFASSTEST ASSTEST,
                         ASGNRBUSROUTELD     RBUSROUTE
                   WHERE ASSTEST.WORKSHOPID = V_MAINTAINORGID
                     AND ASSTEST.DEFENDTYPE = '1'
                     AND ASSTEST.BUSID = RBUSROUTE.BUSID(+)
                   ORDER BY ASSTEST.DEFPLANDATE ASC) AAA
           WHERE ROWNUM <= V_FIRMIDAVGNUM;
        LOOP
          FETCH CUR_DEFINFO
            INTO V_BUSDEFASSID,
                 V_BUSID,
                 V_DAYMILE,
                 V_DEFENDTYPE,
                 V_DEFENDLEVEL,
                 V_DEFENDPERIOD,
                 V_PLANDAYCOUNT,
                 V_ALARMDAYCOUNT,
                 V_DEFAULTWARE,
                 V_BUSTYPE,
                 V_BUSORG,
                 V_DEFPLANDATE,
                 V_PLANFLG,
                 V_ALARMFLG,
                 V_WORKORDERTYPE,
                 V_STOPMIDDAY,
                 V_JUDGEFLG,
                 V_PREDEFDATE,
                 V_DEFDATE,
                 V_AUDITSTATUS,
                 V_WORKSHOPID,
                 V_ROUTEID;
          -- һά��Ϣ
          EXIT WHEN CUR_DEFINFO%NOTFOUND;

          INSERT INTO BM_TEMBUSDEFASS
            (BUSDEFASSID,
             BUSID,
             DAYMILE,
             DEFENDTYPE,
             DEFENDLEVEL,
             DEFENDPERIOD,
             PLANDAYCOUNT,
             ALARMDAYCOUNT,
             DEFAULTWARE,
             BUSTYPE,
             BUSORG,
             WORKORDERTYPE,
             STOPMIDDAY,
             DEFPLANDATE,
             PLANFLG,
             ALARMFLG,
             JUDGEFLG,
             PREDEFDATE,
             DEFDATE,
             AUDITSTATUS,
             WORKSHOPID,
             ROUTEID)
          VALUES
            (V_BUSDEFASSID,
             V_BUSID,
             V_DAYMILE,
             V_DEFENDTYPE,
             V_DEFENDLEVEL,
             V_DEFENDPERIOD,
             V_PLANDAYCOUNT,
             V_ALARMDAYCOUNT,
             V_DEFAULTWARE,
             V_BUSTYPE,
             V_BUSORG,
             V_WORKORDERTYPE,
             V_STOPMIDDAY,
             V_WORKDATE,
             V_PLANFLG,
             V_ALARMFLG,
             V_JUDGEFLG,
             V_PREDEFDATE,
             V_WORKDATE,
             V_AUDITSTATUS,
             V_WORKSHOPID,
             V_ROUTEID);
          -- ɾ����ʱ���е�����
          DELETE FROM BM_TEMBUSDEFASSTEST
           WHERE BM_TEMBUSDEFASSTEST.BUSDEFASSID = V_BUSDEFASSID;
          --�����ύ
          COMMIT;
          -- һά�����ۼ�
          V_FIRDEFWORKYET := V_FIRDEFWORKYET + 1;
        END LOOP;
        CLOSE CUR_DEFINFO;
        -- �����ά��Ϣ
        -- ���α�
        OPEN CUR_DEFINFO FOR
          SELECT *
            FROM (SELECT ASSTEST.BUSDEFASSID,
                         ASSTEST.BUSID,
                         ASSTEST.DAYMILE,
                         ASSTEST.DEFENDTYPE,
                         ASSTEST.DEFENDLEVEL,
                         ASSTEST.DEFENDPERIOD,
                         ASSTEST.PLANDAYCOUNT,
                         ASSTEST.ALARMDAYCOUNT,
                         ASSTEST.DEFAULTWARE,
                         ASSTEST.BUSTYPE,
                         ASSTEST.BUSORG,
                         ASSTEST.DEFPLANDATE,
                         ASSTEST.PLANFLG,
                         ASSTEST.ALARMFLG,
                         ASSTEST.WORKORDERTYPE,
                         ASSTEST.STOPMIDDAY,
                         ASSTEST.JUDGEFLG,
                         ASSTEST.PREDEFDATE,
                         ASSTEST.DEFDATE,
                         ASSTEST.AUDITSTATUS,
                         ASSTEST.WORKSHOPID,
                         RBUSROUTE.ROUTEID
                    FROM BM_TEMBUSDEFASSTEST ASSTEST,
                         ASGNRBUSROUTELD     RBUSROUTE
                   WHERE ASSTEST.WORKSHOPID = V_MAINTAINORGID
                     AND ASSTEST.DEFENDTYPE = '2'
                     AND ASSTEST.BUSID = RBUSROUTE.BUSID(+)
                   ORDER BY ASSTEST.DEFPLANDATE ASC) AAA
           WHERE ROWNUM <= V_SECMIDAVGNUM;
        LOOP
          FETCH CUR_DEFINFO
            INTO V_BUSDEFASSID,
                 V_BUSID,
                 V_DAYMILE,
                 V_DEFENDTYPE,
                 V_DEFENDLEVEL,
                 V_DEFENDPERIOD,
                 V_PLANDAYCOUNT,
                 V_ALARMDAYCOUNT,
                 V_DEFAULTWARE,
                 V_BUSTYPE,
                 V_BUSORG,
                 V_DEFPLANDATE,
                 V_PLANFLG,
                 V_ALARMFLG,
                 V_WORKORDERTYPE,
                 V_STOPMIDDAY,
                 V_JUDGEFLG,
                 V_PREDEFDATE,
                 V_DEFDATE,
                 V_AUDITSTATUS,
                 V_WORKSHOPID,
                 V_ROUTEID;
          -- ��ά��Ϣ
          EXIT WHEN CUR_DEFINFO%NOTFOUND;
          INSERT INTO BM_TEMBUSDEFASS
            (BUSDEFASSID,
             BUSID,
             DAYMILE,
             DEFENDTYPE,
             DEFENDLEVEL,
             DEFENDPERIOD,
             PLANDAYCOUNT,
             ALARMDAYCOUNT,
             DEFAULTWARE,
             BUSTYPE,
             BUSORG,
             WORKORDERTYPE,
             STOPMIDDAY,
             DEFPLANDATE,
             PLANFLG,
             ALARMFLG,
             JUDGEFLG,
             PREDEFDATE,
             DEFDATE,
             AUDITSTATUS,
             WORKSHOPID,
             ROUTEID)
          VALUES
            (V_BUSDEFASSID,
             V_BUSID,
             V_DAYMILE,
             V_DEFENDTYPE,
             V_DEFENDLEVEL,
             V_DEFENDPERIOD,
             V_PLANDAYCOUNT,
             V_ALARMDAYCOUNT,
             V_DEFAULTWARE,
             V_BUSTYPE,
             V_BUSORG,
             V_WORKORDERTYPE,
             V_STOPMIDDAY,
             V_WORKDATE,
             V_PLANFLG,
             V_ALARMFLG,
             V_JUDGEFLG,
             V_PREDEFDATE,
             V_WORKDATE,
             V_AUDITSTATUS,
             V_WORKSHOPID,
             V_ROUTEID);
          -- ɾ����ʱ���е�����
          DELETE FROM BM_TEMBUSDEFASSTEST
           WHERE BM_TEMBUSDEFASSTEST.BUSDEFASSID = V_BUSDEFASSID;
          --�����ύ
          COMMIT;
          -- ��ά�����ۼ�
          V_SECDEFWORKYET := V_SECDEFWORKYET + 1;
        END LOOP;
        CLOSE CUR_DEFINFO;
      END IF;
      -- ������������ڼ�һ
      V_FIRWORKDAYYET := V_FIRWORKDAYYET + V_RESTDAYNUM;
      -- ���¼���һάƽ��ֵ
      IF V_SUMWORKDAY - V_FIRWORKDAYYET > 1 THEN
        V_FIRAVGCOUNT := ROUND((V_FIRDEFTYPE_COUNT - V_FIRDEFWORKYET) /
                               (V_SUMWORKDAY - V_FIRWORKDAYYET));
      END IF;
      -- ��ά���ݴ���
      V_SECWORKDAYYET := V_SECWORKDAYYET + V_RESTDAYNUM;
      -- ���¼����άƽ��ֵ
      IF V_SUMWORKDAY - V_SECWORKDAYYET > 1 THEN
        V_SECAVGCOUNT := ROUND((V_SECDEFTYPE_COUNT - V_SECDEFWORKYET) /
                               (V_SUMWORKDAY - V_SECWORKDAYYET));
      END IF;
      -- �������ۼ�
      V_WORKDATE := V_WORKDATE + 1;
    END LOOP;
  END LOOP;
  CLOSE CUR_MAINWARE;
END P_DENPLAN_MODIFY;
/

prompt
prompt Creating procedure P_DISPLANNOWORKSYNC
prompt ======================================
prompt
create or replace procedure aptspzh.P_DISPLANNOWORKSYNC(v_routeid   in NVARCHAR2,
                                          v_begintime in NVARCHAR2,
                                          v_endtime in   NVARCHAR2,
                                          v_isfinished in number) is
  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_flagone varchar2(2);
  v_flagthree varchar2(2);
  v_viewname varchar2(100);
begin
v_flagone:='1';
v_flagthree:='3';
if v_isfinished = 1 then
v_viewname := 'FDISDISPLANNOWORKVIEW';
else
v_viewname := 'FDISDISPLANNOWORKPLANVIEW';
end if;
  v_substr := 'insert into FDISDISPLANLD
    (DISPLANID,
     ROUTEID,
     SUBROUTEID,
     SEGMENTID,
     BUSID,
     BUSSELFID,
     DRIVERID,
     DRIVERNAME,
     STEWARDID,
     STEWARDNAME,
     SHIFTNUM,
     LEAVETIME,
     ARRIVETIME,
     RECDATE,
     ISSENT,
     WRITETIME,
     WRITEID,
     SEQTYPE,
     MILETYPEID,
     SEGMENTNAME,
     SHIFTTYPE,
     SEQUENCENUM,
     TIMEINTERVAL,
     INFORMTIME,
     REALLEAVETIME,
     REALARRIVETTIME,
     ISINFORMSEND,
     ISFINISHED,
     ISLATE,
     ISSAVE,
     ISSYNC,
     UNEXMCAUSE,
     PREARRIVETTIME,
     MEMOS,
     MILENUM,
     ENDSTATIONID,
     STARTSTATIONID,
     EXTSTEWARDNAME,
     EXTSTEWARDID,
     EXTSTEWARDNAME2,
     EXTSTEWARDID2,
     DISMETHOD,
     ORIGPLANSENDTIME,
     ORIGPLANARRIVETIME,
     SHOWFLAG,
     BUSSID,
     GROUPNUM,
     arrangesid,
     PLANENDSTATIONID,
     PLANSTARTSTATIONID,
     rectype,
     rundate,
     orgid,
     recstate
     -- ,GPSMILE
     -- ROUTENAME,
     --SUBROUTENAME,
     --AHEADLATETIME
     )
    select S_FDISDISPLANGD.Nextval,
           disnowork.routeid,
           disnowork.subrouteid,
           seg.segmentid,
           disnowork.busid,
           disnowork.busselfid,
           disnowork.driverid,
           disnowork.drivername,
           disnowork.stewardid,
           disnowork.stewardname,
           disnowork.shiftnumstring,
           disnowork.leavetime,
           disnowork.arrivetime,
           disnowork.RECDATE,
           disnowork.ISSENT,
           disnowork.WRITETIME,
           disnowork.WRITEID,
           disnowork.segtype,
           disnowork.MILETYPEID,
           seg.segmentname,
           disnowork.shifttype,
           disnowork.sequencenum,
           disnowork.TIMEINTERVAL,
           disnowork.INFORMTIME,
           disnowork.REALLEAVETIME,
           disnowork.REALARRIVETTIME,
           disnowork.ISINFORMSEND,
           disnowork.ISFINISHED,
           disnowork.ISLATE,
           disnowork.ISSAVE,
           disnowork.ISSYNC,
           disnowork.UNEXMCAUSE,
           disnowork.PREARRIVETTIME,
           disnowork.MEMOS,
           disnowork.MILENUM,
           disnowork.arrivestationid,
           disnowork.leavestationid,
           disnowork.EXTSTEWARDNAME,
           disnowork.EXTSTEWARDID,
           disnowork.EXTSTEWARDNAME2,
           disnowork.EXTSTEWARDID2,
           disnowork.DISMETHOD,
           disnowork.ORIGPLANSENDTIME,
           disnowork.ORIGPLANARRIVETIME,
           disnowork.SHOWFLAG,
           TRIM(disnowork.BUSSID),
           disnowork.groupnum,
           disnowork.arrangesid,
           disnowork.arrivestationid,
           disnowork.leavestationid,
           disnowork.rectype,
           disnowork.execdate,
           disnowork.orgid,
           disnowork.recstate
      from '||v_viewname||' disnowork,mcsegmentinfogs seg
     where disnowork.SUBROUTEID=seg.SUBROUTEID and disnowork.isyuan='||'0'||' AND

(SEG.RUNDIRECTION='||v_flagone||' OR SEG.RUNDIRECTION='||v_flagthree||')
     AND SEG.ISACTIVE='||v_flagone||' AND disnowork.routeid in ' || v_routeid || '
     and disnowork.execdate >= ' ||
              v_begintime || '
        and disnowork.execdate < ' || v_endtime||'
        and disnowork.busid is not null
        and disnowork.milenum is not null
        and disnowork.milenum>0 and BUSSID IN (SELECT ITEMVALUE FROM TYPEENTRY
WHERE TYPENAME=''UNRUNTYPE'')'
        ;
  execute immediate v_substr;
  --exception then
  --DBMS_OUTPUT.PUT_LINE('fdisdisplan���Ŀ⿽������');
  commit;
end P_DISPLANNOWORKSYNC;
/

prompt
prompt Creating procedure P_DISPLANNOWORKSYNC_DB
prompt =========================================
prompt
create or replace procedure aptspzh.P_DISPLANNOWORKSYNC_DB(v_routeid   in NVARCHAR2,
                                          v_begintime in NVARCHAR2,
                                          v_endtime in   NVARCHAR2,
                                          v_isfinished in number) is
  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
  v_viewname varchar2(100);
begin
if v_isfinished = 1 then
v_viewname := 'FDISDISPLANNOWORKVIEW';
else
v_viewname := 'FDISDISPLANNOWORKPLANVIEW';
end if;
  v_substr := 'insert into FDISDISPLANLD
    (DISPLANID,
     ROUTEID,
     SUBROUTEID,
     SEGMENTID,
     BUSID,
     BUSSELFID,
     DRIVERID,
     DRIVERNAME,
     STEWARDID,
     STEWARDNAME,
     SHIFTNUM,
     LEAVETIME,
     ARRIVETIME,
     RECDATE,
     ISSENT,
     WRITETIME,
     WRITEID,
     SEQTYPE,
     MILETYPEID,
     SHIFTTYPE,
     SEQUENCENUM,
     TIMEINTERVAL,
     INFORMTIME,
     REALLEAVETIME,
     REALARRIVETTIME,
     ISINFORMSEND,
     ISFINISHED,
     ISLATE,
     ISSAVE,
     ISSYNC,
     UNEXMCAUSE,
     PREARRIVETTIME,
     MEMOS,
     MILENUM,
     ENDSTATIONID,
     STARTSTATIONID,
     EXTSTEWARDNAME,
     EXTSTEWARDID,
     DISMETHOD,
     ORIGPLANSENDTIME,
     ORIGPLANARRIVETIME,
     SHOWFLAG,
     BUSSID,
     GROUPNUM,
     arrangesid,
     PLANENDSTATIONID,
     PLANSTARTSTATIONID,
     rectype,
     rundate,
     orgid,
     recstate,
     DISPATCHNO,
     DISPATCHNAME
     -- ,GPSMILE
     -- ROUTENAME,
     --SUBROUTENAME,
     --AHEADLATETIME
     )
    select S_FDISDISPLANGD.Nextval,
           disnowork.routeid,
           disnowork.routeid,
           disnowork.routeid,
           disnowork.busid,
           disnowork.busselfid,
           disnowork.driverid,
           disnowork.drivername,
           disnowork.stewardid,
           disnowork.stewardname,
           disnowork.shiftnumstring,
           disnowork.leavetime,
           disnowork.arrivetime,
           disnowork.RECDATE,
           disnowork.ISSENT,
           disnowork.WRITETIME,
           disnowork.WRITEID,
           disnowork.segtype,
           disnowork.MILETYPEID,
           disnowork.shifttype,
           disnowork.sequencenum,
           disnowork.TIMEINTERVAL,
           disnowork.INFORMTIME,
           disnowork.REALLEAVETIME,
           disnowork.REALARRIVETTIME,
           disnowork.ISINFORMSEND,
           disnowork.ISFINISHED,
           disnowork.ISLATE,
           disnowork.ISSAVE,
           disnowork.ISSYNC,
           disnowork.UNEXMCAUSE,
           disnowork.PREARRIVETTIME,
           disnowork.MEMOS,
           disnowork.MILENUM,
           disnowork.arrivestationid,
           disnowork.leavestationid,
           disnowork.EXTSTEWARDNAME,
           disnowork.EXTSTEWARDID,
           disnowork.DISMETHOD,
           disnowork.ORIGPLANSENDTIME,
           disnowork.ORIGPLANARRIVETIME,
           disnowork.SHOWFLAG,
           TRIM(disnowork.BUSSID),
           disnowork.groupnum,
           disnowork.arrangesid,
           disnowork.arrivestationid,
           disnowork.leavestationid,
           disnowork.rectype,
           disnowork.execdate,
           disnowork.orgid,
           disnowork.recstate,
           disnowork.dispatchno,
           disnowork.dispatchname
      from '||v_viewname||' disnowork
     where disnowork.isyuan='||'0'||'
     AND disnowork.routeid in ' || v_routeid || '
     and disnowork.execdate >= ' ||
              v_begintime || '
        and disnowork.execdate < ' || v_endtime||'
        and disnowork.busid is not null
        and disnowork.milenum is not null
        and disnowork.milenum>0 and BUSSID IN (SELECT ITEMVALUE FROM TYPEENTRY
WHERE TYPENAME=''UNRUNTYPE'')'
        ;
  execute immediate v_substr;
  --exception then
  --DBMS_OUTPUT.PUT_LINE('fdisdisplan���Ŀ⿽������');
  commit;
end P_DISPLANNOWORKSYNC_DB;
/

prompt
prompt Creating procedure P_DISPLANSYNC
prompt ================================
prompt
create or replace procedure aptspzh.P_DISPLANSYNC(v_routeid   in NVARCHAR2,
                                          v_begintime in NVARCHAR2,
                                          v_endtime   NVARCHAR2) is
  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸ģ�ͨ�ã�
begin
  v_substr := 'delete from FDISDISPLANLD where routeid in ' || v_routeid ||
              'and rundate =' || v_begintime || 'and rectype = 1';
  execute immediate v_substr;
  v_substr := 'insert into FDISDISPLANLD
    (DISPLANID,
     ROUTEID,
     SUBROUTEID,
     SEGMENTID,
     BUSID,
     BUSSELFID,
     DRIVERID,
     DRIVERNAME,
     DISDRIVERID,
     DISDRIVERNAME,
     STEWARDID,
     STEWARDNAME,
     DISSTEWARDID,
     DISSTEWARDNAME,
     SHIFTNUM,
     LEAVETIME,
     ARRIVETIME,
     RECDATE,
     ISSENT,
     WRITETIME,
     WRITEID,
     SEQTYPE,
     MILETYPEID,
     SEGMENTNAME,
     SHIFTTYPE,
     SEQUENCENUM,
     TIMEINTERVAL,
     INFORMTIME,
     REALLEAVETIME,
     REALARRIVETTIME,
     ISINFORMSEND,
     ISFINISHED,
     ISLATE,
     ISSAVE,
     ISSYNC,
     UNEXMCAUSE,
     PREARRIVETTIME,
     MEMOS,
     MILENUM,
     ENDSTATIONID,
     STARTSTATIONID,
     EXTSTEWARDNAME,
     EXTSTEWARDID,
     EXTSTEWARDNAME2,
     EXTSTEWARDID2,
     DISMETHOD,
     ORIGPLANSENDTIME,
     ORIGPLANARRIVETIME,
     SHOWFLAG,
     BUSSID,
     GROUPNUM,
     arrangesid,
     PLANENDSTATIONID,
     PLANSTARTSTATIONID,
     -- ,GPSMILE
     -- ROUTENAME,
     --SUBROUTENAME,
     --AHEADLATETIME
     rundate,
     seqnum,
     shiftdetailtype,
     shiftnumstring,
     orgid,
     BELIEVEPITCH,
     actiontype,
     dispatchno,
     dispatchname,
     SEQUENCETYPE
     )
    select S_FDISDISPLANGD.Nextval,
           routeid,
           subrouteid,
           segmentid,
           busid,
           busselfid,
           driverid,
           drivername,
           driverid,
           drivername,
           stewardid,
           stewardname,
           stewardid,
           stewardname,
           shiftnumstring,
           leavetime,
           arrivetime,
           RECDATE,
           ISSENT,
           WRITETIME,
           WRITEID,
           SEQTYPE,
           MILETYPEID,
           segmentname,
           shifttype,
           sequencenum,
           TIMEINTERVAL,
           INFORMTIME,
           REALLEAVETIME,
           REALARRIVETTIME,
           ISINFORMSEND,
           ISFINISHED,
           ISLATE,
           ISSAVE,
           ISSYNC,
           UNEXMCAUSE,
           PREARRIVETTIME,
           MEMOS,
           MILENUM,
           ENDSTATIONID,
           STARTSTATIONID,
           EXTSTEWARDNAME,
           EXTSTEWARDID,
           EXTSTEWARDNAME2,
           EXTSTEWARDID2,
           DISMETHOD,
           ORIGPLANSENDTIME,
           ORIGPLANARRIVETIME,
           SHOWFLAG,
           TRIM(BUSSID),
           groupnum,
           arrangesid,
           ENDSTATIONID,
           STARTSTATIONID,
           execdate,
           seqnum,
           shiftdetailtype,
           shiftnumstring,
           orgid,
           0,
           actiontype,
           dispatchno,
           dispatchname,
           SEQUENCETYPE
      from fdisdisplanview
     where isyuan='||'0'||' and routeid in ' || v_routeid || '  and execdate >= ' ||
              v_begintime || ' and rownum<=4
        and execdate < ' || v_endtime;
  execute immediate v_substr;
  --exception then
  --DBMS_OUTPUT.PUT_LINE('fdisdisplan���Ŀ⿽������');
  /*P_DISPLANNOWORKSYNC(v_routeid,v_begintime,v_endtime);--���ط�Ӫ��*/
  commit;
end P_DISPLANSYNC;
/

prompt
prompt Creating procedure P_DISPLANSYNC_TE
prompt ===================================
prompt
create or replace procedure aptspzh.P_DISPLANSYNC_TE is

  v_aRowaddversion    INTEGER;
  v_aRowupdateversion INTEGER;
  v_eRowaddversion    INTEGER;
  v_eRowupdateversion INTEGER;
  --�Ӵ����ȸ��ݳ�����Ҫ�޸�
begin
  /*update  asgnarrangeseqgd2 a set a.leavetime=a.leavetime+1,a.arrivetime=arrivetime+1
  where a.execdate>sysdate-1  and a.leavetime<1/8+execdate ;
  update  asgnarrangeseqgd a
  set a.leavetime=a.leavetime+1,a.arrivetime=arrivetime+1
  where a.execdate>sysdate-1 and a.leavetime<1/8+execdate ;
  commit;
  update  asgnarrangeseqgd2 a set a.arrivetime=arrivetime+1
  where a.execdate>sysdate-1  and a.leavetime>a.arrivetime ;
  update  asgnarrangeseqgd a
  set a.arrivetime=arrivetime+1
  where a.execdate>sysdate-1 and a.leavetime>a.arrivetime ;
  commit;*/
  delete from fdislogforhandleld c where c.logtime > sysdate;
  commit;
  delete from FDISDISPLANLD a
   where a.rundate = trunc(sysdate)
     AND nvl(A.ISSENT, 0) = 0;
  insert into FDISDISPLANLD
    (DISPLANID,
     ROUTEID,
     SUBROUTEID,
     SEGMENTID,
     BUSID,
     BUSSELFID,
     DRIVERID,
     DRIVERNAME,
     DISDRIVERID,
     DISDRIVERNAME,
     STEWARDID,
     STEWARDNAME,
     DISSTEWARDID,
     DISSTEWARDNAME,
     SHIFTNUM,
     LEAVETIME,
     ARRIVETIME,
     RECDATE,
     ISSENT,
     WRITETIME,
     WRITEID,
     SEQTYPE,
     MILETYPEID,
     SEGMENTNAME,
     SHIFTTYPE,
     SEQUENCENUM,
     TIMEINTERVAL,
     INFORMTIME,
     REALLEAVETIME,
     REALARRIVETTIME,
     ISINFORMSEND,
     ISFINISHED,
     ISLATE,
     ISSAVE,
     ISSYNC,
     UNEXMCAUSE,
     PREARRIVETTIME,
     MEMOS,
     MILENUM,
     ENDSTATIONID,
     STARTSTATIONID,
     EXTSTEWARDNAME,
     EXTSTEWARDID,
     DISMETHOD,
     ORIGPLANSENDTIME,
     ORIGPLANARRIVETIME,
     SHOWFLAG,
     BUSSID,
     GROUPNUM,
     arrangesid,
     PLANENDSTATIONID,
     PLANSTARTSTATIONID,
     -- ,GPSMILE
     -- ROUTENAME,
     --SUBROUTENAME,
     --AHEADLATETIME
     rundate,
     seqnum,
     shiftdetailtype,
     shiftnumstring,
     orgid)
    select S_FDISDISPLANGD.Nextval,
           routeid,
           subrouteid,
           segmentid,
           busid,
           busselfid,
           driverid,
           drivername,
           driverid,
           drivername,
           stewardid,
           stewardname,
           stewardid,
           stewardname,
           shiftnumstring,
           leavetime,
           arrivetime,
           RECDATE,
           ISSENT,
           WRITETIME,
           'autoload' WRITEID,
           SEQTYPE,
           MILETYPEID,
           segmentname,
           shifttype,
           sequencenum,
           TIMEINTERVAL,
           INFORMTIME,
           REALLEAVETIME,
           REALARRIVETTIME,
           ISINFORMSEND,
           ISFINISHED,
           ISLATE,
           ISSAVE,
           ISSYNC,
           UNEXMCAUSE,
           PREARRIVETTIME,
           MEMOS,
           MILENUM,
           ENDSTATIONID,
           STARTSTATIONID,
           EXTSTEWARDNAME,
           EXTSTEWARDID,
           DISMETHOD,
           ORIGPLANSENDTIME,
           ORIGPLANARRIVETIME,
           SHOWFLAG,
           TRIM(BUSSID),
           groupnum,
           arrangesid,
           ENDSTATIONID,
           STARTSTATIONID,
           execdate,
           seqnum,
           shiftdetailtype,
           shiftnumstring,
           orgid
      from fdisdisplanview
     where execdate = trunc(sysdate)
       and isyuan = '0';
  commit;

  p_getrowversion('fdisarrangedetailld', 1, v_aRowaddversion);
  p_getrowversion('fdisarrangedetailld', 2, v_aRowupdateversion);
  p_getrowversion('fdisempdutyld', 1, v_eRowaddversion);
  p_getrowversion('fdisempdutyld', 2, v_eRowupdateversion);

  v_aRowaddversion    := v_aRowaddversion + 100;
  v_aRowupdateversion := v_aRowupdateversion + 100;
  v_eRowaddversion    := v_eRowaddversion + 100;
  v_eRowupdateversion := v_eRowupdateversion + 100;
  delete from fdisarrangedetailld a where a.execdate = trunc(sysdate);
  commit;
  insert into fdisarrangedetailld
    (arrangesid,
     arrangeid,
     routeid,
     subrouteid,
     shiftnum,
     shiftnumstring,
     shifttype,
     busid,
     empid,
     empname,
     execdate,
     onworktime,
     offworktime,
     writetime,
     writeid,
     groupnum,
     empptype,
     busselfid,
     executestate,
     memo,
     issave,
     issync,
     validmark,
     rowaddversion,
     rowupdateversion,
     detailid,
     clientcode)
    select arrangesid,
           arrangeid,
           routeid,
           0,
           shiftnumstring,
           shiftnumstring,
           shifttype,
           busid,
           empid,
           empname,
           execdate,
           onworktime,
           offworktime,
           sysdate,
           'autoload',
           groupnum,
           empptype,
           busselfid,
           0,
           null,
           0,
           0,
           0,
           v_aRowaddversion,
           v_aRowupdateversion,
           S_ArrangeDetail.Nextval,
           -200
      from fdisarrangesequencedetailview
     where (busid is not null)
       and (empid is not null)
       and EXECDATE = trunc(sysdate);
  commit;
  delete from fdisempdutyld where execdate = trunc(sysdate);
  commit;
  insert into fdisempdutyld
    (dutyid,
     routeid,
     empid,
     empname,
     execdate,
     onworktime,
     offworktime,
     executestate,
     instationid,
     outstationid,
     onworkdisparitytime,
     offworkdisparitytime,
     onworkaddress,
     offworkaddress,
     onworkstatus,
     offworkstatus,
     onworkoperationtype,
     writetime,
     writeid,
     detailid,
     rowaddversion,
     rowupdateversion,
     clientcode,
     memo,
     isactive,
     offworkoperationtype,
     validmark,
     orgid,
     sendplantodaytime,
     sendplannextdaytime,
     explain,
     avoidchecktype)
    select S_EMPDUTY.Nextval,
           routeid,
           empid,
           empname,
           execdate,
           onworktime,
           offworktime,
           0,
           insiteid,
           outsiteid,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           sysdate,
           null,
           null,
           v_eRowaddversion,
           v_eRowupdateversion,
           -200,
           null,
           1,
           null,
           null,
           null,
           null,
           null,
           null,
           null
      from fdisarrangesequencedetailview
     where (busid is not null)
       and (empid is not null)
       and EXECDATE = trunc(sysdate);
  commit;
  v_aRowaddversion    := v_aRowaddversion + 1;
  v_aRowupdateversion := v_aRowupdateversion + 1;
  v_eRowaddversion    := v_eRowaddversion + 1;
  v_eRowupdateversion := v_eRowupdateversion + 1;
  update AD_ROWVERSION
     set ROWADDVERSION = v_aRowaddversion
   where upper(AD_TABLENAME) = upper('fdisarrangedetailld');
  update AD_ROWVERSION
     set rowupdateversion = v_aRowupdateversion
   where upper(AD_TABLENAME) = upper('fdisarrangedetailld');

  update AD_ROWVERSION
     set ROWADDVERSION = v_eRowaddversion
   where upper(AD_TABLENAME) = upper('fdisempdutyld');
  update AD_ROWVERSION
     set rowupdateversion = v_eRowupdateversion
   where upper(AD_TABLENAME) = upper('fdisempdutyld');
  commit;
end P_DISPLANSYNC_TE;
/

prompt
prompt Creating procedure P_DISPLANTIMEBILL
prompt ====================================
prompt
create or replace procedure aptspzh.P_DISPLANTIMEBILL(v_routeid in NVARCHAR2,
                                              v_rundate in NVARCHAR2) is
  v_substr varchar2(4000);
begin
  v_substr := ' delete from fdisdisplantimebill where routeid in ' ||
              v_routeid || 'and rundate =' || v_rundate;
  execute immediate v_substr;

  v_substr := 'insert into fdisdisplantimebill
            (
            id,
            routeid,
            subrouteid,
            segmentid,
            stationid,
            sngserialid,
            arrivetime,
            staytime,
            displanid,
            arrangesid,
            writetime,
            writeid,
            isactive,
            rundate
            )
            select S_FDISDISPLANTIMEBILLGD.Nextval,
                   routeid,
                   subrouteid,
                   segmentid,
                   stationid,
                   sngserialid,
                   arrivetime,
                   staytime,
                   displanid,
                   arrangesid,
                   writetime,
                   writeid,
                   1,
                   execdate
                   from fdisdisplantimebillview
                   where routeid in ' || v_routeid ||
              'and execdate>=' || v_rundate;

  execute immediate v_substr;
  commit;

end P_DISPLANTIMEBILL;
/

prompt
prompt Creating procedure P_DRIVERSAFTYMILE_QUARTER
prompt ============================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_DRIVERSAFTYMILE_QUARTER IS
  /***********************************************************************************
  ���ƣ�P_DRIVERSAFTYMILE_QUARTER
  ��;���������ռ��ȴ����ʻԱӦ�۰�ȫ���
  �������ʻԱ�¶Ȱ�ȫ��̼�¼��SS_DRIVERSAFEMILEMONTHRECGD
         CC  2014-05-23
  **********************************************************************************/

  TYPE T_CURSOR IS REF CURSOR;
  CUR_ACCCOST   T_CURSOR;
  V_FIRSTDATE   DATE; -- �ϼ��ȵ�һ��
  V_LASTDATE    DATE; -- �ϼ������һ��
  V_ACCIDENTID  VARCHAR2(20);
  V_DRIVERID    VARCHAR2(20);
  V_DELRATE     NUMBER(2, 1);
  V_ACCCOST     NUMBER(12, 2);
  V_SAFEMILE    NUMBER(12, 4);
  V_DELSAFEMILE NUMBER(12, 4);
  V_NUM         NUMBER(10) := 0;
BEGIN
  --��ȡ�ϼ��ȵ�һ��
  SELECT TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, -3), 'YYYY-MM') || - '01',
                 'YYYY-MM-DD')
    INTO V_FIRSTDATE
    FROM DUAL T;
  --��ȡ�ϼ������һ��
  SELECT TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD')
    INTO V_LASTDATE
    FROM DUAL T;
  -- ɾ���Ѵ��ڵ��ϼ��ȿ۳��İ�ȫ��̼�¼
  DELETE FROM SS_DRIVERSAFEMILEMONTHRECGD
   WHERE TO_CHAR(RECMONTH, 'YYYY-MM') = TO_CHAR(V_LASTDATE, 'YYYY-MM');
  -- �ύ
  COMMIT;
  --���α꣨���α꣩
  OPEN CUR_ACCCOST FOR
  -- ��ѯ�ϼ��������¹�����
    SELECT ACC.EMPID,
           ACC.ACCIDENTID,
           ACCCOSTINFO.ACCCOSTTOTAL,
           CASE
             WHEN ACCCOSTINFO.ACCCOSTTOTAL <= 300 THEN
              0.1
             WHEN ACCCOSTINFO.ACCCOSTTOTAL <= 500 THEN
              0.2
             WHEN ACCCOSTINFO.ACCCOSTTOTAL <= 1000 THEN
              0.3
             WHEN ACCCOSTINFO.ACCCOSTTOTAL <= 1500 THEN
              0.4
             WHEN ACCCOSTINFO.ACCCOSTTOTAL < 3000 THEN
              0.5
             WHEN ACCCOSTINFO.ACCCOSTTOTAL >= 3000 THEN
              1
           END DELRATE
      FROM SS_ACCIDENTGD ACC,
           (SELECT ACCIDENTID,
                   SUM(ACCCOSTINFO.ACCIDENTCOSTAMOUNT) ACCCOSTTOTAL
              FROM SS_ACCIDENTCOSTGD ACCCOSTINFO
             WHERE 1 = 1
               AND ACCCOSTINFO.COSTDATE >= V_FIRSTDATE
               AND ACCCOSTINFO.COSTDATE <= V_LASTDATE
             GROUP BY ACCCOSTINFO.ACCIDENTID) ACCCOSTINFO
     WHERE 1 = 1
       AND ACC.DUTYCATEGORY != '2'
       AND ACC.ACCIDENTID = ACCCOSTINFO.ACCIDENTID;
  --ѭ���α�
  LOOP
    FETCH CUR_ACCCOST
      INTO V_DRIVERID, V_ACCIDENTID, V_ACCCOST, V_DELRATE;
    -- û������ʱ�˳�
    EXIT WHEN CUR_ACCCOST%NOTFOUND;
    SELECT COUNT(1)
      INTO V_NUM
      FROM SS_DRIVERSAFEMILEMONTHRECGD T
     WHERE 1 = 1
       AND TO_CHAR(T.RECMONTH, 'YYYY-MM') >=
           TO_CHAR(V_FIRSTDATE, 'YYYY-MM')
       AND TO_CHAR(T.RECMONTH, 'YYYY-MM') <= TO_CHAR(V_LASTDATE, 'YYYY-MM')
       AND T.SIGN IN ('0', '1')
       AND T.DRIVERID = V_DRIVERID;
    -- �жϽ��������
    IF V_NUM > 0 THEN
      -- ��ѯ�ϼ��Ⱥϼư�ȫ���
      SELECT SUM(T.MONTHSAFEMILE) SUMMILE
        INTO V_SAFEMILE
        FROM SS_DRIVERSAFEMILEMONTHRECGD T
       WHERE 1 = 1
         AND TO_CHAR(T.RECMONTH, 'YYYY-MM') >=
             TO_CHAR(V_FIRSTDATE, 'YYYY-MM')
         AND TO_CHAR(T.RECMONTH, 'YYYY-MM') <=
             TO_CHAR(V_LASTDATE, 'YYYY-MM')
         AND T.SIGN IN ('0', '1')
         AND T.DRIVERID = V_DRIVERID;
      -- �۳���ȫ���
      V_DELSAFEMILE := ROUND(V_SAFEMILE * (1 - V_DELRATE), 2);
      -- ����۳���ȫ�����Ϣ
      INSERT INTO SS_DRIVERSAFEMILEMONTHRECGD
        (DRIVERSAFEMILEMONTHRECID,
         DRIVERID,
         RECMONTH,
         MONTHSAFEMILE,
         SIGN,
         ACCIDENTID)
        SELECT S_FDISDISPLANGD.NEXTVAL,
               V_DRIVERID,
               to_date(to_char(V_LASTDATE, 'yyyy-MM'), 'yyyy-MM'),
               V_DELSAFEMILE,
               '2',
               V_ACCIDENTID
          FROM DUAL;
      -- �ύ
      COMMIT;
    END IF;
  END LOOP;
  CLOSE CUR_ACCCOST;
  -- �洢���̽���
END P_DRIVERSAFTYMILE_QUARTER;
/

prompt
prompt Creating procedure P_EMPLOYEESERVICEAGE
prompt =======================================
prompt
create or replace procedure aptspzh.P_EmployeeServiceAge is
begin
  UPDATE MCEMPLOYEEINFOGS T
     SET T.SERVICEAGE = TRUNC(TO_CHAR(SYSDATE, 'YYYY') -
                              TO_CHAR(T.STARTDATE, 'YYYY')) + 1
   WHERE T.STARTDATE IS NOT NULL;
end P_EmployeeServiceAge;
/

prompt
prompt Creating procedure P_EMP_TRANS_PROCESS
prompt ======================================
prompt
create or replace procedure aptspzh.P_EMP_TRANS_PROCESS IS
  /***************************************************
  ���ƣ�P_EMP_TRANS_PROCESS
  ��;��������Ա�����¼���޸���Ա������Ա��"ISACTIVE", "FLAG", "ORGID", "EMPPTYPE","STATUS" �ֶ�
                          ɾ����Ա��·��������Ա��������������ְ���޸���Ա������"EXTDATE"��ͬ��ֹ����
  �����:   MCEMPLOYEEINFOGS
            ASGNRBUSEMPLD
            ASGNREMPROUTELD
            EMPEXTENDINFO
  ��д��
  �޸ģ����Ӹ�����Աн�ʼ����ϵ���н�ʼ�����Զ����ֶ�"EMPSALARYLEVELID",
   "RETAIN1", "RETAIN2", "RETAIN3", "RETAIN4", "RETAIN5", "RETAIN6", "RETAIN7", "RETAIN8", "RETAIN9", "RETAIN10"
  ***************************************************/
  V_EMPTRANS_COUNT NUMBER := 0;
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EMPTRANS       T_CURSOR;
  V_EMPID            VARCHAR2(20);
  V_ISACTIVE         CHAR(1);
  V_NEWORGID         VARCHAR2(50);
  V_OLDORGID         VARCHAR2(50);
  V_TRANSFERTYPE     VARCHAR2(40);
  V_NEWEMPTYPE       VARCHAR2(3);
  V_NOWORGID         VARCHAR2(20);
  V_EMPTRANSFERID    VARCHAR2(20);
  V_EMPSALARY_COUNT  NUMBER := 0;
  V_EMPSALARYLEVELID VARCHAR2(20);
  V_RETAIN1          NVARCHAR2(50);
  V_RETAIN2          NVARCHAR2(50);
  V_RETAIN3          NVARCHAR2(50);
  V_RETAIN4          NVARCHAR2(50);
  V_RETAIN5          NVARCHAR2(50);
  V_RETAIN6          NVARCHAR2(50);
  V_RETAIN7          NVARCHAR2(50);
  V_RETAIN8          NVARCHAR2(50);
  V_RETAIN9          NVARCHAR2(50);
  V_RETAIN10         NVARCHAR2(50);
  V_TRANFERDATE      DATE;
  V_BATCHTRANSFERID  VARCHAR2(20);
BEGIN
  /***************************************************
  ������Ա�����������Ա����
  ***************************************************/
  --��ѯ�Ƿ���ڱ䶯��¼
  SELECT COUNT(1)
    INTO V_EMPTRANS_COUNT
    FROM MCEMPTRANSFERGD
   WHERE TRUNC(TRANSFERDATE) = TRUNC(SYSDATE)
     AND TRANSFLAG = '0';
  --1 ���ڱ䶯��¼IF_BEGIN
  IF V_EMPTRANS_COUNT > 0 THEN
    BEGIN
      --OPEN CUR_EMPTRANS
      OPEN CUR_EMPTRANS FOR
        SELECT EMPID,
               EMPTR.Isactive,
               EMPTR.Neworgid,
               EMPTR.Oldorgid,
               EMPTR.Newemptype,
               EMPTR.Transfertype,
               EMPTR.TRID,
               EMPTR.Empsalarylevelid,
               EMPTR.Retain1,
               EMPTR.Retain2,
               EMPTR.Retain3,
               EMPTR.Retain4,
               EMPTR.Retain5,
               EMPTR.Retain6,
               EMPTR.Retain7,
               EMPTR.Retain8,
               EMPTR.Retain9,
               EMPTR.Retain10,
               EMPTR.TRANSFERDATE,
               EMPTR.BATCHTRANSFERID
          FROM MCEMPTRANSFERGD EMPTR
         WHERE TRUNC(TRANSFERDATE) = TRUNC(SYSDATE)
           AND TRANSFLAG = '0';
      LOOP
        FETCH CUR_EMPTRANS
          INTO V_EMPID, V_ISACTIVE, V_NEWORGID, V_OLDORGID, V_NEWEMPTYPE, V_TRANSFERTYPE, V_EMPTRANSFERID, V_EMPSALARYLEVELID, V_RETAIN1, V_RETAIN2, V_RETAIN3, V_RETAIN4, V_RETAIN5, V_RETAIN6, V_RETAIN7, V_RETAIN8, V_RETAIN9, V_RETAIN10, V_TRANFERDATE,V_BATCHTRANSFERID;
        BEGIN
          SELECT ORGID
            INTO V_NOWORGID
            FROM MCEMPLOYEEINFOGS
           WHERE EMPID = V_EMPID;
          --1.1.1 ������Ա��
          UPDATE MCEMPLOYEEINFOGS EMP
             SET EMP.ORGID    = V_NEWORGID,
                 EMP.EMPPTYPE = V_NEWEMPTYPE,
                 EMP.STATUS   = V_TRANSFERTYPE,
                 EMP.ISACTIVE = V_ISACTIVE,
                 EMP.FLAG     = V_ISACTIVE
           WHERE EMP.EMPID = V_EMPID;
          --�ύ������Ա
          COMMIT;
          --1.1.1 ������Ա����״̬Ϊ1
          UPDATE MCEMPTRANSFERGD EMPTRAN
             SET EMPTRAN.TRANSFLAG = '1'
           WHERE EMPTRAN.TRID = V_EMPTRANSFERID;
           --1.1.1.1 ���µ�������
            IF V_BATCHTRANSFERID IS NOT NULL THEN
           UPDATE HR_BATCHTRANSFERGD EMBATPTRAN
             SET EMBATPTRAN.TRANSFLAG = '1'
           WHERE EMBATPTRAN.BATCHTRANSFERID = V_BATCHTRANSFERID;
           END IF;
          COMMIT;
          --1.1.2 ɾ����Ա������ϵ
          DELETE FROM ASGNRBUSEMPLD b
           WHERE EMPID = V_EMPID
             and b.routeid in
                 (select routeid from mcrorgroutegs where orgid = V_OLDORGID)
             and (b.routeid not in
                 (select routeid
                     from mcrorgroutegs
                    where orgid = V_NEWORGID) or
                 b.empid not in
                 (select empid
                     from asgnremprouteld emp
                    where emp.routeid = b.routeid));
          --1.1.3 ɾ����Ա��·��ϵ
          DELETE FROM ASGNREMPROUTELD b
           WHERE EMPID = V_EMPID
             and b.routeid in
                 (select routeid from mcrorgroutegs where orgid = V_OLDORGID)
             and b.routeid not in
                 (select routeid from mcrorgroutegs where orgid = V_NEWORGID);
          --1.1.3.1 ɾ��ά�޳�����Ա��ϵ
          DELETE FROM BM_RMAINTAINWAREEMPGD bb WHERE USERID = V_EMPID;
          DELETE FROM BM_RMTORGEMPGD b WHERE EMPID = V_EMPID;
          --�ύɾ����Ա��ϵ
          COMMIT;
          SELECT COUNT(1)
            INTO V_EMPSALARY_COUNT
            FROM HR_EMPSALARYLEVELSETGD
           WHERE EMPID = V_EMPID;
          IF V_EMPSALARY_COUNT > 0 THEN
            --1.1.4 ������Աн�ʼ�����Զ����ֶ�
            UPDATE HR_EMPSALARYLEVELSETGD EMPSAL
               SET EMPSAL.EMPSALARYLEVELID = V_EMPSALARYLEVELID,
                   EMPSAL.RETAIN1          = V_RETAIN1,
                   EMPSAL.RETAIN2          = V_RETAIN2,
                   EMPSAL.RETAIN3          = V_RETAIN3,
                   EMPSAL.RETAIN4          = V_RETAIN4,
                   EMPSAL.RETAIN5          = V_RETAIN5,
                   EMPSAL.RETAIN6          = V_RETAIN6,
                   EMPSAL.RETAIN7          = V_RETAIN7,
                   EMPSAL.RETAIN8          = V_RETAIN8,
                   EMPSAL.RETAIN9          = V_RETAIN9,
                   EMPSAL.RETAIN10         = V_RETAIN10
             WHERE EMPSAL.EMPID = V_EMPID;
          ELSIF V_EMPSALARYLEVELID IS NOT NULL THEN
            INSERT INTO HR_EMPSALARYLEVELSETGD
              (EMPSALARYLEVELSETID,
               EMPID,
               EMPSALARYLEVELID,
               RETAIN1,
               RETAIN2,
               RETAIN3,
               RETAIN4,
               RETAIN5,
               RETAIN6,
               RETAIN7,
               RETAIN8,
               RETAIN9,
               RETAIN10)
            values
              (rpad('21' || to_char(sysdate, 'yymmddhh24miss') ||
                    ABS(MOD(DBMS_RANDOM.RANDOM, 10000)),
                    20,
                    '0'),
               V_EMPID,
               V_EMPSALARYLEVELID,
               V_RETAIN1,
               V_RETAIN2,
               V_RETAIN3,
               V_RETAIN4,
               V_RETAIN5,
               V_RETAIN6,
               V_RETAIN7,
               V_RETAIN8,
               V_RETAIN9,
               V_RETAIN10);
          END IF;
          --�ύ������Աн�ʼ�����Զ���
          COMMIT;
          IF to_number(V_TRANSFERTYPE) > 4 THEN
            --1.1.5 �����ְ��������Ա�����ĺ�ͬ��ֹ����
            UPDATE EMPEXTENDINFO EMPEXTEND
               SET EMPEXTEND.EXTDATE = V_TRANFERDATE
             WHERE EMPEXTEND.EMPID = V_EMPID;
          END IF;
          COMMIT;
        END;
        EXIT WHEN CUR_EMPTRANS%NOTFOUND;
      END LOOP;
      CLOSE CUR_EMPTRANS;
      --CLOSE CUR_EMPTRANS
    END;
  END IF;
  --1 ���ڱ䶯��¼IF����END
END P_EMP_TRANS_PROCESS;
/

prompt
prompt Creating procedure P_FDISARRSEQUENCETIMELD
prompt ==========================================
prompt
create or replace procedure aptspzh.P_FDISARRSEQUENCETIMELD(v_routeid   in NVARCHAR2,
                                                    v_rundate in NVARCHAR2) is
  v_substr varchar2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸ģ�ͨ�ã�
begin
  v_substr := 'insert into FDISARRSEQUENCETIMELD
  (ARRANGESID,
   ARRANGEID,
   ROUTEID,
   SUBROUTEID,
   SEGMENTID,
   BUSID,
   DRIVERID,
   STEWARDID,
   STEWARDID2,
   SHIFTNUM,
   SHIFTTYPE,
   GROUPNUM,
   SHIFTDETAILTYPE,
   LEAVETIME,
   ARRIVETIME,
   SEQNUM,
   LEAVESTATIONID,
   ARRIVESTATIONID,
   execdate,
   writetime,
   writeid,
   milenum,
   SEQUENCENUM)
  SELECT seq.ARRANGESID,
         seq.ARRANGEID,
         seq.ROUTEID,
         seq.SUBROUTEID,
         seq.SEGMENTID,
         seq.BUSID,
         seq.DRIVERID,
         seq.STEWARDID,
         seq.STEWARDID2,
         seq.SHIFTNUMSTRING,
         seq.SHIFTTYPE,
         seq.GROUPNUM,
         null as SHIFTDETAILTYPE,
         seq.LEAVETIME,
         seq.ARRIVETIME,
         seq.SEQCOUNT1,
         seq.LEAVESTATIONID,
         seq.ARRIVESTATIONID,
         seq.execdate,
         sysdate  as writetime,
         ''0'' as writeid,
         seq.MILEAGE,
         seq.SEQUENCENUM
    FROM asgnarrangeseqgd seq,asgnarrangegd  arrange
   where seq.arrangeid =arrange.arrangeid
     and seq.busid is not null
     and seq.DRIVERID is not null
     and arrange.isyuan=''0''
     and seq.routeid in (' || v_routeid || ')
     and seq.execdate = to_date('''||v_rundate||''',''yyyy-mm-dd'')';
  execute immediate v_substr;
  commit;
end P_FDISARRSEQUENCETIMELD;
/

prompt
prompt Creating procedure P_LOADASGNREMPROUTETMP
prompt =========================================
prompt
create or replace procedure aptspzh.p_LoadASGNREMPROUTETMP(v_routeid in NVARCHAR2,
                                                   v_rundate in NVARCHAR2) is

  v_count  number;
  v_substr varchar2(4000);
begin
  select count(*)
    into v_count
    from asgnremproutetmp
   where routeid = v_routeid
     and RECDATE = to_date(v_rundate, 'yyyy-MM-dd hh24:mi:ss');
  if v_count = 0 then
    select count(*)
      into v_count
      from asgnremproutetmp2
     where routeid = v_routeid
       and RECDATE = to_date(v_rundate, 'yyyy-MM-dd hh24:mi:ss');
    if v_count > 0 then
      v_substr := 'INSERT INTO ASGNREMPROUTETMP
  (REMPRID,
   EMPID,
   ROUTEID,
   RECDATE,
   ARRANGEID,
   EMPSTATUS,
   EMPSTATUSDETAIL,
   EMPPAYMULTIPLE,
   MEMOS)
  SELECT S_ASGNREMPROUTETMP.NEXTVAL,
         AEMP.EMPID,
         AEMP.ROUTEID,
         AEMP.RECDATE,
         AEMP.ARRANGEID,
         AEMP.EMPSTATUS,
         AEMP.EMPSTATUSDETAIL,
         AEMP.EMPPAYMULTIPLE,
         AEMP.MEMOS
    FROM ASGNREMPROUTETMP2 AEMP,asgnarrangegd ARR
   WHERE AEMP.ARRANGEID=ARR.ARRANGEID
   AND ARR.STATUS=''d''
   AND ARR.ISYUAN=''0''
   AND AEMP.ROUTEID=(' || v_routeid || ')
   AND AEMP.RECDATE=to_date(''' || v_rundate ||
                  ''' ,''yyyy-MM-dd hh24:mi:ss'')';
    else
      v_substr := 'INSERT INTO ASGNREMPROUTETMP
  (REMPRID,
   EMPID,
   ROUTEID,
   RECDATE,
   ARRANGEID,
   EMPSTATUS,
   MEMOS)
  SELECT S_ASGNREMPROUTETMP.NEXTVAL,
         EMPID,
         ROUTEID,
         to_date(''' || v_rundate || ''' ,''yyyy-MM-dd hh24:mi:ss''),
         '''',
         1,
         ''''
    FROM asgnremprouteld
   WHERE ROUTEID=(' || v_routeid || ')';
    end if;
  execute immediate v_substr;
  end if;
  commit;
end p_LoadASGNREMPROUTETMP;
/

prompt
prompt Creating procedure P_LOADSENDPARAM
prompt ==================================
prompt
create or replace procedure aptspzh.P_LoadSendParam(v_routeid in NVARCHAR2) is
  v_count number;
begin
  v_count := 0;
  select count(*)
    into v_count
    from fdissendparam
   where isactive = '1'
     and rundate = trunc(sysdate)
     AND ROUTEID =v_routeid;
  if (v_count < 1) then
    insert into fdissendparam
      (SENDPARAMID,
       STYLE,
       ROUTEID,
       SUBROUTEID,
       SEGMENTID,
       BUSID,
       LEAVETIME,
       ARRIVETIME,
       LEAVESTATION,
       ARRIVESTATION,
       RUNDATE,
       ISACTIVE,
       CREATED,
       UPDATED,
       MILENUM,
       ISUSE,
       REMINDEDTIME,
       MIDSTATION,
       ISAVAILABLE)
      select S_FDISSENDPARAM.Nextval,
             STYLE,
             ROUTEID,
             SUBROUTEID,
             SEGMENTID,
             BUSID,
             to_date(to_char(sysdate, 'yyyy-mm-dd') || ' ' ||
                     to_char(LEAVETIME, 'hh24:mi:ss'),
                     'yyyy-mm-dd hh24:mi:ss'),
             to_date(to_char(sysdate, 'yyyy-mm-dd') || ' ' ||
                     to_char(ARRIVETIME, 'hh24:mi:ss'),
                     'yyyy-mm-dd hh24:mi:ss'),
             LEAVESTATION,
             ARRIVESTATION,
             trunc(sysdate),
             isactive,
             sysdate,
             sysdate,
             MILENUM,
             '0',
              to_date(to_char(sysdate, 'yyyy-mm-dd') || ' ' ||
                     to_char(REMINDEDTIME, 'hh24:mi:ss'),
                     'yyyy-mm-dd hh24:mi:ss'),
             MIDSTATION,
             '0'
        from fdissendparam
       where routeid = v_routeid
         and rundate = to_date('2000-01-01', 'yyyy-mm-dd')
         and isactive = '1';
    commit;
  end if;
end P_LoadSendParam;
/

prompt
prompt Creating procedure P_FDISJOB
prompt ============================
prompt
create or replace procedure aptspzh.p_fdisJob as
  --v_routeidlist varchar2(1000);
  v_begintime    varchar2(100);
  v_endtime      varchar2(100);
  v_begintimetwo varchar2(100);
  CURSOR v_route_cur is
    select routeid from mcrouteinfogs;
begin
  v_begintime    := 'date''' || to_char(sysdate+1, 'yyyy-mm-dd') || '''';
  v_endtime      := 'date''' || to_char(sysdate +2, 'yyyy-mm-dd') || '''';
  v_begintimetwo := to_char(trunc(sysdate+1), 'yyyy-mm-dd hh24:mi:ss');
  for v_route in v_route_cur loop
    begin
      p_displansync(' (' || v_route.routeid || ') ',
                    v_begintime,
                    v_endtime);
      P_ARRANGEANDEMP_PROCESS(v_route.routeid, v_begintimetwo);
      P_LoadSendParam(v_route.routeid);
      p_LoadASGNREMPROUTETMP(v_route.routeid, v_begintimetwo);
    end;
  end loop;
  --v_routeidlist:= rtrim(v_routeidlist,',');
  --P_ARRANGEANDEMP_PROCESS(v_routeidlist,to_char(trunc(sysdate),'yyyy-mm-dd hh24:mi:ss'));
end p_fdisJob;
/

prompt
prompt Creating procedure P_FUEL_BEGINE_PROCESS
prompt ========================================
prompt
create or replace procedure aptspzh.P_FUEL_BEGINE_PROCESS IS
  /***************************************************
  ���ƣ�P_FUEL_BEGINE_PROCESS
  ��;�������ڳ���������(����)
  �����:   DI_WX_FUELCOSTIMPORTGD
  ��д��    ����    20120531
  �޸ģ�
  ***************************************************/
  V_FIRSTDATE DATE; -- ָ���µ�һ��
  V_LASTDATE  DATE; -- ָ�������һ��
BEGIN
  --1����ȡ�����ڳ�����ĩ����
  SELECT TO_DATE(TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MONTH'),
                         'YYYY-MM-DD'),
                 'YYYY-MM-DD') FIRSTDATE,
         TO_DATE(TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, -1)), 'YYYY-MM-DD'),
                 'YYYY-MM-DD') LASTDATE
    INTO V_FIRSTDATE, V_LASTDATE
    FROM DUAL;

  -- ɾ�������Ѿ����ɵ��ڳ���������
  DELETE FROM DI_WX_FUELCOSTIMPORTGD TT
   WHERE TT.RUNDATADATE > V_LASTDATE
     AND TT.FUELAPP = '3';
  COMMIT;

  --��������ĩ���ͼ�¼���뵽�����ڳ�����
  INSERT INTO DI_WX_FUELCOSTIMPORTGD
    (FUELCOSTIMPORTID,
     RUNDATADATE,
     BUSSELFID,
     FUELTYPE,
     FUELNUM,
     FUELSUM,
     PLACE,
     DISTRIBUTEDFLAG,
     ASSESSOR,
     RECORDER,
     RECDATADATE,
     IMPFLAG,
     ORGID,
     BUSID,
     FUELAPP,
     FUELPRICE,
     CREATED)
    SELECT S_RBUSROUTEID.NEXTVAL AS FUELCOSTIMPORTID, FUELCOST.*
      FROM (SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM') || '-01',
                           'YYYY-MM-DD') RUNDATADATE,
                   FUELCOST.BUSSELFID,
                   FUELCOST.FUELTYPE,
                   -FUELCOST.FUELNUM,
                   FUELCOST.FUELSUM,
                   FUELCOST.PLACE,
                   FUELCOST.DISTRIBUTEDFLAG,
                   FUELCOST.ASSESSOR,
                   FUELCOST.RECORDER,
                   FUELCOST.RECDATADATE,
                   FUELCOST.IMPFLAG,
                   FUELCOST.ORGID,
                   FUELCOST.BUSID,
                   '3' FUELAPP,
                   FUELCOST.FUELPRICE,
                   SYSDATE
              FROM DI_WX_FUELCOSTIMPORTGD FUELCOST
             WHERE FUELCOST.RUNDATADATE >= V_FIRSTDATE
               AND FUELCOST.RUNDATADATE <= V_LASTDATE
               AND FUELCOST.FUELAPP = '4') FUELCOST;
  --1 ���ڱ䶯��¼
END P_FUEL_BEGINE_PROCESS;
/

prompt
prompt Creating procedure P_GETCLIENTID
prompt ================================
prompt
create or replace procedure aptspzh.P_GETCLIENTID(v_systype in number, v_macaddress in NVARCHAR2, v_ipaddress in nvarchar2, v_machinename in nvarchar2, v_userid in NVARCHAR2, v_clientid out number, v_clientcode out number) is
 v_count number;
 v_count1 number;
begin
v_count := 0;
v_count1 := 0;
  select count(*) into v_count from AD_CLIENTCODE;
  if ( v_count > 0 ) then
      select count(*) into v_count1 from AD_CLIENTCODE where MACADDRESS = v_macaddress and SYSTYPE = v_systype;
      if ( v_count1 > 0 ) then
          select CLIENTCODE into v_clientcode from AD_CLIENTCODE where MACADDRESS = v_macaddress and SYSTYPE = v_systype;
          v_clientid := 100000 + v_clientcode;
      end if;
      if (v_count1 < 1) then
          select max(CLIENTCODE) + 1 into v_clientcode from AD_CLIENTCODE;
          v_clientid := 100000 + v_clientcode;
          insert into AD_CLIENTCODE (MACADDRESS, IPADDRESS, MACHINENAME, SYSTYPE, CLIENTID, CLIENTCODE, USERID) values (v_macaddress, v_ipaddress, v_machinename, v_systype, v_clientid, v_clientcode, v_userid);
          commit;
      end if;
  end if;
  if (v_count < 1) then
     v_clientcode := 10;
     v_clientid := 100000 + v_clientcode;
     insert into AD_CLIENTCODE (MACADDRESS, IPADDRESS, MACHINENAME, SYSTYPE, CLIENTID, CLIENTCODE, USERID) values (v_macaddress, v_ipaddress, v_machinename, v_systype, v_clientid, v_clientcode, v_userid);
     commit;
  end if;


end P_GETCLIENTID;
/

prompt
prompt Creating procedure P_GETCLIENTID2
prompt =================================
prompt
create or replace procedure aptspzh.P_GETCLIENTID2(v_systype    in number,
                                           v_userid     in NVARCHAR2,
                                           v_clientcode out number) is
  v_count  number;
  v_count1 number;
begin
  v_count  := 0;
  v_count1 := 0;
  select count(*) into v_count from mcruserclientid;
  if (v_count > 0) then
    select count(*)
      into v_count1
      from mcruserclientid
     where userid = v_userid
       and SYSTYPE = v_systype;
    if (v_count1 > 0) then
      select CLIENTID
        into v_clientcode
        from mcruserclientid
       where userid = v_userid
         and SYSTYPE = v_systype;
    end if;
    if (v_count1 < 1) then
      select max(CLIENTID) + 1 into v_clientcode from mcruserclientid;
      insert into mcruserclientid
        (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID)
      values
        (v_clientcode + 200000000, v_userid, v_systype, v_clientcode);
      commit;
    end if;
  end if;
  if (v_count < 1) then
    v_clientcode := 200000;
    insert into mcruserclientid
      (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID)
    values
      (v_clientcode + 200000000, v_userid, v_systype, v_clientcode);
    commit;
  end if;

end P_GETCLIENTID2;
/

prompt
prompt Creating procedure P_GETCLIENTVOIP
prompt ==================================
prompt
create or replace procedure aptspzh.P_GETCLIENTVOIP(v_systype in number, v_userid in NVARCHAR2, v_machineid in NVARCHAR2, v_ip in NVARCHAR2, v_clientcode out number) is
 v_count number;
 v_count1 number;
begin
v_count := 0;
v_count1 := 0;
  select count(*) into v_count from mcruserclientid;
  if ( v_count > 0 ) then
      select count(*) into v_count1 from mcruserclientid where userid = v_userid and SYSTYPE = v_systype and MACHINEID = v_machineid;
      if ( v_count1 > 0 ) then
          select CLIENTID into v_clientcode from mcruserclientid where userid = v_userid and SYSTYPE = v_systype and MACHINEID = v_machineid;
      end if;
      if (v_count1 < 1) then
          select max(CLIENTID) + 1 into v_clientcode from mcruserclientid where SYSTYPE <> 9;

          insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID, MACHINEID, IPADDRESS) values (v_clientcode + 100000000, v_userid, v_systype, v_clientcode, v_machineid, v_ip);
          commit;
      end if;
  end if;
  if (v_count < 1) then
     v_clientcode := 100000;
     insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID, MACHINEID, IPADDRESS) values (v_clientcode + 100000000, v_userid, v_systype, v_clientcode, v_machineid, v_ip);
     commit;
  end if;

  /*select count(*) into v_count from mcruserclientid where SYSTYPE = 9;
  if ( v_count > 0 ) then
      -- voip, ����Ϊ9
      select count(*) into v_count1 from mcruserclientid where userid = v_userid and SYSTYPE = 9;
      if ( v_count1 > 0 ) then
          select VOIPID into v_voipid from mcruserclientid where userid = v_userid and SYSTYPE = 9;
      end if;
      if (v_count1 < 1) then
          select max(VOIPID) + 1 into v_voipid from mcruserclientid where SYSTYPE = 9;

          insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, VOIPID, MACHINEID) values (v_userid, v_userid, 9, v_voipid, v_machineid);
          commit;
      end if;
  end if;
  if (v_count < 1) then
     v_voipid := 1000;
     insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, VOIPID, MACHINEID) values (v_userid, v_userid, 9, v_voipid, v_machineid);
     commit;
  end if;*/
end P_GETCLIENTVOIP;
/

prompt
prompt Creating procedure P_GETCLIENTVOIPID
prompt ====================================
prompt
create or replace procedure aptspzh.P_GETCLIENTVOIPID(v_systype in number, v_userid in NVARCHAR2, v_machineid in NVARCHAR2, v_ip in NVARCHAR2,v_clientcode out number, v_voipid out number) is
 v_count number;
 v_count1 number;
begin
v_count := 0;
v_count1 := 0;
  select count(*) into v_count from mcruserclientid;
  if ( v_count > 0 ) then
      select count(*) into v_count1 from mcruserclientid where userid = v_userid and SYSTYPE = v_systype and MACHINEID = v_machineid;
      if ( v_count1 > 0 ) then
          select CLIENTID into v_clientcode from mcruserclientid where userid = v_userid and SYSTYPE = v_systype and MACHINEID = v_machineid;
      end if;
      if (v_count1 < 1) then
          select max(CLIENTID) + 1 into v_clientcode from mcruserclientid where SYSTYPE <> 9;

          insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID, MACHINEID, IPADDRESS) values (v_clientcode + 100000000, v_userid, v_systype, v_clientcode, v_machineid, v_ip);
          commit;
      end if;
  end if;
  if (v_count < 1) then
     v_clientcode := 100000;
     insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, CLIENTID, MACHINEID, IPADDRESS) values (v_clientcode + 100000000, v_userid, v_systype, v_clientcode, v_machineid, v_ip);
     commit;
  end if;

  if v_systype = 54 or  v_systype = 55 then
    select count(*) into v_count from mcruserclientid where SYSTYPE = 9;
    if ( v_count > 0 ) then
        -- voip, ����Ϊ9
        select count(*) into v_count1 from mcruserclientid where userid = v_userid and SYSTYPE = 9;
        if ( v_count1 > 0 ) then
            select VOIPID into v_voipid from mcruserclientid where userid = v_userid and SYSTYPE = 9;
        end if;
        if (v_count1 < 1) then
            select max(VOIPID) + 1 into v_voipid from mcruserclientid where SYSTYPE = 9;

            insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, VOIPID, MACHINEID, IPADDRESS) values (v_userid, v_userid, 9, v_voipid, v_machineid, v_ip);
            commit;
        end if;
    end if;
    if (v_count < 1) then
       v_voipid := 1000;
       insert into mcruserclientid (RRUSERCLIENTID, USERID, SYSTYPE, VOIPID, MACHINEID, IPADDRESS) values (v_userid, v_userid, 9, v_voipid, v_machineid, v_ip);
       commit;
    end if;
  end if;

end P_GETCLIENTVOIPID;
/

prompt
prompt Creating procedure P_HC_SEGMENT_GPS
prompt ===================================
prompt
create or replace procedure aptspzh.P_HC_SEGMENT_GPS(v_routeid in number,
                                                                    v_segid in varchar2,
                                                                    v_begintime in date,
                                                                    v_endtime in date,
                                                                    v_busid   in varchar2,
                                                                    v_count in number,
                                                                    P_flag   in varchar2) is
  TYPE T_CURSOR IS REF CURSOR;
/**********************************************
  name :p_HC_SEGMENT_GPS
  createby: NY_COICE
  CREATED:20130914
  USE TO: ��ͼΪ�Ȼ���ϵͳд����·���й켣
  table:  GPS���� bsvcbusrundatald5
           д�� HC_SEGMENT(ͼΪ����)
  memos��׼������· ����2������д�� ��������ID Ϊ '1'||ԭ����ID
               ��p_HC_SEGMENT����
  UPDATEBY: 20131118 alter by zhuangxinzhou ����ʱ�䳤�̼������GPS���� ���жԱȣ��޸� flag
  UPDATERD:
  **********************************************/
  CUR_GPS                     T_CURSOR;
  v_gps                          clob;
  v_gpsplus                    clob;
  v_count_gps                 number(8);
  v_count_gps_std           number(8);
  v_seg_flag                   number(1);
  v_flag                          number(1);
begin
             v_flag:=p_flag;
            v_gps:=null;
            v_count_gps:=0;
            v_count_gps_std:= (v_endtime-v_begintime) *24*60*60/15;
             select       nvl(min(nvl(a.flag, 0)),0)      into     v_seg_flag
              from hc_segment a where a.segmentid=v_segid;
                                select count(1) into v_count_gps from bsvcbusrundatald5 bsvc
                                    where bsvc.actdatetime between V_begintime  and  v_endtime
                                          and bsvc.routeid=v_routeid
                                          and bsvc.productid=(select productid from mcrbusbusmachinegs where busid=v_busid)
                                          and bsvc.longitude<>0 and bsvc.latitude<>0;
                  IF    v_count_gps<v_count_gps_std*2/3 THEN
                    v_flag:=0;
                    END IF;
                  IF  v_count_gps>v_count  OR v_flag=0  then
                                      OPEN CUR_GPS FOR
                                       select  LONGITUDE||','||LATITUDE||',' jwd  from bsvcbusrundatald5 bsvc
                                                            where bsvc.actdatetime between V_begintime  and  V_endtime
                                                                  and bsvc.routeid=v_routeid
                                                                  and bsvc.productid=(select productid from mcrbusbusmachinegs where busid=v_busid)
                                                                  and bsvc.longitude<>0 and bsvc.latitude<>0
                                                                ORDER BY bsvc.actdatetime
                                  ;
                                     LOOP
                                       FETCH CUR_GPS  INTO v_gpsplus;
                                         if       v_gpsplus is not null then
                                                   v_gps:=v_gps||v_gpsplus;
                                                            v_gpsplus:='';
                                         end if ;
                                      EXIT WHEN CUR_GPS%NOTFOUND;
                                     END LOOP;
                                  CLOSE CUR_GPS;
                                  delete from hc_segment where SEGMENTID= v_segid;
                                    commit;
                                  --д��GPS����
                                 v_gps:=substr(v_gps,1,length(v_gps) - 1);
                                 insert into hc_segment (SEGMENTID, jwd,UPDATED,flag) VALUES (v_segid,v_gps,sysdate,v_flag);
                                 commit;
                                 v_gps:='';
                               END IF;
end;
/

prompt
prompt Creating procedure P_HC_SEGMENT_STATION
prompt =======================================
prompt
create or replace procedure aptspzh.p_HC_SEGMENT_STATION(v_segid in varchar2) is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_station    T_CURSOR;
  v_serialid    number;
  v_gps         clob;
  v_gpsplus     clob;
BEGIN
--ɾ�������ݣ�
delete from hc_segment where segmentid= v_segid;
commit;
v_gps:=null;
OPEN CUR_station FOR
        select distinct b.sngserialid from hc_station b where b.segmentid=v_segid
        and nvl(LONGITUDE,0) <>0 and nvl(LATITUDE,0) <>0 order by b.sngserialid;
      LOOP
        FETCH CUR_station
          INTO v_serialid;
 if v_serialid is not null then
      select a.LONGITUDE||','||a.LATITUDE||','  into v_gpsplus from hc_station  a where a.segmentid=v_segid and a.sngserialid=v_serialid;
      v_gps:=v_gps||v_gpsplus;
      v_gpsplus:='';
 end if;
        EXIT WHEN CUR_station%NOTFOUND;
      END LOOP;
      CLOSE CUR_station;
v_gps:=substr(v_gps,1,length(v_gps) - 1);
insert into hc_segment (SEGMENTID, jwd,UPDATED,flag) VALUES (v_segid,v_gps,sysdate,0);
commit;
end p_HC_SEGMENT_STATION;
/

prompt
prompt Creating procedure P_HC_SEGMENT
prompt ===============================
prompt
create or replace procedure aptspzh.p_HC_SEGMENT is
  TYPE T_CURSOR IS REF CURSOR;
  /**********************************************
  name :p_HC_SEGMENT
  createby: NY_COICE
  CREATED:20130914
  USE TO: ��ͼΪ�Ȼ���ϵͳд����·���й켣
  table: �������� MCROUTEINFOGS,MCSEGMENTINFOGS
           ҵ������ FDISDISPLANLD
           GPS���� bsvcbusrundatald5
           д�� HC_SEGMENT(ͼΪ����)
  memos��׼������· ����2������д�� ��������ID Ϊ '1'||ԭ����ID
               д��������� p_HC_SEGMENT_GPS(v_routeid,v_segid,V_begintime,v_MIDtime,v_busid,v_count )
               ȡ��·��Ӫ�˳��� ǰ2���� ��2���ӵ�GPS���� д��HC_SEGMENT
               ׼���� ת������ �����У�ȡ����վ֮���м�ֵʱ�� Ϊ ���н��� ���п�ʼ
               rundate ȡ�������� һ��ȡ����
               v_count ���ٸ�GPS����Ϊ�������� Ĭ��Ϊ100

  UPDATEBY:    20131101 �޸� ׼���� д��һ������һ����д������
                             ���û�������������ݣ���ǰ��2��
  UPDATERD:
  **********************************************/
  CUR_seg          T_CURSOR;
  CUR_DISPLAN      T_CURSOR;
  V_ROUTETYPE      varchar2(2);
  V_SEGMENTTYPE    varchar2(2);
  V_FALSEROUTETYPE varchar2(2);
  V_ROUTEID        NUMBER(8);
  V_MIDSERIALID    NUMBER(3);
  V_begintime      date;
  v_endtime        date;
  v_MIDtime        date;
  v_updated        date;
  v_rsupdated      date;
  v_segid          varchar2(20);
  v_BUSid          varchar2(20);
  v_rundate        date;
  v_rundate1       date;
  v_count          number(8);
  v_count_displan  number(8);
  v_length_jwd     number(8);
  v_flag           varchar2(2);

BEGIN
  v_rundate       := trunc(sysdate-1 );
  v_rundate1      := trunc(sysdate-1 );
  v_count         := 50;
  v_count_displan := 0;
  v_flag          := '1';
  --��ȡ��·
  OPEN CUR_seg FOR
    SELECT R.ROUTEID,
           S.SEGMENTID,
           R.ROUTETYPE,
           R.FALSEROUTETYPE,
           S.RUNDIRECTION
      FROM MCROUTEINFOGS R, MCSEGMENTINFOGS S
     WHERE S.ROUTEID = R.ROUTEID--and r.routeid=58
       AND S.ISACTIVE = 1
       AND R.ISACTIVE = 1
     ORDER BY R.ROUTEID, S.SEGMENTID;
  LOOP
    FETCH CUR_seg
      INTO V_ROUTEID, v_segid, V_ROUTETYPE, V_FALSEROUTETYPE, V_SEGMENTTYPE;
    EXIT WHEN CUR_seg%NOTFOUND;
    select max(nvl(nvl(updated, created), date '2011-1-1')) + 1
      into v_rsupdated
      from mcrsegmentstationgs
     where routeid = V_ROUTEID
       AND SEGMENTID = v_segid;
    select min(length(nvl(a.jwd, 0))),
           min(nvl(a.flag, 0)),
           min(nvl(a.updated, date '2000-1-1'))
      into v_length_jwd, v_flag, v_updated
      from hc_segment a, hc_line line
     where line.routeid = v_routeid
       and line.segmentid = a.segmentid(+);
    IF v_rsupdated > V_updated OR v_flag = 0 then
      SELECT count(1)
        into v_count_displan
        FROM FDISDISPLANLD F, MCSEGMENTINFOGS SEG
       WHERE F.RUNDATE = v_rundate
         AND f.isfinished = 1
         and f.gpsmile > 0
           AND F.SEGMENTID = SEG.SEGMENTID
           AND F.STARTSTATIONID = SEG.FSTSTATIONID
           AND F.ENDSTATIONID = SEG.LSTSTATIONID
         and f.routeid = V_ROUTEID
         AND F.SEGMENTID = v_segid
       order by abs(f.gpsmile - f.milenum);
      if v_count_displan = 0 then
        v_rundate1 := v_rundate - 2;
      end if;
      --��ȡʱ������
      OPEN CUR_DISPLAN FOR
        SELECT f.busid,
               f.realleavetime - (1 / 1440),
               f.realarrivettime + (1 / 1440)
          FROM FDISDISPLANLD F, MCSEGMENTINFOGS SEG
         WHERE F.RUNDATE between v_rundate1 and v_rundate
           AND f.isfinished = 1
           and rectype = 1
           and f.gpsmile > 0
           AND F.SEGMENTID = SEG.SEGMENTID
           AND F.STARTSTATIONID = SEG.FSTSTATIONID
           AND F.ENDSTATIONID = SEG.LSTSTATIONID
           and f.routeid = V_ROUTEID
           AND F.SEGMENTID = v_segid
         order by abs(f.gpsmile - f.milenum);
      LOOP
        FETCH CUR_DISPLAN
          INTO V_BUSID, V_begintime, v_endtime;
        IF NOT (V_FALSEROUTETYPE = 1 AND V_ROUTETYPE = 2) THEN
          P_HC_SEGMENT_GPS(v_routeid,
                           v_segid,
                           V_begintime,
                           v_endtime,
                           v_busid,
                           v_count,
                           '1');
        ELSE
          SELECT RS.DUALSERIALID
            INTO V_MIDSERIALID
            FROM MCRSEGMENTSTATIONGS RS
           WHERE RS.ROUTEID = V_ROUTEID
             AND RS.SEGMENTID = V_SEGID
             AND RS.STATIONTYPEID = '12';
          select MIN(actdatetime) +
                 (MAX(actdatetime) - MIN(actdatetime)) / 2
            into v_MIDTIME
            from bsvcbusrundatald5 bsvc
           where bsvc.actdatetime between V_begintime and v_endtime
             and bsvc.routeid = v_routeid
             and bsvc.productid = (select productid
                                     from mcrbusbusmachinegs
                                    where busid = v_busid)
             AND BSVC.STATIONSEQNUM = V_MIDSERIALID;
             v_length_jwd:=0;
             v_flag:=0;
         select min(length(nvl(a.jwd, 0))),
                 min(nvl(a.flag, 0)),
                 min(nvl(a.updated, date '2000-1-1'))
            into v_length_jwd, v_flag, v_updated
            from hc_segment a
           where  a.segmentid IN (V_SEGID,'1'||V_SEGID);
          if not (v_length_jwd > v_count * 20 and v_flag = '1' and
              v_updated > trunc(sysdate)) then
            IF v_MIDTIME IS NULL THEN
              v_MIDTIME := V_begintime + (v_endtime - V_begintime) / 2;
              v_flag    := '0';
            END IF;
            IF v_MIDTIME IS not NULL THEN
              v_flag := '1';
            end if;
            --д�� ���в���
            P_HC_SEGMENT_GPS(v_routeid,
                             v_segid,
                             V_begintime,
                             v_MIDtime,
                             v_busid,
                             v_count,
                             v_flag);
            --д�� ���в���
            P_HC_SEGMENT_GPS(v_routeid,
                             '1' || v_segid,
                             v_MIDtime,
                             v_endtime,
                             v_busid,
                             v_count,
                             v_flag);
          end if;
        END IF;
             v_length_jwd:=0;
             v_flag:=0;
         select min(length(nvl(a.jwd, 0))),
                 min(nvl(a.flag, 0)),
                 min(nvl(a.updated, date '2000-1-1'))
            into v_length_jwd, v_flag, v_updated
            from hc_segment a
           where  a.segmentid IN (V_SEGID,'1'||V_SEGID);
        EXIT WHEN(CUR_DISPLAN%NOTFOUND OR
                  (v_length_jwd > v_count * 20 and v_flag = 1 and
                  v_updated > trunc(sysdate)));
      END LOOP;
      CLOSE CUR_DISPLAN;
    end if;
   select NVL(min(length(nvl(a.jwd, 0))),0)
          into v_length_jwd
          from hc_segment a
         where a.segmentid=V_SEGID;
     IF v_length_jwd<5 THEN
      p_HC_SEGMENT_STATION(V_SEGID);
      END IF;
     select NVL( min(length(nvl(a.jwd, 0))),0)
            into v_length_jwd
            from hc_segment a
           where a.segmentid='1'||V_SEGID;
     IF v_length_jwd<5 THEN
      p_HC_SEGMENT_STATION('1'||V_SEGID);
      END IF;
 END LOOP;
  CLOSE CUR_SEG;
end p_HC_SEGMENT;
/

prompt
prompt Creating procedure P_HC_SEGMENT_ATIS
prompt ====================================
prompt
create or replace procedure aptspzh.P_HC_SEGMENT_ATIS(P_ROUTEID IN NUMBER) is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_station    T_CURSOR;
  CUR_ROUTE    T_CURSOR;
  v_gps         clob;
  v_gpsplus     clob;
  v_segid          varchar2(20);
BEGIN
 OPEN CUR_ROUTE FOR
    SELECT R.segmentid
      FROM hc_line R
     WHERE  R.ROUTEID = P_ROUTEID
        or NVL(P_ROUTEID,0) =0
     ORDER BY R.ROUTEID;
  LOOP
    FETCH CUR_ROUTE  INTO v_segid;
    EXIT WHEN CUR_ROUTE%NOTFOUND;
    delete from hc_segment where segmentid=v_segid;
    Commit;
    V_GPS:=NULL;
    OPEN CUR_station FOR
            select case when (S.LONGITUDE<>0 and S.LATITUDE <>0) and NVL(to_char(a.jwd),'0')<>'0'
                                     then  S.LONGITUDE||','||S.LATITUDE||';'||to_char(a.jwd)||';'
                            when  (S.LONGITUDE<>0 and S.LATITUDE <>0) and NVL(to_char(a.jwd),'0')='0'
                                     then  S.LONGITUDE||','||S.LATITUDE||';'
                            when  not(S.LONGITUDE<>0 and S.LATITUDE <>0 )and NVL(to_char(a.jwd),'0')<>'0'
                                     then to_char(a.jwd)||';'
                            else null
                       end gps
                from hc_station h, atis_segstaline a,MCSTATIONINFOGS S
               where h.routeid_Original = a.ROUTEID(+)
                 and h.subrouteid_Original = a.subrouteid(+)
                 and h.stationid = a.stastationid(+)
                 AND h.stationid=S.STATIONID
               --  and h.routeid_Original = 101
                 and h.SEGMENTID=v_segid
                 order by h.segmentid, h.sngserialid;
          LOOP
            FETCH CUR_station
              INTO v_gpsplus;
              v_gps:=v_gps||v_gpsplus;
              v_gpsplus:='';
          EXIT WHEN CUR_station%NOTFOUND;
         END LOOP;
        CLOSE CUR_station;
        v_gps:=substr(v_gps,1,length(v_gps) - 1);
        insert into hc_segment (SEGMENTID, jwd,UPDATED,flag)
                    VALUES (v_segid,v_gps,sysdate,1);
        commit;
    END LOOP;
   CLOSE CUR_ROUTE;
END P_HC_SEGMENT_ATIS;
/

prompt
prompt Creating procedure P_HC_SEGMENT_INTO
prompt ====================================
prompt
create or replace procedure aptspzh.p_HC_SEGMENT_INTO is
TYPE T_CURSOR IS REF CURSOR;
  CUR_into    T_CURSOR;
v_segmentid varchar2(200);
BEGIN
--ɾ�������ݣ�
delete from hc_segment where 1=1;
commit;

OPEN CUR_into FOR
        select distinct t.segmentid from mcsegmentinfogs t where t.isactive='1';
      LOOP
        FETCH CUR_into
          INTO v_segmentid;
 if v_segmentid is not null then
 begin
 p_HC_SEGMENT_station(v_segmentid);
 end;
 end if;
        EXIT WHEN CUR_into%NOTFOUND;
      END LOOP;
      CLOSE CUR_into;
end p_HC_SEGMENT_INTO;
/

prompt
prompt Creating procedure P_HR_BACKUPBUSRUNSHIFTSALARY
prompt ===============================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_BACKUPBUSRUNSHIFTSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                         V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                         V_RECDATE   IN DATE, --��¼����
                                                         V_MONTH     IN VARCHAR2 --ͳ���·�
                                                         ) is
  /*****************
  ���๤��
  ******************/
  -- ���๤��
  V_BACKUPBUSRUNSHIFTSALARY_PARA NUMBER := 0;
begin
  SELECT HSC.VALUE
    INTO V_BACKUPBUSRUNSHIFTSALARY_PARA
    FROM HR_SALARY_CONFIGS HSC
   WHERE HSC.SECTION = 'BBCZ';
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT bb.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   bb.ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select bb.empid,
                           sum(case
                                 when bb.bbccs > 0 then
                                  bb.bbccs
                                 else
                                  0
                               end) ITEMVALUE
                      from (select bc.empid,
                                   bc.recdate,
                                   round(nvl2(bc.bbcc,
                                              V_BACKUPBUSRUNSHIFTSALARY_PARA * (bc.bbcc - nvl(yx.seqnum1,0) +
                                               nvl(gz.seqnum2,0) +  nvl(lb.seqnum3,0)) /
                                              bc.bbcc,
                                              0),
                                         2) bbccs
                              from /*�������ڼ���������� Start*/
                                   (select es.empid,
                                           es.recdate,
                                           sum(ds.standardvalue) bbcc
                                      from ASGNREMPROUTETMP    es,
                                           HR_DRIVERSTANDARDGD ds
                                     where es.routeid = ds.routeid
                                       and ds.stdtdate = V_MONTH
                                       and ds.standardclassic = '0'
                                       and es.empstatus = '2'
                                       and es.empstatusdetail = '2'
                                       and es.recdate >= TRUNC(V_STARTDATE)
                                       and es.recdate <= TRUNC(V_ENDDATE)
                                     group by es.empid, es.recdate) bc,
                                   /*�������ڼ���������� end*/
                                   /*��Ч����� Start*/
                                   (select sum(fsr.seqnum) seqnum1,
                                           fsr.driverid,
                                           fsr.rundatadate
                                      from fdisbusrunrecgd fsr
                                     where fsr.isavailable = '1'
                                       and fsr.rundatadate >=
                                           TRUNC(V_STARTDATE)
                                       and fsr.rundatadate <= TRUNC(V_ENDDATE)
                                       and fsr.bussid in
                                           (SELECT column_value as bussid
                                              FROM TABLE(CAST(fn_split((select ''',' ||
                                                                              t.bussidlist ||
                                                                              ','''
                                                                         from mcrectypeinfogs t
                                                                        where t.rectype = '1'),
                                                                       ''',''') AS
                                                              ty_str_split))
                                             where column_value is not null)
                                     group by fsr.driverid, fsr.rundatadate) yx,
                                   /*��Ч����� end*/
                                   /*���ϱ����Ϊ����İ�� Start*/
                                   (select sum(fdp.seqnum) seqnum2,
                                           fdp.driverid,
                                           fdp.rundate
                                      from FDISBUSTRUBLELD tru,
                                           fdisdisplanld   fdp
                                     where tru.bustrbid = fdp.displanbustrbid
                                       and tru.prostatus = '1'
                                       and tru.verifystatus = '1'
                                       and fdp.rundate >= TRUNC(V_STARTDATE)
                                       and fdp.rundate <= TRUNC(V_ENDDATE)
                                     group by fdp.driverid, fdp.rundate) gz,
                                   /*1.1.2 �ð��е�·���¼(�������) Start*/
                                   (select fdp.driverid,
                                           sum(fdp.seqnum) seqnum3,
                                           fdp.rundate
                                      from FDISFAKESEQGD fake,
                                           fdisdisplanld fdp
                                     where fake.fakeseqid =
                                           fdp.displanfakeseqid
                                       and fake.prostatus = '1'
                                       and fake.verifystatus = '1'
                                       and fdp.rundate >= V_STARTDATE
                                       and fdp.rundate <= V_ENDDATE
                                     group by fdp.driverid, fdp.rundate) lb
                            /*1.1.2 �ð��е�·���¼(�������) enf*/
                            /*���ϱ����Ϊ����İ�� end*/
                             where bc.empid = yx.driverid(+)
                               and bc.recdate = yx.rundatadate(+)
                               and bc.empid = gz.driverid(+)
                               and bc.recdate = lb.rundate(+)
                               and bc.empid = lb.driverid(+)
                               and bc.recdate = gz.rundate(+)) bb
                     group by bb.empid) bb,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '9');
  commit;
end P_HR_BACKUPBUSRUNSHIFTSALARY;
/

prompt
prompt Creating procedure P_HR_BUSRUNSHIFTALLOWANCE
prompt ============================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_BUSRUNSHIFTALLOWANCE(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                      V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                      V_RECDATE   IN DATE, --��¼����
                                                      V_MONTH     IN VARCHAR2 --ͳ���·�
                                                      ) is
  /*****************
  ��Ч��β���
  ******************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT YXBC.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   allowance ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select sum(t.allowance) allowance, t.empid
                      from (select (t1.seqnum * t3.standardvalue) allowance,
                                   t1.driverid empid,
                                   t1.routeid
                              from (select sum(fsr.seqnum) seqnum,
                                           fsr.driverid,
                                           fsr.routeid
                                      from fdisbusrunrecgd fsr
                                     where fsr.rundatadate >=
                                           TRUNC(V_STARTDATE)
                                       and fsr.rundatadate <= TRUNC(V_ENDDATE)
                                       and fsr.isavailable = '1'
                                       and fsr.bussid in
                                           (SELECT column_value as bussid
                                              FROM TABLE(CAST(fn_split((select ''',' ||
                                                                              t.bussidlist ||
                                                                              ','''
                                                                         from mcrectypeinfogs t
                                                                        where t.rectype = '1'),
                                                                       ''',''') AS
                                                              ty_str_split))
                                             where column_value is not null)
                                     group by fsr.driverid, fsr.routeid) t1,
                                   HR_DRIVERSTANDARDGD t3
                             where t1.routeid = t3.routeid
                               and t3.standardclassic = '6'
                               and t3.stdtdate = V_MONTH) t
                     group by t.empid) YXBC,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '10');
  commit;
end P_HR_BUSRUNSHIFTALLOWANCE;
/

prompt
prompt Creating procedure P_HR_BUSRUNSHIFTSALARY
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_BUSRUNSHIFTSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                   V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                   V_RECDATE   IN DATE, --��¼����
                                                   V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                                   ) is
  /*****************
  ��Ч��ι���
  ******************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT YXBC.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   YXBC ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select sum(t.yxbc) yxbc, t.empid
                      from (select (t1.seqnum * t3.price) yxbc,
                                   t1.driverid empid,
                                   t1.subrouteid
                              from (select fsr.seqnum,
                                           fsr.driverid,
                                           fsr.routeid,
                                           fsr.subrouteid,
                                           fsr.rundatadate,
                                           nvl(decode(fsr.emppaymultiple,-1,null,fsr.emppaymultiple),
                                               decode(es.emppaymultiple,-1,null,es.emppaymultiple)) emppaymultiple
                                      from fdisbusrunrecgd  fsr,
                                           ASGNREMPROUTETMP es
                                     where fsr.driverid = es.empid(+)
                                       and fsr.routeid = es.routeid(+)
                                       and fsr.rundatadate = es.recdate(+)
                                       and fsr.rundatadate >=
                                           TRUNC(V_STARTDATE)
                                       and fsr.rundatadate <= TRUNC(V_ENDDATE)
                                       and fsr.isavailable = '1'
                                       and fsr.bussid in
                                           (SELECT column_value as bussid
                                              FROM TABLE(CAST(fn_split((select ''',' ||
                                                                              t.bussidlist ||
                                                                              ','''
                                                                         from mcrectypeinfogs t
                                                                        where t.rectype = '1'),
                                                                       ''',''') AS
                                                              ty_str_split))
                                             where column_value is not null)) t1,
                                   OM_ROUTESEQNUMPRICEGD t3
                             where t1.emppaymultiple is null
                               and t1.subrouteid = t3.subrouteid
                               and t1.rundatadate <= t3.enddate
                               and t1.rundatadate >= t3.startdate) t
                     group by t.empid) YXBC,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '7');
  commit;
end P_HR_BUSRUNSHIFTSALARY;
/

prompt
prompt Creating procedure P_HR_HOLIDAYSSALARY
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_HOLIDAYSSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                V_RECDATE   IN DATE, --��¼����
                                                V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                                ) is
  /*****************
  ���н��
  ******************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT HOLIDAYS.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   HOLIDAYS.ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select sum(t1.SEQCOUNT1 * rp.price) ITEMVALUE, t1.extdriverid EMPID
                      from asgnarrangeseqgd      t1,
                           asgnarrangegd         t2,
                           ASGNREMPROUTETMP      es,
                           OM_ROUTESEQNUMPRICEGD rp
                     where t2.status = 'd'
                       and t1.arrangeid = t2.arrangeid
                       and t1.extdriverid = es.empid
                       and t1.routeid = es.routeid
                       and t1.execdate = es.recdate
                       and t1.execdate >= rp.startdate
                       and t1.execdate <= rp.enddate
                       and t1.subrouteid = rp.subrouteid
                       and es.empstatus = '4'
                       and es.empstatusdetail = '1'
                       and es.recdate >= TRUNC(V_STARTDATE)
                       and es.recdate <= TRUNC(V_ENDDATE)
                       and t1.execdate >= TRUNC(V_STARTDATE)
                       and t1.execdate <= TRUNC(V_ENDDATE)
                     group by t1.extdriverid) HOLIDAYS,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '11');
  commit;
end P_HR_HOLIDAYSSALARY;
/

prompt
prompt Creating procedure P_HR_LEAVESETSALARY
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_LEAVESETSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                V_RECDATE   IN DATE, --��¼����
                                                V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                                ) is
  /*****************
  �����ȱ�ڹ���
  ******************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT LEAVESET.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   LEAVESET.ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select es.empid, sum(ls.value) ITEMVALUE
                      from ASGNREMPROUTETMP es, HR_LEAVESETSHGGD ls
                     where es.empstatusdetail = ls.itemtype
                       and ls.type = '0'
                       and es.empstatus = '4'
                       and es.empstatusdetail <> '1'
                       and es.recdate >= TRUNC(V_STARTDATE)
                       and es.recdate <= TRUNC(V_ENDDATE)
                     group by es.empid) LEAVESET,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '12');
  commit;
end P_HR_LEAVESETSALARY;
/

prompt
prompt Creating procedure P_HR_PASSENGERFLOWSALARY
prompt ===========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_PASSENGERFLOWSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                     V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                     V_RECDATE   IN DATE, --��¼����
                                                     V_MONTH     IN VARCHAR2 --ͳ���·�
                                                     ) is
/********************
������
*********************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT klj.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   klj.klj ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select bcwcl.empid,
       (case
         when (bcwcl.bcwcl * 100) >= bcwcl.wclbz  then
          (case
         when klj.klj < kljfds.standardvalue then
          klj.klj
         else
          kljfds.standardvalue
       end) else 0 end) klj
  from /*1 �������� Start*/
       (select (case
                 when wcl.jh = 0 then
                  0
                 else
                  wcl.yxbc / wcl.jh
               end) bcwcl,
               wcl.empid,
               wcl.routeid,
               bzz.standardvalue wclbz
          from /*1.1 �����ɲ�ѯ�������ʻԱ��������·�ϵ���Ч��κͼƻ���� start*/
               (select sum(yxbc) yxbc, sum(jh) jh, empid, routeid
                  from ( /*1.1.1 ��Ч��� start*/
                        select t1.yxbc, t1.empid, t1.routeid, 0 jh
                          from (select sum(fsr.seqnum) yxbc,
                                        fsr.driverid empid,
                                        fsr.routeid
                                   from fdisbusrunrecgd fsr
                                  where fsr.rundatadate >=
                                        TRUNC(V_STARTDATE)
                                    and fsr.rundatadate <=
                                        TRUNC(V_ENDDATE)
                                    and fsr.isavailable = '1'
                                    and fsr.bussid in
                                        (SELECT column_value as bussid
                                           FROM TABLE(CAST(fn_split((select ''',' ||
                                                                           t.bussidlist ||
                                                                           ','''
                                                                      from mcrectypeinfogs t
                                                                     where t.rectype = '1'),
                                                                    ''',''') AS
                                                           ty_str_split))
                                          where column_value is not null)
                                  group by fsr.driverid, fsr.routeid) t1,
                                HR_TMP_EMPROUTEINFOGD t2
                         where t1.empid = t2.empid
                           and t1.routeid = t2.routeid
                        /*1.1.1 ��Ч��� end*/
                        union all
                        /*1.1.2 �ƻ���� start*/
                        select 0 yxbc, t3.empid, t3.ROUTEID, t3.jh
                          from (select ars.driverid empid,
                                       ars.ROUTEID,
                                       sum(ars.SEQCOUNT1) jh
                                  from ASGNARRANGESEQGD ars, ASGNARRANGEGD ar
                                 where ars.arrangeid = ar.arrangeid
                                   and ar.status = 'd'
                                   and ar.execdate >= TRUNC(V_STARTDATE)
                                   and ar.execdate <= TRUNC(V_ENDDATE)
                                 group by ars.ROUTEID, ars.driverid) t3,
                               HR_TMP_EMPROUTEINFOGD t4
                         where t3.empid = t4.empid
                           and t3.routeid = t4.routeid
                        /*1.1.2 �ƻ���� end*/
                        )
                 group by empid, routeid) wcl,
               /*1.1 �����ɲ�ѯ�������ʻԱ��������·�ϵ���Ч��κͼƻ���� start*/
               /*1.2 �������ʱ�׼ start*/
               (select ebrs.standardvalue, ebrs.empid
                  from HR_EMPBUSRUNSHIFTSTDGD ebrs
                 where ebrs.stdtdate = V_MONTH) bzz
        /*1.2 �������ʱ�׼ end*/
         where wcl.empid = bzz.empid(+)) bcwcl,
       /*1 �������� end*/
       /*2 ������������ Start*/
       (select sum(kljjss.klj) klj, kljjss.empid
          from /*2.1 ������Ա������·�ϵĿ����� Start*/
               (select (klsj.klsj - nvl(kljh.kljh, 0)) * jlxs.standardvalue klj,
                       klsj.empid,
                       klsj.routeid
                  from /*2.1.1 ����ʵ�� Start*/
                       (select sum(dtt.passengerflow) klsj,
                               dtt.DRIVERID empid,
                               dtt.routeid
                          from dssticketreceiptld dtt
                         where dtt.operationdate >= V_STARTDATE
                           and dtt.operationdate >= V_ENDDATE
                         group by dtt.DRIVERID, dtt.routeid) klsj,
                       /*2.1.1 ����ʵ�� end*/
                       /*2.1.2 �����ƻ� Start*/
                       (select zkl.routeid,
                               jsybc.empid,
                               (zkl.zkl * hds.standardvalue * (case
                                 when xlbc.yxbc = 0 then
                                  0
                                 else
                                  jsybc.yxbc / xlbc.yxbc
                               end)) kljh
                          from /*2.1.2.1 ��·���ܿ��� Start*/
                               (select sum(dtt.passengerflow) zkl, dtt.routeid
                                  from dssticketreceiptld dtt
                                 where dtt.operationdate >= V_STARTDATE
                                   and dtt.operationdate >= V_ENDDATE
                                 group by dtt.routeid) zkl,
                               /*2.1.2.1 ��·���ܿ��� end*/
                               /*2.1.2.2 ����ϵ�� Start*/
                               HR_DRIVERSTANDARDGD hds,
                               /*2.1.2.2 ����ϵ�� end*/
                               /*2.1.2.3 ��ʻԱ����·����ʻ�İ���� Start*/
                               (select sum(fsr.seqnum) yxbc,
                                       fsr.driverid empid,
                                       fsr.routeid
                                  from fdisbusrunrecgd fsr
                                 where fsr.rundatadate >=
                                       TRUNC(V_STARTDATE)
                                   and fsr.rundatadate <=
                                       TRUNC(V_ENDDATE)
                                   and fsr.isavailable = '1'
                                   and fsr.bussid in
                                       (SELECT column_value as bussid
                                          FROM TABLE(CAST(fn_split((select ''',' ||
                                                                          t.bussidlist ||
                                                                          ','''
                                                                     from mcrectypeinfogs t
                                                                    where t.rectype = '1'),
                                                                   ''',''') AS
                                                          ty_str_split))
                                         where column_value is not null)
                                 group by fsr.driverid, fsr.routeid) jsybc,
                               /*2.1.2.3 ��ʻԱ����·����ʻ�İ���� end*/
                               /*2.1.2.4 ��·����ʻ�İ���� Start*/
                               (select sum(fsr.seqnum) yxbc, fsr.routeid
                                  from fdisbusrunrecgd fsr
                                 where fsr.rundatadate >=
                                       TRUNC(V_STARTDATE)
                                   and fsr.rundatadate <=
                                       TRUNC(V_ENDDATE)
                                   and fsr.isavailable = '1'
                                   and fsr.bussid in
                                       (SELECT column_value as bussid
                                          FROM TABLE(CAST(fn_split((select ''',' ||
                                                                          t.bussidlist ||
                                                                          ','''
                                                                     from mcrectypeinfogs t
                                                                    where t.rectype = '1'),
                                                                   ''',''') AS
                                                          ty_str_split))
                                         where column_value is not null)
                                 group by fsr.routeid) xlbc
                        /*2.1.2.4 ��·����ʻ�İ���� end*/
                         where zkl.routeid = hds.routeid(+)
                           and hds.standardclassic = '2'
                           and hds.stdtdate = V_MONTH
                           and zkl.routeid = jsybc.routeid
                           and zkl.routeid = xlbc.routeid
                           and jsybc.routeid = xlbc.routeid) kljh,
                       /*2.1.2 �����ƻ� end*/
                       /*2.1.3 ����ϵ�� Start*/
                       HR_DRIVERSTANDARDGD jlxs
                /*2.1.3 ����ϵ�� end*/
                 where klsj.routeid = jlxs.routeid(+)
                   and jlxs.standardclassic = '1'
                   and jlxs.stdtdate = V_MONTH
                   and klsj.empid = kljh.empid(+)
                   and klsj.routeid = kljh.routeid(+)) kljjss
        /*2.1 ������Ա������·�ϵĿ����� end*/
         group by kljjss.empid) klj,
       /*2 ������������ end*/
       /*3 �������ⶥ�� Start*/
       HR_DRIVERSTANDARDGD kljfds
/*3 �������ⶥ�� end*/
 where bcwcl.empid = klj.empid(+)
   and bcwcl.routeid = kljfds.routeid(+)
   and kljfds.standardclassic = '5'
   and kljfds.stdtdate = V_MONTH) klj,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '13');
                commit;
end P_HR_PASSENGERFLOWSALARY;
/

prompt
prompt Creating procedure P_HR_ROADBLOCK
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_ROADBLOCK(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                           V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                           V_RECDATE   IN DATE, --��¼����
                                           V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                           ) is
  /********************
  ·�蹤��
  *********************/
  -- ·��ϵ��
  V_ROADBLOCK_PARA NUMBER := 0;
begin
  SELECT HSC.VALUE
    INTO V_ROADBLOCK_PARA
    FROM HR_SALARY_CONFIGS HSC
   WHERE HSC.SECTION = 'LZXS';

  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (select lzgz.empid,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   lzgz.lzgz ITEMVALUE,
                   t.itemkey ITEMNAME
              from /*1.·�蹤�� (�������ڼ�¼�ϼƣ�Start*/
                   (SELECT lz.empid,
                           sum(lz.seqnum * rsp.price * V_ROADBLOCK_PARA *
                               (nvl(shg.value, 1))) lzgz
                      FROM (
                            /*1.1 ȫ��·�蹤�ʣ�������㣩Start*/
                            select lz.subrouteid,
                                    lz.routeid,
                                    lz.driverid empid,
                                    lz.seqnum seqnum,
                                    lz.rundate,
                                    lz.emppaymultiple
                              from (
                                     /*1.1.1 �����е�·���¼(�������) Start*/
                                     select fdp.subrouteid,
                                             fdp.routeid,
                                             tru.driverid,
                                             tru.involvedseq seqnum,
                                             fdp.rundate,
                                             nvl(decode(fdp.emppaymultiple,-1,null,fdp.emppaymultiple),
                                               decode(es.emppaymultiple,-1,null,es.emppaymultiple)) emppaymultiple
                                       from FDISBUSTRUBLELD  tru,
                                             fdisdisplanld    fdp,
                                             ASGNREMPROUTETMP es
                                      where tru.bustrbid = fdp.displanbustrbid
                                        and fdp.driverid = es.empid(+)
                                        and fdp.routeid = es.routeid(+)
                                        and fdp.rundate = es.recdate(+)
                                        and tru.prostatus = '0'
                                        and tru.verifystatus = '1'
                                        and fdp.rundate >= V_STARTDATE
                                        and fdp.rundate <= V_ENDDATE
                                     /*1.1.1 �����е�·���¼(�������) end*/
                                     union all
                                     /*1.1.2 �ð��е�·���¼(�������) Start*/
                                     select fdp.subrouteid,
                                            fdp.routeid,
                                            fdp.driverid,
                                            fdp.seqnum seqnum,
                                            fdp.rundate,
                                            nvl(decode(fdp.emppaymultiple,-1,null,fdp.emppaymultiple),
                                               decode(es.emppaymultiple,-1,null,es.emppaymultiple)) emppaymultiple
                                       from FDISFAKESEQGD    fake,
                                            fdisdisplanld    fdp,
                                            ASGNREMPROUTETMP es
                                      where fake.fakeseqid = fdp.displanfakeseqid
                                        and fdp.driverid = es.empid(+)
                                        and fdp.routeid = es.routeid(+)
                                        and fdp.rundate = es.recdate(+)
                                        and fake.prostatus = '0'
                                        and fake.verifystatus = '1'
                                        and fdp.rundate >= V_STARTDATE
                                        and fdp.rundate <= V_ENDDATE
                                     ) lz
                                     /*1.1.2 �ð��е�·���¼(�������) end*/
                            ) LZ,
                           /*1.1 ȫ��·�蹤�ʣ�������㣩end*/
                           /*1.2 ��·�ϵİ�ε��� Start*/
                           OM_ROUTESEQNUMPRICEGD rsp,
                           /*1.2 ��·�ϵİ�ε��� end*/
                           /*1.3 ������׼ Start*/
                           (select s.itemtype, s.value
                              from HR_LEAVESETSHGGD s
                             where s.type = '1') shg
                    /*1.3 ������׼ end*/
                     where lz.subrouteid = rsp.subrouteid
                       and lz.emppaymultiple = shg.itemtype(+)
                       and lz.routeid = rsp.routeid
                       and lz.rundate <= rsp.enddate
                       and lz.rundate >= rsp.startdate
                     group by lz.empid) lzgz,
                   /*1.·�蹤�� (�������ڼ�¼�ϼƣ�end*/
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '8');
  commit;
end P_HR_ROADBLOCK;
/

prompt
prompt Creating procedure P_HR_SHENGGONGSALARY
prompt =======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_SHENGGONGSALARY(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                                 V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                                 V_RECDATE   IN DATE, --��¼����
                                                 V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                                 ) is
  /*****************
  ���չ��ʼ��Ӱ�н��
  ******************/
begin
  INSERT INTO HRMONTHLYRECGD T
    (SEQID, EMPID, RECDATE, ITEMVALUE, ITEMKEY)
    SELECT S_HRMONTHLYRECGD.NEXTVAL,
           EMPID,
           RUNDATADATE,
           ITEMVALUE,
           ITEMNAME
      FROM (SELECT YXBC.EMPID EMPID,
                   TRUNC(V_RECDATE) RUNDATADATE,
                   YXBC ITEMVALUE,
                   T.ITEMKEY ITEMNAME
              FROM (select sum(t.yxbc) yxbc, t.empid
                      from (select (t1.seqnum * t1.price * shg.value) yxbc,
                                   t1.driverid empid,
                                   t1.routeid,
                                   t1.subrouteid
                              from (select fsr.seqnum,
                                           t3.price,
                                           fsr.driverid,
                                           fsr.routeid,
                                           fsr.subrouteid,
                                           fsr.rundatadate,
                                           nvl(decode(fsr.emppaymultiple,-1,null,fsr.emppaymultiple),
                                               decode(es.emppaymultiple,-1,null,es.emppaymultiple)) emppaymultiple
                                      from fdisbusrunrecgd       fsr,
                                           ASGNREMPROUTETMP      es,
                                           OM_ROUTESEQNUMPRICEGD t3
                                     where fsr.driverid = es.empid(+)
                                       and fsr.routeid = es.routeid(+)
                                       and fsr.rundatadate = es.recdate(+)
                                       and fsr.subrouteid = t3.subrouteid
                                       and fsr.rundatadate <= t3.enddate
                                       and fsr.rundatadate >= t3.startdate
                                       and fsr.rundatadate >= TRUNC(V_STARTDATE)
                                       and fsr.rundatadate <= TRUNC(V_ENDDATE)
                                       and fsr.isavailable = '1'
                                       and fsr.bussid in
                                           (SELECT column_value as bussid
                                              FROM TABLE(CAST(fn_split((select ''',' ||
                                                                              t.bussidlist ||
                                                                              ','''
                                                                         from mcrectypeinfogs t
                                                                        where t.rectype = '1'),
                                                                       ''',''') AS
                                                              ty_str_split))
                                             where column_value is not null)) t1,
                                   HR_LEAVESETSHGGD shg
                             where t1.emppaymultiple is not null
                               and t1.emppaymultiple = shg.itemtype
                               and shg.type = '1') t
                     group by t.empid) YXBC,
                   TYPEENTRY T
             WHERE T.TYPENAME = 'HRSALARYDVM'
               AND T.ITEMVALUE = '14');
  commit;
end P_HR_SHENGGONGSALARY;
/

prompt
prompt Creating procedure P_HR_TMP_EMPROUTE
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_HR_TMP_EMPROUTE(V_STARTDATE IN DATE, --ͳ�ƿ�ʼ����
                                              V_ENDDATE   IN DATE, --ͳ�ƽ�������
                                              V_RECDATE   IN DATE, --��¼���ڣ�û���õ���Ϊͳһ�����ӿڶ�����
                                              V_MONTH     IN VARCHAR2 --ͳ���·ݣ�û���õ���Ϊͳһ�����ӿڶ�����
                                              ) is
  /*******************************
  ��Ա��·��ϵ��ʱ���������
  ��Ա��������·ʱ����ӵ�������·
  û��������·ʱ����ӵ����г���������·
  ********************************/
begin
  -- ɾ��������
  delete from HR_TMP_EMPROUTEINFOGD;
  -- ������Ա��·������ϵ���������
  insert into HR_TMP_EMPROUTEINFOGD
    (HTERID, EMPID, ROUTEID)
    select S_HR_TMP_EMPROUTEGD.nextval, t.*
      from (select aer.empid, aer.routeid
              from asgnremprouteld aer,
                   (select max(t.remprid) remprid, t.empid
                      from asgnremprouteld t
                     group by t.empid) t
             where t.empid = aer.empid
               and t.remprid = aer.remprid) t;
  -- û����·��������Ա��ȥӪ�˰��������·
  insert into HR_TMP_EMPROUTEINFOGD
    (HTERID, EMPID, ROUTEID)
    select S_HR_TMP_EMPROUTEGD.nextval, ern.*
      from (select f.driverid, f.routeid
              from (select t.driverid,
                           t.routeid,
                           RANK() OVER(PARTITION BY driverid ORDER BY seqnum desc) as seqno
                      from (select sum(t1.seqnum) seqnum,
                                   t1.driverid,
                                   t1.routeid
                              from fdisbusrunrecgd t1,
                                   (select e.empid
                                      from (select emp.empid, t.empid empid2
                                              from (select distinct m.empid
                                                      from mcemployeeinfogs m) emp,
                                                   (select t.empid
                                                      from asgnremprouteld t
                                                     group by t.empid) t
                                             where emp.empid = t.empid(+)) e
                                     where e.empid2 is null) t2
                             where t1.driverid = t2.empid
                               and t1.rundatadate >= TRUNC(V_STARTDATE)
                               and t1.rundatadate <= TRUNC(V_ENDDATE)
                               and t1.isavailable = '1'
                               and t1.bussid in
                                   (SELECT column_value as bussid
                                      FROM TABLE(CAST(fn_split((select ''',' ||
                                                                      t.bussidlist ||
                                                                      ','''
                                                                 from mcrectypeinfogs t
                                                                where t.rectype = '1'),
                                                               ''',''') AS
                                                      ty_str_split))
                                     where column_value is not null)
                             group by t1.driverid, t1.routeid) t) f
             where f.seqno = 1) ern;
  commit;
end P_HR_TMP_EMPROUTE;
/

prompt
prompt Creating procedure P_IMP_TICKETINCOME
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_IMP_TICKETINCOME(P_RUNDATADATE IN DATE,
                                               P_TICKETSORT  IN NVARCHAR2,
                                               P_NUM         OUT NUMBER,
                                               P_MESSAGE     OUT NVARCHAR2) AS
BEGIN
  SELECT 0 INTO P_NUM FROM DUAL;
  --�������ݴ���
  IF (P_RUNDATADATE IS NULL OR P_TICKETSORT IS NULL) THEN
    SELECT '�������ݴ���' INTO P_MESSAGE FROM DUAL;
    --������������
  ELSE
    BEGIN
      --IC������
      BEGIN
        --ɾ����������DI_WX_TICKETIMPORTGD
        delete from DI_WX_TICKETIMPORTGD
         where rundatadate = P_RUNDATADATE
           and ticketsort = P_TICKETSORT
           and impflag = 1;
        --ת�䵽DI_WX_TICKETIMPORTGD(��ͨ����Ӫ��)
        insert into DI_WX_TICKETIMPORTGD
          (tickeimportid,
           busid,
           orgid,
           rundatadate,
           posno,
           busselfid,
           ticketsort,
           tickettype,
           income,
           passengerflow,
           distributedflag,
           impflag,
           DATATYPE,
           ROUTEID)
          select S_DI_TICKETIMPORTGD.NEXTVAL, t.*
            from (select BUS.BUSID,
                         F_GET_ORGID_BY_SELFID(t.busselfid, P_RUNDATADATE) orgid,
                         T.RUNDATADATE,
                         BUS.Posno,
                         t.busselfid,
                         T.ticketsort,
                         T.tickettype,
                         sum(income/100)  income,
                         sum(passengerflow),
                         '0' distributedflag,
                         '1' impflag,
                         '1' DATATYPE,
                         F_GET_TICKETROUTEID(t.busselfid, '0')
                    from DI_WX_TICKETIMPORTORIGINALGD T, MCBUSINFOGS BUS
                   WHERE T.BUSSELFID = BUS.BUSSELFID
                     AND T.RUNDATADATE = P_RUNDATADATE
                     AND T.TICKETSORT = P_TICKETSORT
                     AND T.INCOMETYPE = '1'
                   group by BUS.BUSID,
                            T.RUNDATADATE,
                            BUS.POSNO,
                            t.busselfid,
                            T.ticketsort,
                            T.tickettype) t;
        --ת�䵽DI_WX_TICKETIMPORTGD(վ̨Ӫ��)
        insert into DI_WX_TICKETIMPORTGD
          (tickeimportid,
           STATIONID,
           orgid,
           rundatadate,
           posno,
           ticketsort,
           tickettype,
           income,
           passengerflow,
           distributedflag,
           impflag,
           DATATYPE,
           BUSSELFID,
           ROUTEID)
          select S_DI_TICKETIMPORTGD.NEXTVAL, t.*
            from (select T.STATIONID,
                         F_GET_ORGID_BY_ROUTEID(F_GET_TICKETROUTEID(T.STATIONID,
                                                                    '1')),
                         T.RUNDATADATE,
                         T.BUSSELFID posno,
                         T.ticketsort,
                         T.tickettype,
                         sum(T.income/100)  income,
                         sum(T.passengerflow),
                         '0' distributedflag,
                         '1' impflag,
                         '2' DATATYPE,
                         T.STATIONID BUSSELFID,
                         F_GET_TICKETROUTEID(T.STATIONID, '1')
                    from DI_WX_TICKETIMPORTORIGINALGD T
                   WHERE T.RUNDATADATE = P_RUNDATADATE
                     AND T.TICKETSORT = P_TICKETSORT
                     AND T.INCOMETYPE = '2'
                   group by T.STATIONID,
                            T.RUNDATADATE,
                            T.BUSSELFID,
                            T.ticketsort,
                            T.tickettype) t;
        COMMIT; -- Ӫ�ռ�¼
        --ɾ����������DSSTICKETRECEIPTLD
        delete from DSSTICKETRECEIPTLD
         where OPERATIONDATE = P_RUNDATADATE
           and ticketsort = P_TICKETSORT
           and SOURCEFROM = '1'
           and DATATYPE = '2';
        --(վ̨Ӫ��)ת�䵽DSSTICKETRECEIPTLD
        insert into dssticketreceiptld
          (ticketreceiptid,
           orgid,
           routeid,
           operationdate,
           busid,
           datatype,
           totalincome,
           passengerflow,
           ticketsort,
           tickettype,
           created,
           isactive,
           sourcefrom,
           noticket,
           createdate,
           stationid)
          SELECT S_DI_TICKETIMPORTGD.NEXTVAL, T.*
            FROM (select F_GET_ORGID_BY_ROUTEID(F_GET_TICKETROUTEID(T.STATIONID,
                                                                    '1')),
                         F_GET_TICKETROUTEID(T.STATIONID, '1'),
                         T.RUNDATADATE,
                         '' busid,
                         '2' datatype,
                         sum(T.income/100)  income,
                         sum(T.passengerflow),
                         T.ticketsort,
                         T.tickettype,
                         SYSDATE,
                         '1' isactive,
                         '1' sourcefrom,
                         '0' noticket,
                         P_RUNDATADATE,
                         T.STATIONID
                    from DI_WX_TICKETIMPORTORIGINALGD T
                   WHERE T.RUNDATADATE = P_RUNDATADATE
                     AND T.TICKETSORT = P_TICKETSORT
                     AND T.INCOMETYPE = '2'
                   group by T.ROUTEID,
                            T.RUNDATADATE,
                            T.ticketsort,
                            T.tickettype,
                            T.STATIONID) T;
        COMMIT;
        SELECT '�ɹ�����' || to_char(count(1)) || ' ������Ӫ�ռ�¼���� ' ||
               to_char(nvl(sum(income), 0)) || 'Ԫ��,'
          INTO P_MESSAGE
          FROM DI_WX_TICKETIMPORTGD
         where rundatadate = P_RUNDATADATE
           and ticketsort = P_TICKETSORT
           and impflag = 1
           and DATATYPE = '1';
        SELECT P_MESSAGE || to_char(count(1)) || ' ��վ̨Ӫ�ռ�¼���� ' ||
               to_char(nvl(sum(income), 0)) || 'Ԫ��'
          INTO P_MESSAGE
          FROM DI_WX_TICKETIMPORTGD
         where rundatadate = P_RUNDATADATE
           and ticketsort = P_TICKETSORT
           and impflag = 1
           and DATATYPE = '2';
      end;
    END;
  END IF;
  --Rollback;
end P_IMP_TICKETINCOME;
/

prompt
prompt Creating procedure P_INSERT_SEGMENT_GPS
prompt =======================================
prompt
create or replace procedure aptspzh.P_INSERT_SEGMENT_GPS(v_routeid   in number,
                                                 v_segid     in varchar2,
                                                 v_busid     in varchar2,
                                                 v_begintime in date,
                                                 v_endtime   in date) is
  TYPE T_CURSOR IS REF CURSOR;
  /**********************************************
  name :P_INSERT_SEGMENT_GPS
  createby: NY_COICE
  CREATED:20131121
  USE TO: ��ERP���ã�д��HC_SEGMENT ���̾�γ�� ��ͼΪ�Ȼ���ϵͳд����·���й켣
  table:  GPS���� bsvcbusrundatald5
           д�� HC_SEGMENT(ͼΪ����)
  memos��
  UPDATEBY:
  UPDATERD:
  **********************************************/
  CUR_GPS         T_CURSOR;
  v_gps           clob;
  v_gpsplus       clob;
  v_count_gps     number(8);
  v_count_gps_std number(8);
  v_flag          number(1);
begin
  v_flag          := 1;
  v_gps           := null;
  v_count_gps     := 0;
  v_count_gps_std := (v_endtime - v_begintime) * 24 * 60 * 60 / 15;
  select count(1)
    into v_count_gps
    from bsvcbusrundatald5 bsvc
   where bsvc.actdatetime between V_begintime and v_endtime
     and bsvc.routeid = v_routeid
     and bsvc.productid =
         (select productid from mcrbusbusmachinegs where busid = v_busid)
     and bsvc.longitude <> 0
     and bsvc.latitude <> 0;
  IF v_count_gps < v_count_gps_std * 2 / 3 THEN
    v_flag := 0;
  END IF;
  OPEN CUR_GPS FOR
    select LONGITUDE || ',' || LATITUDE || ',' jwd
      from bsvcbusrundatald5 bsvc
     where bsvc.actdatetime between V_begintime and V_endtime
       and bsvc.routeid = v_routeid
       and bsvc.productid =
           (select productid from mcrbusbusmachinegs where busid = v_busid)
       and bsvc.longitude <> 0
       and bsvc.latitude <> 0
     ORDER BY bsvc.actdatetime;
  LOOP
    FETCH CUR_GPS
      INTO v_gpsplus;
    if v_gpsplus is not null then
      v_gps     := v_gps || v_gpsplus;
      v_gpsplus := '';
    end if;
    EXIT WHEN CUR_GPS%NOTFOUND;
  END LOOP;
  CLOSE CUR_GPS;
  delete from hc_segment where SEGMENTID = v_segid;
  commit;
  --д��GPS����
  v_gps := substr(v_gps, 1, length(v_gps) - 1);
  insert into hc_segment
    (SEGMENTID, jwd, UPDATED, flag)
  VALUES
    (v_segid, v_gps, sysdate, v_flag);
  commit;
/*  SELECT '�ѳɹ�д�뵥��GPS��γ�ȣ���ʹ�� ' || v_count_gps || ' ���㡣'
    INTO P_MESSAGE
    from dual;*/
end;
/

prompt
prompt Creating procedure P_INSERT_SEGMENT_GPS_BUSSELFID
prompt =================================================
prompt
create or replace procedure aptspzh.P_INSERT_SEGMENT_GPS_busselfid(v_routeid in number,
                                                                    v_segid in varchar2,
                                                                    v_busselfid   in varchar2,
                                                                    v_begintime in date,
                                                                    v_endtime in date/*,
                                                                    P_MESSAGE     OUT NVARCHAR2
                                                                   */ ) is
  TYPE T_CURSOR IS REF CURSOR;
/**********************************************
  name :P_INSERT_SEGMENT_GPS
  createby: NY_COICE
  CREATED:20131121
  USE TO: ��ERP���ã�д��HC_SEGMENT ���̾�γ�� ��ͼΪ�Ȼ���ϵͳд����·���й켣
  table:  GPS���� bsvcbusrundatald5
           д�� HC_SEGMENT(ͼΪ����)
  memos��
  UPDATEBY:
  UPDATERD:
  **********************************************/
  CUR_GPS                     T_CURSOR;
  v_gps                          clob;
  v_gpsplus                    clob;
  v_count_gps                 number(8);
  v_count_gps_std           number(8);
  v_flag                          number(1);
  v_busid                         varchar2(20);
begin
 select min(busid) into v_busid from mcbusinfogs b where b.busselfid=v_busselfid;
            v_flag:=1;
            v_gps:=null;
            v_count_gps:=0;
            v_count_gps_std:= (v_endtime-v_begintime) *24*60*60/15;
              select count(1) into v_count_gps from bsvcbusrundatald5 bsvc
                 where bsvc.actdatetime between V_begintime  and  v_endtime
                    and bsvc.routeid=v_routeid
                    and bsvc.productid=(select productid from mcrbusbusmachinegs where busid=v_busid)
                    and bsvc.longitude<>0 and bsvc.latitude<>0;
                  IF    v_count_gps<v_count_gps_std*2/3 THEN
                         v_flag:=0;
                    END IF;
                  OPEN CUR_GPS FOR
                                       select  LONGITUDE||','||LATITUDE||',' jwd  from bsvcbusrundatald5 bsvc
                                                            where bsvc.actdatetime between V_begintime  and  V_endtime
                                                                  and bsvc.routeid=v_routeid
                                                                  and bsvc.productid=(select productid from mcrbusbusmachinegs where busid=v_busid)
                                                                  and bsvc.longitude<>0 and bsvc.latitude<>0
                                                                ORDER BY bsvc.actdatetime;
                          LOOP
                               FETCH CUR_GPS  INTO v_gpsplus;
                                   if  v_gpsplus is not null then
                                                   v_gps:=v_gps||v_gpsplus;
                                                            v_gpsplus:='';
                                      end if ;
                                  EXIT WHEN CUR_GPS%NOTFOUND;
                            END LOOP;
                     CLOSE CUR_GPS;
                     delete from hc_segment where SEGMENTID= v_segid;
                      commit;
                     --д��GPS����
                                 v_gps:=substr(v_gps,1,length(v_gps) - 1);
                    insert into hc_segment (SEGMENTID, jwd,UPDATED,flag) VALUES (v_segid,v_gps,sysdate,v_flag);
                    commit;
   --SELECT '�ѳɹ�д�뵥��GPS��γ�ȣ���ʹ�� '||v_count_gps||' ���㡣' INTO P_MESSAGE from dual;
   end;
/

prompt
prompt Creating procedure P_JC_PZHYS
prompt =============================
prompt
create or replace procedure aptspzh.p_jc_pzhys(V_DATE DATE) IS
  V_DATE_START DATE := TRUNC(V_DATE, 'mm');
  V_DATE_END   DATE := TRUNC(V_DATE);
BEGIN
  DELETE JC_PZHYS JC WHERE JC.YSSJ=V_DATE_END;
  INSERT INTO JC_PZHYS (
  SELECT T.OPERATIONDATE,
         SYSDATE,
         DRLNK,
         LJLNK,
         DRSCK,
         LJSCK,
         DRDBK,
         LJDBK,
         DRDZQB,
         LJDZQBK,
         DRCRYPK,
         LJCRYPK,
         DRXSK,
         LJXSK,
         DRDHJ,
         LJHJ
    FROM (SELECT T.OPERATIONDATE OPERATIONDATE,
                 SUM(T.LNKRC) DRLNK,
                 SUM(T.SCKRC) DRSCK,
                 SUM(T.DBKRC) DRDBK,
                 SUM(T.DZQBRC) DRDZQB,
                 SUM(T.CRYPKRC) DRCRYPK,
                 SUM(T.XSKRC) DRXSK,
                 SUM(T.DHJRC) DRDHJ
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE =V_DATE_END
           GROUP BY T.OPERATIONDATE) T,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.LNKRC) OVER(ORDER BY T.OPERATIONDATE) LJLNK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >=V_DATE_START
             AND T.OPERATIONDATE <= V_DATE_END) T1,

         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.SCKRC) OVER(ORDER BY T.OPERATIONDATE) LJSCK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <=V_DATE_END) T2,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.DBKRC) OVER(ORDER BY T.OPERATIONDATE) LJDBK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <= V_DATE_END) T3,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.DZQBRC) OVER(ORDER BY T.OPERATIONDATE) LJDZQBK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <=V_DATE_END) T4,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.CRYPKRC) OVER(ORDER BY T.OPERATIONDATE) LJCRYPK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <= V_DATE_END) T5,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.XSKRC) OVER(ORDER BY T.OPERATIONDATE) LJXSK
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <= V_DATE_END) T6,
         (SELECT DISTINCT T.OPERATIONDATE,
                          SUM(T.DHJRC) OVER(ORDER BY T.OPERATIONDATE) LJHJ
            FROM PZHYS T
           WHERE 1 = 1
             AND T.OPERATIONDATE >= V_DATE_START
             AND T.OPERATIONDATE <= V_DATE_END) T7

   WHERE 1 = 1
     AND T.OPERATIONDATE = T1.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T2.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T3.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T4.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T5.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T6.OPERATIONDATE(+)
     AND T.OPERATIONDATE = T7.OPERATIONDATE(+)
  );
   commit;
END p_jc_pzhys;
/

prompt
prompt Creating procedure P_LOADBUSORDER
prompt =================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_LOADBUSORDER(V_ROUTEID   IN NVARCHAR2,
                                           V_BEGINTIME IN NVARCHAR2) IS
  V_SUBSTR VARCHAR2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
BEGIN
  --��ձ�fdisbusorderinfo
  V_SUBSTR := 'delete from fdisbusorderinfo where routeid in ' ||
              V_ROUTEID || ' and RUNDATE =' || V_BEGINTIME ;
  EXECUTE IMMEDIATE V_SUBSTR;

  V_SUBSTR := 'insert into fdisbusorderinfo
              (id,
              busid,
              ordernum,
              shiftnumstring,
              shifttype,
              routeid,
              subrouteid,
              rundate,
              checked,
              isactive,
              busordertype,
              busrundirection)
             select arrangesid,
                    busid,
                    rownum,
                    shiftnumstring,
                    shifttype,
                    routeid,
                    subrouteid,
                    execdate,
                    1,
                    1,
                    busordertype,
                    shiftdirection
                    from
                    (select  t.arrangesid,
                             t.busid,
                             t.shiftnumstring,
                             t.shifttype,
                             t.routeid,
                             t.subrouteid,
                             t.execdate,
                             t.busordertype,
                             t.shiftdirection
                            from fdisbusorderview t
                    where   t.execdate = ' || V_BEGINTIME || '
                      and t.routeid in ' || V_ROUTEID || ' and t.groupnum = ''1'' and empptype=''1''
                      order by t.onworktime)';
  EXECUTE IMMEDIATE V_SUBSTR;
  COMMIT;
END P_LOADBUSORDER;
/

prompt
prompt Creating procedure P_LOADROUTESTANDCONFIG
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_LOADROUTESTANDCONFIG(V_ROUTEID   IN NVARCHAR2,
                                           V_BEGINTIME IN NVARCHAR2) IS
  V_SUBSTR VARCHAR2(4000); --�Ӵ����ȸ��ݳ�����Ҫ�޸�
BEGIN
  --��ձ�fdisbusorderinfo
  V_SUBSTR := 'delete from fdisroutestandconfig where routeid in ' ||
              V_ROUTEID || ' and RUNDATE =' || V_BEGINTIME ;
  EXECUTE IMMEDIATE V_SUBSTR;

  V_SUBSTR := 'insert into fdisroutestandconfig
              (id,
              routeid,
              openshift,
              openonhourstand,
              rundate)
             select  S_FDISDISPLANGD.Nextval,
                    t.routeid,
                    1,
                    1,
                    trunc(sysdate)
                    from  mcrouteinfogs t
                    where  t.routeid in ' || V_ROUTEID ;
  EXECUTE IMMEDIATE V_SUBSTR;
  COMMIT;
END P_LOADROUTESTANDCONFIG;
/

prompt
prompt Creating procedure P_MM_CREATEPURCHASEBILL
prompt ==========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MM_CREATEPURCHASEBILL IS
  v_num   number(8);
  v_count number(8);
  v_value number(8);
  /***************************************************
  ���ƣ�P_MM_CREATEPURCHASEBILL
  ��;�� ����������ȫ��汨��
  �����:   mm_createpurchasebill
  ��д��������
  ������ڣ�2015��08��05��
  �޸ģ�**************************************************/
BEGIN
  select count(1)
    into v_num
    from (select rm.materialid,
                 m.materialno,
                 m.materialname,
                 m.standardinfo,
                 unit.measureunitname unitnm,
                 m.directionforuse,
                 m.keysize,
                 rm.batchno,
                 rm.allcount count,
                 m.lowcount,
                 m.lowcount - rm.allcount difcount,
                 mm.materialid sign
            from (select r.materialid,
                         max(r.batchno) batchno,
                         sum(r.count) allcount
                    from mm_realtimestockgd r
                   where r.warehouseid in
                         (select t.warehouseid
                            from mm_warehousegd t
                           where t.iscreatepurchasebill = '1'
                             and t.isactive = '1')
                     and r.count > 0
                   group by r.materialid) rm,
                 mm_materialgd m,
                 mm_measureunitgd unit,
                 (select d.materialid
                    from mm_inquirybillgd b, mm_inquirybilldetailgd d
                   where b.inquirybillid = d.inquirybillid
                     and b.verifystatus = '1'
                  union
                  select materialid
                    from (select d.materialid, stock.linkbill sign
                            from mm_purchasebillgd       b,
                                 mm_stockbillgd          stock,
                                 mm_purchasebilldetailgd d
                           where b.purchasebillid = d.purchasebillid
                             and b.purchasebillid = stock.linkbill(+))
                   where sign is null) mm
           where m.materialid = mm.materialid(+)
             and m.unit = unit.measureunitid
             and rm.materialid = m.materialid
             and rm.allcount - m.lowcount < 0
             and m.importantlevel = '0'
             and m.isactive = '1')
   where sign is null;
  select count(1) into v_count from mm_createpurchasebill t;
  select count(1)
    into v_value
    from mm_createpurchasebill t
   where t.num = v_num;
  if v_value = 0 then
    if v_count > 0 then
      update mm_createpurchasebill t
         set t.num = v_num, t.updated = sysdate;
    else
      insert into mm_createpurchasebill
        (num, updated)
      values
        (v_num, sysdate);
    end if;
  end if;
  commit;
END P_MM_CREATEPURCHASEBILL;
/

prompt
prompt Creating procedure P_MM_RETURNCOMPUTE
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MM_RETURNCOMPUTE(p_returncompute in number, --�����ܽ��
                                               p_stockbillid   in char, --��ⵥID
                                               p_operateman    in char) as
  /************************************************************************************************
    ��ⵥ���㣬�˹��̹�WEB������ã�������                   ������ 2013-11-26
    ��ⵥ����ҵ�����:������˰�۸��Զ�������˰�۸�       ���� 2014-3-20
    ��ⵥ����ҵ�����:������󵥼ۡ���˰����뼰ʱ���   ������ 2015-4-8
  ************************************************************************************************/
  v_alltotalsum           number(14, 6);
  v_realprice             number(14, 6);
  v_matcostshare          number(14, 6);
  v_realtotalsum          number(14, 6);
  v_totalcost             number(14, 6) := 0;
  v_warehouseid           varchar2(20);
  v_laststockbillid       varchar2(20);
  v_lastmaterialid        varchar2(20);
  v_lastbatchno           varchar2(50);
  v_lastrealtotalsum      number(14, 6);
  v_lastcount             number(14, 6);
  v_lasttaxpriceratevalue number(14, 6);

begin
  --��ȡ��ⵥ�ܽ��
  select sum(d.taxtotalsum)
    into v_alltotalsum
    from mm_stockbillgd s, mm_stockbilldetailgd d
   where s.stockbillid = d.stockbillid
     and s.stockbillid = p_stockbillid;
  --��ȡ��ⵥ��ϸ���ݺ�˰���
  for cur_mater in (select d.stockbilldetailid,
                           d.materialid,
                           d.batchno,
                           s.acceptwarehouse warehouseid,
                           d.taxtotalsum,
                           d.count,
                           d.taxpricerate,
                           to_number(t.itemkey) * 0.01 taxpriceratevalue
                      from mm_stockbillgd s,
                           mm_stockbilldetailgd d,
                           (select t.itemkey, t.itemvalue
                              from typeentry t
                             where t.typename = 'TAXPRICERATE') t
                     where s.stockbillid = d.stockbillid
                       and d.taxpricerate = t.itemvalue
                       and s.stockbillid = p_stockbillid) loop
    --���ʷ�̯��˰���
    v_matcostshare := round(p_returncompute * cur_mater.taxtotalsum /
                            v_alltotalsum,
                            2);
    -- ������Ĳ���
    v_totalcost := v_totalcost + v_matcostshare;
    -- ʵ�ʺ�˰���
    v_realtotalsum := cur_mater.taxtotalsum - v_matcostshare;
    --�������ʷ����ĺ�˰����
    v_realprice := round(v_realtotalsum / cur_mater.count, 2);

    --���½��׵���ϸ�еĵ��ۼ��ܽ�����֮ǰ�ĵ��ۼ��ܽ��
    update mm_stockbilldetailgd t
       set t.returnflag     = '2',
           t.realtotalsum   = v_realtotalsum,
           t.realprice      = v_realprice,
           t.returnprice    = v_realprice,
           t.returntotalsum = v_realtotalsum,
           t.returntaxsum   = v_realtotalsum - round(v_realtotalsum / (1 +
                                                     cur_mater.taxpriceratevalue),
                                                     2)
     where t.stockbilldetailid = cur_mater.stockbilldetailid;
    commit;
    --���¼�ʱ���
    update mm_realtimestockgd t
       set t.returnflag     = '2',
           t.returnprice    = v_realprice,
           t.returntotalsum = v_realtotalsum,
           t.returntaxsum   = v_realtotalsum - round(v_realtotalsum / (1 +
                                                     cur_mater.taxpriceratevalue),
                                                     2)
     where t.warehouseid = cur_mater.warehouseid
       and t.materialid = cur_mater.materialid
       and t.batchno = cur_mater.batchno;
    commit;
    --��¼��ǰѭ���Ľ��׵���ϸID
    v_laststockbillid       := cur_mater.stockbilldetailid;
    v_lastrealtotalsum      := v_realtotalsum;
    v_lastcount             := cur_mater.count;
    v_lastmaterialid        := cur_mater.materialid;
    v_lastbatchno           := cur_mater.batchno;
    v_warehouseid           := cur_mater.warehouseid;
    v_lasttaxpriceratevalue := cur_mater.taxpriceratevalue;
  end loop;
  --���㷵���ܽ�����̯������ⵥ�Ľ��֮�͵Ĳ�ֵ
  v_matcostshare := p_returncompute - v_totalcost;
  --�����ֵ��Ϊ0������ֵ���µ����һ�����׵���ϸ��
  if v_matcostshare != 0 then
    -- ʵ�ʺ�˰���
    v_realtotalsum := v_lastrealtotalsum - v_matcostshare;
    --�������ʷ����ĺ�˰����
    v_realprice := round(v_realtotalsum / v_lastcount, 2);

    --���½��׵���ϸ�еĵ��ۼ��ܽ�����֮ǰ�ĵ��ۼ��ܽ��
    update mm_stockbilldetailgd t
       set t.returnflag     = '2',
           t.realtotalsum   = v_realtotalsum,
           t.realprice      = v_realprice,
           t.returnprice    = v_realprice,
           t.returntotalsum = v_realtotalsum,
           t.returntaxsum   = v_realtotalsum - round(v_realtotalsum / (1 +
                                                     v_lasttaxpriceratevalue),
                                                     2)
     where t.stockbilldetailid = v_laststockbillid;
    commit;
    --���¼�ʱ���
    update mm_realtimestockgd t
       set t.returnflag     = '2',
           t.returnprice    = v_realprice,
           t.returntotalsum = v_realtotalsum,
           t.returntaxsum   = v_realtotalsum - round(v_realtotalsum / (1 +
                                                     v_lasttaxpriceratevalue),
                                                     2)
     where t.warehouseid = v_warehouseid
       and t.materialid = v_lastmaterialid
       and t.batchno = v_lastbatchno;
    commit;
  end if;
  --���½��׵���״̬(�ѷ���+������)
  update mm_stockbillgd t
     set t.iscostshare      = '2',
         t.returncompute    = p_returncompute,
         t.returncomputeman = p_operateman
   where t.stockbillid = p_stockbillid;
  commit;
end;
/

prompt
prompt Creating procedure P_MM_UPDATE_STOCKBILLUSINGORG
prompt ================================================
prompt
create or replace procedure aptspzh.P_MM_UPDATE_STOCKBILLUSINGORG
(
  BILLDATE    in varchar2,
  WAREHOUSEID in varchar2
) is
  /***************************************************
  ���ƣ�    P_MM_UPDATE_STOCKBILLUSINGORG
  ��;��    ����MM_STOCKBILLGD���г��ⵥ��USINGORGID�ֶΣ���RECORGID��Ӧ���ϼ��ֹ�˾��
            ��֯IDд�뵽USINGORGID�ֶ��С�

  �����:   MM_STOCKBILLGD
  ������̣��ٹ��� ��֯ID���ֹ�˾ID�Ľ����
            ������MM_STOCKBILLGD��RECORGID������֯ID�����ֹ�˾ID���µ�USINGORGID�ֶ�
            ������������֮����Ȼ��USINGORGIDΪ�յ�������������Ϊ�ܹ�˾��ID��10000000000000000000��
  ***************************************************/
  V_DATEFROM date; --��ǰ�½��·ݵĿ�ʼ����
  V_DATETO   date; --��ǰ�½��·ݵĽ�������
  V_WAREID   varchar2(20); --��Ҫ�����ݵĲֿ�ID
begin
  -- ��������
  V_DATEFROM := ADD_MONTHS(TO_DATE(BILLDATE || '-27', 'YYYY-MM-DD'), -1);
  V_DATETO   := TO_DATE(BILLDATE || '-26', 'YYYY-MM-DD');
  V_WAREID   := WAREHOUSEID;
  --�ٹ��� ��֯ID���ֹ�˾ID�Ľ����
  --������MM_STOCKBILLGD��RECORGID������֯ID�����ֹ�˾ID���µ�USINGORGID�ֶ�
  update (select /*+ BYPASS_UJVC */
           BILL.RECORGID,
           BILL.USINGORGID,
           ORG.ORGID,
           ORG.PARENTORGID
            from MM_STOCKBILLGD BILL,
                 (select ORG1.ORGID,
                         ORG1.ORGID PARENTORGID
                    from MCORGINFOGS ORG1
                   where ORG1.ORGTYPE = '2'
                  union
                  select ORG2.ORGID,
                         ORG2.PARENTORGID
                    from MCORGINFOGS ORG2,
                         MCORGINFOGS ORG22
                   where ORG2.PARENTORGID = ORG22.ORGID
                     and ORG22.ORGTYPE = '2'
                  union
                  select ORG3.ORGID,
                         ORG33.PARENTORGID
                    from MCORGINFOGS ORG3,
                         (select ORG2.ORGID,
                                 ORG2.PARENTORGID
                            from MCORGINFOGS ORG2,
                                 MCORGINFOGS ORG22
                           where ORG2.PARENTORGID = ORG22.ORGID
                             and ORG22.ORGTYPE = '2') ORG33
                   where ORG3.PARENTORGID = ORG33.ORGID) ORG
           where BILL.RECORGID = ORG.ORGID
             and BILL.ISSUEWAREHOUSE = V_WAREID
             and BILL.BILLDATE between V_DATEFROM and V_DATETO
             and BILL.BILLTYPE = '1') T
     set T.USINGORGID = T.PARENTORGID;
  commit;
  --�� �����Ȼ��Ϊ�յ�������趨ʹ�õ�λΪ�����ܹ�˾
  update MM_STOCKBILLGD T
     set T.USINGORGID = '10000000000000000000'
   where T.ISSUEWAREHOUSE = V_WAREID
     and T.BILLDATE between V_DATEFROM and V_DATETO
     and T.BILLTYPE = '1'
     and T.USINGORGID is null;
  commit;
end P_MM_UPDATE_STOCKBILLUSINGORG;
/

prompt
prompt Creating procedure P_MM_WHMONTHLYCLOSING
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MM_WHMONTHLYCLOSING(P_WAREHOUSEID CHAR, --�ֿ�ID
                                                  P_YEAR        CHAR, --�½���
                                                  P_MONTH       CHAR, --�½��·�
                                                  P_QDATEFROM   DATE, --�½Ὺʼ����
                                                  P_QDATETO     DATE, --�½��������
                                                  P_USERID      CHAR, --��½��ID
                                                  REFLG         OUT CHAR) AS
  /****************************************************************
    ���ƣ�P_MM_WHMONTHLYCLOSING
    ���������P_WAREHOUSEID CHAR, --�ֿ���
                 P_YEAR            CHAR, --�½���
                 P_MONTH         CHAR, --�½��·�
                 P_QDATEFROM     DATE, --�½Ὺʼ����
                 P_QDATETO       DATE, --�½��������
                 P_USERID        CHAR, --��½��empID
     ����������REFLG
    ��;��ERP���� �����½����� д���½��
    д���:
              MM_WHMONTHLYCLOSINGMNGGD
              MM_WHMONTHLYCLOSINGDEATAILGD
    ��д��    COICE  CHENGPENG  20130528
    �޸ģ�
  -- CREATE SEQUENCE
  CREATE SEQUENCE S_MM_WHMONTHLYCLOSING
  MINVALUE 1
  MAXVALUE 99999999999999999
  START WITH 100000000000000
  INCREMENT BY 1
  CACHE 20;
  
  ****************************************************************/
  V_PRICEMNG VARCHAR2(2); --�۸���㷽ʽ (1:��Ȩƽ���� 2:�ɱ��� 3:�ƻ���)
  V_WHMONID  VARCHAR2(20); --MM_WHMONTHLYCLOSINGMNGGD����
  V_RUNDATE  DATE;
  V_PREMONTH VARCHAR2(2);
  V_PREYEAR  VARCHAR2(4);
  --
BEGIN
  --��ϸ��RUNDATE
  SELECT TO_DATE(P_YEAR || P_MONTH, 'YYYY-MM') INTO V_RUNDATE FROM DUAL;
  --���º�����
  SELECT TO_CHAR(V_RUNDATE - 1, 'YYYY'), TO_CHAR(V_RUNDATE - 1, 'MM')
    INTO V_PREYEAR, V_PREMONTH
    FROM DUAL;
  --��ȡ�ֿ�۸���㷽ʽ
  SELECT T.PRICEMNG
    INTO V_PRICEMNG
    FROM MM_WAREHOUSETEAMGD T, MM_RWAREHOUSETEAMWHGD RT
   WHERE RT.WAREHOUSETEAMID = T.WAREHOUSETEAMID
     AND RT.WAREHOUSEID = P_WAREHOUSEID;
  --��ȡMM_WHMONTHLYCLOSINGMNGGD����
  SELECT S_MM_WHMONTHLYCLOSING.NEXTVAL INTO V_WHMONID FROM DUAL;
  --��������MM_WHMONTHLYCLOSINGMNGGD����
  INSERT INTO MM_WHMONTHLYCLOSINGMNGGD
    (WHMONID,
     YEARNUM,
     MONTHNUM,
     CLOSINGSTART,
     CLOSINGEND,
     WAREHOUSEID,
     CREATED,
     CREATEBY,
     CLOSEFLAG)
  VALUES
    (V_WHMONID,
     P_YEAR,
     P_MONTH,
     P_QDATEFROM,
     P_QDATETO,
     P_WAREHOUSEID,
     SYSDATE,
     P_USERID,
     0);
  --������ϸ������
  INSERT INTO MM_WHMONTHLYCLOSINGDEATAILGD
    (WHMONDETAILID,
     WHMONID,
     CREATED,
     CREATEBY,
     RUNDATE,
     MATERIALID,
     BATCHNO,
     Issupplierout,
     PRICE,
     NOWCOUNT,
     PRIORCOUNT,
     PRIORSUMCOUNT,
     INPUTCOUNT,
     INPUTSUMCOUNT,
     OUTCOUNT,
     ENDINGCOUNT,
     SUMCOUNT)
    SELECT S_MM_WHMONTHLYCLOSING.NEXTVAL,
           V_WHMONID,
           SYSDATE,
           P_USERID,
           V_RUNDATE,
           RESULTINFO.MATERIALID,
           RESULTINFO.BATCHNO,
           RESULTINFO.Issupplierout,
           (CASE
           -- ��Ȩƽ����
             WHEN V_PRICEMNG = 1 THEN
              RESULTINFO.ISSUEPRICE
           -- �ƻ���
             WHEN V_PRICEMNG = 2 THEN
              RESULTINFO.OUTPRICE
           -- �ɱ���
             WHEN V_PRICEMNG = 3 THEN
              RESULTINFO.MATPRICE
             ELSE
              RESULTINFO.PRICE
           END) PRICE,
           (RESULTINFO.PRECOUNT + RESULTINFO.INCOUNT - RESULTINFO.OUTCOUNT),
           RESULTINFO.PRECOUNT,
           RESULTINFO.PRESUMCOUNT,
           RESULTINFO.INCOUNT,
           RESULTINFO.INSUM,
           RESULTINFO.OUTCOUNT,
           --RESULTINFO.OUTSUM,
           RESULTINFO.PRECOUNT + RESULTINFO.INCOUNT - RESULTINFO.OUTCOUNT AS ENDINGCOUNT,
           (CASE
           -- �ƻ���
             WHEN V_PRICEMNG = 2 THEN
              RESULTINFO.OUTPRICE *
              (RESULTINFO.PRECOUNT + RESULTINFO.INCOUNT -
              RESULTINFO.OUTCOUNT)
             ELSE
              RESULTINFO.PRESUMCOUNT + RESULTINFO.INSUM - RESULTINFO.OUTSUM
           END) SUMCOUNT
      FROM (SELECT RESULTINFO.MATERIALID,
                   RESULTINFO.WAREHOUSEID,
                   RESULTINFO.BATCHNO,
                   RESULTINFO.Issupplierout,
                   -- �ڳ��۸�
                   MAX(RESULTINFO.PRICE) PRICE,
                   -- �ɱ���
                   (SELECT MAX(R.PRICE) MATPRICE
                      FROM MM_REALTIMESTOCKGD R
                     WHERE R.WAREHOUSEID = P_WAREHOUSEID
                       AND RESULTINFO.MATERIALID = R.MATERIALID(+)) MATPRICE,
                   -- ��Ȩƽ����
                   (SELECT MAX(O.ISSUEPRICE) ISSUEPRICE
                      FROM MM_RWAREHOUSETEAMWHGD RWAREHOUSETEAM,
                           MM_ISSUEPRICEGD       O
                     WHERE RWAREHOUSETEAM.WAREHOUSEID = P_WAREHOUSEID
                       AND RWAREHOUSETEAM.WAREHOUSETEAMID = O.WAREHOUSETEAMID
                       AND RESULTINFO.MATERIALID = O.MATERIALID(+)) ISSUEPRICE,
                   -- �ƻ���
                   (SELECT MAX(O.OUTPRICE) OUTPRICE
                      FROM MM_OUTPRICEGD O
                     WHERE O.STARTDATE <= P_QDATEFROM
                       AND O.ENDDATE >= P_QDATETO
                       AND O.VERIFYSTATUS = '2'
                       AND RESULTINFO.MATERIALID = O.MATERIALID(+)
                       AND RESULTINFO.BATCHNO = O.BATCHNO(+)) OUTPRICE,
                   SUM(RESULTINFO.PRECOUNT) PRECOUNT,
                   SUM(RESULTINFO.PRESUMCOUNT) PRESUMCOUNT,
                   SUM(RESULTINFO.INCOUNT) INCOUNT,
                   SUM(RESULTINFO.INSUM) INSUM,
                   SUM(RESULTINFO.OUTCOUNT) OUTCOUNT,
                   SUM(RESULTINFO.OUTSUM) OUTSUM
              FROM (
                    -- �������
                    SELECT STOCKDETAIL.MATERIALID,
                            STOCK.ACCEPTWAREHOUSE WAREHOUSEID,
                            STOCKDETAIL.BATCHNO,
                            STOCKDETAIL.Issupplierout,
                            0 AS PRICE,
                            0 AS PRECOUNT,
                            0 AS PRESUMCOUNT,
                            SUM(STOCKDETAIL.COUNT) AS INCOUNT,
                            SUM(STOCKDETAIL.TOTALSUM) AS INSUM,
                            0 AS OUTCOUNT,
                            0 AS OUTSUM
                      FROM MM_STOCKBILLDETAILGD STOCKDETAIL,
                            MM_STOCKBILLGD       STOCK
                     WHERE STOCK.BILLTYPE = '2'
                       AND STOCK.VERIFYSTATUS = '2'
                       AND STOCK.BILLDATE >= P_QDATEFROM
                       AND STOCK.BILLDATE <= P_QDATETO
                       AND STOCK.ACCEPTWAREHOUSE = P_WAREHOUSEID
                       AND STOCK.STOCKBILLID = STOCKDETAIL.STOCKBILLID
                     GROUP BY STOCKDETAIL.MATERIALID,
                               STOCK.ACCEPTWAREHOUSE,
                               STOCKDETAIL.BATCHNO,
                               STOCKDETAIL.Issupplierout
                    UNION ALL
                    -- ��������
                    SELECT STOCKDETAIL.MATERIALID,
                           STOCK.ISSUEWAREHOUSE WAREHOUSEID,
                           STOCKDETAIL.BATCHNO,
                           STOCKDETAIL.Issupplierout,
                           0 AS PRICE,
                           0 AS PRECOUNT,
                           0 AS PRESUMCOUNT,
                           0 AS INCOUNT,
                           0 AS INSUM,
                           SUM(STOCKDETAIL.COUNT) AS OUTCOUNT,
                           SUM(STOCKDETAIL.TOTALSUM) AS OUTSUM
                      FROM MM_STOCKBILLDETAILGD STOCKDETAIL,
                           MM_STOCKBILLGD       STOCK
                     WHERE STOCK.BILLTYPE = '1'
                       AND STOCK.VERIFYSTATUS = '2'
                       AND STOCK.BILLDATE >= P_QDATEFROM
                       AND STOCK.BILLDATE <= P_QDATETO
                       AND STOCK.ISSUEWAREHOUSE = P_WAREHOUSEID
                       AND STOCK.STOCKBILLID = STOCKDETAIL.STOCKBILLID
                     GROUP BY STOCKDETAIL.MATERIALID,
                              STOCK.ISSUEWAREHOUSE,
                              STOCKDETAIL.BATCHNO,
                              STOCKDETAIL.Issupplierout
                    UNION ALL
                    -- �����½�����
                    SELECT DETAIL.MATERIALID,
                           WHM.WAREHOUSEID,
                           DETAIL.BATCHNO,
                           DETAIL.Issupplierout,
                           NVL(DETAIL.PRICE, 0) PRICE,
                           SUM(DETAIL.ENDINGCOUNT) PRECOUNT,
                           SUM(DETAIL.SUMCOUNT) PRESUMCOUNT,
                           0 AS INCOUNT,
                           0 AS INSUM,
                           0 AS OUTCOUNT,
                           0 AS OUTSUM
                      FROM MM_WHMONTHLYCLOSINGMNGGD     WHM,
                           MM_WHMONTHLYCLOSINGDEATAILGD DETAIL
                     WHERE WHM.YEARNUM = V_PREYEAR
                       AND WHM.MONTHNUM = V_PREMONTH
                       AND WHM.WAREHOUSEID = P_WAREHOUSEID
                       AND WHM.WHMONID = DETAIL.WHMONID
                     GROUP BY DETAIL.MATERIALID,
                              WHM.WAREHOUSEID,
                              DETAIL.BATCHNO,
                              DETAIL.PRICE,
                              DETAIL.Issupplierout) RESULTINFO
             GROUP BY RESULTINFO.MATERIALID,
                      RESULTINFO.WAREHOUSEID,
                      RESULTINFO.BATCHNO,
                      RESULTINFO.Issupplierout
            HAVING NOT(SUM(RESULTINFO.PRECOUNT) = 0 AND SUM(RESULTINFO.PRESUMCOUNT) = 0 AND SUM(RESULTINFO.INCOUNT) = 0 AND SUM(RESULTINFO.INSUM) = 0 AND SUM(RESULTINFO.OUTCOUNT) = 0 AND SUM(RESULTINFO.OUTSUM) = 0)) RESULTINFO;
  --�ɹ�
  SELECT '1' INTO REFLG FROM DUAL;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    REFLG := '0';
    ROLLBACK;
END;
/

prompt
prompt Creating procedure P_MONTHEND
prompt =============================
prompt
create or replace procedure aptspzh.P_MonthEnd
(
p_userid in varchar2,
p_empname in varchar2,
p_month IN VARCHAR2,
p_startdate in varchar2,
p_enddate in VARCHAR2,
p_tickethouse in  VARCHAR2,
isLast in char ,
p_info out varchar2)
AS
lastmonth DATE;
thismonth DATE;
--startdate DATE;
--enddate DATE;
TYPE t_MonthEnd IS REF CURSOR;
  v_CursorVar t_MonthEnd;
v_TKCLASSNAME VARCHAR2(30);
v_TKCLASSCODE VARCHAR2(30);
v_PIECENUM NUMBER;
v_MONEY NUMBER;
v_CARDID VARCHAR2(30);
v_OPERATOR VARCHAR2(30);
v_Count NUMBER;
Begin
p_info:='';
thismonth := to_date(p_month || '-01','yyyy-mm-dd');
lastmonth := Add_Months(thismonth,-1);
--startdate := to_date(p_startdate,'yyyy-mm-dd');
--enddate := to_date(p_enddate,'yyyy-mm-dd');
--SELECT orgid FROM MCRUserOrgGS WHERE userid=p_userid;
-------------------------------------------------------------------------------------------------
--ɾ����������
-------------------------------------------------------------------------------------------------
DELETE FROM bfarejzmonth
 WHERE accountmonth = thismonth
   and tickethouse = p_tickethouse;
--Ա���½�
INSERT INTO bfarejzmonth
  (recorder,
   cardid,
   biztype,
   tkclasscode,
   tkclassname,
   lastpiecenum,
   lastmoney,
   getpiecenum,
   getmoney,
   gopiecenum,
   gomoney,
   curpiecenum,
   curmoney,
   accountrecorder,
   accountdate,
   accountmonth,
   tickethouse,
   emporgid )
  SELECT recorder,
         cardid,
         biztype,
         tkclasscode,
         tkclassname,
         SUM(lastpiecenum) AS lastpiecenum,
         SUM(lastmoney) AS lastmoney,
         SUM(getpiecenum) AS getpiecenum,
         SUM(getmoney) AS getmoney,
         SUM(gopiecenum) AS gopiecenum,
         sum(gomoney) gomoney,
         0 AS curpiecenum,
         0 AS curmoney,
         p_empname AS accountrecorder,
         SYSDATE AS accountdate,
         thismonth AS accountmonth,
         p_tickethouse,
         emporgid
FROM
(
 --���½������
SELECT b.recorder,
       to_char(b.cardid) as cardid,
       b.biztype,
       to_char(b.tkclasscode) as tkclasscode,
       b.tkclassname,
       b.curpiecenum AS lastpiecenum,
       b.curmoney AS lastmoney,
       0 AS getpiecenum,
       0 AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       b.emporgid
  FROM bfarejzmonth b, Mcemployeeinfogs emp
 WHERE b.recorder = emp.empid
   AND b.accountmonth = lastmonth
   and b.tickethouse = p_tickethouse
UNION ALL
( --���½�������
    SELECT t.OP AS recorder,
     emp.cardid AS cardid,
     t.biztype AS biztype,
     to_char(t.TKCLASSCODE) as TKCLASSCODE ,
     t.TKCLASSNAME,
     0 AS lastpiecenum,
     0 AS lastmoney,
     SUM(t.getpiecenum) AS getpiecenum,
     SUM(t.getMONEY) AS getmoney,
     SUM(t.gopiecenum) AS gopiecenum,
     SUM(t.goMONEY) AS gomoney,
     t.emporgid
  FROM Mcemployeeinfogs emp,
(
--1��Ʊ������----------------------------------------------------------------------------------------
--Ʊ��Ա���
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       t1.piecenum AS getpiecenum,
       t2.bizdate,
       t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS OP,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t2.TKACNTID = t1.tkacntID
   AND t2.biztype = 'P1'
   AND t2.flag = '1'
UNION ALL
----Ʊ��Ա��Ʊ
SELECT 'P' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       t1.piecenum AS gopiecenum,
       t1.MONEY AS gomoney,
       t2.entryuser AS OP,
       t1.tickethouse,
       t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t2.TKACNTID = t1.tkacntID
   AND t2.biztype = 'F1'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ��Ʊ��Ʊ��Ա
SELECT 'P' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       -t1.piecenum AS gopiecenum,
       -t1.MONEY AS gomoney,
       t2.entryuser AS OP,
       t1.tickethouse,
       t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t2.TKACNTID = t1.tkacntID
   and t2.biztype = 'F2'
   and t2.flag = '1'
---2����ƱԱ---------------------------------------------------------------
UNION ALL
--��ƱԱ���
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       t1.piecenum AS getpiecenum,
       t2.bizdate,
       t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'F1'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ��Ʊ��Ʊ��Ա
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       -t1.piecenum AS getpiecenum,
       t2.bizdate,
       -t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'F2'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ֮��תƱ��ת��
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       -t1.piecenum AS getpiecenum,
       t2.bizdate,
       -t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'Z1'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ֮��תƱ��ת��
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       t1.piecenum AS getpiecenum,
       t2.bizdate,
       t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.receiver AS OP,
       t1.tickethouse,
       t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'Z1'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ��Ʊ
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       t1.piecenum AS gopiecenum,
       t1.MONEY AS gomoney,
       t2.entryuser AS op,
       t1.tickethouse,
        t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'C1'
   AND t2.flag = '1'
UNION ALL
--����Ա��Ʊ����ƱԱ
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       -t1.piecenum AS gopiecenum,
       -t1.MONEY AS gomoney,
       t2.entryuser AS op,
       t1.tickethouse,
        t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'C2'
   AND t2.flag = '1'
UNION ALL
--��ƱԱ��Ʊ
SELECT 'F' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       t1.piecenum AS gopiecenum,
       t1.MONEY AS gomoney,
       t2.operator AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'F3'
   AND t2.flag = '1'
---3������Ա-------------------------------------------------------------------------------------
UNION ALL
--����Ա��Ʊ
SELECT 'C' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       t1.piecenum AS getpiecenum,
       t2.bizdate,
       t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'C1'
   AND t2.flag = '1'
UNION ALL
---����Ա��Ʊ����ƱԱ
SELECT 'C' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       -t1.piecenum AS getpiecenum,
       t2.bizdate,
       -t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'C2'
   AND t2.flag = '1'
UNION ALL
--����Ա֮��תƱ��ת��
SELECT 'C' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       -t1.piecenum AS getpiecenum,
       t2.bizdate,
       -t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'Z2'
   AND t2.flag = '1'
UNION ALL
---����Ա֮��תƱ��ת��
SELECT 'C' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       t1.piecenum AS getpiecenum,
       t2.bizdate,
       t1.MONEY AS getmoney,
       0 AS gopiecenum,
       0 AS gomoney,
       t2.receiver AS OP,
       t1.tickethouse,
       t2.outemporgid as emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'Z2'
   AND t2.flag = '1'
UNION ALL
---����Ա����
SELECT 'C' AS biztype,
       t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       0 AS getpiecenum,
       t2.bizdate,
       0 AS getmoney,
       t1.piecenum AS gopiecenum,
       t1.MONEY AS gomoney,
       t2.OPERATOR AS op,
       t1.tickethouse,
       t2.emporgid
  FROM bfareTKacntdetail t1, bfaretkacnt t2
 WHERE t1.TKACNTID = t2.tkacntID
   AND t2.biztype = 'J1'
   AND t2.flag = '1'
---����Ա��������
---��ʵ��
)t
WHERE   t.bizdate>=to_date(p_startdate,'yyyy-mm-dd')
AND t.bizdate<=to_date(p_enddate,'yyyy-mm-dd')
AND emp.empid = t.op
and t.tickethouse = p_tickethouse
GROUP BY t.TKCLASSNAME,t.TKCLASSCODE, emp.cardid,t.emporgid,t.OP,t.biztype
)
)
GROUP BY recorder,cardid,emporgid,biztype,tkclasscode,tkclassname
;
---------------------------------------------------------------------------------------------------
--���½�ת����
IF (isLast='0') THEN  --��ʹ�ô�Ʊ��Ϊ��ĩ����
UPDATE bfarejzmonth
   set curpiecenum = lastpiecenum + getpiecenum - gopiecenum,
       curmoney    = lastmoney + getmoney - gomoney
 WHERE accountmonth = thismonth
   and tickethouse = p_tickethouse;
  ELSE --ʹ�ô�Ʊ��Ϊ��ĩ����
--Ʊ���ܹܴ�Ʊ
OPEN v_CursorVar FOR
SELECT t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       SUM(t1.curpiecenum) piecenum,
       SUM(t1.CURMONEY) money,
       t2.cardid,
       t1.recorder
  FROM bfareTKStock t1, mcemployeeinfogs t2
 WHERE t1.recorder = t2.empid
   and t1.tickethouse = p_tickethouse
 GROUP BY t1.TKCLASSNAME, t1.TKCLASSCODE, t1.recorder, t2.cardid;
LOOP
FETCH v_CursorVar INTO v_TKCLASSNAME,v_TKCLASSCODE,v_PIECENUM,v_MONEY,v_CARDID,v_OPERATOR;
SELECT COUNT(*) INTO v_Count
        FROM bfarejzmonth
        WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
              AND accountmonth IS NULL AND biztype='P'
              and tickethouse = p_tickethouse;
IF ( v_Count > 0 ) THEN
            UPDATE bfarejzmonth SET
curpiecenum = v_PIECENUM,
curmoney = v_MONEY
            WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
                  AND accountmonth IS NULL AND biztype='P'
                  and tickethouse = p_tickethouse ;
        ELSE
            INSERT INTO bfarejzmonth
(TKCLASSNAME,TKCLASSCODE,biztype,cardid,recorder,curpiecenum,curmoney,TICKETHOUSE)
            VALUES
( v_TKCLASSNAME,v_TKCLASSCODE,'P',v_CARDID,v_OPERATOR,v_PIECENUM,v_MONEY,p_tickethouse);
END IF;
    END LOOP;
CLOSE v_CursorVar;
--��ƱԱ��Ʊ
OPEN v_CursorVar FOR
SELECT t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       SUM(t1.curpiecenum) piecenum,
       SUM(t1.CURMONEY) money,
       t2.cardid,
       t1.recorder
  FROM bfareFKStock t1, mcemployeeinfogs t2
 WHERE t1.recorder = t2.empid
   and t1.tickethouse = p_tickethouse
 GROUP BY t1.TKCLASSNAME, t1.TKCLASSCODE, t1.recorder, t2.cardid;
LOOP
FETCH v_CursorVar INTO v_TKCLASSNAME,v_TKCLASSCODE,v_PIECENUM,v_MONEY,v_CARDID,v_OPERATOR;
SELECT COUNT(*) INTO v_Count
        FROM bfarejzmonth
        WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
              AND accountmonth IS NULL AND biztype='F'
              and tickethouse = p_tickethouse;
IF ( v_Count > 0 ) THEN
           UPDATE bfarejzmonth SET
curpiecenum = v_PIECENUM,
                  curmoney = v_MONEY
           WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
                 AND accountmonth IS NULL AND biztype='F'
                 and tickethouse = p_tickethouse ;
        ELSE
           INSERT INTO bfarejzmonth
(TKCLASSNAME,TKCLASSCODE,biztype,cardid,recorder,curpiecenum,curmoney,TICKETHOUSE)
           VALUES
(v_TKCLASSNAME,v_TKCLASSCODE,'F',v_CARDID,v_OPERATOR,v_PIECENUM,v_MONEY,p_tickethouse);
        END IF;
END LOOP;
CLOSE v_CursorVar;
--����Ա��Ʊ
OPEN v_CursorVar FOR
         SELECT t1.TKCLASSNAME,
       t1.TKCLASSCODE,
       SUM(t1.curpiecenum) piecenum,
       SUM(t1.CURMONEY) money,
       t2.cardid,
       t1.recorder
  FROM bfareCKStock t1, mcemployeeinfogs t2
 WHERE t1.recorder = t2.empid
   and tickethouse = p_tickethouse
 GROUP BY t1.TKCLASSNAME, t1.TKCLASSCODE, t1.recorder, t2.cardid;
    LOOP
FETCH v_CursorVar INTO v_TKCLASSNAME,v_TKCLASSCODE,v_PIECENUM,v_MONEY,v_CARDID,v_OPERATOR;
SELECT COUNT(*) INTO v_Count
FROM  bfarejzmonth
        WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
              AND accountmonth IS NULL AND biztype='C'
              and tickethouse = p_tickethouse ;
IF ( v_Count > 0 ) THEN
           UPDATE bfarejzmonth SET
curpiecenum = v_PIECENUM,
                  curmoney = v_MONEY
           WHERE TKCLASSCODE = v_TKCLASSCODE AND cardid = v_CARDID
                AND accountmonth IS NULL AND biztype='C'
                and tickethouse = p_tickethouse ;
        ELSE
           INSERT INTO bfarejzmonth
(TKCLASSNAME,TKCLASSCODE,biztype,cardid,recorder,curpiecenum,curmoney,tickethouse)
           VALUES
(v_TKCLASSNAME,v_TKCLASSCODE,'C',v_CARDID,v_OPERATOR,v_PIECENUM,v_MONEY,p_tickethouse);
        END IF;
END LOOP;
CLOSE v_CursorVar;
  END IF;
-------------------------------------------------------------------------------------------------------
COMMIT;
END P_MonthEnd;
/

prompt
prompt Creating procedure P_MONTHLY_BUSRUN
prompt ===================================
prompt
create or replace procedure aptspzh.P_MONTHLY_BUSRUN(V_ORGID          IN NVARCHAR2, -- ��֯ID
                                             V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                             V_ENDTIME        IN DATE, -- ����ʱ��
                                             V_YEARMONTH      IN DATE, -- ��¼�·�
                                             V_EMPID          IN NVARCHAR2, -- ������
                                             V_MONTHLYCARRYID IN VARCHAR2 --�½�����ID
                                             ) IS
  V_ORGTYPE     VARCHAR2(2) := '';
  V_CONVERTTYPE VARCHAR2(2) := '0';
  V_MDDATA      NUMBER := 0;
BEGIN
  --��ѯ��֯����
  SELECT T.ORGTYPE
    INTO V_ORGTYPE
    FROM MCORGINFOGS T
   WHERE T.ORGID = V_ORGID;
  DELETE FROM OM_MS_MONTHLYDATAGD
   WHERE mdobjectid = V_ORGID
     AND yearmonth = V_YEARMONTH
     AND converttype = V_CONVERTTYPE;
  COMMIT;
  --0������(��)
  SELECT COUNT(1)
    INTO V_MDDATA
    FROM (SELECT DISTINCT RUNDATADATE, BUSID
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1');
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --0������(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '0',
     '',
     V_MDDATA);
  --1������ʱ(��ʱ)
  SELECT ROUND(NVL(SUM(WORKTIME), 0), 3)
    INTO V_MDDATA
    FROM (SELECT RUNDATADATE,
                 BUSID,
                 24 * (MAX(ARRIVETIME) - MIN(LEAVETIME)) WORKTIME
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1'
           GROUP BY RUNDATADATE, BUSID);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --1������ʱ(��ʱ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '1',
     '',
     V_MDDATA);
  --2Ӫҵ��ʱ(��ʱ)
  SELECT ROUND(NVL(SUM(WORKTIME), 0), 3)
    INTO V_MDDATA
    FROM (SELECT RUNDATADATE,
                 BUSID,
                 24 * (MAX(ARRIVETIME) - MIN(LEAVETIME)) WORKTIME
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1'
             AND RECTYPE = '1'
           GROUP BY RUNDATADATE, BUSID);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --2Ӫҵ��ʱ(��ʱ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '2',
     '',
     V_MDDATA);
  --3�ϼ�-��ʻ����(��)
  SELECT NVL(SUM(SEQNUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --3�ϼ�-��ʻ����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '3',
     '',
     V_MDDATA);
  --4����-��ʻ����(��)
  SELECT NVL(SUM(SEQNUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1'
     AND ISLATE = '0';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --4����-��ʻ����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '4',
     '',
     V_MDDATA);
  --5���-��ʻ����(��)
  SELECT NVL(SUM(SEQNUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1'
     AND (ISLATE = '1' OR ISLATE = '2');
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --5���-��ʻ����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '5',
     '',
     V_MDDATA);
  --6���-��ʻ����(��)
  SELECT NVL(SUM(SEQNUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1'
     AND ISLATE = '3';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --6���-��ʻ����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '6',
     '',
     V_MDDATA);
  --7������-��ʻ����(��)
  SELECT NVL(ROUND(100 * SUM(CASE
                           WHEN ISLATE = '0' THEN
                            NVL(SEQNUM, 0)
                           ELSE
                            0
                         END) / NVL(SUM(SEQNUM), 0),
               3),0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --7������-��ʻ����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '7',
     '',
     V_MDDATA);
  --8�ϼ�-��ʻ���(����)
  SELECT NVL(SUM(MILENUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --8�ϼ�-��ʻ���(����)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '8',
     '',
     V_MDDATA);
  --9Ӫҵ���-��ʻ���(����)
  SELECT NVL(SUM(MILENUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --9Ӫҵ���-��ʻ���(����)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '9',
     '',
     V_MDDATA);
  --10�������-��ʻ���(����)
  SELECT NVL(SUM(MILENUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1'
     AND RECTYPE = '2';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --10�������-��ʻ���(����)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '10',
     '',
     V_MDDATA);
  --11����-����
  SELECT COUNT(1)
    INTO V_MDDATA
    FROM FDISBUSTRUBLELD
   WHERE RUNDATE >= TRUNC(V_BEGINTIME)
     AND RUNDATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISACTIVE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --11����-����
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '11',
     '',
     V_MDDATA);
  --12ʱ��(��)-����
  SELECT NVL(SUM(TROUBLETIME), 0)
    INTO V_MDDATA
    FROM FDISBUSTRUBLELD
   WHERE RUNDATE >= TRUNC(V_BEGINTIME)
     AND RUNDATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISACTIVE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --12ʱ��(��)-����
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '12',
     '',
     V_MDDATA);
  --13��/�ٹ���-����
  SELECT (case when NVL(SUM(TOTALMILE), 0)=0 then 0 else
  100 *60 * SUM(TROUBLETIME) / SUM(TOTALMILE)
         end)
    INTO V_MDDATA
    FROM (SELECT SUM(TROUBLETIME) TROUBLETIME, 0 TOTALMILE
            FROM FDISBUSTRUBLELD
           WHERE RUNDATE >= TRUNC(V_BEGINTIME)
             AND RUNDATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISACTIVE = '1'
          UNION
          SELECT 0 TROUBLETIME, SUM(MILENUM) TOTALMILE
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1');
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --13��/�ٹ���-����
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '13',
     '',
     V_MDDATA);
  COMMIT;
END P_MONTHLY_BUSRUN;
/

prompt
prompt Creating procedure P_MONTHLY_BUSRUNFORYC
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MONTHLY_BUSRUNFORYC(V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                             V_ENDTIME        IN DATE, -- ����ʱ��
                                             V_YEARMONTH      IN DATE -- ��¼�·�
                                             ) IS
BEGIN
  --��ѯ��֯����
  DELETE FROM MS_FDISBUSRUNRECGD
   WHERE YEARMONTH = V_YEARMONTH;
  DELETE FROM MS_FDISDISPLANLD
   WHERE YEARMONTH = V_YEARMONTH;
  COMMIT;
/*  INSERT INTO MS_FDISBUSRUNRECGD
    (MSBUSRUNID, YEARMONTH, ORGID, ORGNAME, ROUTEID, ROUTENAME, SUBROUTEID, SEGMENTID, SNGMILE, BUSID, BUSSELFID, BUSCARDID, EMPID, CARDID, EMPNAME, YYLC, FYYLC, JHCC, JHLC, SJCC, ZDCC, ZKLC, KSLC, BCLC, GWLC, XXLC, QTLC, LB_LDCC, LB_SGCC, LB_GZCC, LB_TTCC, LB_BJCC, LB_CDCC, LB_JFCC, LB_JQCC, LB_CZJHCC, LB_GWCC, LB_WBCC, LB_KBCC, LB_CKCC, LB_QTCC)*/
  --���α�
  BEGIN
INSERT INTO MS_FDISBUSRUNRECGD
SELECT S_BUSRUNDATA.NEXTVAL,V_YEARMONTH,T.* FROM
(SELECT
 T.ORGID,ORG.ORGNAME,T.ROUTEID,ROUTE.ROUTENAME,RROUTE.ROUTENAME YYROUTENAME,T.SUBROUTEID,T.SEGMENTID, SEG.SNGMILE,
T.BUSID,BUS.BUSSELFID,BUS.CARDID BUSCARDID, EMP.EMPID,EMP.CARDID,EMP.EMPNAME,
--Ӫ�����
SUM(CASE WHEN T.RECTYPE='1' THEN T.MILENUM ELSE 0 END) YYLC,
--��Ӫ�����
SUM(CASE WHEN T.RECTYPE='2' THEN T.MILENUM ELSE 0 END) FYYLC,
--Ӫ�˳���
SUM(CASE WHEN T.RECTYPE='1' THEN T.SEQNUM ELSE 0 END) YYCC,
--��Ӫ�˳���
SUM(CASE WHEN T.RECTYPE='2' THEN T.SEQNUM ELSE 0 END) FYYCC,
--ʵ�ʳ���
sum(case when  T.RECTYPE='1' and (t.SEQUENCETYPE=-1 or t.SEQUENCETYPE is null) then t.seqnum else 0 end) SJCC,
--���㳵��
SUM(CASE WHEN T.RECTYPE='1' AND T.ISLATE IN ('0') THEN T.SEQNUM ELSE 0 END) ZDCC,
-- ��㳵��
SUM(CASE WHEN T.RECTYPE='1' AND  T.ISLATE IN ('1','2') THEN T.SEQNUM ELSE 0 END) WDCC,
--�ؿ����
SUM(CASE WHEN T.RECTYPE='1' THEN T.MILENUM ELSE 0 END) ZKLC,
--��ʻ���
SUM(CASE WHEN T.RECTYPE='2' AND  T.BUSSID NOT IN ('0','14') THEN T.MILENUM ELSE 0 END) KSLC,
--�������
SUM(CASE WHEN T.BUSSID IN ('14') THEN T.MILENUM ELSE 0 END) BCLC,
--�������
SUM(CASE WHEN T.BUSSID IN ('0') THEN T.MILENUM ELSE 0 END) GWLC,
--С�����
SUM(CASE WHEN T.BUSSID IN ('31') THEN T.MILENUM ELSE 0 END) XXLC,
--�������
SUM(CASE WHEN T.BUSSID IN ('50') THEN T.MILENUM ELSE 0 END) QTLC,
--�Ӱ೵��
SUM(CASE WHEN T.SEQUENCETYPE=1 THEN T.SEQNUM ELSE 0 END) JBCC,
--����--�ܼ�
count(distinct TRB.BUSTRBID)GZ_ZJ,
--����--���Σ��˴γ��
sum(case when trb.ISACTIVE='1' then TRB.INVOLVEDSEQ else 0 end)GZ_CC,
COUNT(DISTINCT T.RUNDATADATE)CQR
FROM FDISBUSRUNRECGD T,MCROUTEINFOGS ROUTE,MCSUBROUTEINFOGS SUBROUTE,MCSEGMENTINFOGS SEG
,MCORGINFOGS ORG,MCBUSINFOGS BUS,MCEMPLOYEEINFOGS EMP,FDISDISPLANLD DISPLAN,
FDISBUSTRUBLELD TRB,ASGNREMPROUTELD REMP,MCROUTEINFOGS RROUTE
WHERE T.ROUTEID=ROUTE.ROUTEID AND T.ORGID=ORG.ORGID
AND T.SUBROUTEID=SUBROUTE.SUBROUTEID AND T.SEGMENTID=SEG.SEGMENTID
AND T.BUSID=BUS.BUSID AND T.DRIVERID=EMP.EMPID
AND T.DRIVERID=REMP.EMPID AND REMP.ROUTEID=RROUTE.ROUTEID
AND T.DISPLANID=DISPLAN.DISPLANID(+)
AND DISPLAN.DISPLANBUSTRBID=TRB.BUSTRBID(+)
AND DISPLAN.RUNDATE=TRB.RUNDATE(+)
AND T.RUNDATADATE>=V_BEGINTIME
AND T.RUNDATADATE<=V_ENDTIME
AND DISPLAN.RUNDATE>=V_BEGINTIME
AND DISPLAN.RUNDATE<=V_ENDTIME
AND T.ISAVAILABLE='1'
GROUP BY T.ORGID,ORG.ORGNAME,ROUTE.ROUTENAME,RROUTE.ROUTENAME,T.ROUTEID,T.SUBROUTEID,T.SEGMENTID, SEG.SNGMILE,
T.BUSID,BUS.BUSSELFID,BUS.CARDID,EMP.EMPID,EMP.CARDID,EMP.EMPNAME)T;

COMMIT;
INSERT INTO MS_FDISDISPLANLD
SELECT S_BUSRUNDATA.NEXTVAL,V_YEARMONTH,T.* FROM
(SELECT
 DISPLAN.ORGID,DISPLAN.ROUTEID,DISPLAN.SUBROUTEID,DISPLAN.SEGMENTID,
DISPLAN.BUSID, DISPLAN.DRIVERID,
--�ƻ�����
SUM(TT.SEQCOUNT1)JHCC,
--�ƻ��˴�
COUNT(TT.ARRANGESID)JHTC,
--�ƻ����
SUM(TT.MILEAGE)JHLC,
--�ð�-·�³���
SUM(CASE WHEN FAKE.FAKETYPE='6' THEN DISPLAN.SEQNUM ELSE 0 END) LB_LDCC,
--�ð�-�¹ʳ���
SUM(CASE WHEN FAKE.FAKETYPE='8' THEN DISPLAN.SEQNUM ELSE 0 END) LB_SGCC,
--�ð�-���ϳ���
SUM(CASE WHEN FAKE.FAKETYPE='3' THEN DISPLAN.SEQNUM ELSE 0 END) LB_GZCC,
--�ð�-��ͣ����
SUM(CASE WHEN FAKE.FAKETYPE='10' THEN DISPLAN.SEQNUM ELSE 0 END) LB_TTCC,
--�ð�-���ٳ���
SUM(CASE WHEN FAKE.FAKETYPE='1' THEN DISPLAN.SEQNUM ELSE 0 END) LB_BJCC,
--�ð�-�ٵ�����
SUM(CASE WHEN FAKE.FAKETYPE='12' THEN DISPLAN.SEQNUM ELSE 0 END) LB_CDCC,
--�ð�-���׳���
SUM(CASE WHEN FAKE.FAKETYPE='4' THEN DISPLAN.SEQNUM ELSE 0 END) LB_JFCC,
--�ð�-��������
SUM(CASE WHEN FAKE.FAKETYPE='11' THEN DISPLAN.SEQNUM ELSE 0 END) LB_JQCC,
--�ð�-���ػ�/Ʊ�仵����
SUM(CASE WHEN FAKE.FAKETYPE='14' THEN DISPLAN.SEQNUM ELSE 0 END) LB_CZJHCC,
--�ð�-���񳵴�
SUM(CASE WHEN FAKE.FAKETYPE='13' THEN DISPLAN.SEQNUM ELSE 0 END) LB_GWCC,
--�ð�-��೵��
SUM(CASE WHEN FAKE.FAKETYPE='7' THEN DISPLAN.SEQNUM ELSE 0 END) LB_WBCC,
--�ð�-�۱�����
SUM(CASE WHEN FAKE.FAKETYPE='5' THEN DISPLAN.SEQNUM ELSE 0 END) LB_KBCC,
--�ð�-���۳���
SUM(CASE WHEN FAKE.FAKETYPE='2' THEN DISPLAN.SEQNUM ELSE 0 END) LB_CKCC,
--�ð�-��������
SUM(CASE WHEN FAKE.FAKETYPE='9' THEN DISPLAN.SEQNUM ELSE 0 END) LB_QTCC,
--�ð೵��
SUM(CASE WHEN FAKE.FAKETYPE IS NOT NULL THEN DISPLAN.SEQNUM ELSE 0 END) LBCC
FROM FDISDISPLANLD DISPLAN,FDISFAKESEQGD FAKE,asgnarrangeseqgd tt,asgnarrangegd arrange
where DISPLAN.arrangesid(+)  = tt.arrangesid
and tt.ARRANGEID=arrange.ARRANGEID and arrange.status='d'
AND DISPLAN.DISPLANFAKESEQID=FAKE.FAKESEQID(+)
AND DISPLAN.RUNDATE=FAKE.RUNDATE(+)
AND arrange.EXECDATE>=V_BEGINTIME
AND arrange.EXECDATE<=V_ENDTIME
AND DISPLAN.RUNDATE>=V_BEGINTIME
AND DISPLAN.RUNDATE<=V_ENDTIME
--AND DISPLAN.ISACTIVE='1'
GROUP BY DISPLAN.ORGID,DISPLAN.ROUTEID,DISPLAN.SUBROUTEID,DISPLAN.SEGMENTID,
DISPLAN.BUSID,DISPLAN.DRIVERID)T;
COMMIT;
 --��ѯ��֯����
  DELETE FROM MS_BUSDYNAMICDATALD
   WHERE YEARMONTH = V_YEARMONTH;
  COMMIT;
  INSERT INTO MS_BUSDYNAMICDATALD
    (MSBUSDYNAMICDATAID, YEARMONTH, ORGID, ROUTEID, BUSID, SJYYCR)
SELECT S_BUSRUNDATA.NEXTVAL,V_YEARMONTH,T.* FROM
(SELECT T.ORGID, T.ROUTEID,T.BUSID,COUNT(DISTINCT T.RUNDATADATE)SJYYCR FROM FDISBUSRUNRECGD T WHERE T.RUNDATADATE>=V_BEGINTIME
AND T.RUNDATADATE<=V_ENDTIME AND T.ISAVAILABLE='1' AND T.RECTYPE='1'
GROUP BY T.ORGID, T.ROUTEID,T.BUSID)T;
    COMMIT;
    END;
END P_MONTHLY_BUSRUNFORYC;
/

prompt
prompt Creating procedure P_MONTHLY_DRIVERSAFEMILE
prompt ===========================================
prompt
create or replace procedure aptspzh.P_MONTHLY_DRIVERSAFEMILE is
  /***********************************************************************************
  ���ƣ�P_MONTHLY_DRIVERSAFEMILE
  ��;����ʻԱ��ȫ����½�
  �������ʻԱ�¶Ȱ�ȫ��̼�¼��SS_DRIVERSAFEMILEMONTHRECGD
          ��ʻԱ�հ�ȫ�����ͼDRIVER_DAYMILE_V
  **********************************************************************************/
begin
  -- ɾ���Ѵ��ڵĵ�ǰ�����µİ�ȫ��̼�¼
  DELETE FROM SS_DRIVERSAFEMILEMONTHRECGD
   WHERE TO_CHAR(RECMONTH, 'YYYY-MM') =
         TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYY-MM');
  -- ���뵱ǰ�����µİ�ȫ��̼�¼
  INSERT INTO SS_DRIVERSAFEMILEMONTHRECGD
    (DRIVERSAFEMILEMONTHRECID, DRIVERID, RECMONTH, MONTHSAFEMILE, sign)
    SELECT S_FDISDISPLANGD.NEXTVAL,
           T.DRIVERID,
           T.RECMONTH,
           T.MONTHSAFEMILE,
           '1'
      FROM (SELECT DAYMILEREC.DRIVERID,
                   TO_DATE(DAYMILEREC.RECMONTH, 'YYYY-MM') AS RECMONTH,
                   SUM(DAYMILEREC.DAYSAFEMILE) AS MONTHSAFEMILE
              FROM (SELECT DRIVERDAYMILE.DRIVERID AS DRIVERID,
                           DRIVERDAYMILE.RUNDATE AS RUNDATE,
                           TO_CHAR(DRIVERDAYMILE.RUNDATE, 'YYYY-MM') AS RECMONTH,
                           SUM(DRIVERDAYMILE.MILE) AS DAYSAFEMILE
                      FROM DRIVER_DAYMILE_V DRIVERDAYMILE
                     WHERE TO_CHAR(DRIVERDAYMILE.RUNDATE, 'YYYY-MM') =
                           TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYY-MM')
                     GROUP BY DRIVERDAYMILE.DRIVERID, DRIVERDAYMILE.RUNDATE) DAYMILEREC
             GROUP BY DAYMILEREC.DRIVERID, DAYMILEREC.RECMONTH) T;
  -- �����ύ
  COMMIT;
end P_MONTHLY_DRIVERSAFEMILE;
/

prompt
prompt Creating procedure P_MONTHLY_FUEL
prompt =================================
prompt
create or replace procedure aptspzh.P_MONTHLY_FUEL(V_ORGID          IN NVARCHAR2, -- ��֯ID
                                           V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                           V_ENDTIME        IN DATE, -- ����ʱ��
                                           V_YEARMONTH      IN DATE, -- ��¼�·�
                                           V_EMPID          IN NVARCHAR2, -- ������

                                           V_MONTHLYCARRYID IN VARCHAR2 --�½�����ID
                                           ) IS
  V_ORGTYPE     VARCHAR2(2) := '';
  V_CONVERTTYPE VARCHAR2(2) := '2';
  V_MDDATA      NUMBER := 0;
BEGIN
  --��ѯ��֯����
  SELECT T.ORGTYPE
    INTO V_ORGTYPE
    FROM MCORGINFOGS T
   WHERE T.ORGID = V_ORGID;
  DELETE FROM OM_MS_MONTHLYDATAGD
   WHERE mdobjectid = V_ORGID
     AND yearmonth = V_YEARMONTH
     AND converttype = V_CONVERTTYPE;
  COMMIT;
  --0������--����(��)
  SELECT NVL(SUM(FUELNUM), 0)
    INTO V_MDDATA
    FROM dssfuelcostld
   WHERE RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND FUELTYPE = '2'
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --0������--����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '0',
     '',
     V_MDDATA);
  --1�ٹ���������--����(��/�ٹ���)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
   ROUND(100 * NVL(SUM(T.FUELNUM), 0) / SUM(TT.MILENUM), 3) end)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '2'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --1�ٹ���������--����(��/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '1',
     '',
     V_MDDATA);
  --2��ʻ���--����
  SELECT NVL(SUM(TT.MILENUM), 0)
    INTO V_MDDATA
    FROM (SELECT DISTINCT T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '2'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --2��ʻ���--����
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '2',
     '',
     V_MDDATA);
  --3���Ľڿ�--����(��/�ٹ���)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100 - T.FUELNUM),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '2'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.ROUTEID = V.routeid(+)
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --3���Ľڿ�--����(��/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '3',
     '',
     V_MDDATA);
     ----20�ƻ�������--����(��)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '2'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.ROUTEID = V.routeid(+)
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --20�ƻ�������--����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '3',
     '',
     V_MDDATA);
  --4������--����(��)
  SELECT NVL(SUM(FUELNUM), 0)
    INTO V_MDDATA
    FROM dssfuelcostld
   WHERE RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND FUELTYPE = '1'
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --4������--����(��)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '4',
     '',
     V_MDDATA);
  --5�ٹ���������--����(��/�ٹ���)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
   ROUND(100 * NVL(SUM(T.FUELNUM), 0) / SUM(TT.MILENUM), 3) end )
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '1'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --5�ٹ���������--����(��/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '5',
     '',
     V_MDDATA);
  --6��ʻ���--����
  SELECT NVL(SUM(TT.MILENUM), 0)
    INTO V_MDDATA
    FROM (SELECT DISTINCT T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '1'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --6��ʻ���--����
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '6',
     '',
     V_MDDATA);
  --7���Ľڿ�--����(��/�ٹ���)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100 - T.FUELNUM),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '1'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND T.ROUTEID = V.routeid(+)
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --7���Ľڿ�--����(��/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '7',
     '',
     V_MDDATA);
  --8������--��Ȼ��(������)
  SELECT NVL(SUM(FUELNUM), 0)
    INTO V_MDDATA
    FROM dssfuelcostld
   WHERE RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND FUELTYPE = '3'
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --8������--��Ȼ��(������)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '8',
     '',
     V_MDDATA);
  --9�ٹ���������--��Ȼ��(������/�ٹ���)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
   ROUND(100 * NVL(SUM(T.FUELNUM), 0) / SUM(TT.MILENUM), 3) end)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '3'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --9�ٹ���������--��Ȼ��(������/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '9',
     '',
     V_MDDATA);
  --10��ʻ���--��Ȼ��
  SELECT NVL(SUM(TT.MILENUM), 0)
    INTO V_MDDATA
    FROM (SELECT DISTINCT T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '3'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --10��ʻ���--��Ȼ��
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '10',
     '',
     V_MDDATA);
     --21�ƻ�������--��Ȼ��(������)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '3'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.ROUTEID = V.routeid(+)
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --21�ƻ�������--��Ȼ��(������)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '3',
     '',
     V_MDDATA);
  --11���Ľڿ�--��Ȼ��(������/�ٹ���)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100 - T.FUELNUM),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '3'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND T.ROUTEID = V.routeid(+)
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --11���Ľڿ�--��Ȼ��(������/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '11',
     '',
     V_MDDATA);
  --12������--�޹�糵(ǧ��ʱ)
  SELECT NVL(SUM(FUELNUM), 0)
    INTO V_MDDATA
    FROM dssfuelcostld
   WHERE RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND FUELTYPE = '4'
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --12������--�޹�糵(ǧ��ʱ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '12',
     '',
     V_MDDATA);
  --13�ٹ���������--�޹�糵(ǧ��ʱ/�ٹ���)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
  ROUND(100 * NVL(SUM(T.FUELNUM), 0) / SUM(TT.MILENUM), 3) end)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '4'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --13�ٹ���������--�޹�糵(ǧ��ʱ/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '13',
     '',
     V_MDDATA);
  --14��ʻ���--�޹�糵
  SELECT NVL(SUM(TT.MILENUM), 0)
    INTO V_MDDATA
    FROM (SELECT DISTINCT T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '4'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --14��ʻ���--�޹�糵
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '14',
     '',
     V_MDDATA);
  --15���Ľڿ�--�޹�糵(ǧ��ʱ/�ٹ���)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100 - T.FUELNUM),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '4'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND T.ROUTEID = V.routeid(+)
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --15���Ľڿ�--�޹�糵(ǧ��ʱ/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '15',
     '',
     V_MDDATA);
  --16������--���綯��(ǧ��ʱ)
  SELECT NVL(SUM(FUELNUM), 0)
    INTO V_MDDATA
    FROM dssfuelcostld
   WHERE RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND FUELTYPE = '5'
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --12������--���綯��(ǧ��ʱ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '16',
     '',
     V_MDDATA);
  --17�ٹ���������--���綯��(ǧ��ʱ/�ٹ���)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
   ROUND(100 * NVL(SUM(T.FUELNUM), 0) / SUM(TT.MILENUM), 3) end)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '5'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --17�ٹ���������--���綯��(ǧ��ʱ/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '17',
     '',
     V_MDDATA);
  --18��ʻ���--���綯��
  SELECT NVL(SUM(TT.MILENUM), 0)
    INTO V_MDDATA
    FROM (SELECT DISTINCT T.RUNNINGDATE, T.ORGID, T.BUSID, T.DRIVERID
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '5'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE, TT.ORGID, TT.BUSID, TT.DRIVERID) TT
   WHERE T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID;
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --18��ʻ���--���綯��
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '18',
     '',
     V_MDDATA);
  --19���Ľڿ�--���綯��(ǧ��ʱ/�ٹ���)
  SELECT NVL(SUM(TT.MILENUM * (CASE
                   WHEN V.routeid = T.ROUTEID THEN
                    NVL(V.routestdoilvalue + V.busstdoilvalue, V.bustypestdoilvalue)
                   ELSE
                    V.bustypestdoilvalue
                 END) / 100 - T.FUELNUM),
             0)
    INTO V_MDDATA
    FROM (SELECT T.RUNNINGDATE,
                 T.ORGID,
                 T.ROUTEID,
                 T.BUSID,
                 T.DRIVERID,
                 SUM(T.FUELNUM) FUELNUM
            FROM dssfuelcostld T
           WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
             AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
             AND T.FUELTYPE = '5'
             AND T.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY T.RUNNINGDATE, T.ORGID, T.ROUTEID, T.BUSID, T.DRIVERID) T,
         (SELECT TT.RUNDATADATE,
                 TT.ORGID,
                 TT.ROUTEID,
                 TT.BUSID,
                 TT.DRIVERID,
                 SUM(TT.MILENUM) MILENUM
            FROM FDISBUSRUNRECGD TT
           WHERE TT.RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND TT.RUNDATADATE <= TRUNC(V_ENDTIME)
             AND TT.ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
           GROUP BY TT.RUNDATADATE,
                    TT.ORGID,
                    TT.ROUTEID,
                    TT.BUSID,
                    TT.DRIVERID) TT,
         standardinfovw V
   WHERE T.ORGID = TT.ORGID
     AND T.ROUTEID = TT.ROUTEID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.DRIVERID = TT.DRIVERID
     AND T.BUSID = V.BUSID
     AND T.ROUTEID = V.routeid(+)
     AND ((T.RUNNINGDATE >= V.bustypestartdate AND
         T.RUNNINGDATE <= V.bustypeenddate) OR
         (T.RUNNINGDATE >= V.routestartdate AND
         T.RUNNINGDATE <= V.routeenddate) OR
         (T.RUNNINGDATE >= V.busstartdate AND
         T.RUNNINGDATE <= V.busenddate));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --19���Ľڿ�--���綯��(ǧ��ʱ/�ٹ���)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '19',
     '',
     V_MDDATA);
  COMMIT;
END P_MONTHLY_FUEL;
/

prompt
prompt Creating procedure P_MONTHLY_FUELFORYC
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MONTHLY_FUELFORYC(V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                             V_ENDTIME        IN DATE, -- ����ʱ��
                                             V_YEARMONTH      IN DATE -- ��¼�·�
                                             ) IS
BEGIN
  --��ѯ��֯����
  DELETE FROM MS_DSSFUELCOSTLD
   WHERE YEARMONTH = V_YEARMONTH;
  COMMIT;
  --�ͺı�
INSERT INTO MS_DSSFUELCOSTLD
SELECT S_BUSRUNDATA.NEXTVAL,V_YEARMONTH,T.* FROM
(--�ͺı�
SELECT T.ORGID,T.ROUTEID,
T.BUSID, T.DRIVERID,
--�ͺ����
SUM(CASE WHEN T.FUELTYPE IN ('1','2') THEN T.MILE ELSE 0 END) YHLC,
--�������
SUM(CASE WHEN T.FUELTYPE='3' THEN T.MILE ELSE 0 END) QHLC,
--�ͺ�
SUM(CASE WHEN T.FUELTYPE IN ('1','2') THEN T.FUELACT ELSE 0 END) YH,
--����
SUM(CASE WHEN T.FUELTYPE='3' THEN T.FUELACT ELSE 0 END) QH,
--������
SUM(FUELALLOWANCE) BTY,
--�ڿ���
SUM(CASE WHEN T.FUELTYPE IN ('1','2') THEN T.FUELCMP ELSE 0 END) JKY,
--�ڿ���
SUM(CASE WHEN T.FUELTYPE='3'  THEN T.FUELCMP ELSE 0 END) JKQ
FROM DRIVERFUELCOSTVW T
WHERE T.RUNDATADATE>=V_BEGINTIME AND T.RUNDATADATE<=V_ENDTIME
GROUP BY T.ORGID,T.ROUTEID,T.BUSID, T.DRIVERID
)T;
COMMIT;
END P_MONTHLY_FUELFORYC;
/

prompt
prompt Creating procedure P_MONTHLY_INCOME
prompt ===================================
prompt
create or replace procedure aptspzh.P_MONTHLY_INCOME(V_ORGID          IN NVARCHAR2, -- ��֯ID
                                             V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                             V_ENDTIME        IN DATE, -- ����ʱ��
                                             V_YEARMONTH      IN DATE, -- ��¼�·�
                                             V_EMPID          IN NVARCHAR2, -- ������
                                             V_MONTHLYCARRYID IN VARCHAR2 --�½�����ID
                                             ) IS

  V_ORGTYPE     VARCHAR2(2) := '';
  V_CONVERTTYPE VARCHAR2(2) := '1';
BEGIN
  --��ѯ��֯����
  SELECT T.ORGTYPE
    INTO V_ORGTYPE
    FROM MCORGINFOGS T
   WHERE T.ORGID = V_ORGID;
  --ɾ��Ӫ��
  DELETE FROM OM_MS_MONTHLYDATAGD
   WHERE mdobjectid = V_ORGID
     AND yearmonth = V_YEARMONTH
     AND converttype = V_CONVERTTYPE;
  --ɾ������
  DELETE FROM OM_MS_MONTHLYDATAGD
   WHERE mdobjectid = V_ORGID
     AND yearmonth = V_YEARMONTH
     AND converttype = 11;
  COMMIT;
  --Ӫ��
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           V_CONVERTTYPE,
           TICKETSORT,
           TICKETTYPE,
           TOTALINCOME
      FROM (SELECT TICKETSORT, TICKETTYPE, sum(TOTALINCOME) TOTALINCOME
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /* AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid)
             GROUP BY TICKETSORT, TICKETTYPE);
  --�ֽ��IC������Ӫ�պϼ�
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           V_CONVERTTYPE,
           TICKETSORT,
           '',
           TOTALINCOME
      FROM (SELECT TICKETSORT, sum(TOTALINCOME) TOTALINCOME
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /* AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid)
             GROUP BY TICKETSORT);
  COMMIT;
  --����
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           11,
           TICKETSORT,
           TICKETTYPE,
           PASSENGERFLOW
      FROM (SELECT TICKETSORT, TICKETTYPE, sum(PASSENGERFLOW) PASSENGERFLOW
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /*AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid)
             GROUP BY TICKETSORT, TICKETTYPE);
  --�ֽ��IC�����������ϼ�
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           11,
           TICKETSORT,
           '',
           PASSENGERFLOW
      FROM (SELECT TICKETSORT, sum(PASSENGERFLOW) PASSENGERFLOW
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /*AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid)
             GROUP BY TICKETSORT);
  --����Ӫ�պϼ�
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           V_CONVERTTYPE,
           '',
           '',
           TOTALINCOME
      FROM (SELECT sum(TOTALINCOME) TOTALINCOME
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /* AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid));
  --���������ϼ�
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
    SELECT S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
           V_MONTHLYCARRYID,
           V_ORGID,
           V_ORGTYPE,
           V_YEARMONTH,
           11,
           '',
           '',
           PASSENGERFLOW
      FROM (SELECT sum(PASSENGERFLOW) PASSENGERFLOW
              FROM DSSTICKETRECEIPTLD
             where OPERATIONDATE >= TRUNC(V_BEGINTIME)
               AND OPERATIONDATE <= TRUNC(V_ENDTIME)
                  /*AND ISACTIVE = '1'*/
               AND ORGID in
                   (select org.orgid --��֯ID
                      from mcorginfogs org
                     where org.isactive = '1'
                       and org.orgtype = '3'
                       and org.isoperationunit = '1'
                     start with org.orgid = V_ORGID
                    connect by prior org.orgid = org.parentorgid));
  COMMIT;
END P_MONTHLY_INCOME;
/

prompt
prompt Creating procedure P_MONTHLY_INCOMEFORYC
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_MONTHLY_INCOMEFORYC(V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                             V_ENDTIME        IN DATE, -- ����ʱ��
                                             V_YEARMONTH      IN DATE -- ��¼�·�
                                             ) IS
BEGIN
  --��ѯ��֯����
  DELETE FROM MS_DSSTICKETRECEIPTLD
   WHERE YEARMONTH = V_YEARMONTH;
  COMMIT;
  --Ӫ�ձ�
INSERT INTO MS_DSSTICKETRECEIPTLD
SELECT S_BUSRUNDATA.NEXTVAL,V_YEARMONTH,TT.* FROM
(--Ӫ�ձ�
SELECT T.ORGID,T.ROUTEID,T.BUSID, T.DRIVERID,SUM(XJSR)XJSR,
SUM(XJKL)XJKL,SUM(ICSR)ICSR,SUM(ICKL)ICKL
,SUM(ZSR)ZSR,SUM(ZKL)ZKL FROM
(
SELECT (CASE WHEN T.ORGID IS NOT NULL THEN T.ORGID ELSE
f_get_orgid_by_busid(TO_CHAR(T.BUSID),T.OPERATIONDATE) END)ORGID,T.OPERATIONDATE,T.ROUTEID,
T.BUSID, T.DRIVERID,
--�ֽ�����
SUM(CASE WHEN T.TICKETSORT='1' THEN T.TOTALINCOME ELSE 0 END) XJSR,
--�ֽ����
SUM(CASE WHEN T.TICKETSORT='1' THEN T.PASSENGERFLOW ELSE 0 END) XJKL,
--IC������
SUM(CASE WHEN T.TICKETSORT='2' THEN T.TOTALINCOME ELSE 0 END) ICSR,
--IC������
SUM(CASE WHEN T.TICKETSORT='2' THEN T.PASSENGERFLOW ELSE 0 END) ICKL,
--������
SUM(TOTALINCOME) ZSR,
--�ܿ���
SUM(PASSENGERFLOW) ZKL
FROM DSSTICKETRECEIPTLD T
WHERE T.OPERATIONDATE>=V_BEGINTIME AND T.OPERATIONDATE<=V_ENDTIME
GROUP BY T.ORGID,T.OPERATIONDATE,T.ROUTEID,T.BUSID,T.DRIVERID
)T GROUP BY T.ORGID,T.ROUTEID,T.BUSID,T.DRIVERID)TT;
COMMIT;
END P_MONTHLY_INCOMEFORYC;
/

prompt
prompt Creating procedure P_MONTHLY_MATERIAL
prompt =====================================
prompt
create or replace procedure aptspzh.P_MONTHLY_MATERIAL(V_ORGID          IN NVARCHAR2, -- ��֯ID
                                               V_BEGINTIME      IN DATE, -- ��ʼʱ��
                                               V_ENDTIME        IN DATE, -- ����ʱ��
                                               V_YEARMONTH      IN DATE, -- ��¼�·�
                                               V_EMPID          IN NVARCHAR2, -- ������
                                               V_MONTHLYCARRYID IN VARCHAR2 --�½�����ID
                                               ) IS
  V_ORGTYPE     VARCHAR2(2) := '';
  V_CONVERTTYPE VARCHAR2(2) := '3';
  V_MDDATA      NUMBER := 0;
BEGIN
  --��ѯ��֯����
  SELECT T.ORGTYPE
    INTO V_ORGTYPE
    FROM MCORGINFOGS T
   WHERE T.ORGID = V_ORGID;
  DELETE FROM OM_MS_MONTHLYDATAGD
   WHERE mdobjectid = V_ORGID
     AND yearmonth = V_YEARMONTH
     AND converttype = V_CONVERTTYPE;
  COMMIT;
  --0�����--���޲��Ϸ�(Ԫ)
  SELECT NVL(SUM(MILENUM), 0)
    INTO V_MDDATA
    FROM FDISBUSRUNRECGD
   WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
     AND RUNDATADATE <= TRUNC(V_ENDTIME)
     AND ORGID in (select org.orgid --��֯ID
                     from mcorginfogs org
                    where org.isactive = '1'
                      and org.orgtype = '3'
                      and org.isoperationunit = '1'
                    start with org.orgid = V_ORGID
                   connect by prior org.orgid = org.parentorgid)
     AND ISAVAILABLE = '1';
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --0�����--���޲��Ϸ�(Ԫ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '0',
     '',
     V_MDDATA);
  --1���Ϸ�-- ���޲��Ϸ�(Ԫ)
  SELECT NVL(sum(tt.totalsum), 0)
    INTO V_MDDATA
    FROM MM_STOCKBILLGD T, mm_stockbilldetailgd tt
   WHERE t.stockbillid = tt.stockbillid
     and T.BILLTYPE = '1'
     AND T.BILLFROM = '3'
     and t.BILLDATE >= TRUNC(V_BEGINTIME)
     AND t.BILLDATE <= TRUNC(V_ENDTIME)
     AND t.recorgid in
         (select org.orgid --��֯ID
            from mcorginfogs org
           where org.isactive = '1'
             and org.orgtype = '3'
             and org.isoperationunit = '1'
           start with org.orgid = V_ORGID
          connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --1���Ϸ�-- ���޲��Ϸ�(Ԫ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '1',
     '',
     V_MDDATA);

  SELECT (case when nvl(sum(totalmile),0)=0 then 0 else
   NVL(ROUND(100 * sum(cost) / sum(totalmile), 3), 0) end)
    INTO V_MDDATA
    FROM (SELECT NVL(SUM(MILENUM), 0) totalmile, 0 cost
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1'
          union
          SELECT 0 totalmile, sum(tt.totalsum) cost
            FROM MM_STOCKBILLGD T, mm_stockbilldetailgd tt
           WHERE t.stockbillid = tt.stockbillid
             and T.BILLTYPE = '1'
             AND T.BILLFROM = '3'
             and t.BILLDATE >= TRUNC(V_BEGINTIME)
             AND t.BILLDATE <= TRUNC(V_ENDTIME)
             AND t.recorgid in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid));
  --2�ٹ���--���޲��Ϸ�(Ԫ)
  SELECT (case when NVL(SUM(TT.MILENUM), 0)=0 then 0 else
   ROUND(100 * NVL(SUM(FUELNUM), 0) / SUM(TT.MILENUM), 3) end)
    INTO V_MDDATA
    FROM dssfuelcostld T, FDISBUSRUNRECGD TT
   WHERE T.RUNNINGDATE >= TRUNC(V_BEGINTIME)
     AND T.RUNNINGDATE <= TRUNC(V_ENDTIME)
     AND T.FUELTYPE = '2'
     AND T.ORGID = TT.ORGID
     AND T.BUSID = TT.BUSID
     AND T.RUNNINGDATE = TT.RUNDATADATE
     AND T.ORGID in
         (select org.orgid --��֯ID
            from mcorginfogs org
           where org.isactive = '1'
             and org.orgtype = '3'
             and org.isoperationunit = '1'
           start with org.orgid = V_ORGID
          connect by prior org.orgid = org.parentorgid);
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --2�ٹ���--���޲��Ϸ�(Ԫ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '2',
     '',
     V_MDDATA);
  --3��Լ--���޲��Ϸ�(Ԫ)
  select nvl(nvl(sum(std), 0) * nvl(sum(totalmile), 0) - nvl(sum(cost), 0),
             0)
    into V_MDDATA
    from (SELECT NVL(SUM(MILENUM), 0) totalmile, 0 cost, 0 std
            FROM FDISBUSRUNRECGD
           WHERE RUNDATADATE >= TRUNC(V_BEGINTIME)
             AND RUNDATADATE <= TRUNC(V_ENDTIME)
             AND ORGID in
                 (select org.orgid --��֯ID
                    from mcorginfogs org
                   where org.isactive = '1'
                     and org.orgtype = '3'
                     and org.isoperationunit = '1'
                   start with org.orgid = V_ORGID
                  connect by prior org.orgid = org.parentorgid)
             AND ISAVAILABLE = '1'
          union
          SELECT 0 totalmile,
                 tt.totalsum cost,
                 NVL(V.routestdstdvalue + V.busstdstdvalue,
                     V.bustypestdstdvalue) std
            FROM (SELECT T.BILLDATE,
                         T.RECROUTEID,
                         T.BUSID,
                         sum(TT.totalsum) totalsum
                    FROM MM_STOCKBILLGD T, mm_stockbilldetailgd tt
                   WHERE t.stockbillid = tt.stockbillid
                     and T.BILLTYPE = '1'
                     AND T.BILLFROM = '3'
                     and t.BILLDATE >= TRUNC(V_BEGINTIME)
                     AND t.BILLDATE <= TRUNC(V_ENDTIME)
                     AND t.recorgid in
                         (select org.orgid --��֯ID
                            from mcorginfogs org
                           where org.isactive = '1'
                             and org.orgtype = '3'
                             and org.isoperationunit = '1'
                           start with org.orgid = V_ORGID
                          connect by prior org.orgid = org.parentorgid)
                   GROUP BY T.BILLDATE, T.RECROUTEID, T.BUSID) TT,
                 standardinfovw V
           WHERE TT.BUSID = V.BUSID
             AND TT.RECROUTEID = V.routeid(+)
             AND ((TT.BILLDATE >= V.bustypestartdate AND
                 TT.BILLDATE <= V.bustypeenddate) OR
                 (TT.BILLDATE >= V.routestartdate AND
                 TT.BILLDATE <= V.routeenddate) OR
                 (TT.BILLDATE >= V.busstartdate AND
                 TT.BILLDATE <= V.busenddate)));
  INSERT INTO OM_MS_MONTHLYDATAGD
    (mdid,
     monthlycarryid,
     mdobjectid,
     mdobjecttype,
     yearmonth,
     converttype,
     converttypedetail,
     CONVERTTYPEDETAILCHILD,
     mddata)
  values
    (
     --3��Լ--���޲��Ϸ�(Ԫ)
     S_OM_MS_FDISBUSRUNREC_MR_GD.nextval,
     V_MONTHLYCARRYID,
     V_ORGID,
     V_ORGTYPE,
     V_YEARMONTH,
     V_CONVERTTYPE,
     '3',
     '',
     V_MDDATA);
  COMMIT;
END P_MONTHLY_MATERIAL;
/

prompt
prompt Creating procedure P_OM_APPDEVEVENT
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_APPDEVEVENT is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EVENT        T_CURSOR;
  CUR_ONLINE       T_CURSOR;
  V_LASTTIME       DATE; --�ϴ�ִ��ʱ��
  V_LASTSTATE      VARCHAR2(1);
  V_NOWTIME        DATE; --����ִ��ʱ��
  V_DEVTYPE        VARCHAR2(20); --�ն�����
  V_PRODUCTID      VARCHAR2(20); -- �ն˱��
  V_EVENTTYPE      VARCHAR2(20); -- ״̬����
  V_EVENTTIME      DATE; --״̬���ʱ��
  V_IP             VARCHAR2(20); --IP��ַ
  V_CFGVER         VARCHAR2(20); --�����ļ��汾��
  V_ROUTEID        VARCHAR2(20); --��ǰ��·
  V_SIMCARD        VARCHAR2(20); --SIM����
  V_SOFTVER        VARCHAR2(20); --����汾��
  V_EVENT          VARCHAR2(20); -- ״̬���ͣ���������ʱ����
  V_ETIME          DATE; --״̬���ʱ�䣨��������ʱ����
  V_ONLINETIME     NUMBER(12, 4); --����ʱ��
  V_STARTTIME      DATE; --��������ʼʱ�䣨��������ʱ����
  V_SIGN           VARCHAR2(1); --�������ж�֮ǰ�Ƿ��ǵ�½�¼�����������ʱ����
  V_EVENTNUM       NUMBER; --�������ն˵����ж����¼�����������ʱ����
  V_NUM            NUMBER; --������
  V_OFFLINENUM     NUMBER; --���ߴ���
  V_ISBEING        NUMBER; --�ж�OM_DEVEVENT���Ƿ�������
  V_OFFLINERATE    NUMBER(12, 4); --�ն˵�����
  V_STANDARDVALUE  NUMBER(6, 2); --��׼ֵ
  v_objectid       VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_ELEDEVEVENT
  ��;�� ����״̬���
  �����:   DEVEVENT5
            OM_DEVEVENT
            MS_MONITORREPORTGD
  ��д��������
  �޸�ʱ�䣺2013��12��11�� �޸��ˣ�������
  �޸�ʱ�䣺2014��01��18�� �޸��ˣ�������  �޸����ݣ��޸��Զ�Ѳ�칦��
  **************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --��ȡ��ǰʱ��
  V_NOWTIME := sysdate;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_APPDEVEVENT';
  if v_sign > 0 then
    select t.lasttime
      into V_LASTTIME
      from om_event_date t
     where t.eventname = 'P_OM_APPDEVEVENT';
    commit;
  else
    V_LASTTIME := to_date(to_char(V_NOWTIME, 'yyyy-MM-dd') || '03:00;00',
                          'yyyy-MM-dd HH24:mi:ss');
  end if;
  --���������û���¼������ݼ���ʱ��������Ƶ��
  for cur_devenvent in (SELECT t.deveventid,
                               round(t.onlinetime +
                                     to_number(V_NOWTIME - V_LASTTIME) * 24,
                                     2) as onlinetime,
                               t.offlinenum /
                               ceil(t.onlinetime +
                                    to_number(V_NOWTIME - V_LASTTIME) * 24) as offlinerate
                          FROM (select t.deveventid,
                                       t.productid,
                                       t.devtypecode,
                                       t.onlinetime,
                                       t.offlinenum
                                  from om_devevent t
                                 where t.recorddate =
                                       trunc(V_NOWTIME - 3 / 24)
                                   and t.devstate in (1, 2, 6, 7)
                                   and t.devtypecode in (3, 15)) t
                         WHERE NOT EXISTS
                         (SELECT d.productid
                                  FROM devevent5 d
                                 WHERE d.productid = t.productid
                                   and t.devtypecode = d.devtypecode
                                   and d.eventtime > V_LASTTIME
                                   and d.eventtime <= V_NOWTIME
                                   and d.devtypecode in (3, 15))) loop
    update om_devevent t
       set t.onlinetime  = cur_devenvent.onlinetime,
           t.offlinerate = cur_devenvent.offlinerate
     where t.deveventid = cur_devenvent.deveventid;
  end loop;

  --��ȡ�ն˵���������¼�
  --1:�����ն˷��ͱ�ʶ��2������վ�Ʒ��ͱ�ʶ��3������������ͱ�ʶ��4��IC���������ķ��ͱ�ʶ��5��IC�������ͱ�ʶ��6��ҵ�����ģ�7�����ݿ����ģ�8����Ϣ����ƽ̨��9�����ѷ�������10���߼���������11��ý�����ķ�������12����վ����13��ģ�⳵�ػ���14����������15�����ļ�������ʶ��16���洢����17���˿���Ϣ���񣨵���վ��+���ķ��������񣩣�18���ն���������19������ת������20���쳣������21��VOIP�������أ�22��δ֪Դ/Ŀ�����ͣ�
  --��ȡ���ϴ�ִ�иô洢���̺����ϱ�������
  open CUR_EVENT for
    select devevent.devtypecode,
           devevent.productid,
           devevent.eventtypecode,
           devevent.eventtime,
           devevent.ip,
           devevent.cfgver,
           devevent.routeid,
           devevent.simcardid,
           devevent.softver
      from (select row_number() over(partition by t.productid order by t.eventtime desc, t.eventtypecode asc) as num,
                   t.devtypecode,
                   t.productid,
                   t.eventtypecode,
                   t.eventtime,
                   t.ip,
                   t.cfgver,
                   t.routeid,
                   t.simcardid,
                   t.softver
              from devevent5 t
             where t.devtypecode in (3, 15)
               and t.eventtime > V_LASTTIME
               and t.eventtime <= V_NOWTIME) devevent
     where devevent.num = 1;
  --ѭ���α�
  <<firstloop>>
  LOOP
    FETCH CUR_EVENT
      INTO V_DEVTYPE, V_PRODUCTID, V_EVENTTYPE, V_EVENTTIME, V_IP, V_CFGVER, V_ROUTEID, V_SIMCARD, V_SOFTVER;
    -- û������ʱ�˳�
    EXIT WHEN CUR_EVENT%NOTFOUND;
    begin
      --��ȡ�ϴ�ִ�е���ǰʱ���ڵ�������
      select count(1)
        into V_EVENTNUM
        from devevent5 t
       where t.devtypecode = V_DEVTYPE
         and t.productid = V_PRODUCTID
         and t.eventtime > V_LASTTIME
         and t.eventtime <= V_NOWTIME;
      --��ȡ�ϴ�ִ�к��ͳ������
      select count(1)
        into v_sign
        from om_devevent t
       where t.devtypecode = 'V_SELDEVTYPEVLUE'
         and t.productid = 'V_PRODUCTID'
         and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      if v_sign > 0 then
        select t.devstate, t.onlinetime, t.offlinenum
          into V_LASTSTATE, V_ONLINETIME, V_OFFLINENUM
          from om_devevent t
         where t.devtypecode = 'V_SELDEVTYPEVLUE'
           and t.productid = 'V_PRODUCTID'
           and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      else
        V_LASTSTATE  := 0;
        V_ONLINETIME := 0;
        V_OFFLINENUM := 0;
      end if;
      V_NUM         := 1;
      V_OFFLINERATE := 0;
      open CUR_ONLINE for
        select t.eventtypecode, t.eventtime
          from devevent5 t
         where t.devtypecode = V_DEVTYPE
           and t.productid = V_PRODUCTID
           and t.eventtime > V_LASTTIME
           and t.eventtime <= V_NOWTIME
         order by t.eventtime asc;
      <<secondloop>>
      LOOP
        FETCH CUR_ONLINE
          INTO V_EVENT, V_ETIME;
        -- û������ʱ�˳�
        EXIT WHEN CUR_ONLINE%NOTFOUND;
        -- ������ߴ���
        if V_EVENT = '8' then
          V_OFFLINENUM := V_OFFLINENUM + 1;
        end if;
        --��������ʱ��
        if (V_LASTSTATE = '1' or V_LASTSTATE = '2' or V_LASTSTATE = '6' or
           V_LASTSTATE = '7') then
          V_SIGN      := '1';
          V_STARTTIME := V_LASTTIME;
        end if;
        if V_NUM < V_EVENTNUM then
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            if V_SIGN = '0' then
              V_SIGN      := '1';
              V_STARTTIME := V_ETIME;
            end if;
          else
            if V_SIGN = '1' then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
              V_SIGN       := '0';

            end if;
          end if;
        else
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            V_ONLINETIME := V_ONLINETIME +
                            to_number(V_NOWTIME - V_ETIME) * 24 * 60;
          else
            if (V_SIGN = '1') then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
            end if;
          end if;
          --���������
          if V_ONLINETIME > 0 then
            V_ONLINETIME  := V_ONLINETIME / 60;
            V_OFFLINERATE := V_OFFLINENUM / ceil(V_ONLINETIME);
          end if;
          --���¼����в���(����)����
          select count(1)
            into V_ISBEING
            from om_devevent t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE
             and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVEVENT
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER,
                 ONLINETIME,
                 OFFLINENUM,
                 OFFLINERATE,
                 RECORDDATE)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER,
                 round(V_ONLINETIME, 2),
                 V_OFFLINENUM,
                 round(V_OFFLINERATE, 2),
                 trunc(V_NOWTIME - 3 / 24));
              commit;
            end;
          else
            begin
              update om_devevent
                 set DEVSTATE    = V_EVENTTYPE,
                     EVENTTIME   = V_EVENTTIME,
                     IP          = V_IP,
                     CFGVER      = V_CFGVER,
                     ROUTEID     = V_ROUTEID,
                     SIMCARDID   = V_SIMCARD,
                     SOFTVER     = V_SOFTVER,
                     ONLINETIME  = round(V_ONLINETIME, 2),
                     OFFLINENUM  = V_OFFLINENUM,
                     OFFLINERATE = round(V_OFFLINERATE, 2)
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE
                 and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
              commit;
            end;
          end if;
          --����Ϣ���в���(����)����
          if (V_EVENTTYPE = '1' or V_EVENTTYPE = '2' or V_EVENTTYPE = '6' or
             V_EVENTTYPE = '7') then
            V_EVENTTYPE := '1';
          else
            V_EVENTTYPE := '0';
            V_ROUTEID   := '';
          end if;
          select count(1)
            into V_ISBEING
            from om_devbase t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE;
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVBASE
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER)
              values
                (to_char(S_OM_DEVBASE.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER);
              commit;
            end;
          else
            begin
              update OM_DEVBASE
                 set DEVSTATE  = V_EVENTTYPE,
                     EVENTTIME = V_EVENTTIME,
                     IP        = V_IP,
                     CFGVER    = V_CFGVER,
                     ROUTEID   = V_ROUTEID,
                     SIMCARDID = V_SIMCARD,
                     SOFTVER   = V_SOFTVER
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE;
              commit;
            end;
          end if;
        end if;
        V_NUM := V_NUM + 1;
        EXIT secondloop WHEN CUR_ONLINE%NOTFOUND;
      END LOOP secondloop;
      CLOSE CUR_ONLINE;
    end;
    EXIT firstloop WHEN CUR_EVENT%NOTFOUND;
  END LOOP firstloop;
  CLOSE CUR_EVENT;

    --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_APPDEVEVENT';
  if v_sign > 0 then
    update om_event_date t
       set t.lasttime = V_NOWTIME
     where t.eventname = 'P_OM_APPDEVEVENT';
    commit;
  else
    insert into om_event_date
      (EVENTNAME, LASTTIME)
    values
      ('P_OM_APPDEVEVENT', V_NOWTIME);
    commit;
  end if;
end P_OM_APPDEVEVENT;
/

prompt
prompt Creating procedure P_OM_BUSMASHINEMALMONITOR
prompt ============================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_BUSMASHINEMALMONITOR is
  v_objectid           VARCHAR2(20);
  v_newmonitorreportid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DVRMALMONITOR
  ��;�� DVR���ϼ��
  �����:   MS_MONITORREPORTGD
            OM_MONITORREPORTGD
  ��д��������
  ������ڣ�2014��01��17��
  �޸ģ�**************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --ɾ�����ϼ�ر��е��������
  delete from om_devmalmonitor t
   where t.monitordate = trunc(sysdate)
     and t.devtype = '1';
  commit;
  -- ������ϼ�ر�
  insert into om_devmalmonitor
    (DEVMALMONITORID,
     DEVTYPE,
     PRODUCTID,
     DEVCATEGORYTYPE,
     DEVCATEGORYSHOW,
     DEVCODE,
     DEVCODESHOW,
     DEVMALTYPE,
     DEVMALTYPESHOW,
     DEVMALTIME,
     MALNUM,
     MONITORDATE,
     SOFTVER)
    select to_char(DEVMALNUM.Nextval),
           mal.terminaltypecode,
           mal.productid,
           mal.devcategorytype,
           decode(mal.devcategorytype,
                  '1',
                  '����',
                  '2',
                  '���ڻ�',
                  '3',
                  'Ͷ�һ�',
                  '4',
                  'Υ��ץ����',
                  '5',
                  '���������豸',
                  '6',
                  '���ڱ�վ��',
                  '7',
                  'վ����',
                  '8',
                  '·��',
                  '9',
                  'ý�岥�Ż�',
                  '10',
                  '�����շѻ�') as devcategoryshow,
           decode(mal.devcode, '', '-1', null, '-1', mal.devcode),
           case
             when mal.devcode = '16' then
              'ǰ��'
             when to_number(mal.devcode) between 17 and 30 then
              '����' || to_char(to_number(mal.devcode) - 16)
             when mal.devcode = '31' then
              '����'
             when mal.devcode = '32' or mal.devcode = '33' then
              'վ����' || to_char(to_number(mal.devcode) - 31)
             when mal.devcode = '48' then
              'ͷ��'
             when to_number(mal.devcode) between 49 and 62 then
              '����' || to_char(to_number(mal.devcode) - 48)
             when mal.devcode = '63' then
              'β��'
             when mal.devcode = '64' or mal.devcode = '65' then
              'ý�岥�Ż�' || to_char(to_number(mal.devcode) - 63)
             when mal.devcode = '80' or mal.devcode = '81' then
              '�����շѻ�' || to_char(to_number(mal.devcode) - 79)
           end as devcodeshow,
           mal.devmaltype,
           case
             when mal.devcategorytype = '1' and mal.devcode = '1' then
              '��λģ�����'
             else
              '����ͨ�Ź���'
           end as devmaltypeshow,
           mal.devmaltime,
           mal.maltnum,
           trunc(sysdate),
           mal.softver
      from (select t.terminaltypecode,
                   t.productid,
                   t.devcategorytype,
                   t.devcode,
                   t.devmaltype,
                   t.softver,
                   max(t.devmaltime) devmaltime,
                   count(1) maltnum
              from bsvcdevmalrptld5 t
             where t.recdate >= trunc(sysdate)
               and t.terminaltypecode = '1'
             group by t.terminaltypecode,
                      t.productid,
                      t.devcategorytype,
                      t.devcode,
                      t.devmaltype,
                      t.softver) mal;
  commit;

  for cur_monitor in (select m.productid,
                             dev.busmachinetype,
                             dev.busmachinetypename,
                             dev.orgid,
                             dev.orgname,
                             dev.parentorgname,
                             dev.routename,
                             dev.busselfid,
                             dev.productserial,
                             m.devcategorytype,
                             m.devcategoryshow,
                             m.devcode,
                             m.devcodeshow,
                             m.devmaltype,
                             m.devmaltypeshow
                        from om_devmalmonitor       m,
                             om_reportsetstandardgd r,
                             om_monitordetailgd     d,
                             om_view_busmachine     dev
                       where not exists
                       (select null
                                from ms_monitorreportgd t
                               where t.devmaltype = m.devmaltype
                                 and t.devcode = m.devcode
                                 and t.devcategorytype = m.devcategorytype
                                 and t.productid = m.productid
                                 and t.repairstatus in (0, 1, 2, 3, 99)
                                 and t.devtypecode = '1')
                         and m.productid = dev.productid
                         and m.devcategorytype = d.devbreakdowntype
                         and r.reportsetstandardid = d.reportsetstandardid
                         and r.isautomaticreport = '1'
                         and r.isactive = '1'
                         and r.monitortype = '1'
                         and m.devtype = '1'
                         and m.malnum >= d.value
                         and m.monitordate = trunc(sysdate)) loop
    -- ������ϱ��ޱ�
    v_newmonitorreportid := F_OM_GETNEXSERVICEREPORTNO();
    insert into ms_monitorreportgd
      (MONITORREPORTID,
       DEVTYPECODE,
       DEVTYPESHOW,
       PRODUCTID,
       DEVMODEL,
       SERIALNUMBER,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       ERRORCHANNEL,
       DEVCATEGORYSHOW,
       devcodeshow,
       devmaltypeshow,
       REPORTTIME,
       PARENTORGNAME,
       ORGNAME,
       ROUTENAME,
       BUSSELFID,
       MALDESCRIPTION,
       REPAIRTYPE,
       REPAIRTYPESHOW,
       REPAIRSTATUS,
       PROJECTID)
    values
      (v_newmonitorreportid,
       '1',
       '�����ն�',
       cur_monitor.productid,
       cur_monitor.busmachinetypename,
       cur_monitor.productserial,
       cur_monitor.devcategorytype,
       cur_monitor.devcode,
       cur_monitor.devmaltype,
       '-1',
       cur_monitor.devcategoryshow,
       cur_monitor.devcodeshow,
       cur_monitor.devmaltypeshow,
       sysdate,
       cur_monitor.parentorgname,
       cur_monitor.orgname,
       cur_monitor.routename,
       cur_monitor.busselfid,
       cur_monitor.devcategoryshow ||
       decode(cur_monitor.devcodeshow, '', '', '��') ||
       decode(cur_monitor.devcodeshow, '', '', cur_monitor.devcodeshow) ||
       decode(cur_monitor.devcodeshow, '', '', '��') ||
       decode(cur_monitor.devmaltypeshow, '', '', '��') ||
       decode(cur_monitor.devmaltypeshow,
              '',
              '',
              cur_monitor.devmaltypeshow),
       '1',
       '����Ѳ��',
       '0',
       v_objectid);
    commit;
  end loop;
end P_OM_BUSMASHINEMALMONITOR;
/

prompt
prompt Creating procedure P_OM_DEVEVENT
prompt ================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DEVEVENT is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EVENT       T_CURSOR;
  CUR_ONLINE      T_CURSOR;
  V_LASTTIME      DATE; --�ϴ�ִ��ʱ��
  V_LASTSTATE     VARCHAR2(1);
  V_NOWTIME       DATE; --����ִ��ʱ��
  V_DEVTYPE       VARCHAR2(20); --�ն�����
  V_PRODUCTID     VARCHAR2(20); -- �ն˱��
  V_EVENTTYPE     VARCHAR2(20); -- ״̬����
  V_EVENTTIME     DATE; --״̬���ʱ��
  V_IP            VARCHAR2(20); --IP��ַ
  V_CFGVER        VARCHAR2(20); --�����ļ��汾��
  V_ROUTEID       VARCHAR2(20); --��ǰ��·
  V_SIMCARD       VARCHAR2(20); --SIM����
  V_SOFTVER       VARCHAR2(20); --����汾��
  V_EVENT         VARCHAR2(20); -- ״̬���ͣ���������ʱ����
  V_ETIME         DATE; --״̬���ʱ�䣨��������ʱ����
  V_ONLINETIME    NUMBER(12, 4); --����ʱ��
  V_STARTTIME     DATE; --��������ʼʱ�䣨��������ʱ����
  V_SIGN          VARCHAR2(1); --�������ж�֮ǰ�Ƿ��ǵ�½�¼�����������ʱ����
  V_EVENTNUM      NUMBER; --�������ն˵����ж����¼�����������ʱ����
  V_NUM           NUMBER; --������
  V_OFFLINENUM    NUMBER; --���ߴ���
  V_ISBEING       NUMBER; --�ж�OM_DEVEVENT���Ƿ�������
  V_OFFLINERATE   NUMBER(12, 4); --�ն˵�����
  V_STANDARDVALUE NUMBER(6, 2); --��׼ֵ
  v_objectid      VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DEVEVENT
  ��;�� ����״̬���
  �����:   DEVEVENT5
            OM_DEVEVENT
            MS_MONITORREPORTGD
  ��д��������
  �޸�ʱ�䣺2013��12��11�� �޸��ˣ�������
  �޸�ʱ�䣺2014��01��18�� �޸��ˣ�������  �޸����ݣ��޸��Զ�Ѳ�칦��
  **************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --��ȡ��ǰʱ��
  V_NOWTIME := sysdate;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_DEVEVENT';
  if v_sign > 0 then
    select t.lasttime
      into V_LASTTIME
      from om_event_date t
     where t.eventname = 'P_OM_DEVEVENT';
    commit;
  else
    V_LASTTIME := to_date(to_char(V_NOWTIME, 'yyyy-MM-dd') || '03:00;00',
                          'yyyy-MM-dd HH24:mi:ss');
  end if;
  --���������û���¼������ݼ���ʱ��������Ƶ��
  for cur_devenvent in (SELECT t.deveventid,
                               round(t.onlinetime +
                                     to_number(V_NOWTIME - V_LASTTIME) * 24,
                                     2) as onlinetime,
                               t.offlinenum /
                               ceil(t.onlinetime +
                                    to_number(V_NOWTIME - V_LASTTIME) * 24) as offlinerate
                          FROM (select t.deveventid,
                                       t.productid,
                                       t.devtypecode,
                                       t.onlinetime,
                                       t.offlinenum
                                  from om_devevent t
                                 where t.recorddate =
                                       trunc(V_NOWTIME - 3 / 24)
                                   and t.devstate in (1, 2, 6, 7)
                                   and t.devtypecode = '1') t
                         WHERE NOT EXISTS
                         (SELECT d.productid
                                  FROM devevent5 d
                                 WHERE d.productid = t.productid
                                   and t.devtypecode = d.devtypecode
                                   and d.eventtime > V_LASTTIME
                                   and d.eventtime <= V_NOWTIME
                                   and d.devtypecode = '1')) loop
    update om_devevent t
       set t.onlinetime  = cur_devenvent.onlinetime,
           t.offlinerate = cur_devenvent.offlinerate
     where t.deveventid = cur_devenvent.deveventid;
  end loop;

  --��ȡ�ն˵���������¼�
  --1:�����ն˷��ͱ�ʶ��2������վ�Ʒ��ͱ�ʶ��3������������ͱ�ʶ��4��IC���������ķ��ͱ�ʶ��5��IC�������ͱ�ʶ��6��ҵ�����ģ�7�����ݿ����ģ�8����Ϣ����ƽ̨��9�����ѷ�������10���߼���������11��ý�����ķ�������12����վ����13��ģ�⳵�ػ���14����������15�����ļ�������ʶ��16���洢����17���˿���Ϣ���񣨵���վ��+���ķ��������񣩣�18���ն���������19������ת������20���쳣������21��VOIP�������أ�22��δ֪Դ/Ŀ�����ͣ�
  --��ȡ���ϴ�ִ�иô洢���̺����ϱ�������
  open CUR_EVENT for
    select devevent.devtypecode,
           devevent.productid,
           devevent.eventtypecode,
           devevent.eventtime,
           devevent.ip,
           devevent.cfgver,
           devevent.routeid,
           devevent.simcardid,
           devevent.softver
      from (select row_number() over(partition by t.productid order by t.eventtime desc, t.eventtypecode asc) as num,
                   t.devtypecode,
                   t.productid,
                   t.eventtypecode,
                   t.eventtime,
                   t.ip,
                   t.cfgver,
                   t.routeid,
                   t.simcardid,
                   t.softver
              from devevent5 t
             where t.devtypecode = '1'
               and t.eventtime > V_LASTTIME
               and t.eventtime <= V_NOWTIME) devevent
     where devevent.num = 1;
  --ѭ���α�
  <<firstloop>>
  LOOP
    FETCH CUR_EVENT
      INTO V_DEVTYPE, V_PRODUCTID, V_EVENTTYPE, V_EVENTTIME, V_IP, V_CFGVER, V_ROUTEID, V_SIMCARD, V_SOFTVER;
    -- û������ʱ�˳�
    EXIT WHEN CUR_EVENT%NOTFOUND;
    begin
      --��ȡ�ϴ�ִ�е���ǰʱ���ڵ�������
      select count(1)
        into V_EVENTNUM
        from devevent5 t
       where t.devtypecode = V_DEVTYPE
         and t.productid = V_PRODUCTID
         and t.eventtime > V_LASTTIME
         and t.eventtime <= V_NOWTIME;
      --��ȡ�ϴ�ִ�к��ͳ������
      select count(1)
        into v_sign
        from om_devevent t
       where t.devtypecode = 'V_SELDEVTYPEVLUE'
         and t.productid = 'V_PRODUCTID'
         and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      if v_sign > 0 then
        select t.devstate, t.onlinetime, t.offlinenum
          into V_LASTSTATE, V_ONLINETIME, V_OFFLINENUM
          from om_devevent t
         where t.devtypecode = 'V_SELDEVTYPEVLUE'
           and t.productid = 'V_PRODUCTID'
           and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      else
        V_LASTSTATE  := 0;
        V_ONLINETIME := 0;
        V_OFFLINENUM := 0;
      end if;
      V_NUM         := 1;
      V_OFFLINERATE := 0;
      open CUR_ONLINE for
        select t.eventtypecode, t.eventtime
          from devevent5 t
         where t.devtypecode = V_DEVTYPE
           and t.productid = V_PRODUCTID
           and t.eventtime > V_LASTTIME
           and t.eventtime <= V_NOWTIME
         order by t.eventtime asc;
      <<secondloop>>
      LOOP
        FETCH CUR_ONLINE
          INTO V_EVENT, V_ETIME;
        -- û������ʱ�˳�
        EXIT WHEN CUR_ONLINE%NOTFOUND;
        -- ������ߴ���
        if V_EVENT = '8' then
          V_OFFLINENUM := V_OFFLINENUM + 1;
        end if;
        --��������ʱ��
        if (V_LASTSTATE = '1' or V_LASTSTATE = '2' or V_LASTSTATE = '6' or
           V_LASTSTATE = '7') then
          V_SIGN      := '1';
          V_STARTTIME := V_LASTTIME;
        end if;
        if V_NUM < V_EVENTNUM then
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            if V_SIGN = '0' then
              V_SIGN      := '1';
              V_STARTTIME := V_ETIME;
            end if;
          else
            if V_SIGN = '1' then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
              V_SIGN       := '0';

            end if;
          end if;
        else
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            V_ONLINETIME := V_ONLINETIME +
                            to_number(V_NOWTIME - V_ETIME) * 24 * 60;
          else
            if (V_SIGN = '1') then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
            end if;
          end if;
          --���������
          if V_ONLINETIME > 0 then
            V_ONLINETIME  := V_ONLINETIME / 60;
            V_OFFLINERATE := V_OFFLINENUM / ceil(V_ONLINETIME);
          end if;
          --���¼����в���(����)����
          select count(1)
            into V_ISBEING
            from om_devevent t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE
             and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVEVENT
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER,
                 ONLINETIME,
                 OFFLINENUM,
                 OFFLINERATE,
                 RECORDDATE)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER,
                 round(V_ONLINETIME, 2),
                 V_OFFLINENUM,
                 round(V_OFFLINERATE, 2),
                 trunc(V_NOWTIME - 3 / 24));
              commit;
            end;
          else
            begin
              update om_devevent
                 set DEVSTATE    = V_EVENTTYPE,
                     EVENTTIME   = V_EVENTTIME,
                     IP          = V_IP,
                     CFGVER      = V_CFGVER,
                     ROUTEID     = V_ROUTEID,
                     SIMCARDID   = V_SIMCARD,
                     SOFTVER     = V_SOFTVER,
                     ONLINETIME  = round(V_ONLINETIME, 2),
                     OFFLINENUM  = V_OFFLINENUM,
                     OFFLINERATE = round(V_OFFLINERATE, 2)
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE
                 and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
              commit;
            end;
          end if;
          --����Ϣ���в���(����)����
          if (V_EVENTTYPE = '1' or V_EVENTTYPE = '2' or V_EVENTTYPE = '6' or
             V_EVENTTYPE = '7') then
            V_EVENTTYPE := '1';
          else
            V_EVENTTYPE := '0';
            V_ROUTEID   := '';
          end if;
          select count(1)
            into V_ISBEING
            from om_devbase t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE;
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVBASE
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER)
              values
                (to_char(S_OM_DEVBASE.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER);
              commit;
            end;
          else
            begin
              update OM_DEVBASE
                 set DEVSTATE  = V_EVENTTYPE,
                     EVENTTIME = V_EVENTTIME,
                     IP        = V_IP,
                     CFGVER    = V_CFGVER,
                     ROUTEID   = V_ROUTEID,
                     SIMCARDID = V_SIMCARD,
                     SOFTVER   = V_SOFTVER
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE;
              commit;
            end;
          end if;
        end if;
        V_NUM := V_NUM + 1;
        EXIT secondloop WHEN CUR_ONLINE%NOTFOUND;
      END LOOP secondloop;
      CLOSE CUR_ONLINE;
    end;
    EXIT firstloop WHEN CUR_EVENT%NOTFOUND;
  END LOOP firstloop;
  CLOSE CUR_EVENT;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_DEVEVENT';
  if v_sign > 0 then
    update om_event_date t
       set t.lasttime = V_NOWTIME
     where t.eventname = 'P_OM_DEVEVENT';
    commit;
  else
    insert into om_event_date
      (EVENTNAME, LASTTIME)
    values
      ('P_OM_DEVEVENT', V_NOWTIME);
    commit;
  end if;
end P_OM_DEVEVENT;
/

prompt
prompt Creating procedure P_OM_DEVEVENTDETAIL
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DEVEVENTDETAIL is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_PRODUCT     T_CURSOR;
  CUR_CONDITION   T_CURSOR;
  V_PRODUCTID     NUMBER(10); --���ػ���
  V_EVENTTIME     DATE; --״̬���ʱ��
  V_EVENTTYPECODE VARCHAR2(3); --״̬����
  V_SIGN          VARCHAR2(1); --��־
  V_STARTTIME     DATE; --��ʼʱ��
  V_ENDTIME       DATE; --����ʱ��
  V_OFFLINETIME   DATE; --����ʱ��
  V_ONLINETIME    NUMBER(12, 4); --����ʱ��
begin
  open CUR_PRODUCT for
    select distinct t.productid
      from DEVEVENT5 t
     where t.devtypecode = '1'
       and t.eventtime <
           to_date(to_char(sysdate, 'yyyy-MM-dd') || '03:00:00',
                   'yyyy-MM-dd hh24:mi:ss')
       and t.eventtime >=
           to_date(to_char(sysdate - 1, 'yyyy-MM-dd') || '03:00:00',
                   'yyyy-MM-dd hh24:mi:ss');
  <<Firstloop>>
  LOOP
    FETCH CUR_PRODUCT
      INTO V_PRODUCTID;
    -- û������ʱ�˳�
    EXIT WHEN CUR_PRODUCT%NOTFOUND;
    begin
      V_SIGN        := 0;
      V_STARTTIME   := null; --��ʼʱ��
      V_ENDTIME     := null; --����ʱ��
      V_OFFLINETIME := null; --����ʱ��
      V_ONLINETIME  := 0; --����ʱ��
      open CUR_CONDITION for
        select t.EVENTTIME, t.EVENTTYPECODE
          from DEVEVENT5 t
         where t.eventtime <
               to_date(to_char(sysdate, 'yyyy-MM-dd') || '03:00:00',
                       'yyyy-MM-dd hh24:mi:ss')
           and t.eventtime >=
               to_date(to_char(sysdate - 1, 'yyyy-MM-dd') || '03:00:00',
                       'yyyy-MM-dd hh24:mi:ss')
           and t.devtypecode = '1'
           and t.productid = V_PRODUCTID
         order by t.eventtime asc;
      --ѭ���α�
      <<Secondloop>>
      LOOP
        FETCH CUR_CONDITION
          INTO V_EVENTTIME, V_EVENTTYPECODE;
        -- û������ʱ�˳�
        EXIT WHEN CUR_CONDITION%NOTFOUND;
        begin
          --�������
          if (V_EVENTTYPECODE = '2' or V_EVENTTYPECODE = '5' or
             V_EVENTTYPECODE = '6' or V_EVENTTYPECODE = '7') then
            if V_SIGN = '0' then
              V_SIGN      := '1';
              V_STARTTIME := V_EVENTTIME;
            end if;
          else
            if (V_EVENTTYPECODE = '1' or V_EVENTTYPECODE = '3' or
               V_EVENTTYPECODE = '4') then
              if V_SIGN = '1' then
                V_SIGN       := '0';
                V_ENDTIME    := V_EVENTTIME;
                V_ONLINETIME := round((V_ENDTIME - V_STARTTIME) * 24 * 60,
                                      4);
                --��������
                insert into OM_BUSMACHINEEVENT
                  (BUSMACHINEEVENTID,
                   PRODUCTID,
                   RECDATE,
                   ONLINETIME,
                   OFFLINETIME,
                   TRUNROUNDTIME,
                   ONLINETIMELENGTH)
                values
                  (to_char(S_SERVICEREPORT.NEXTVAL),
                   V_PRODUCTID,
                   trunc(sysdate) - 1,
                   V_STARTTIME,
                   V_ENDTIME,
                   V_OFFLINETIME,
                   V_ONLINETIME);
                commit;
              end if;
            end if;
          end if;
        end;
        EXIT secondloop WHEN CUR_CONDITION%NOTFOUND;
      END LOOP secondloop;
      CLOSE CUR_CONDITION;
    end;
    EXIT firstloop WHEN CUR_PRODUCT%NOTFOUND;
  END LOOP firstloop;
  CLOSE CUR_PRODUCT;
end P_OM_DEVEVENTDETAIL;
/

prompt
prompt Creating procedure P_OM_DEVMALMONITOR
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DEVMALMONITOR is
  v_objectid   VARCHAR2(20);
    /***************************************************
  ���ƣ�P_OM_DEVMALMONITOR
  ��;�� �豸�������նˡ�����վ�ơ������������ϼ�أ��Լ����ϵı���
  �����:   BSVCDEVMALRPTLD5
            OM_DEVMALMONITOR
            OM_MONITORREPORTGD
  ��д��������
  ������ڣ�2014��01��17��
  �޸ģ�**************************************************/
begin
  -- ��ȡ��ĿID
  select t.value into v_objectid from configs t where t.section = 'OM_OBJECTID';
  -- ɾ�����ϼ�ر��е��������
  delete om_devmalmonitor t where t.monitordate = trunc(sysdate) and t.devcategorytype != '91';
  commit;
  --���ϼ�ر��в�������
  insert into om_devmalmonitor
    (DEVMALMONITORID,
     DEVTYPE,
     PRODUCTID,
     DEVCATEGORYTYPE,
     DEVCATEGORYSHOW,
     DEVCODE,
     DEVCODESHOW,
     DEVMALTYPE,
     DEVMALTYPESHOW,
     DEVMALTIME,
     MALNUM,
     MONITORDATE,
     SOFTVER)
    select to_char(DEVMALNUM.Nextval),
           mal.terminaltypecode,
           mal.productid,
           mal.devcategorytype,
           case
             when mal.terminaltypecode = '1' then
              decode(mal.devcategorytype,
                     '1',
                     '����',
                     '2',
                     '���ڻ�',
                     '3',
                     'Ͷ�һ�',
                     '4',
                     'Υ��ץ����',
                     '5',
                     '���������豸',
                     '6',
                     '���ڱ�վ��',
                     '7',
                     'վ����',
                     '8',
                     '·��',
                     '9',
                     'ý�岥�Ż�',
                     '10',
                     '�����շѻ�')
             else
              decode(mal.devcategorytype,
                     '1',
                     '��վվ̨��������',
                     '2',
                     '��վLED������',
                     '3',
                     '��վҺ��������',
                     '4',
                     'վ̨�˿���ϢLED��ʾ��',
                     '5',
                     'վ̨�˿���ϢҺ����ʾ��',
                     '6',
                     '��վ�̳�ͨ���豸',
                     '7',
                     'վ̨�̳�ͨ���豸',
                     '8',
                     'վ̨վ����')
           end as devcategoryshow,
           decode(mal.devcode, '', '-1', null, '-1', mal.devcode),
           case
             when mal.terminaltypecode = '1' then
              case
             when mal.devcode = '16' then
              'ǰ��'
             when to_number(mal.devcode) between 17 and 30 then
              '����' || to_char(to_number(mal.devcode) - 16)
             when mal.devcode = '31' then
              '����'
             when mal.devcode = '32' or mal.devcode = '33' then
              'վ����' || to_char(to_number(mal.devcode) - 31)
             when mal.devcode = '48' then
              'ͷ��'
             when to_number(mal.devcode) between 49 and 62 then
              '����' || to_char(to_number(mal.devcode) - 48)
             when mal.devcode = '63' then
              'β��'
             when mal.devcode = '64' or mal.devcode = '65' then
              'ý�岥�Ż�' || to_char(to_number(mal.devcode) - 63)
             when mal.devcode = '80' or mal.devcode = '81' then
              '�����շѻ�' || to_char(to_number(mal.devcode) - 79)
           end
           else
           case
           when to_number(mal.devcode) between 1 and 15 then
             'LED������' || mal.devcode
             when to_number(mal.devcode) between 17 and 31 then
             'Һ��������'|| to_char(to_number(mal.devcode)- 15)
             when to_number(mal.devcode) between 33 and 47 then
             'LED��ʾ��'|| to_char(to_number(mal.devcode)- 32)
               when to_number(mal.devcode) between 49 and 63 then
             'Һ����ʾ��'|| to_char(to_number(mal.devcode)- 33)
              when to_number(mal.devcode) between 65 and 79 then
             '��վ�̳�ͨ���豸'|| to_char(to_number(mal.devcode)- 64)
               when to_number(mal.devcode) between 81 and 95 then
             'վ̨�̳�ͨ���豸'|| to_char(to_number(mal.devcode)- 65)
              when to_number(mal.devcode) between 97 and 111 then
             'վ����'|| to_char(to_number(mal.devcode)- 96)
           end
           end as devcodeshow,
           mal.devmaltype,
           case
           when  mal.terminaltypecode = '1' and mal.devcategorytype = '1' and mal.devcode = '1' then
           '��λģ�����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '1' then
           'ͨ���쳣'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '2' then
           '�����ļ�����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '3' then
           '���ݿ������쳣'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '4' then
           '���ݿ�汾�쳣����ͼ����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '5' then
           '���ݿ���������쳣'
           else
           '����ͨ�Ź���'
            end as devmaltypeshow,
           mal.devmaltime,
           mal.maltnum,
           trunc(sysdate),
           mal.softver
      from (select t.terminaltypecode,
                   t.productid,
                   t.devcategorytype,
                   t.devcode,
                   t.devmaltype,
                   t.softver,
                   max(t.devmaltime) devmaltime,
                   count(1) maltnum
              from bsvcdevmalrptld5 t
             where t.recdate >= trunc(sysdate)
             group by t.terminaltypecode,
                      t.productid,
                      t.devcategorytype,
                      t.devcode,
                      t.devmaltype,
                      t.softver) mal;
  commit;

--���ϱ��ޱ��в�������
  insert into MS_MONITORREPORTGD
   (monitorreportid,
    devtypecode,
    devtypeshow,
    productid,
    DEVCATEGORYTYPE,
    DEVCATEGORYSHOW,
    DEVCODE,
    DEVCODESHOW,
    DEVMALTYPE,
    DEVMALTYPESHOW,
    REPORTTIME,
    PARENTORGNAME,
    ORGNAME,
    ROUTENAME,
    BUSSELFID,
    DEVMODEL,
    maldescription,
    REPAIRTYPE,
    REPAIRTYPESHOW,
    REPAIRSTATUS,
    SERIALNUMBER,
    PROJECTID)
   select to_char(S_DEVEVENT.NEXTVAL),
          '1',
          '�����ն�',
          mal.productid,
          mal.devcategorytype,
          mal.devcategoryshow,
          mal.devcode,
          mal.devcodeshow,
          mal.devmaltype,
          mal.devmaltypeshow,
          sysdate,
          base.parentorgname,
          base.orgname,
          base.routename,
          base.busselfid,
          base.busmachinetypename,
          mal.devcategoryshow || decode(mal.devcodeshow, '', '', '��') ||
          decode(mal.devcodeshow, '', '', mal.devcodeshow) ||
          decode(mal.devcodeshow, '', '', '��') ||
          decode(mal.devmaltypeshow, '', '', '��') ||
          decode(mal.devmaltypeshow, '', '', mal.devmaltypeshow) as maldescription,
          '1',
          '����Ѳ��',
          '0',
          base.productserial,
          v_objectid
     from (select mal.devtype,
                  mal.productid,
                  mal.devcategorytype,
                  mal.devcategoryshow,
                  mal.devcode,
                  mal.devcodeshow,
                  mal.devmaltype,
                  mal.devmaltypeshow,
                  mal.devmaltime,
                  mal.malnum,
                  mal.softver
             from (select t.devtype,
                          t.productid,
                          t.devcategorytype,
                          t.devcategoryshow,
                          t.devcode,
                          t.devcodeshow,
                          t.devmaltype,
                          t.devmaltypeshow,
                          t.softver,
                          t.devmaltime,
                          t.malnum
                     from om_devmalmonitor t
                    where not exists
                    (select null
                             from ms_monitorreportgd m
                            where m.repairstatus in (0, 1, 2, 3)
                              and m.devcategorytype = t.devcategorytype
                              and m.devcode = t.devcode
                              and m.devmaltype = t.devmaltype
                              and m.productid = t.productid
                              and m.devtypecode = '1')
                      and t.monitordate = trunc(sysdate)
                      and t.devtype = '1') mal,
                  (select t.monitortype, d.devbreakdowntype, d.value as minmalnum
                     from om_reportsetstandardgd t, om_monitordetailgd d
                    where t.reportsetstandardid = d.reportsetstandardid
                      and t.isactive = '1') d
            where mal.devtype = d.monitortype
              and mal.devcategorytype = d.devbreakdowntype
              and mal.malnum >= d.minmalnum) mal,
          om_view_busmachine base
    where mal.productid = base.productid;
   commit;
end P_OM_DEVMALMONITOR;
/

prompt
prompt Creating procedure P_OM_DUTYDEVEVENT
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DUTYDEVEVENT is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EVENT       T_CURSOR;
  CUR_ONLINE      T_CURSOR;
  V_LASTTIME      DATE; --�ϴ�ִ��ʱ��
  V_LASTSTATE     VARCHAR2(1);
  V_NOWTIME       DATE; --����ִ��ʱ��
  V_DEVTYPE       VARCHAR2(20); --�ն�����
  V_PRODUCTID     VARCHAR2(20); -- �ն˱��
  V_EVENTTYPE     VARCHAR2(20); -- ״̬����
  V_EVENTTIME     DATE; --״̬���ʱ��
  V_IP            VARCHAR2(20); --IP��ַ
  V_CFGVER        VARCHAR2(20); --�����ļ��汾��
  V_ROUTEID       VARCHAR2(20); --��ǰ��·
  V_SIMCARD       VARCHAR2(20); --SIM����
  V_SOFTVER       VARCHAR2(20); --����汾��
  V_EVENT         VARCHAR2(20); -- ״̬���ͣ���������ʱ����
  V_ETIME         DATE; --״̬���ʱ�䣨��������ʱ����
  V_ONLINETIME    NUMBER(12, 4); --����ʱ��
  V_STARTTIME     DATE; --��������ʼʱ�䣨��������ʱ����
  V_SIGN          VARCHAR2(1); --�������ж�֮ǰ�Ƿ��ǵ�½�¼�����������ʱ����
  V_EVENTNUM      NUMBER; --�������ն˵����ж����¼�����������ʱ����
  V_NUM           NUMBER; --������
  V_OFFLINENUM    NUMBER; --���ߴ���
  V_ISBEING       NUMBER; --�ж�OM_DEVEVENT���Ƿ�������
  V_OFFLINERATE   NUMBER(12, 4); --�ն˵�����
  V_STANDARDVALUE NUMBER(6, 2); --��׼ֵ
  v_objectid      VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DEVEVENT
  ��;�� ����״̬���
  �����:   DEVEVENT5
            OM_DEVEVENT
            MS_MONITORREPORTGD
  ��д��������
  �޸�ʱ�䣺2013��12��11�� �޸��ˣ�������
  �޸�ʱ�䣺2014��01��18�� �޸��ˣ�������  �޸����ݣ��޸��Զ�Ѳ�칦��
  **************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --��ȡ��ǰʱ��
  V_NOWTIME := sysdate;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_DUTYDEVEVENT';
  if v_sign > 0 then
    select t.lasttime
      into V_LASTTIME
      from om_event_date t
     where t.eventname = 'P_OM_DUTYDEVEVENT';
    commit;
  else
    V_LASTTIME := to_date(to_char(V_NOWTIME, 'yyyy-MM-dd') || '03:00;00',
                          'yyyy-MM-dd HH24:mi:ss');
  end if;
  --���������û���¼������ݼ���ʱ��������Ƶ��
  for cur_devenvent in (SELECT t.deveventid,
                               round(t.onlinetime +
                                     to_number(V_NOWTIME - V_LASTTIME) * 24,
                                     2) as onlinetime,
                               t.offlinenum /
                               ceil(t.onlinetime +
                                    to_number(V_NOWTIME - V_LASTTIME) * 24) as offlinerate
                          FROM (select t.deveventid,
                                       t.productid,
                                       t.devtypecode,
                                       t.onlinetime,
                                       t.offlinenum
                                  from om_devevent t
                                 where t.recorddate =
                                       trunc(V_NOWTIME - 3 / 24)
                                   and t.devstate in (1, 2, 6, 7)
                                   and t.devtypecode = '12') t
                         WHERE NOT EXISTS
                         (SELECT d.productid
                                  FROM devevent5 d
                                 WHERE d.productid = t.productid
                                   and t.devtypecode = d.devtypecode
                                   and d.eventtime > V_LASTTIME
                                   and d.eventtime <= V_NOWTIME
                                   and d.devtypecode = '12')) loop
    update om_devevent t
       set t.onlinetime  = cur_devenvent.onlinetime,
           t.offlinerate = cur_devenvent.offlinerate
     where t.deveventid = cur_devenvent.deveventid;
  end loop;

  --��ȡ�ն˵���������¼�
  --1:�����ն˷��ͱ�ʶ��2������վ�Ʒ��ͱ�ʶ��3������������ͱ�ʶ��4��IC���������ķ��ͱ�ʶ��5��IC�������ͱ�ʶ��6��ҵ�����ģ�7�����ݿ����ģ�8����Ϣ����ƽ̨��9�����ѷ�������10���߼���������11��ý�����ķ�������12����վ����13��ģ�⳵�ػ���14����������15�����ļ�������ʶ��16���洢����17���˿���Ϣ���񣨵���վ��+���ķ��������񣩣�18���ն���������19������ת������20���쳣������21��VOIP�������أ�22��δ֪Դ/Ŀ�����ͣ�
  --��ȡ���ϴ�ִ�иô洢���̺����ϱ�������
  open CUR_EVENT for
    select devevent.devtypecode,
           devevent.productid,
           devevent.eventtypecode,
           devevent.eventtime,
           devevent.ip,
           devevent.cfgver,
           devevent.routeid,
           devevent.simcardid,
           devevent.softver
      from (select row_number() over(partition by t.productid order by t.eventtime desc, t.eventtypecode asc) as num,
                   t.devtypecode,
                   t.productid,
                   t.eventtypecode,
                   t.eventtime,
                   t.ip,
                   t.cfgver,
                   t.routeid,
                   t.simcardid,
                   t.softver
              from devevent5 t
             where t.devtypecode = '12'
               and t.eventtime > V_LASTTIME
               and t.eventtime <= V_NOWTIME) devevent
     where devevent.num = 1;
  --ѭ���α�
  <<firstloop>>
  LOOP
    FETCH CUR_EVENT
      INTO V_DEVTYPE, V_PRODUCTID, V_EVENTTYPE, V_EVENTTIME, V_IP, V_CFGVER, V_ROUTEID, V_SIMCARD, V_SOFTVER;
    -- û������ʱ�˳�
    EXIT WHEN CUR_EVENT%NOTFOUND;
    begin
      --��ȡ�ϴ�ִ�е���ǰʱ���ڵ�������
      select count(1)
        into V_EVENTNUM
        from devevent5 t
       where t.devtypecode = V_DEVTYPE
         and t.productid = V_PRODUCTID
         and t.eventtime > V_LASTTIME
         and t.eventtime <= V_NOWTIME;
      --��ȡ�ϴ�ִ�к��ͳ������
      select count(1)
        into v_sign
        from om_devevent t
       where t.devtypecode = 'V_SELDEVTYPEVLUE'
         and t.productid = 'V_PRODUCTID'
         and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      if v_sign > 0 then
        select t.devstate, t.onlinetime, t.offlinenum
          into V_LASTSTATE, V_ONLINETIME, V_OFFLINENUM
          from om_devevent t
         where t.devtypecode = 'V_SELDEVTYPEVLUE'
           and t.productid = 'V_PRODUCTID'
           and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      else
        V_LASTSTATE  := 0;
        V_ONLINETIME := 0;
        V_OFFLINENUM := 0;
      end if;
      V_NUM         := 1;
      V_OFFLINERATE := 0;
      open CUR_ONLINE for
        select t.eventtypecode, t.eventtime
          from devevent5 t
         where t.devtypecode = V_DEVTYPE
           and t.productid = V_PRODUCTID
           and t.eventtime > V_LASTTIME
           and t.eventtime <= V_NOWTIME
         order by t.eventtime asc;
      <<secondloop>>
      LOOP
        FETCH CUR_ONLINE
          INTO V_EVENT, V_ETIME;
        -- û������ʱ�˳�
        EXIT WHEN CUR_ONLINE%NOTFOUND;
        -- ������ߴ���
        if V_EVENT = '8' then
          V_OFFLINENUM := V_OFFLINENUM + 1;
        end if;
        --��������ʱ��
        if (V_LASTSTATE = '1' or V_LASTSTATE = '2' or V_LASTSTATE = '6' or
           V_LASTSTATE = '7') then
          V_SIGN      := '1';
          V_STARTTIME := V_LASTTIME;
        end if;
        if V_NUM < V_EVENTNUM then
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            if V_SIGN = '0' then
              V_SIGN      := '1';
              V_STARTTIME := V_ETIME;
            end if;
          else
            if V_SIGN = '1' then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
              V_SIGN       := '0';

            end if;
          end if;
        else
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            V_ONLINETIME := V_ONLINETIME +
                            to_number(V_NOWTIME - V_ETIME) * 24 * 60;
          else
            if (V_SIGN = '1') then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
            end if;
          end if;
          --���������
          if V_ONLINETIME > 0 then
            V_ONLINETIME  := V_ONLINETIME / 60;
            V_OFFLINERATE := V_OFFLINENUM / ceil(V_ONLINETIME);
          end if;
          --���¼����в���(����)����
          select count(1)
            into V_ISBEING
            from om_devevent t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE
             and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVEVENT
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER,
                 ONLINETIME,
                 OFFLINENUM,
                 OFFLINERATE,
                 RECORDDATE)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER,
                 round(V_ONLINETIME, 2),
                 V_OFFLINENUM,
                 round(V_OFFLINERATE, 2),
                 trunc(V_NOWTIME - 3 / 24));
              commit;
            end;
          else
            begin
              update om_devevent
                 set DEVSTATE    = V_EVENTTYPE,
                     EVENTTIME   = V_EVENTTIME,
                     IP          = V_IP,
                     CFGVER      = V_CFGVER,
                     ROUTEID     = V_ROUTEID,
                     SIMCARDID   = V_SIMCARD,
                     SOFTVER     = V_SOFTVER,
                     ONLINETIME  = round(V_ONLINETIME, 2),
                     OFFLINENUM  = V_OFFLINENUM,
                     OFFLINERATE = round(V_OFFLINERATE, 2)
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE
                 and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
              commit;
            end;
          end if;
          --����Ϣ���в���(����)����
          if (V_EVENTTYPE = '1' or V_EVENTTYPE = '2' or V_EVENTTYPE = '6' or
             V_EVENTTYPE = '7') then
            V_EVENTTYPE := '1';
          else
            V_EVENTTYPE := '0';
            V_ROUTEID   := '';
          end if;
          select count(1)
            into V_ISBEING
            from om_devbase t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE;
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVBASE
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER)
              values
                (to_char(S_OM_DEVBASE.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER);
              commit;
            end;
          else
            begin
              update OM_DEVBASE
                 set DEVSTATE  = V_EVENTTYPE,
                     EVENTTIME = V_EVENTTIME,
                     IP        = V_IP,
                     CFGVER    = V_CFGVER,
                     ROUTEID   = V_ROUTEID,
                     SIMCARDID = V_SIMCARD,
                     SOFTVER   = V_SOFTVER
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE;
              commit;
            end;
          end if;
        end if;
        V_NUM := V_NUM + 1;
        EXIT secondloop WHEN CUR_ONLINE%NOTFOUND;
      END LOOP secondloop;
      CLOSE CUR_ONLINE;
    end;
    EXIT firstloop WHEN CUR_EVENT%NOTFOUND;
  END LOOP firstloop;
  CLOSE CUR_EVENT;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_DUTYDEVEVENT';
  if v_sign > 0 then
    update om_event_date t
       set t.lasttime = V_NOWTIME
     where t.eventname = 'P_OM_DUTYDEVEVENT';
    commit;
  else
    insert into om_event_date
      (EVENTNAME, LASTTIME)
    values
      ('P_OM_DUTYDEVEVENT', V_NOWTIME);
    commit;
  end if;
end P_OM_DUTYDEVEVENT;
/

prompt
prompt Creating procedure P_OM_DVRDEVEVENT
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DVRDEVEVENT is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EVENT       T_CURSOR;
  V_PRODUCTID     VARCHAR2(20); -- �ն˱��
  V_EVENTTYPE     VARCHAR2(20); -- ״̬����
  V_EVENTTIME     DATE; --״̬���ʱ��
  V_IP            VARCHAR2(20); --IP��ַ
  V_ROUTEID       VARCHAR2(20); --��ǰ��·
  V_SOFTVER       VARCHAR2(20); --����汾��
  V_ONLINETIME    NUMBER(12, 4); --����ʱ��
  V_OFFLINENUM    NUMBER; --���ߴ���
  V_OFFLINERATE   NUMBER(12, 4);
  V_ISBEING       NUMBER;
  V_STANDARDVALUE NUMBER(6, 2); --��׼ֵ
  v_objectid      VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DVRDEVEVENT
  ��;�� ����״̬���
  �����:   dvr_onlinerecordgd
            OM_DEVEVENT
            MS_MONITORREPORTGD
  ��д��������
  �޸�ʱ�䣺2014��01��18�� �޸��ˣ�������  �޸����ݣ��޸��Զ�Ѳ�칦��
  �޸�ʱ�䣺2014��08��19�� �޸��ˣ�������  �޸����ݣ�Ч���Ż�
  **************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';

  open CUR_EVENT for
    select base.dvrselfid,
           base.eventid,
           base.eventtime,
           base.dvrip,
           base.version,
           base.routeid,
           decode(onlinedata.onlinetime, null, 0, onlinedata.onlinetime),
           decode(onlinedata.offlinecount, null, 0, onlinedata.offlinecount)
      from (select dvrnew.dvrselfid,
                   dvrnew.routeid,
                   dvrnew.eventtime,
                   dvrnew.version,
                   dvrnew.dvrip,
                   dvrnew.eventid
              from (select row_number() over(partition by dvr.dvrselfid order by dvr.eventtime desc) as num,
                           dvr.*
                      from (select t.onlinerecordid,
                                   t.dvrselfid,
                                   t.routeid,
                                   t.onlinedate eventtime,
                                   t.version,
                                   t.dvrip,
                                   t.eventid
                              from dvr_onlinerecordgd t
                             where t.offonlinedate is null
                               and t.onlinedate >
                                   trunc(sysdate - 3 / 24) + 3 / 24
                            union
                            select t.onlinerecordid,
                                   t.dvrselfid,
                                   t.routeid,
                                   t.offonlinedate eventtime,
                                   t.version,
                                   t.dvrip,
                                   t.eventid
                              from dvr_onlinerecordgd t
                             where t.offonlinedate is not null
                               and t.onlinedate >
                                   trunc(sysdate - 3 / 24) + 3 / 24) dvr) dvrnew
             where dvrnew.num = 1) base,
           (select t.dvrselfid,
                   sum((t.offonlinedate - t.onlinedate) * 24) onlinetime,
                   count(1) offlinecount
              from dvr_onlinerecordgd t
             where t.eventid = 2
               and t.onlinedate is not null
               and t.offonlinedate > trunc(sysdate - 3 / 24) + 3 / 24
             group by t.dvrselfid) onlinedata
     where base.dvrselfid = onlinedata.dvrselfid(+);
  LOOP
    FETCH CUR_EVENT
      INTO V_PRODUCTID, V_EVENTTYPE, V_EVENTTIME, V_IP, V_SOFTVER, V_ROUTEID, V_ONLINETIME, V_OFFLINENUM;
    -- û������ʱ�˳�
    EXIT WHEN CUR_EVENT%NOTFOUND;
    if V_EVENTTYPE = '1' or V_EVENTTYPE = '3' or V_EVENTTYPE = '4' then
      V_ONLINETIME := V_ONLINETIME + to_number(sysdate - V_EVENTTIME) * 24;
    end if;
    if V_ONLINETIME > 0 then
      V_OFFLINERATE := V_OFFLINENUM / ceil(V_ONLINETIME);
    end if;
    --���¼����в���(����)����
    select count(1)
      into V_ISBEING
      from om_devevent t
     where t.productid = V_PRODUCTID
       and t.devtypecode = '41'
       and RECORDDATE = trunc(sysdate - 3 / 24);
    if V_ISBEING = 0 then
      begin
        insert into OM_DEVEVENT
          (DEVEVENTID,
           DEVTYPECODE,
           PRODUCTID,
           DEVSTATE,
           EVENTTIME,
           IP,
           ROUTEID,
           SOFTVER,
           ONLINETIME,
           OFFLINENUM,
           OFFLINERATE,
           RECORDDATE)
        values
          (to_char(S_DEVEVENT.NEXTVAL),
           '41',
           V_PRODUCTID,
           V_EVENTTYPE,
           V_EVENTTIME,
           V_IP,
           V_ROUTEID,
           V_SOFTVER,
           round(V_ONLINETIME, 4),
           V_OFFLINENUM,
           round(V_OFFLINERATE, 4),
           trunc(sysdate - 3 / 24));
        commit;
      end;
    else
      begin
        update om_devevent
           set DEVSTATE    = V_EVENTTYPE,
               EVENTTIME   = V_EVENTTIME,
               IP          = V_IP,
               ROUTEID     = V_ROUTEID,
               SOFTVER     = V_SOFTVER,
               ONLINETIME  = round(V_ONLINETIME, 2),
               OFFLINENUM  = V_OFFLINENUM,
               OFFLINERATE = round(V_OFFLINERATE, 4),
               RECORDDATE  = trunc(sysdate - 3 / 24)
         where PRODUCTID = V_PRODUCTID
           and DEVTYPECODE = '41'
           and RECORDDATE = trunc(sysdate - 3 / 24);
        commit;
      end;
    end if;
    --����Ϣ���в���(����)����
    select count(1)
      into V_ISBEING
      from om_devbase t
     where t.productid = V_PRODUCTID
       and t.devtypecode = '41';
    if V_ISBEING = 0 then
      begin
        insert into OM_DEVBASE
          (DEVEVENTID,
           DEVTYPECODE,
           PRODUCTID,
           DEVSTATE,
           EVENTTIME,
           IP,
           ROUTEID,
           SOFTVER)
        values
          (to_char(S_OM_DEVBASE.NEXTVAL),
           '41',
           V_PRODUCTID,
           V_EVENTTYPE,
           V_EVENTTIME,
           V_IP,
           V_ROUTEID,
           V_SOFTVER);
        commit;
      end;
    else
      begin
        update OM_DEVBASE
           set DEVSTATE  = V_EVENTTYPE,
               EVENTTIME = V_EVENTTIME,
               IP        = V_IP,
               ROUTEID   = V_ROUTEID,
               SOFTVER   = V_SOFTVER
         where PRODUCTID = V_PRODUCTID
           and DEVTYPECODE = '41';
        commit;
      end;
    end if;
    EXIT WHEN CUR_EVENT%NOTFOUND;
  END LOOP;
  --��ȡ����Ƶ����׼
  select decode(sum(d.value), null, 0, sum(d.value))
    into V_STANDARDVALUE
    from om_reportsetstandardgd r, om_monitordetailgd d
   where r.reportsetstandardid = d.reportsetstandardid
     and r.monitortype = '41'
     and d.devbreakdowntype = '0';
  if V_STANDARDVALUE > 0 then
    insert into ms_monitorreportgd
      (MONITORREPORTID,
       DEVTYPECODE,
       DEVTYPESHOW,
       PRODUCTID,
       DEVMODEL,
       SERIALNUMBER,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       DEVCATEGORYSHOW,
       REPORTTIME,
       PARENTORGNAME,
       ORGNAME,
       ROUTENAME,
       BUSSELFID,
       MALDESCRIPTION,
       REPAIRTYPE,
       REPAIRTYPESHOW,
       REPAIRSTATUS,
       PROJECTID)
      select to_char(S_DEVEVENT.NEXTVAL),
             '41',
             'DVR',
             e.productid,
             d.dvrtypename,
             d.productserial,
             '0',
             '-1',
             '-1',
             '�豸����Ƶ��',
             sysdate,
             d.parentorgname,
             d.orgname,
             d.routename,
             d.busselfid,
             '�豸����Ƶ��',
             '1',
             '����Ѳ��',
             '0',
             v_objectid
        from om_devevent e, om_view_dvr d
       where not exists (select null
                from ms_monitorreportgd t
               where e.productid = t.productid
                 and t.devcategorytype = '0'
                 and t.devtypecode = '41'
                 and t.repairstatus in (0, 1, 2, 3))
         and e.productid = d.productid
         and e.offlinerate > V_STANDARDVALUE
         and e.devtypecode = '41'
         and e.recorddate > trunc(sysdate - 60);
    commit;
  end if;
end P_OM_DVRDEVEVENT;
/

prompt
prompt Creating procedure P_OM_DVRMALMONITOR
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_DVRMALMONITOR is
  v_objectid           VARCHAR2(20);
  v_newmonitorreportid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DVRMALMONITOR
  ��;�� DVR���ϼ��
  �����:   MS_MONITORREPORTGD
            OM_MONITORREPORTGD
  ��д��������
  ������ڣ�2014��01��17��
  �޸ģ�**************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --ɾ�����ϼ�ر��е��������
  delete from om_dvrmalmonitor t where t.monitordate = trunc(sysdate);
  commit;
  -- ������ϼ�ر�
  insert into OM_DVRMALMONITOR
    (DVRMALMONITORID,
     PRODUCTID,
     DEVMALTYPE,
     DEVMALTYPESHOW,
     MALNUM,
     DEVMALTIME,
     ERRORCHANNEL,
     MONITORDATE)
    select to_char(DEVMALNUM.Nextval),
           dvr.dvrselfid,
           dvr.errorcode,
           error.itemkey as errortype,
           dvr.repirtnum,
           dvr.errortime,
           decode(dvr.errorchannel, '', '-1', '', '-1', dvr.errorchannel),
           to_date(to_char(sysdate, 'yyyy-MM-dd'), 'yyyy-MM-dd')
      from (select t.dvrselfid,
                   t.errorcode,
                   t.errorchannel,
                   max(t.errortime) as errortime,
                   count(1) repirtnum
              from dvr_errorloggs t
             where t.errortype = '1'
               and t.errortime >= trunc(sysdate)
               and t.stoptype in ('0', '1')
             group by t.dvrselfid, t.errorcode, t.errorchannel) dvr,
           (select t.itemkey, t.itemvalue
              from typeentry t
             where t.typename = 'ERRORTYPE') error
     where dvr.errorcode = error.itemvalue;
  commit;

  for cur_monitor in (select m.productid,
                             dvr.dvrtypename,
                             dvr.dvrserial,
                             m.devmaltype,
                             m.errorchannel,
                             m.devmaltypeshow,
                             dvr.parentorgname,
                             dvr.orgname,
                             dvr.routename,
                             dvr.busselfid
                        from om_dvrmalmonitor       m,
                             om_reportsetstandardgd r,
                             om_monitordetailgd     d,
                             om_view_dvr            dvr
                       where not exists
                       (select null
                                from ms_monitorreportgd t
                               where t.errorchannel = m.errorchannel
                                 and t.devcategorytype = m.devmaltype
                                 and t.productid = m.productid
                                 and t.repairstatus in (0, 1, 2, 3)
                                 and t.devtypecode = '41')
                         and m.productid = dvr.productid
                         and m.devmaltype = d.devbreakdowntype
                         and r.reportsetstandardid = d.reportsetstandardid
                         and r.isautomaticreport = '1'
                         and r.isactive = '1'
                         and r.monitortype = '41'
                         and m.malnum >= d.value
                         and m.monitordate = trunc(sysdate)) loop
    -- ������ϱ��ޱ�
    v_newmonitorreportid := F_OM_GETNEXSERVICEREPORTNO();
    insert into ms_monitorreportgd
      (MONITORREPORTID,
       DEVTYPECODE,
       DEVTYPESHOW,
       PRODUCTID,
       DEVMODEL,
       SERIALNUMBER,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       ERRORCHANNEL,
       DEVCATEGORYSHOW,
       REPORTTIME,
       PARENTORGNAME,
       ORGNAME,
       ROUTENAME,
       BUSSELFID,
       MALDESCRIPTION,
       REPAIRTYPE,
       REPAIRTYPESHOW,
       REPAIRSTATUS,
       PROJECTID)
    values
      (v_newmonitorreportid,
       '41',
       'DVR',
       cur_monitor.productid,
       cur_monitor.dvrtypename,
       cur_monitor.dvrserial,
       cur_monitor.devmaltype,
       '-1',
       '-1',
       cur_monitor.errorchannel,
       cur_monitor.devmaltypeshow,
       sysdate,
       cur_monitor.parentorgname,
       cur_monitor.orgname,
       cur_monitor.routename,
       cur_monitor.busselfid,
       cur_monitor.devmaltypeshow ||
       decode(cur_monitor.errorchannel, '-1', '', '��ͨ���ţ�') ||
       decode(cur_monitor.errorchannel, '-1', '', cur_monitor.errorchannel) ||
       decode(cur_monitor.errorchannel, '-1', '', '��'),
       '1',
       '����Ѳ��',
       '0',
       v_objectid);
    commit;
  end loop;
end P_OM_DVRMALMONITOR;
/

prompt
prompt Creating procedure P_OM_ELEDEVEVENT
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_ELEDEVEVENT is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_EVENT       T_CURSOR;
  CUR_ONLINE      T_CURSOR;
  V_LASTTIME      DATE; --�ϴ�ִ��ʱ��
  V_LASTSTATE     VARCHAR2(1);
  V_NOWTIME       DATE; --����ִ��ʱ��
  V_DEVTYPE       VARCHAR2(20); --�ն�����
  V_PRODUCTID     VARCHAR2(20); -- �ն˱��
  V_EVENTTYPE     VARCHAR2(20); -- ״̬����
  V_EVENTTIME     DATE; --״̬���ʱ��
  V_IP            VARCHAR2(20); --IP��ַ
  V_CFGVER        VARCHAR2(20); --�����ļ��汾��
  V_ROUTEID       VARCHAR2(20); --��ǰ��·
  V_SIMCARD       VARCHAR2(20); --SIM����
  V_SOFTVER       VARCHAR2(20); --����汾��
  V_EVENT         VARCHAR2(20); -- ״̬���ͣ���������ʱ����
  V_ETIME         DATE; --״̬���ʱ�䣨��������ʱ����
  V_ONLINETIME    NUMBER(12, 4); --����ʱ��
  V_STARTTIME     DATE; --��������ʼʱ�䣨��������ʱ����
  V_SIGN          VARCHAR2(1); --�������ж�֮ǰ�Ƿ��ǵ�½�¼�����������ʱ����
  V_EVENTNUM      NUMBER; --�������ն˵����ж����¼�����������ʱ����
  V_NUM           NUMBER; --������
  V_OFFLINENUM    NUMBER; --���ߴ���
  V_ISBEING       NUMBER; --�ж�OM_DEVEVENT���Ƿ�������
  V_OFFLINERATE   NUMBER(12, 4); --�ն˵�����
  V_STANDARDVALUE NUMBER(6, 2); --��׼ֵ
  v_objectid      VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_ELEDEVEVENT
  ��;�� ����״̬���
  �����:   DEVEVENT5
            OM_DEVEVENT
            MS_MONITORREPORTGD
  ��д��������
  �޸�ʱ�䣺2013��12��11�� �޸��ˣ�������
  �޸�ʱ�䣺2014��01��18�� �޸��ˣ�������  �޸����ݣ��޸��Զ�Ѳ�칦��
  **************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --��ȡ��ǰʱ��
  V_NOWTIME := sysdate;
  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_ELEDEVEVENT';
  if v_sign > 0 then
    select t.lasttime
      into V_LASTTIME
      from om_event_date t
     where t.eventname = 'P_OM_ELEDEVEVENT';
    commit;
  else
    V_LASTTIME := to_date(to_char(V_NOWTIME, 'yyyy-MM-dd') || '03:00;00',
                          'yyyy-MM-dd HH24:mi:ss');
  end if;
  --���������û���¼������ݼ���ʱ��������Ƶ��
  for cur_devenvent in (SELECT t.deveventid,
                               round(t.onlinetime +
                                     to_number(V_NOWTIME - V_LASTTIME) * 24,
                                     2) as onlinetime,
                               t.offlinenum /
                               ceil(t.onlinetime +
                                    to_number(V_NOWTIME - V_LASTTIME) * 24) as offlinerate
                          FROM (select t.deveventid,
                                       t.productid,
                                       t.devtypecode,
                                       t.onlinetime,
                                       t.offlinenum
                                  from om_devevent t
                                 where t.recorddate =
                                       trunc(V_NOWTIME - 3 / 24)
                                   and t.devstate in (1, 2, 6, 7)
                                   and t.devtypecode in (2, 14)) t
                         WHERE NOT EXISTS
                         (SELECT d.productid
                                  FROM devevent5 d
                                 WHERE d.productid = t.productid
                                   and t.devtypecode = d.devtypecode
                                   and d.eventtime > V_LASTTIME
                                   and d.eventtime <= V_NOWTIME
                                   and d.devtypecode in (2, 14))) loop
    update om_devevent t
       set t.onlinetime  = cur_devenvent.onlinetime,
           t.offlinerate = cur_devenvent.offlinerate
     where t.deveventid = cur_devenvent.deveventid;
  end loop;

  --��ȡ�ն˵���������¼�
  --1:�����ն˷��ͱ�ʶ��2������վ�Ʒ��ͱ�ʶ��3������������ͱ�ʶ��4��IC���������ķ��ͱ�ʶ��5��IC�������ͱ�ʶ��6��ҵ�����ģ�7�����ݿ����ģ�8����Ϣ����ƽ̨��9�����ѷ�������10���߼���������11��ý�����ķ�������12����վ����13��ģ�⳵�ػ���14����������15�����ļ�������ʶ��16���洢����17���˿���Ϣ���񣨵���վ��+���ķ��������񣩣�18���ն���������19������ת������20���쳣������21��VOIP�������أ�22��δ֪Դ/Ŀ�����ͣ�
  --��ȡ���ϴ�ִ�иô洢���̺����ϱ�������
  open CUR_EVENT for
    select devevent.devtypecode,
           devevent.productid,
           devevent.eventtypecode,
           devevent.eventtime,
           devevent.ip,
           devevent.cfgver,
           devevent.routeid,
           devevent.simcardid,
           devevent.softver
      from (select row_number() over(partition by t.productid order by t.eventtime desc, t.eventtypecode asc) as num,
                   t.devtypecode,
                   t.productid,
                   t.eventtypecode,
                   t.eventtime,
                   t.ip,
                   t.cfgver,
                   t.routeid,
                   t.simcardid,
                   t.softver
              from devevent5 t
             where t.devtypecode in (2, 14)
               and t.eventtime > V_LASTTIME
               and t.eventtime <= V_NOWTIME) devevent
     where devevent.num = 1;
  --ѭ���α�
  <<firstloop>>
  LOOP
    FETCH CUR_EVENT
      INTO V_DEVTYPE, V_PRODUCTID, V_EVENTTYPE, V_EVENTTIME, V_IP, V_CFGVER, V_ROUTEID, V_SIMCARD, V_SOFTVER;
    -- û������ʱ�˳�
    EXIT WHEN CUR_EVENT%NOTFOUND;
    begin
      --��ȡ�ϴ�ִ�е���ǰʱ���ڵ�������
      select count(1)
        into V_EVENTNUM
        from devevent5 t
       where t.devtypecode = V_DEVTYPE
         and t.productid = V_PRODUCTID
         and t.eventtime > V_LASTTIME
         and t.eventtime <= V_NOWTIME;
      --��ȡ�ϴ�ִ�к��ͳ������
      select count(1)
        into v_sign
        from om_devevent t
       where t.devtypecode = 'V_SELDEVTYPEVLUE'
         and t.productid = 'V_PRODUCTID'
         and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      if v_sign > 0 then
        select t.devstate, t.onlinetime, t.offlinenum
          into V_LASTSTATE, V_ONLINETIME, V_OFFLINENUM
          from om_devevent t
         where t.devtypecode = 'V_SELDEVTYPEVLUE'
           and t.productid = 'V_PRODUCTID'
           and t.recorddate = trunc(V_NOWTIME - 3 / 24);
      else
        V_LASTSTATE  := 0;
        V_ONLINETIME := 0;
        V_OFFLINENUM := 0;
      end if;
      V_NUM         := 1;
      V_OFFLINERATE := 0;
      open CUR_ONLINE for
        select t.eventtypecode, t.eventtime
          from devevent5 t
         where t.devtypecode = V_DEVTYPE
           and t.productid = V_PRODUCTID
           and t.eventtime > V_LASTTIME
           and t.eventtime <= V_NOWTIME
         order by t.eventtime asc;
      <<secondloop>>
      LOOP
        FETCH CUR_ONLINE
          INTO V_EVENT, V_ETIME;
        -- û������ʱ�˳�
        EXIT WHEN CUR_ONLINE%NOTFOUND;
        -- ������ߴ���
        if V_EVENT = '8' then
          V_OFFLINENUM := V_OFFLINENUM + 1;
        end if;
        --��������ʱ��
        if (V_LASTSTATE = '1' or V_LASTSTATE = '2' or V_LASTSTATE = '6' or
           V_LASTSTATE = '7') then
          V_SIGN      := '1';
          V_STARTTIME := V_LASTTIME;
        end if;
        if V_NUM < V_EVENTNUM then
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            if V_SIGN = '0' then
              V_SIGN      := '1';
              V_STARTTIME := V_ETIME;
            end if;
          else
            if V_SIGN = '1' then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
              V_SIGN       := '0';

            end if;
          end if;
        else
          if (V_EVENT = '1' or V_EVENT = '2' or V_EVENT = '6' or
             V_EVENT = '7') then
            V_ONLINETIME := V_ONLINETIME +
                            to_number(V_NOWTIME - V_ETIME) * 24 * 60;
          else
            if (V_SIGN = '1') then
              V_ONLINETIME := V_ONLINETIME +
                              to_number(V_ETIME - V_STARTTIME) * 24 * 60;
            end if;
          end if;
          --���������
          if V_ONLINETIME > 0 then
            V_ONLINETIME  := V_ONLINETIME / 60;
            V_OFFLINERATE := V_OFFLINENUM / ceil(V_ONLINETIME);
          end if;
          --���¼����в���(����)����
          select count(1)
            into V_ISBEING
            from om_devevent t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE
             and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVEVENT
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER,
                 ONLINETIME,
                 OFFLINENUM,
                 OFFLINERATE,
                 RECORDDATE)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER,
                 round(V_ONLINETIME, 2),
                 V_OFFLINENUM,
                 round(V_OFFLINERATE, 2),
                 trunc(V_NOWTIME - 3 / 24));
              commit;
            end;
          else
            begin
              update om_devevent
                 set DEVSTATE    = V_EVENTTYPE,
                     EVENTTIME   = V_EVENTTIME,
                     IP          = V_IP,
                     CFGVER      = V_CFGVER,
                     ROUTEID     = V_ROUTEID,
                     SIMCARDID   = V_SIMCARD,
                     SOFTVER     = V_SOFTVER,
                     ONLINETIME  = round(V_ONLINETIME, 2),
                     OFFLINENUM  = V_OFFLINENUM,
                     OFFLINERATE = round(V_OFFLINERATE, 2)
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE
                 and RECORDDATE = trunc(V_NOWTIME - 3 / 24);
              commit;
            end;
          end if;
          --����Ϣ���в���(����)����
          if (V_EVENTTYPE = '1' or V_EVENTTYPE = '2' or V_EVENTTYPE = '6' or
             V_EVENTTYPE = '7') then
            V_EVENTTYPE := '1';
          else
            V_EVENTTYPE := '0';
            V_ROUTEID   := '';
          end if;
          select count(1)
            into V_ISBEING
            from om_devbase t
           where t.productid = V_PRODUCTID
             and t.devtypecode = V_DEVTYPE;
          if V_ISBEING = 0 then
            begin
              insert into OM_DEVBASE
                (DEVEVENTID,
                 DEVTYPECODE,
                 PRODUCTID,
                 DEVSTATE,
                 EVENTTIME,
                 IP,
                 CFGVER,
                 ROUTEID,
                 SIMCARDID,
                 SOFTVER)
              values
                (to_char(S_OM_DEVBASE.NEXTVAL),
                 V_DEVTYPE,
                 V_PRODUCTID,
                 V_EVENTTYPE,
                 V_EVENTTIME,
                 V_IP,
                 V_CFGVER,
                 V_ROUTEID,
                 V_SIMCARD,
                 V_SOFTVER);
              commit;
            end;
          else
            begin
              update OM_DEVBASE
                 set DEVSTATE  = V_EVENTTYPE,
                     EVENTTIME = V_EVENTTIME,
                     IP        = V_IP,
                     CFGVER    = V_CFGVER,
                     ROUTEID   = V_ROUTEID,
                     SIMCARDID = V_SIMCARD,
                     SOFTVER   = V_SOFTVER
               where PRODUCTID = V_PRODUCTID
                 and DEVTYPECODE = V_DEVTYPE;
              commit;
            end;
          end if;
        end if;
        V_NUM := V_NUM + 1;
        EXIT secondloop WHEN CUR_ONLINE%NOTFOUND;
      END LOOP secondloop;
      CLOSE CUR_ONLINE;
    end;
    EXIT firstloop WHEN CUR_EVENT%NOTFOUND;
  END LOOP firstloop;
  CLOSE CUR_EVENT;

  --�ж��Ƿ��ǵ�һ��ִ�иô洢����
  select count(1)
    into v_sign
    from om_event_date t
   where t.eventname = 'P_OM_ELEDEVEVENT';
  if v_sign > 0 then
    update om_event_date t
       set t.lasttime = V_NOWTIME
     where t.eventname = 'P_OM_ELEDEVEVENT';
    commit;
  else
    insert into om_event_date
      (EVENTNAME, LASTTIME)
    values
      ('P_OM_ELEDEVEVENT', V_NOWTIME);
    commit;
  end if;
end P_OM_ELEDEVEVENT;
/

prompt
prompt Creating procedure P_OM_ELEMALMONITOR
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_ELEMALMONITOR is
  v_objectid           VARCHAR2(20);
  v_newmonitorreportid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_DVRMALMONITOR
  ��;�� DVR���ϼ��
  �����:   MS_MONITORREPORTGD
            OM_MONITORREPORTGD
  ��д��������
  ������ڣ�2014��01��17��
  �޸ģ�**************************************************/
begin
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --ɾ�����ϼ�ر��е��������
  delete from om_devmalmonitor t
   where t.monitordate = trunc(sysdate)
     and t.devtype in ('2', '14');
  commit;
  -- ������ϼ�ر�
  insert into om_devmalmonitor
    (DEVMALMONITORID,
     DEVTYPE,
     PRODUCTID,
     DEVCATEGORYTYPE,
     DEVCATEGORYSHOW,
     DEVCODE,
     DEVCODESHOW,
     DEVMALTYPE,
     DEVMALTYPESHOW,
     DEVMALTIME,
     MALNUM,
     MONITORDATE,
     SOFTVER)
    select to_char(DEVMALNUM.Nextval),
           mal.terminaltypecode,
           mal.productid,
           mal.devcategorytype,
           decode(mal.devcategorytype,
                  '1',
                  '��վվ̨��������',
                  '2',
                  '��վLED������',
                  '3',
                  '��վҺ��������',
                  '4',
                  'վ̨�˿���ϢLED��ʾ��',
                  '5',
                  'վ̨�˿���ϢҺ����ʾ��',
                  '6',
                  '��վ�̳�ͨ���豸',
                  '7',
                  'վ̨�̳�ͨ���豸',
                  '8',
                  'վ̨վ����') as devcategoryshow,
           decode(mal.devcode, '', '-1', null, '-1', mal.devcode),
           case
             when to_number(mal.devcode) between 1 and 15 then
              'LED������' || mal.devcode
             when to_number(mal.devcode) between 17 and 31 then
              'Һ��������' || to_char(to_number(mal.devcode) - 15)
             when to_number(mal.devcode) between 33 and 47 then
              'LED��ʾ��' || to_char(to_number(mal.devcode) - 32)
             when to_number(mal.devcode) between 49 and 63 then
              'Һ����ʾ��' || to_char(to_number(mal.devcode) - 33)
             when to_number(mal.devcode) between 65 and 79 then
              '��վ�̳�ͨ���豸' || to_char(to_number(mal.devcode) - 64)
             when to_number(mal.devcode) between 81 and 95 then
              'վ̨�̳�ͨ���豸' || to_char(to_number(mal.devcode) - 65)
             when to_number(mal.devcode) between 97 and 111 then
              'վ����' || to_char(to_number(mal.devcode) - 96)
           end as devcodeshow,
           mal.devmaltype,
           case
             when mal.devcategorytype = '1' and mal.devcode = '1' then
              'ͨ���쳣'
             when mal.devcategorytype = '1' and mal.devcode = '2' then
              '�����ļ�����'
             when mal.devcategorytype = '1' and mal.devcode = '3' then
              '���ݿ������쳣'
             when mal.devcategorytype = '1' and mal.devcode = '4' then
              '���ݿ�汾�쳣����ͼ����'
             when mal.devcategorytype = '1' and mal.devcode = '5' then
              '���ݿ���������쳣'
             else
              '����ͨ�Ź���'
           end as devmaltypeshow,
           mal.devmaltime,
           mal.maltnum,
           trunc(sysdate),
           mal.softver
      from (select t.terminaltypecode,
                   t.productid,
                   t.devcategorytype,
                   t.devcode,
                   t.devmaltype,
                   t.softver,
                   max(t.devmaltime) devmaltime,
                   count(1) maltnum
              from bsvcdevmalrptld5 t
             where t.recdate >= trunc(sysdate)
               and t.terminaltypecode in ('2', '14')
             group by t.terminaltypecode,
                      t.productid,
                      t.devcategorytype,
                      t.devcode,
                      t.devmaltype,
                      t.softver) mal;
  commit;

  for cur_monitor in (select m.productid,
                             dev.devtype,
                             dev.devtypeshow,
                             dev.routename,
                             m.devcategorytype,
                             m.devcategoryshow,
                             m.devcode,
                             m.devcodeshow,
                             m.devmaltype,
                             m.devmaltypeshow
                        from om_devmalmonitor       m,
                             om_reportsetstandardgd r,
                             om_monitordetailgd     d,
                             om_view_electronscreen dev
                       where not exists
                       (select null
                                from ms_monitorreportgd t
                               where t.devmaltype = m.devmaltype
                                 and t.devcode = m.devcode
                                 and t.devcategorytype = m.devcategorytype
                                 and t.devtypecode = m.devtype
                                 and t.productid = m.productid
                                 and t.repairstatus in (0, 1, 2, 3, 99)
                                 and t.devtypecode in ('2', '14'))
                         and m.productid = dev.productid
                         and m.devcategorytype = d.devbreakdowntype
                         and r.reportsetstandardid = d.reportsetstandardid
                         and r.isautomaticreport = '1'
                         and r.isactive = '1'
                         and r.monitortype = '1'
                         and m.devtype in ('2', '14')
                         and m.malnum >= d.value
                         and m.monitordate = trunc(sysdate)) loop
    -- ������ϱ��ޱ�
    v_newmonitorreportid := F_OM_GETNEXSERVICEREPORTNO();
    insert into ms_monitorreportgd
      (MONITORREPORTID,
       DEVTYPECODE,
       DEVTYPESHOW,
       PRODUCTID,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       ERRORCHANNEL,
       DEVCATEGORYSHOW,
       devcodeshow,
       devmaltypeshow,
       REPORTTIME,
       ROUTENAME,
       MALDESCRIPTION,
       REPAIRTYPE,
       REPAIRTYPESHOW,
       REPAIRSTATUS,
       PROJECTID)
    values
      (v_newmonitorreportid,
       cur_monitor.devtype,
       cur_monitor.devtypeshow,
       cur_monitor.productid,
       cur_monitor.devcategorytype,
       cur_monitor.devcode,
       cur_monitor.devmaltype,
       '-1',
       cur_monitor.devcategoryshow,
       cur_monitor.devcodeshow,
       cur_monitor.devmaltypeshow,
       sysdate,
       cur_monitor.routename,
       cur_monitor.devcategoryshow ||
       decode(cur_monitor.devcodeshow, '', '', '��') ||
       decode(cur_monitor.devcodeshow, '', '', cur_monitor.devcodeshow) ||
       decode(cur_monitor.devcodeshow, '', '', '��') ||
       decode(cur_monitor.devmaltypeshow, '', '', '��') ||
       decode(cur_monitor.devmaltypeshow,
              '',
              '',
              cur_monitor.devmaltypeshow),
       '1',
       '����Ѳ��',
       '0',
       v_objectid);
    commit;
  end loop;
end P_OM_ELEMALMONITOR;
/

prompt
prompt Creating procedure P_OM_IN_SUM_DSSTICKETRECEIPTLD
prompt =================================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_IN_Sum_dssticketreceiptld

AS
  /***************************************************
  ���ƣ�P_OM_IN_dssticketreceiptld
  ��;���������»���Ӫ������
  �����:   dssticketreceiptld
  ��д��    ������ 2015-5-25 16:55:40
  ***************************************************/
  v_dataCount number;  --��¼�����µ�������
BEGIN

  v_dataCount:=0;

  select count(1)
  into  v_dataCount
  from  DI_WX_TICKETIMPORTGD
  where DISTRIBUTEDFLAG=0
  and icid is not null;

  if v_dataCount=0 then
     return;
  end if;

  --������ͨӪ��
  insert into dssticketreceiptld(
            TICKETRECEIPTID,--���
            ORGID,--��֯ID
            ROUTEID,--·��ID
            SUBROUTEID,--����·ID
            DRIVERID,--��ʻԱID
            STEWARDID,--����ԱID
            OPERATIONDATE,--��Ӫ����
            RECORDER,--¼����ID
            BUSID,--����ID
            DATATYPE,--��������(1-�������,2-վ����)
            TOTALINCOME,--�ܹ�����
            PASSENGERFLOW,--����
            TICKETSORT,--Ʊ����ࣨ1-�ֽ�2-IC����
            TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            CREATED,--
            ISACTIVE,--�Ƿ���Ч 1 ��Ч
            MEMOS,--��ע
            SOURCEFROM,--0-¼��;1-����;2-��̯
            PERSONTIMES,--�ۺ��˴�
            SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            GROUPNUM,--����(�ֵ��GROUPNUM)
            NOTICKET,--0���������� 1��������Ʊ¼�� 2:������̯
            CREATEDATE,--�Ǽ�����
            ASSESSORDATE,--�㳮����
            icid
            )
     SELECT to_char(S_DSSTICKETRECEIPTID.NEXTVAL) AS TICKETRECEIPTID,
       GG.*
    FROM(select  ORGID,--��֯ID
            ROUTEID,--·��ID
            SUBROUTEID,--����·ID
            DRIVERID,--��ʻԱID
            STEWARDID,--����ԱID
            RUNDATADATE,--��Ӫ����
            RECORDER,--¼����ID
            BUSID,--����ID
            '1' AA,--��������(1-�������,2-վ����)
            sum(INCOME) as INCOME,--�ܹ�����
            sum(PASSENGERFLOW) as PASSENGERFLOW,--����
            '2',--Ʊ����ࣨ1-�ֽ�2-IC����
            TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            SYSRECDATE LL,--
            '1' FF,----�Ƿ���Ч 1 ��Ч
            '' GG,--��ע
            '1' HH,--0-¼��;1-����;2-��̯
            PERSONTIMES,--�ۺ��˴�
            SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            GROUPNUM,--����(�ֵ��GROUPNUM)
            '0' KK,--0���������� 1��������Ʊ¼�� 2:������̯
            SYSDATE VV,--�Ǽ�����
            SYSRECDATE,--�㳮����
            icid
     from ( select diw.icid,
             diw.ORGID,--��֯ID
             fd.ROUTEID,--·��ID
             fd.SUBROUTEID,--����·ID
            fd.DRIVERID,--��ʻԱID
            fd.STEWARDID,--����ԱID
            fd.RUNDATADATE,--��Ӫ����
            diw.RECORDER,--¼����ID
            fd.BUSID,--����ID
            diw.INCOME,
            diw.PASSENGERFLOW,
            diw.TICKETTYPE,
            diw.PERSONTIMES,--�ۺ��˴�
            fd.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            fd.GROUPNUM,
            fd.LEAVETIME,
            diw.SYSRECDATE
  from (select fdiout.* from FDISBUSRUNRECGD fdiout
        where not exists(select * from FDISBUSRUNRECGD fdiin
                               where fdiout.RUNDATADATE=fdiin.RUNDATADATE
                               and fdiout.BUSID=fdiin.BUSID
                               and fdiout.DRIVERID=fdiin.DRIVERID
                               and nvl(fdiout.STEWARDID,' ')=nvl(fdiin.STEWARDID,' ')
                               and fdiin.RECTYPE='1'
                               and fdiout.RECTYPE='1'
                               and fdiout.LEAVETIME>fdiin.LEAVETIME)
                               and fdiout.RECTYPE='1') fd
        inner join DI_WX_TICKETIMPORTGD diw
        on fd.RUNDATADATE=diw.Rundatadate
        and fd.BUSID=diw.BUSID
        and fd.DRIVERID=diw.DRIVERID
        and nvl(fd.STEWARDID,' ')=nvl(diw.STEWARDID,' ')
        and diw.DATATYPE=1
        --�ų��Ѿ����µ�����
        where nvl(diw.DISTRIBUTEDFLAG,0)=0
        and diw.icid is not null
        and diw.DATATYPE=1
        and fd.RECTYPE='1'
        /*and diw.icid not in(
         select icid from dssticketreceiptld where ISACTIVE=1
         and icid is not null)*/
        )
     group by ORGID,--��֯ID
            ROUTEID,--·��ID
            SUBROUTEID,--����·ID
            DRIVERID,--��ʻԱID
            STEWARDID,--����ԱID
            RUNDATADATE,--��Ӫ����
            RECORDER,--¼����ID
            BUSID,--����ID
            TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            PERSONTIMES,--�ۺ��˴�
            SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            GROUPNUM,--����(�ֵ��GROUPNUM)
            SYSRECDATE,
            icid) GG;--�㳮

     commit;

  --����վ̨����
 /* insert into dssticketreceiptld(
            TICKETRECEIPTID,--���
            ORGID,--��֯ID
            ROUTEID,--·��ID
            SUBROUTEID,--����·ID
            DRIVERID,--��ʻԱID
            STEWARDID,--����ԱID
            OPERATIONDATE,--��Ӫ����
            RECORDER,--¼����ID
            DATATYPE,--��������(1-�������,2-վ����)
            TOTALINCOME,--�ܹ�����
            PASSENGERFLOW,--����
            TICKETSORT,--Ʊ����ࣨ1-�ֽ�2-IC����
            TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            CREATED,--
            ISACTIVE,--
            MEMOS,--��ע
            SOURCEFROM,--0-¼��;1-����;2-��̯
            PERSONTIMES,--�ۺ��˴�
            SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            GROUPNUM,--����(�ֵ��GROUPNUM)
            NOTICKET,--0���������� 1��������Ʊ¼�� 2:������̯
            CREATEDATE,--�Ǽ�����
            STATIONID,--վ��ID
            STATION,--վ��
            ASSESSORDATE,--�㳮����
            icid
            )

     SELECT to_char(S_DSSTICKETRECEIPTID.NEXTVAL) AS TICKETRECEIPTID,
            MM.*
            FROM
      (select
            a.ORGID,--��֯ID
            a.ROUTEID,--·��ID
            a.SUBROUTEID,--����·ID
            a.DRIVERID,--��ʻԱID
            a.STEWARDID,--����ԱID
            a.RUNDATADATE,--��Ӫ����
            a.RECORDER,--¼����ID
            '2' QQ, --��������(1-�������,2-վ����)
            sum(a.INCOME) as INCOME,--�ܹ�����
            sum(a.PASSENGERFLOW) as PASSENGERFLOW,--����
            '2' WW,--Ʊ����ࣨ1-�ֽ�2-IC����
            a.TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            SYSRECDATE EE,--
            '1' RR,--
            '' TT,--��ע
            '1' YY,--0-¼��;1-����;2-��̯
            a.PERSONTIMES,--�ۺ��˴�
            a.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            a.GROUPNUM,--����(�ֵ��GROUPNUM)
            '0' UU,--0���������� 1��������Ʊ¼�� 2:������̯
            SYSDATE II,--�Ǽ�����
            a.BUSID,--վ��ID
            nvl(t.sitename,'') as sitename,--վ��
            a.SYSRECDATE, --�㳮����
            a.icid
     from (select diw.icid,
            diw.ORGID,--��֯ID
            fd.ROUTEID,--·��ID
            fd.SUBROUTEID,--����·ID
            fd.DRIVERID,--��ʻԱID
            fd.STEWARDID,--����ԱID
            fd.RUNDATADATE,--��Ӫ����
            diw.RECORDER,--¼����ID
            fd.BUSID,--����ID
            diw.INCOME,
            diw.PASSENGERFLOW,
            diw.TICKETTYPE,
            diw.PERSONTIMES,--�ۺ��˴�
            fd.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            fd.GROUPNUM,
            fd.LEAVETIME,
            diw.SYSRECDATE
        from (select fdiout.* from FDISBUSRUNRECGD fdiout
              where not exists(select * from FDISBUSRUNRECGD fdiin
                         where fdiout.RUNDATADATE=fdiin.RUNDATADATE
                         and fdiout.BUSID=fdiin.BUSID
                         and fdiout.DRIVERID=fdiin.DRIVERID
                         and nvl(fdiout.STEWARDID,' ')=nvl(fdiin.STEWARDID,' ')
                         and fdiin.RECTYPE='1'
                         and fdiout.RECTYPE='1'
                         and fdiout.LEAVETIME>fdiin.LEAVETIME)
                         and fdiout.RECTYPE='1'
        ) fd
        inner join DI_WX_TICKETIMPORTGD diw
        on fd.RUNDATADATE=diw.Rundatadate
        \*and fd.BUSID=diw.BUSID*\
        and fd.DRIVERID=diw.DRIVERCARDID
        and nvl(fd.STEWARDID,' ')=nvl(diw.STEWARDCARDID,' ')
        --�ų��Ѿ����µ�����
        where nvl(diw.DISTRIBUTEDFLAG,0)=0
        and diw.icid is not null
        and diw.DATATYPE=2
        and fd.RECTYPE='1'
       \* and diw.icid not in(
                     select icid from dssticketreceiptld
                     where ISACTIVE=1 and icid is not null)*\
        ) a
     left join mcsiteinfogs t
     on a.BUSID=t.siteid
     and t.sitetype='9'
     group by a.ORGID,--��֯ID
            a.ROUTEID,--·��ID
            a.SUBROUTEID,--����·ID
            a.DRIVERID,--��ʻԱID
            a.STEWARDID,--����ԱID
            a.RUNDATADATE,--��Ӫ����
            a.RECORDER,
            a.TICKETTYPE,
            a.PERSONTIMES,--�ۺ��˴�
            a.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            a.GROUPNUM,--����
            a.BUSID,--վ��ID
            t.sitename,--վ��
            a.SYSRECDATE,
            a.icid) MM;*/

      insert into dssticketreceiptld(
            TICKETRECEIPTID,--���
            ORGID,--��֯ID
            ROUTEID,--·��ID
            SUBROUTEID,--����·ID
            DRIVERID,--��ʻԱID
            STEWARDID,--����ԱID
            OPERATIONDATE,--��Ӫ����
            RECORDER,--¼����ID
            DATATYPE,--��������(1-�������,2-վ����)
            TOTALINCOME,--�ܹ�����
            PASSENGERFLOW,--����
            TICKETSORT,--Ʊ����ࣨ1-�ֽ�2-IC����
            TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            CREATED,--
            ISACTIVE,--
            MEMOS,--��ע
            SOURCEFROM,--0-¼��;1-����;2-��̯
            PERSONTIMES,--�ۺ��˴�
            SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            GROUPNUM,--����(�ֵ��GROUPNUM)
            NOTICKET,--0���������� 1��������Ʊ¼�� 2:������̯
            CREATEDATE,--�Ǽ�����
            STATIONID,--վ��ID
            STATION,--վ��
            ASSESSORDATE,--�㳮����
            icid
            )

     SELECT to_char(S_DSSTICKETRECEIPTID.NEXTVAL) AS TICKETRECEIPTID,
            MM.*
            FROM
      (select
            a.ORGID,--��֯ID
            a.ROUTEID,--·��ID
            a.SUBROUTEID,--����·ID
            a.DRIVERID,--��ʻԱID
            a.STEWARDID,--����ԱID
            a.RUNDATADATE,--��Ӫ����
            a.RECORDER,--¼����ID
            '2' QQ, --��������(1-�������,2-վ����)
            sum(a.INCOME) as INCOME,--�ܹ�����
            sum(a.PASSENGERFLOW) as PASSENGERFLOW,--����
            '2' WW,--Ʊ����ࣨ1-�ֽ�2-IC����
            a.TICKETTYPE,--Ʊ��������ͣ���ͨ����ѧ���������˿���
            SYSRECDATE EE,--
            '1' RR,--
            '' TT,--��ע
            '1' YY,--0-¼��;1-����;2-��̯
            a.PERSONTIMES,--�ۺ��˴�
            a.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            a.GROUPNUM,--����(�ֵ��GROUPNUM)
            '0' UU,--0���������� 1��������Ʊ¼�� 2:������̯
            SYSDATE II,--�Ǽ�����
            a.BUSID,--վ��ID
            nvl(t.sitename,'') as sitename,--վ��
            a.SYSRECDATE, --�㳮����
            a.icid
     from (select diw.icid,
            diw.ORGID,--��֯ID
            diw.ROUTEID,--·��ID
            '' SUBROUTEID,--����·ID
            diw.DRIVERCARDID DRIVERID,--��ʻԱID
            diw.STEWARDCARDID STEWARDID,--����ԱID
            diw.Rundatadate RUNDATADATE,--��Ӫ����
            diw.RECORDER,--¼����ID
            diw.BUSID,--����ID
            diw.INCOME,
            diw.PASSENGERFLOW,
            diw.TICKETTYPE,
            diw.PERSONTIMES,--�ۺ��˴�
            '' SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            '' GROUPNUM,
            '' LEAVETIME,
            diw.SYSRECDATE
        from DI_WX_TICKETIMPORTGD diw
        --�ų��Ѿ����µ�����
        where nvl(diw.DISTRIBUTEDFLAG,0)=0
        and diw.icid is not null
        and diw.DATATYPE=2
       /* and diw.icid not in(
                     select icid from dssticketreceiptld
                     where ISACTIVE=1 and icid is not null)*/
        ) a
     left join mcsiteinfogs t
     on a.BUSID=t.siteid
     and t.sitetype='9'
     group by a.ORGID,--��֯ID
            a.ROUTEID,--·��ID
            a.SUBROUTEID,--����·ID
            a.DRIVERID,--��ʻԱID
            a.STEWARDID,--����ԱID
            a.RUNDATADATE,--��Ӫ����
            a.RECORDER,
            a.TICKETTYPE,
            a.PERSONTIMES,--�ۺ��˴�
            a.SHIFTTYPE,--���(�ֵ��SHIFTTYPE)
            a.GROUPNUM,--����
            a.BUSID,--վ��ID
            t.sitename,--վ��
            a.SYSRECDATE,
            a.icid) MM;
     commit;

    merge into DI_WX_TICKETIMPORTGD
    using dssticketreceiptld
    on(DI_WX_TICKETIMPORTGD.icid=dssticketreceiptld.icid
       and dssticketreceiptld.ISACTIVE=1
       and DI_WX_TICKETIMPORTGD.icid is not null
       and dssticketreceiptld.icid is not null)
    when matched then
    update set DI_WX_TICKETIMPORTGD.DISTRIBUTEDFLAG = 1;
    commit;


end P_OM_IN_Sum_dssticketreceiptld;
/

prompt
prompt Creating procedure P_OM_MALMONITOR
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_MALMONITOR as
begin
  insert into OM_MONITORREPORTGD
    (monitorreportid,
     devtypecode,
     devtypeshow,
     productid,
     DEVCATEGORYTYPE,
     DEVCATEGORYSHOW,
     REPORTTIME,
     ERRORCHANNEL)
    select to_char(S_DEVEVENT.NEXTVAL),
           '41',
           'DVR',
           dvrerr.dvrselfid,
           dvrerr.errorcode,
           dvrerr.errortype,
           sysdate,
           decode(dvrerr.errorchannel,
                  '',
                  '-1',
                  '',
                  '-1',
                  dvrerr.errorchannel)
      from (select dvr.*, report.productid sign
              from (select dvr.dvrselfid,
                           dvr.errorcode,
                           error.itemkey as errortype,
                           dvr.repirtnum,
                           dvr.errortime,
                           dvr.errorchannel
                      from (select t.dvrselfid,
                                   t.errorcode,
                                   decode(t.errorchannel,
                                          '',
                                          '-1',
                                          t.errorchannel) errorchannel,
                                   max(t.errortime) as errortime,
                                   count(1) repirtnum
                              from dvr_errorloggs t
                             where t.errortype = '1'
                               and t.createdtime > trunc(sysdate)
                               and t.stoptype in ('0', '1')
                             group by t.dvrselfid, t.errorcode, t.errorchannel) dvr,
                           (select t.itemkey, t.itemvalue
                              from typeentry t
                             where t.typename = 'ERRORTYPE') error
                     where dvr.errorcode = error.itemvalue) dvr,
                   (select t.productid, t.devcategorytype, t.errorchannel
                      from om_monitorreportgd t
                     where t.devtypecode = '41'
                       and t.reporttime > trunc(sysdate)) report
             where dvr.dvrselfid = report.productid(+)
               and dvr.errorcode = report.devcategorytype(+)
               and dvr.errorchannel = report.errorchannel(+)) dvrerr
     where dvrerr.sign is null;

     --���ϱ������в�������
insert into OM_MONITORREPORTGD
      (monitorreportid,
       devtypecode,
       devtypeshow,
       productid,
       DEVCATEGORYTYPE,
       DEVCATEGORYSHOW,
       DEVCODE,
       DEVCODESHOW,
       devmaltype,
       devmaltypeshow,
       REPORTTIME)
select to_char(S_DEVEVENT.NEXTVAL),
       decode(mal.terminaltypecode, '1', '1', '2', '2', '3', '14') as devtypecode,
       decode(mal.terminaltypecode,
              '1',
              '�����ն�',
              '2',
              '����վ��',
              '14',
              '������') as devtypeshow,
       mal.productid,
       mal.devcategorytype,
       case
             when mal.terminaltypecode = '1' then
              decode(mal.devcategorytype,
                     '1',
                     '����',
                     '2',
                     '���ڻ�',
                     '3',
                     'Ͷ�һ�',
                     '4',
                     'Υ��ץ����',
                     '5',
                     '���������豸',
                     '6',
                     '���ڱ�վ��',
                     '7',
                     'վ����',
                     '8',
                     '·��',
                     '9',
                     'ý�岥�Ż�',
                     '10',
                     '�����շѻ�')
             else
              decode(mal.devcategorytype,
                     '1',
                     '��վվ̨��������',
                     '2',
                     '��վLED������',
                     '3',
                     '��վҺ��������',
                     '4',
                     'վ̨�˿���ϢLED��ʾ��',
                     '5',
                     'վ̨�˿���ϢҺ����ʾ��',
                     '6',
                     '��վ�̳�ͨ���豸',
                     '7',
                     'վ̨�̳�ͨ���豸',
                     '8',
                     'վ̨վ����')
           end as devcategoryshow,
       mal.devcode,
       case
             when mal.terminaltypecode = '1' then
              case
             when mal.devcode = '16' then
              'ǰ��'
             when to_number(mal.devcode) between 17 and 30 then
              '����' || to_char(to_number(mal.devcode) - 16)
             when mal.devcode = '31' then
              '����'
             when mal.devcode = '32' or mal.devcode = '33' then
              'վ����' || to_char(to_number(mal.devcode) - 31)
             when mal.devcode = '48' then
              'ͷ��'
             when to_number(mal.devcode) between 49 and 62 then
              '����' || to_char(to_number(mal.devcode) - 48)
             when mal.devcode = '63' then
              'β��'
             when mal.devcode = '64' or mal.devcode = '65' then
              'ý�岥�Ż�' || to_char(to_number(mal.devcode) - 63)
             when mal.devcode = '80' or mal.devcode = '81' then
              '�����շѻ�' || to_char(to_number(mal.devcode) - 79)
           end
           else
           case
           when to_number(mal.devcode) between 1 and 15 then
             'LED������' || mal.devcode
             when to_number(mal.devcode) between 17 and 31 then
             'Һ��������'|| to_char(to_number(mal.devcode)- 15)
             when to_number(mal.devcode) between 33 and 47 then
             'LED��ʾ��'|| to_char(to_number(mal.devcode)- 32)
               when to_number(mal.devcode) between 49 and 63 then
             'Һ����ʾ��'|| to_char(to_number(mal.devcode)- 33)
              when to_number(mal.devcode) between 65 and 79 then
             '��վ�̳�ͨ���豸'|| to_char(to_number(mal.devcode)- 64)
               when to_number(mal.devcode) between 81 and 95 then
             'վ̨�̳�ͨ���豸'|| to_char(to_number(mal.devcode)- 65)
              when to_number(mal.devcode) between 97 and 111 then
             'վ����'|| to_char(to_number(mal.devcode)- 96)
           end
           end as devcodeshow,
       mal.devmaltype,
       case
           when  mal.terminaltypecode = '1' and mal.devcategorytype = '1' and mal.devcode = '1' then
           '��λģ�����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '1' then
           'ͨ���쳣'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '2' then
           '�����ļ�����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '3' then
           '���ݿ������쳣'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '4' then
           '���ݿ�汾�쳣����ͼ����'
           when  mal.terminaltypecode = '2' and mal.devcategorytype = '1' and mal.devcode = '5' then
           '���ݿ���������쳣'
           else
           '����ͨ�Ź���'
            end as devmaltypeshow,
       sysdate
  from (select devmal.terminaltypecode,
               devmal.productid,
               devmal.devcategorytype,
               devmal.devcode,
               devmal.devmaltype,
               devmal.devmaltime,
               devmal.maltnum,
               report.productid sign
          from (select t.terminaltypecode,
                     t.productid,
                     t.devcategorytype,
                     t.devcode,
                     t.devmaltype,
                     max(t.devmaltime) devmaltime,
                     count(1) maltnum
                from bsvcdevmalrptld5 t,
                     (select standard.monitortype, detail.devbreakdowntype
                        from om_reportsetstandardgd standard, om_monitordetailgd detail
                       where standard.isactive = '1'
                         and standard.reportsetstandardid = detail.reportsetstandardid
                         and detail.devbreakdowntype != '0') standardtype
               where t.recdate > trunc(sysdate)
                 and t.devcategorytype = standardtype.devbreakdowntype
                 and t.terminaltypecode = standardtype.monitortype
               group by t.terminaltypecode,
                        t.productid,
                        t.devcategorytype,
                        t.devcode,
                        t.devmaltype) devmal,
               (select t.devtypecode,
                       t.productid,
                       t.devmaltype,
                       t.devcategorytype,
                       t.devcode
                  from om_monitorreportgd t
                 where to_char(t.reporttime, 'yyyy-MM-dd') =
                       to_char(sysdate, 'yyyy-MM-dd')) report
         where devmal.productid = report.productid(+)
           and devmal.devcategorytype = report.devcategorytype(+)
           and devmal.devcode = report.devcode(+)
           and devmal.devmaltype = report.devmaltype(+)) mal
 where mal.sign is null;
 commit;

end P_OM_MALMONITOR;
/

prompt
prompt Creating procedure P_OM_OFFLINEMONITOR
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_OFFLINEMONITOR is
  v_objectid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_OFFLINEMONITOR
  ��;�� �豸���ϲ����߼��
  �����:   MS_MONITORREPORTGD
            OM_DEVMALMONITOR
  ��д��������
  ������ڣ�2014��01��17��
  �޸ģ�**************************************************/
BEGIN
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  for cur_check in (select deverr.productid,
                           deverr.parentorgname,
                           deverr.orgname,
                           deverr.routename,
                           deverr.busselfid,
                           deverr.busmachinetypename,
                           deverr.productserial
                      from (select dev.busid,
                                   dev.busselfid,
                                   dev.productid,
                                   dev.busmachinetypename,
                                   dev.parentorgname,
                                   dev.orgname,
                                   dev.routename,
                                   dev.productserial,
                                   event.productid as sign
                              from (select b.busid,
                                           b.productid,
                                           b.busmachinetypename,
                                           b.parentorgname,
                                           b.orgname,
                                           b.routename,
                                           b.busselfid,
                                           b.productserial
                                      from om_view_busmachine b
                                     where not exists
                                     (select null
                                              from ms_monitorreportgd t
                                             where t.repairstatus in
                                                   (0, 1, 2, 3, 99)
                                               and t.devcategorytype = '91'
                                               and t.devtypecode = '1'
                                               and t.isactive = '1'
                                               and b.productid = t.productid)) dev,
                                   (select t.busid
                                      from fdisbusrunrecgd t
                                     where t.rundatadate = trunc(sysdate - 1)
                                       and t.rectype = '1'
                                       and t.isavailable = '1'
                                     group by t.busid) busrun,
                                   (select t.productid
                                      from bsvcbusrundatald5 t
                                     where t.actdatetime > trunc(sysdate - 1)
                                       and t.actdatetime < trunc(sysdate)
                                     group by t.productid) event
                             where dev.busid = busrun.busid
                               and dev.productid = event.productid(+)) deverr
                     where deverr.sign is null) loop
    -- ���б���
    insert into MS_MONITORREPORTGD
      (monitorreportid,
       devtypecode,
       devtypeshow,
       productid,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       DEVCATEGORYSHOW,
       REPORTTIME,
       PARENTORGNAME,
       ORGNAME,
       ROUTENAME,
       BUSSELFID,
       DEVMODEL,
       maldescription,
       REPAIRTYPE,
       REPAIRSTATUS,
       REPAIRTYPESHOW,
       SERIALNUMBER,
       PROJECTID)
    values
      (F_OM_GETNEXSERVICEREPORTNO(),
       '1',
       '�����ն�',
       cur_check.productid,
       '91',
       '-1',
       '-1',
       '�豸���ϲ�����',
       trunc(sysdate) + 8 / 24,
       cur_check.parentorgname,
       cur_check.orgname,
       cur_check.routename,
       cur_check.busselfid,
       cur_check.busmachinetypename,
       '�豸���ϲ�����',
       '1',
       '0',
       '����Ѳ��',
       cur_check.productserial,
       v_objectid);
    commit;
  end loop;
  -- �Ǻ���ά�޼��
  for cur_nothisenrepair in (select dev.monitorreportid
                               from (select t.monitorreportid,
                                            t.devtypecode,
                                            t.productid,
                                            t.busselfid,
                                            bus.busid
                                       from ms_monitorreportgd t,
                                            mcbusinfogs        bus
                                      where t.busselfid = bus.busselfid
                                        and t.devcategorytype = '91'
                                        and t.devtypecode = '1'
                                        and t.repairstatus = '99'
                                        and t.isactive = '1'
                                        and t.ishisenrepair = '0') dev,
                                    (select t.busid
                                       from fdisbusrunrecgd t
                                      where t.rundatadate =
                                            trunc(sysdate - 1)
                                        and t.rectype = '1'
                                        and t.isavailable = '1'
                                      group by t.busid) busrun,
                                    (select t.productid
                                       from bsvcbusrundatald5 t
                                      where t.actdatetime >
                                            trunc(sysdate - 1)
                                        and t.actdatetime < trunc(sysdate)
                                      group by t.productid) event
                              where dev.busid = busrun.busid
                                and dev.productid = event.productid) loop
    update ms_monitorreportgd t
       set t.repairstatus = '5'
     where t.monitorreportid = cur_nothisenrepair.monitorreportid;
    commit;
  end loop;
END P_OM_OFFLINEMONITOR;
/

prompt
prompt Creating procedure P_OM_OILOFFLINEMONITOR
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.p_om_oilofflinemonitor IS
  v_objectid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_OFFLINEMONITOR_OIL
  ��;�� ���������ϲ����߼��
  �����:   MS_MONITORREPORTGD
            OM_DEVMALMONITOR
  ��д��������
  ������ڣ�2014��03��24��
  �޸ģ�**************************************************/
BEGIN
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';

  --�����ʱ��om_temporary_oil
  execute immediate 'truncate table om_temporary_oil';

  --����ʱ��om_temporary_oil��������
  insert into om_temporary_oil
    (PRODUCTID, MINVALUE, maxvalue)
    select t.productid,
           min(to_number(nvl(t.reservechar2, 0))),
           max(to_number(nvl(t.reservechar2, 0)))
      from bsvcbusrundatald5 t
     where t.actdatetime >= trunc(sysdate - 1)
       and t.actdatetime < trunc(sysdate)
     group by t.productid;
  commit;
  for cur_check in (select dev.productid,
                           dev.parentorgname,
                           dev.orgname,
                           dev.routename,
                           dev.busselfid
                      from (select b.busid,
                                   b.productid,
                                   b.busmachinetypename,
                                   b.parentorgname,
                                   b.orgname,
                                   b.routename,
                                   b.busselfid,
                                   b.productserial
                              from om_view_busmachine b
                             where not exists
                             (select null
                                      from ms_monitorreportgd t
                                     where t.repairstatus in (0, 1, 2)
                                       and t.devcategorytype = '91'
                                       and t.devtypecode = '99'
                                       and t.isactive = '1'
                                       and b.busselfid = t.busselfid)) dev,
                           (select t.busid,
                                   round(sum(t.arrivetime - t.leavetime) * 24,
                                         2) runtime
                              from fdisbusrunrecgd t
                             where t.rundatadate = trunc(sysdate - 1)
                               and t.isavailable = '1'
                             group by t.busid) busrun,
                           (select t.productid
                              from om_temporary_oil t
                             where t.minvalue = t.maxvalue) event,
                           mcbusinfogs bus
                     where dev.busselfid = bus.busselfid
                       and bus.isactive = '1'
                       and bus.isinstalloillmeasurement = '1'
                       and dev.busid = busrun.busid
                       and dev.productid = event.productid) loop
    insert into MS_MONITORREPORTGD
      (monitorreportid,
       devtypecode,
       devtypeshow,
       productid,
       DEVCATEGORYTYPE,
       DEVCODE,
       DEVMALTYPE,
       DEVCATEGORYSHOW,
       REPORTTIME,
       PARENTORGNAME,
       ORGNAME,
       ROUTENAME,
       BUSSELFID,
       maldescription,
       REPAIRTYPE,
       REPAIRSTATUS,
       REPAIRTYPESHOW,
       PROJECTID)
    values
      (F_OM_GETNEXSERVICEREPORTNO(),
       '99',
       '������',
       cur_check.productid,
       '91',
       '-1',
       '-1',
       '�豸���ϲ�����',
       trunc(sysdate) + 8 / 24,
       cur_check.parentorgname,
       cur_check.orgname,
       cur_check.routename,
       cur_check.busselfid,
       '�豸���ϲ�����',
       '1',
       '0',
       '����Ѳ��',
       v_objectid);
    commit;
  end loop;
  -- �Ǻ���ά�޼��
  for cur_nothisenrepair in (select dev.monitorreportid
                               from (select t.monitorreportid, t.busselfid
                                       from ms_monitorreportgd t
                                      where t.devcategorytype = '91'
                                        and t.devtypecode = '99'
                                        and t.repairstatus = '99'
                                        and t.isactive = '1'
                                        and t.ishisenrepair = '0') dev,
                                    (select t.busid,
                                            round(sum(t.arrivetime -
                                                      t.leavetime) * 24,
                                                  2) runtime
                                       from fdisbusrunrecgd t
                                      where t.rundatadate =
                                            trunc(sysdate - 1)
                                        and t.isavailable = '1'
                                      group by t.busid) busrun,
                                    (select t.productid
                                       from om_temporary_oil t
                                      where t.minvalue <> t.maxvalue) event,
                                    om_view_busmachine bus
                              where dev.busselfid = bus.busselfid
                                and bus.busid = busrun.busid
                                and bus.productid = event.productid) loop
    update ms_monitorreportgd t
       set t.repairstatus = '5'
     where t.monitorreportid = cur_nothisenrepair.monitorreportid;
    commit;
  end loop;
END p_om_oilofflinemonitor;
/

prompt
prompt Creating procedure P_OM_REALTIMEONLINEBUS
prompt =========================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_REALTIMEONLINEBUS as
begin
  delete from OM_REALTIMEONLINEBUS;
  insert into OM_REALTIMEONLINEBUS
    (PRODUCTID, BUSID, ROUTEID, ORGID, RECDATE)
    select t.productid,
           dev.busid,
           t.routeid,
           dev.orgid,
           to_date(to_char(sysdate, 'yyyy-MM-dd HH24:mi'),
                   'yyyy-MM-dd HH24:mi')
      from bsvcdevlaststatusld5 t, om_view_busmachine dev
     where t.productid = dev.productid
       and t.devcurstatus = '1'
       and t.devtypecode = '1';
  commit;
end P_OM_REALTIMEONLINEBUS;
/

prompt
prompt Creating procedure P_OM_REPAIRTEST
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_REPAIRTEST IS
  v_sign               NUMBER(1);
  v_newmonitorreportid VARCHAR2(20);
  /***************************************************
  ���ƣ�P_OM_REPAIRTEST
  ��;�� �豸����ά�޼���
  �����:   MS_MONITORREPORTGD
            OM_DEVMALMONITOR
  ��д��������
  ������ڣ�2014��01��21��
  �޸ģ�**************************************************/
BEGIN
  -- ������ϼ�ر���
  for cur_service in (select m.monitorreportid, m.devtypecode, m.productid
                        from ms_monitorreportgd m, om_devevent e
                       where m.productid is not null
                         and m.devtypecode = e.devtypecode
                         and m.productid = e.productid
                         and e.onlinetime > 1
                         and e.recorddate = trunc(sysdate - 1)
                         and m.finishtime < trunc(sysdate - 1)
                         and m.repairstatus = '3'
                         and m.devcategorytype <> '91'
                       group by m.monitorreportid,
                                m.devtypecode,
                                m.productid) loop

    if cur_service.devtypecode != 41 then
      select count(1)
        into v_sign
        from om_devmalmonitor m,
             (select t.monitortype, d.devbreakdowntype, d.value as minmalnum
                from om_reportsetstandardgd t, om_monitordetailgd d
               where t.reportsetstandardid = d.reportsetstandardid
                 and t.isactive = '1'
                 and t.monitortype != '41') d
       where m.malnum >= d.minmalnum
         and m.devcategorytype = d.devbreakdowntype
         and m.productid = cur_service.productid
         and d.monitortype = cur_service.devtypecode
         and m.devtype = cur_service.devtypecode
         and m.monitordate = trunc(sysdate - 1);
      if v_sign > 0 then
        update ms_monitorreportgd t
           set t.repairstatus = '0', t.againrepair = '1'
         where t.monitorreportid = cur_service.monitorreportid;
        commit;
      else
        update ms_monitorreportgd t
           set t.repairstatus = '5'
         where t.monitorreportid = cur_service.monitorreportid;
        commit;
      end if;
    else
      select count(1)
        into v_sign
        from om_dvrmalmonitor m,
             (select t.monitortype, d.devbreakdowntype, d.value as minmalnum
                from om_reportsetstandardgd t, om_monitordetailgd d
               where t.reportsetstandardid = d.reportsetstandardid
                 and t.isactive = '1'
                 and t.monitortype = '41') d
       where m.malnum >= d.minmalnum
         and m.devmaltype = d.devbreakdowntype
         and m.productid = cur_service.productid
         and m.monitordate = trunc(sysdate - 1);
      if v_sign > 0 then
        v_newmonitorreportid := F_OM_GETNEXSERVICEREPORTNO();
        insert into ms_monitorreportgd
          (MONITORREPORTID,
           DEVTYPECODE,
           DEVTYPESHOW,
           PRODUCTID,
           DEVMODEL,
           SERIALNUMBER,
           DEVCATEGORYTYPE,
           DEVCATEGORYSHOW,
           DEVCODE,
           DEVCODESHOW,
           ERRORCHANNEL,
           SERVERSTYPE,
           SERVERSTYPESHOW,
           DEVMALTYPE,
           DEVMALTYPESHOW,
           REPORTTIME,
           VALUE,
           PARENTORGNAME,
           ORGNAME,
           ROUTENAME,
           BUSSELFID,
           MALDESCRIPTION,
           REPAIRTYPE,
           REPAIRTYPESHOW,
           REPAIRSTATUS,
           PROJECTID,
           AGAINREPAIR,
           STATIONNAME,
           ELEROUTENAME,
           BUSAGAINREPAIR,
           LASTMONITORREPORTID,
           ISACTIVE,
           ROUTEID,
           SUPPLVALUE)
          select v_newmonitorreportid,
                 t.devtypecode,
                 t.devtypeshow,
                 t.productid,
                 t.devmodel,
                 t.serialnumber,
                 t.devcategorytype,
                 t.devcategoryshow,
                 t.devcode,
                 t.devcodeshow,
                 t.errorchannel,
                 t.serverstype,
                 t.serverstypeshow,
                 t.devmaltype,
                 t.devmaltypeshow,
                 t.reporttime,
                 t.value,
                 t.parentorgname,
                 t.orgname,
                 t.routename,
                 t.busselfid,
                 t.maldescription,
                 t.repairtype,
                 t.repairtypeshow,
                 '0',
                 t.projectid,
                 '1',
                 t.stationname,
                 t.eleroutename,
                 '1',
                 cur_service.monitorreportid,
                 '1',
                 t.routeid,
                 t.supplvalue
            from ms_monitorreportgd t
           where t.monitorreportid = cur_service.monitorreportid;
        commit;
        update ms_monitorreportgd t
           set t.repairstatus = '9'
         where t.monitorreportid = cur_service.monitorreportid;
        commit;
      else
        update ms_monitorreportgd t
           set t.repairstatus = '5'
         where t.monitorreportid = cur_service.monitorreportid;
        commit;
      end if;
    end if;
  end loop;
  update ms_monitorreportgd t
     set t.repairstatus = '9'
   where t.monitorreportid in (select monitorreportid
                                 from (select row_number() over(partition by m.productid order by m.reporttime desc) num,
                                              m.monitorreportid
                                         from ms_monitorreportgd m
                                        where m.devcategorytype = '91'
                                          and m.repairstatus = '3'
                                          and m.devtypecode = '1')
                                where num <> 1);
  commit;
  for cur_check in (select m.monitorreportid, event.productid
                      from om_view_busmachine dev,
                           (select m.busselfid, m.monitorreportid
                              from ms_monitorreportgd m
                             where m.productid is not null
                               and m.finishtime < trunc(sysdate - 1)
                               and m.repairstatus = '3'
                               and m.devcategorytype = '91'
                               and m.devtypecode = '1') m,
                           (select t.busid,
                                   round(sum(t.arrivetime - t.leavetime) * 24,
                                         2) runtime
                              from fdisbusrunrecgd t
                             where t.rundatadate = trunc(sysdate - 1)
                               and t.rectype = '1'
                               and t.isavailable = '1'
                             group by t.busid) busrun,
                           (select t.productid
                              from bsvcbusrundatald5 t
                             where t.actdatetime > trunc(sysdate - 1)
                               and t.actdatetime < trunc(sysdate)
                             group by t.productid) event
                     where m.busselfid = dev.busselfid
                       and dev.busid = busrun.busid
                       and dev.productid = event.productid(+)) loop
    if cur_check.productid is null then
      v_newmonitorreportid := F_OM_GETNEXSERVICEREPORTNO();
      insert into ms_monitorreportgd
        (MONITORREPORTID,
         DEVTYPECODE,
         DEVTYPESHOW,
         PRODUCTID,
         DEVMODEL,
         SERIALNUMBER,
         DEVCATEGORYTYPE,
         DEVCATEGORYSHOW,
         DEVCODE,
         DEVCODESHOW,
         ERRORCHANNEL,
         SERVERSTYPE,
         SERVERSTYPESHOW,
         DEVMALTYPE,
         DEVMALTYPESHOW,
         REPORTTIME,
         VALUE,
         PARENTORGNAME,
         ORGNAME,
         ROUTENAME,
         BUSSELFID,
         MALDESCRIPTION,
         REPAIRTYPE,
         REPAIRTYPESHOW,
         REPAIRSTATUS,
         PROJECTID,
         AGAINREPAIR,
         STATIONNAME,
         ELEROUTENAME,
         BUSAGAINREPAIR,
         LASTMONITORREPORTID,
         ISACTIVE,
         ROUTEID,
         SUPPLVALUE)
        select v_newmonitorreportid,
               t.devtypecode,
               t.devtypeshow,
               t.productid,
               t.devmodel,
               t.serialnumber,
               t.devcategorytype,
               t.devcategoryshow,
               t.devcode,
               t.devcodeshow,
               t.errorchannel,
               t.serverstype,
               t.serverstypeshow,
               t.devmaltype,
               t.devmaltypeshow,
               to_date(to_char(sysdate, 'yyyy-MM-dd') || '08:00',
                       'yyyy-MM-dd HH24:mi'),
               t.value,
               t.parentorgname,
               t.orgname,
               t.routename,
               t.busselfid,
               t.maldescription,
               t.repairtype,
               t.repairtypeshow,
               '0',
               t.projectid,
               '1',
               t.stationname,
               t.eleroutename,
               '1',
               cur_check.monitorreportid,
               '1',
               t.routeid,
               t.supplvalue
          from ms_monitorreportgd t
         where t.monitorreportid = cur_check.monitorreportid;
      commit;
      update ms_monitorreportgd t
         set t.repairstatus = '9'
       where t.monitorreportid = cur_check.monitorreportid;
      commit;
    else
      update ms_monitorreportgd t
         set t.repairstatus = '5'
       where t.monitorreportid = cur_check.monitorreportid;
      commit;
    end if;
  end loop;
END P_OM_REPAIRTEST;
/

prompt
prompt Creating procedure P_OM_SERVERSEVENT
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_SERVERSEVENT IS
  V_ISBEING         NUMBER(6);
  V_SERVICEREPORTID VARCHAR2(20);
 /************************************************************************************************
    �����أ�OM��  ������ 2013-9-2
  ************************************************************************************************/
BEGIN
  /*��ȡ���������͵�������Ϣ���������ͱ�š��������ơ����������Ϣ��
  ���У�sign��ʾ �������Ƿ����ñ������ܣ�
        isautomaticreport��ʾ �������Ƿ������Զ����޹��ܣ�
        value1��ʾ ������CPUռ���ʣ�
        value2��ʾ �������CPUʹ����
        value3��ʾ ����ռ���ڴ�(MB)
        value4��ʾ ������ʣ���ڴ�(MB)*/
  for cur_sign in (select servertype.itemvalue as servertype,
                          servertype.itemkey as servertypeshow,
                          decode(t.reportsetstandardid, null, 0, '', 0, 1) sign,
                          decode(t.isautomaticreport,
                                 null,
                                 0,
                                 t.isautomaticreport) isautomaticreport,
                          nvl(t.value1, 0) * 100 as value1,
                          nvl(t.value2, 0) * 100 as value2,
                          nvl(t.value3, 0) as value3,
                          nvl(t.value4, 0) as value4
                     from (select *
                             from om_reportsetstandardgd t
                            where t.isactive = '1'
                              and t.monitortype = '31') t,
                          (select t.itemkey, t.itemvalue
                             from typeentry t
                            where t.typename = 'SERVERTYPE') servertype
                    where servertype.itemvalue = t.servertype(+)) loop
    /* ��ȡ�����͵�������Ϣ*/
    for cur_detail in (SELECT SERVER.SERVERID,
                              SERVER.SERVERIP,
                              SERVER.LASTUPDATE,
                              to_number(SERVER.SERVERCPUUSAGE) as SERVERCPUUSAGE,
                              to_number(SERVER.SERVICECPUUSAGE) as SERVICECPUUSAGE,
                              SERVER.SERVERMEMTOTAL,
                              SERVER.SERVERMEMUSAGE,
                              SERVER.SERVICEMEMUSAGE,
                              SERVER.SERVERPROCESSCOUNT,
                              SERVER.SERVERHOSTNAME
                         FROM (SELECT ROW_NUMBER() OVER(PARTITION BY T.SERVERID ORDER BY T.LASTUPDATE DESC) AS NUM,
                                      T.*
                                 FROM SERVERSTATUS T
                                WHERE T.SERVERTYPE = cur_sign.servertype
                                  and TO_CHAR(T.LASTUPDATE, 'YYYY-MM-DD') =
                                      TO_CHAR(SYSDATE, 'YYYY-MM-DD')) SERVER
                        WHERE SERVER.NUM = 1) loop
      if (cur_sign.sign = 1) then
        /*������CPUʹ���ʼ��*/
        if (cur_sign.value1 < cur_detail.servercpuusage) then
          select count(1)
            into V_ISBEING
            from om_monitorreportgd t
           where t.productid = cur_detail.serverid
             and t.devtypecode = '31'
             and t.devcategorytype = '1'
             and to_char(t.reporttime, 'yyyy-MM-dd') =
                 to_char(sysdate, 'yyyy-MM-dd');
          if (V_ISBEING = 0) then
            begin
              insert into OM_MONITORREPORTGD
                (monitorreportid,
                 devtypecode,
                 devtypeshow,
                 serverstype,
                 serverstypeshow,
                 productid,
                 devcategorytype,
                 DEVCATEGORYSHOW,
                 REPORTTIME,
                 value)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 '31',
                 '����',
                 cur_sign.servertype,
                 cur_sign.servertypeshow,
                 cur_detail.serverid,
                 '1',
                 '����������CPUʹ���ʹ���',
                 sysdate,
                 cur_detail.servercpuusage);
              commit;
            end;
          end if;
        end if;
        if (cur_sign.isautomaticreport = 1) then
          select count(1)
            into V_ISBEING
            from om_servicereportgd     r,
                 om_servicemanagegd     m,
                 om_servicereportdetail d
           where r.servicereportid = d.servicereportid
             and r.servicereportid = m.servicereportno(+)
             and m.servicereportno is null
             and r.devtype = '31'
             and d.devbreakdowntype = '1'
             and r.productid = cur_detail.serverid;
          if (V_ISBEING = 0) then
            select count(1)
              into V_ISBEING
              from om_servicereportgd     r,
                   om_servicemanagegd     m,
                   om_servicereportdetail d
             where r.servicereportid = d.servicereportid
               and r.servicereportid = m.servicereportno(+)
               and m.servicereportno is null
               and r.devtype = '31'
               and r.productid = cur_detail.serverid;
            if (V_ISBEING = 0) then
              insert into om_servicereportgd r
                (SERVICEREPORTID,
                 SERVICEREPORTNO,
                 SERVICEREPORTTYPE,
                 DEVTYPE,
                 PRODUCTID,
                 PRIORITYLEVEL,
                 SERVICEREPORTDATE,
                 ISRETURNSERVICE,
                 ISACTIVE)
              values
                (to_char(S_SERVICEREPORT.NEXTVAL),
                 'BX' || to_char(S_SERVICEREPORT.NEXTVAL),
                 '1',
                 '31',
                 cur_detail.serverid,
                 '3',
                 sysdate,
                 '0',
                 '1');
              commit;
              insert into OM_SERVICEREPORTDETAIL
                (SERVICEREPORTDETAILID,
                 SERVICEREPORTID,
                 PRODUCTID,
                 DEVTYPE,
                 DEVBREAKDOWNTYPE,
                 MOMES)
              values
                (to_char(S_SERVICEREPORT.CURRVAL),
                 to_char(S_SERVICEREPORT.CURRVAL),
                 cur_detail.serverid,
                 '31',
                 '1',
                 '����������CPUʹ���ʹ���:' || cur_detail.servercpuusage);
              commit;
            else
              select r.servicereportid
                into V_SERVICEREPORTID
                from om_servicereportgd     r,
                     om_servicemanagegd     m,
                     om_servicereportdetail d
               where r.servicereportid = d.servicereportid
                 and r.servicereportid = m.servicereportno(+)
                 and m.servicereportno is null
                 and r.devtype = '31'
                 and r.productid = cur_detail.serverid
               group by r.servicereportid;
              insert into OM_SERVICEREPORTDETAIL
                (SERVICEREPORTDETAILID,
                 SERVICEREPORTID,
                 PRODUCTID,
                 DEVTYPE,
                 DEVBREAKDOWNTYPE,
                 MOMES)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 V_SERVICEREPORTID,
                 cur_detail.serverid,
                 '31',
                 '1',
                 '����������CPUʹ���ʹ���:' || cur_detail.servercpuusage);
              commit;
            end if;
          end if;
        end if;
        /*�������CPUʹ����*/
        if (cur_sign.value2 < cur_detail.servicecpuusage) then
          select count(1)
            into V_ISBEING
            from om_monitorreportgd t
           where t.productid = cur_detail.serverid
             and t.devtypecode = '31'
             and t.devcategorytype = '2'
             and to_char(t.reporttime, 'yyyy-MM-dd') =
                 to_char(sysdate, 'yyyy-MM-dd');
          if (V_ISBEING = 0) then
            begin
              insert into OM_MONITORREPORTGD
                (monitorreportid,
                 devtypecode,
                 devtypeshow,
                 serverstype,
                 serverstypeshow,
                 productid,
                 devcategorytype,
                 DEVCATEGORYSHOW,
                 REPORTTIME,
                 value)
              values
                (to_char(S_DEVEVENT.NEXTVAL),
                 '31',
                 '����',
                 cur_sign.servertype,
                 cur_sign.servertypeshow,
                 cur_detail.serverid,
                 '2',
                 '����CPUʹ���ʹ���',
                 sysdate,
                 cur_detail.servicecpuusage);
              commit;
            end;
          end if;
          if (cur_sign.isautomaticreport = 1) then
            select count(1)
              into V_ISBEING
              from om_servicereportgd     r,
                   om_servicemanagegd     m,
                   om_servicereportdetail d
             where r.servicereportid = d.servicereportid
               and r.servicereportid = m.servicereportno(+)
               and m.servicereportno is null
               and r.devtype = '31'
               and d.devbreakdowntype = '2'
               and r.productid = cur_detail.serverid;
            if (V_ISBEING = 0) then
              select count(1)
                into V_ISBEING
                from om_servicereportgd     r,
                     om_servicemanagegd     m,
                     om_servicereportdetail d
               where r.servicereportid = d.servicereportid
                 and r.servicereportid = m.servicereportno(+)
                 and m.servicereportno is null
                 and r.devtype = '31'
                 and r.productid = cur_detail.serverid;
              if (V_ISBEING = 0) then
                insert into om_servicereportgd r
                  (SERVICEREPORTID,
                   SERVICEREPORTNO,
                   SERVICEREPORTTYPE,
                   DEVTYPE,
                   PRODUCTID,
                   PRIORITYLEVEL,
                   SERVICEREPORTDATE,
                   ISRETURNSERVICE,
                   ISACTIVE)
                values
                  (to_char(S_SERVICEREPORT.NEXTVAL),
                   'BX' || to_char(S_SERVICEREPORT.NEXTVAL),
                   '1',
                   '31',
                   cur_detail.serverid,
                   '3',
                   sysdate,
                   '0',
                   '1');
                commit;
                insert into OM_SERVICEREPORTDETAIL
                  (SERVICEREPORTDETAILID,
                   SERVICEREPORTID,
                   PRODUCTID,
                   DEVTYPE,
                   DEVBREAKDOWNTYPE,
                   MOMES)
                values
                  (to_char(S_SERVICEREPORT.CURRVAL),
                   to_char(S_SERVICEREPORT.CURRVAL),
                   cur_detail.serverid,
                   '31',
                   '2',
                   '����CPUʹ���ʹ���:' || cur_detail.servicecpuusage);
                commit;
              else
                select r.servicereportid
                  into V_SERVICEREPORTID
                  from om_servicereportgd     r,
                       om_servicemanagegd     m,
                       om_servicereportdetail d
                 where r.servicereportid = d.servicereportid
                   and r.servicereportid = m.servicereportno(+)
                   and m.servicereportno is null
                   and r.devtype = '31'
                   and r.productid = cur_detail.serverid
                 group by r.servicereportid;
                insert into OM_SERVICEREPORTDETAIL
                  (SERVICEREPORTDETAILID,
                   SERVICEREPORTID,
                   PRODUCTID,
                   DEVTYPE,
                   DEVBREAKDOWNTYPE,
                   MOMES)
                values
                  (to_char(S_DEVEVENT.NEXTVAL),
                   V_SERVICEREPORTID,
                   cur_detail.serverid,
                   '31',
                   '2',
                   '����CPUʹ���ʹ���:' || cur_detail.servicecpuusage);
                commit;
              end if;
            end if;
          end if;
          --����ռ���ڴ�(MB)
          if (cur_detail.servicememusage > cur_sign.value3) then
            select count(1)
              into V_ISBEING
              from om_monitorreportgd t
             where t.productid = cur_detail.serverid
               and t.devtypecode = '31'
               and t.devcategorytype = '3'
               and to_char(t.reporttime, 'yyyy-MM-dd') =
                   to_char(sysdate, 'yyyy-MM-dd');
            if (V_ISBEING = 0) then
              begin
                insert into OM_MONITORREPORTGD
                  (monitorreportid,
                   devtypecode,
                   devtypeshow,
                   serverstype,
                   serverstypeshow,
                   productid,
                   devcategorytype,
                   DEVCATEGORYSHOW,
                   REPORTTIME,
                   value)
                values
                  (to_char(S_DEVEVENT.NEXTVAL),
                   '31',
                   '����',
                   cur_sign.servertype,
                   cur_sign.servertypeshow,
                   cur_detail.serverid,
                   '3',
                   '�����ڴ�ռ���ʹ���',
                   sysdate,
                   cur_detail.servicememusage);
                commit;
              end;
            end if;
            if (cur_sign.isautomaticreport = 1) then
              select count(1)
                into V_ISBEING
                from om_servicereportgd     r,
                     om_servicemanagegd     m,
                     om_servicereportdetail d
               where r.servicereportid = d.servicereportid
                 and r.servicereportid = m.servicereportno(+)
                 and m.servicereportno is null
                 and r.devtype = '31'
                 and d.devbreakdowntype = '3'
                 and r.productid = cur_detail.serverid;
              if (V_ISBEING = 0) then
                select count(1)
                  into V_ISBEING
                  from om_servicereportgd     r,
                       om_servicemanagegd     m,
                       om_servicereportdetail d
                 where r.servicereportid = d.servicereportid
                   and r.servicereportid = m.servicereportno(+)
                   and m.servicereportno is null
                   and r.devtype = '31'
                   and r.productid = cur_detail.serverid;
                if (V_ISBEING = 0) then
                  insert into om_servicereportgd r
                    (SERVICEREPORTID,
                     SERVICEREPORTNO,
                     SERVICEREPORTTYPE,
                     DEVTYPE,
                     PRODUCTID,
                     PRIORITYLEVEL,
                     SERVICEREPORTDATE,
                     ISRETURNSERVICE,
                     ISACTIVE)
                  values
                    (to_char(S_SERVICEREPORT.NEXTVAL),
                     'BX' || to_char(S_SERVICEREPORT.NEXTVAL),
                     '1',
                     '31',
                     cur_detail.serverid,
                     '3',
                     sysdate,
                     '0',
                     '1');
                  commit;
                  insert into OM_SERVICEREPORTDETAIL
                    (SERVICEREPORTDETAILID,
                     SERVICEREPORTID,
                     PRODUCTID,
                     DEVTYPE,
                     DEVBREAKDOWNTYPE,
                     MOMES)
                  values
                    (to_char(S_SERVICEREPORT.CURRVAL),
                     to_char(S_SERVICEREPORT.CURRVAL),
                     cur_detail.serverid,
                     '31',
                     '3',
                     '�����ڴ�ռ���ʹ���:' || cur_detail.servicememusage);
                  commit;
                else
                  select r.servicereportid
                    into V_SERVICEREPORTID
                    from om_servicereportgd     r,
                         om_servicemanagegd     m,
                         om_servicereportdetail d
                   where r.servicereportid = d.servicereportid
                     and r.servicereportid = m.servicereportno(+)
                     and m.servicereportno is null
                     and r.devtype = '31'
                     and r.productid = cur_detail.serverid
                   group by r.servicereportid;
                  insert into OM_SERVICEREPORTDETAIL
                    (SERVICEREPORTDETAILID,
                     SERVICEREPORTID,
                     PRODUCTID,
                     DEVTYPE,
                     DEVBREAKDOWNTYPE,
                     MOMES)
                  values
                    (to_char(S_DEVEVENT.NEXTVAL),
                     V_SERVICEREPORTID,
                     cur_detail.serverid,
                     '31',
                     '3',
                     '�����ڴ�ռ���ʹ���:' || cur_detail.servicememusage);
                  commit;
                end if;
              end if;
            end if;
          end if;
          --������ʣ���ڴ�(MB)
          if ((cur_detail.servermemtotal - cur_detail.servermemusage) <
             cur_sign.value4) then
            select count(1)
              into V_ISBEING
              from om_monitorreportgd t
             where t.productid = cur_detail.serverid
               and t.devtypecode = '31'
               and t.devcategorytype = '4'
               and to_char(t.reporttime, 'yyyy-MM-dd') =
                   to_char(sysdate, 'yyyy-MM-dd');
            if (V_ISBEING = 0) then
              begin
                insert into OM_MONITORREPORTGD
                  (monitorreportid,
                   devtypecode,
                   devtypeshow,
                   serverstype,
                   serverstypeshow,
                   productid,
                   devcategorytype,
                   DEVCATEGORYSHOW,
                   REPORTTIME,
                   value)
                values
                  (to_char(S_DEVEVENT.NEXTVAL),
                   '31',
                   '����',
                   cur_sign.servertype,
                   cur_sign.servertypeshow,
                   cur_detail.serverid,
                   '4',
                   '������ʣ���ڴ����',
                   sysdate,
                   cur_detail.servermemtotal - cur_detail.servermemusage);
                commit;
              end;
            end if;
            if (cur_sign.isautomaticreport = 1) then
              select count(1)
                into V_ISBEING
                from om_servicereportgd     r,
                     om_servicemanagegd     m,
                     om_servicereportdetail d
               where r.servicereportid = d.servicereportid
                 and r.servicereportid = m.servicereportno(+)
                 and m.servicereportno is null
                 and r.devtype = '31'
                 and d.devbreakdowntype = '3'
                 and r.productid = cur_detail.serverid;
              if (V_ISBEING = 0) then
                select count(1)
                  into V_ISBEING
                  from om_servicereportgd     r,
                       om_servicemanagegd     m,
                       om_servicereportdetail d
                 where r.servicereportid = d.servicereportid
                   and r.servicereportid = m.servicereportno(+)
                   and m.servicereportno is null
                   and r.devtype = '31'
                   and r.productid = cur_detail.serverid;
                if (V_ISBEING = 0) then
                  insert into om_servicereportgd r
                    (SERVICEREPORTID,
                     SERVICEREPORTNO,
                     SERVICEREPORTTYPE,
                     DEVTYPE,
                     PRODUCTID,
                     PRIORITYLEVEL,
                     SERVICEREPORTDATE,
                     ISRETURNSERVICE,
                     ISACTIVE)
                  values
                    (to_char(S_SERVICEREPORT.NEXTVAL),
                     'BX' || to_char(S_SERVICEREPORT.NEXTVAL),
                     '1',
                     '31',
                     cur_detail.serverid,
                     '3',
                     sysdate,
                     '0',
                     '1');
                  commit;
                  insert into OM_SERVICEREPORTDETAIL
                    (SERVICEREPORTDETAILID,
                     SERVICEREPORTID,
                     PRODUCTID,
                     DEVTYPE,
                     DEVBREAKDOWNTYPE,
                     MOMES)
                  values
                    (to_char(S_SERVICEREPORT.CURRVAL),
                     to_char(S_SERVICEREPORT.CURRVAL),
                     cur_detail.serverid,
                     '31',
                     '4',
                     '������ʣ���ڴ����:' || cur_detail.servermemtotal -
                     cur_detail.servermemusage);
                  commit;
                else
                  select r.servicereportid
                    into V_SERVICEREPORTID
                    from om_servicereportgd     r,
                         om_servicemanagegd     m,
                         om_servicereportdetail d
                   where r.servicereportid = d.servicereportid
                     and r.servicereportid = m.servicereportno(+)
                     and m.servicereportno is null
                     and r.devtype = '31'
                     and r.productid = cur_detail.serverid
                   group by r.servicereportid;
                  insert into OM_SERVICEREPORTDETAIL
                    (SERVICEREPORTDETAILID,
                     SERVICEREPORTID,
                     PRODUCTID,
                     DEVTYPE,
                     DEVBREAKDOWNTYPE,
                     MOMES)
                  values
                    (to_char(S_DEVEVENT.NEXTVAL),
                     V_SERVICEREPORTID,
                     cur_detail.serverid,
                     '31',
                     '4',
                     '������ʣ���ڴ����:' || cur_detail.servermemtotal -
                     cur_detail.servermemusage);
                  commit;
                end if;
              end if;
            end if;
          end if;

        end if;
      end if;
      select count(1)
        into V_ISBEING
        from om_serverevent t
       where t.serverid = cur_detail.serverid;
      if (V_ISBEING = 0) then
        begin
          insert into om_serverevent
            (servereventid,
             servertype,
             serverid,
             serverip,
             lastupdate,
             servercpuusage,
             servicecpuusage,
             servermemtotal,
             servermemusage,
             servicememusage,
             serverprocesscount,
             serverhostname)
          values
            (to_char(S_DEVEVENT.NEXTVAL),
             cur_sign.servertype,
             cur_detail.serverid,
             cur_detail.serverip,
             cur_detail.lastupdate,
             cur_detail.servercpuusage,
             cur_detail.servicecpuusage,
             cur_detail.servermemtotal,
             cur_detail.servermemusage,
             cur_detail.servicememusage,
             cur_detail.serverprocesscount,
             cur_detail.serverhostname);
          commit;
        end;
      else
        begin
          update om_serverevent
             set lastupdate         = cur_detail.lastupdate,
                 servercpuusage     = cur_detail.servercpuusage,
                 servicecpuusage    = cur_detail.servicecpuusage,
                 servermemtotal     = cur_detail.servermemtotal,
                 servermemusage     = cur_detail.servermemusage,
                 servicememusage    = cur_detail.servicememusage,
                 serverprocesscount = cur_detail.serverprocesscount,
                 serverhostname     = cur_detail.serverhostname
           where serverid = cur_detail.serverid;
          commit;
        end;
      end if;
    end loop;
  end loop;
END P_OM_SERVERSEVENT;
/

prompt
prompt Creating procedure P_OM_SUMMARYDATAGD
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_SUMMARYDATAGD IS
  v_devnum           NUMBER(6); --�豸��
  v_devmalnum        NUMBER(6); --������
  v_devmalnum0       NUMBER(6); --������
  v_devmalnum1       NUMBER(6); --������
  v_devmalnum2       NUMBER(6); --������
  v_planrunnum       NUMBER(6); --�Ű���
  v_onlinenum        NUMBER(6); --������
  v_planonlinenum    NUMBER(6); --�����Ű�������
  v_objectid         VARCHAR2(20);
  v_devmaltimes      NUMBER(10, 2);
  v_devtimes         NUMBER(10, 2);
  v_offlinebuslonger NUMBER(4, 2); --δӪ�˳���Ĭ��ʱ��
  v_repirtnum1       NUMBER(6); --������
  v_repirtnum2       NUMBER(6); --������
  v_repirtnum4       NUMBER(6); --������
  v_repirtnum6       NUMBER(6); --������
  v_repirtnum9       NUMBER(6); --������
  v_dvrnovideonum    NUMBER(6);
  /***************************************************
  ���ƣ�P_OM_OFFLINEMONITOR
  ��;�� ��άƽ̨���ݻ��ܱ�
  �����:   om_summarydatagd
  ��д��������
  ������ڣ�2014��01��22��
  �޸�ʱ�䣺2014��08��19�� �޸��ˣ�������  �޸����ݣ�Ч���Ż�
  �޸�ʱ�䣺2015��02��11�� �޸��ˣ�������  �޸����ݣ��޸�ͳ���豸�����ʣ��ƻ��Ű೵����
  �޸�ʱ�䣺2015��03��13�� �޸��ˣ�������  �޸����ݣ�ϵͳ�����ʡ�DVR¼����
  **************************************************/
BEGIN
  delete from om_summarydatagd t where t.summarydate = trunc(sysdate - 1);
  commit;
  delete from om_faultequipmentlist t
   where t.summarydate = trunc(sysdate - 1);
  commit;
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  -- δӪ�˳���Ĭ��ʱ��
  select t.value
    into v_offlinebuslonger
    from configs t
   where t.section = 'OMFOFFLINEBUSLONGER';
  select t.value
    into v_repirtnum1
    from configs t
   where t.section = 'OMMAL1REPIRTNUM';
  select t.value
    into v_repirtnum2
    from configs t
   where t.section = 'OMMAL2REPIRTNUM';
  select t.value
    into v_repirtnum4
    from configs t
   where t.section = 'OMMAL4REPIRTNUM';
  select t.value
    into v_repirtnum6
    from configs t
   where t.section = 'OMMAL6REPIRTNUM';
  select t.value
    into v_repirtnum9
    from configs t
   where t.section = 'OMMAL9REPIRTNUM';
  -- ���ػ�������
  select count(1)
    into v_onlinenum
    from (select distinct (t.productid) productid
            from bsvcbusrundatald5 t
           where t.actdatetime > trunc(sysdate - 1)
             and t.actdatetime < trunc(sysdate)) e,
         (select distinct t.busid, t.rundatadate
            from fdisbusrunrecgd t
           where t.rundatadate = trunc(sysdate - 1)
             and t.rectype = '1'
             and t.isavailable = '1') r,
         om_view_busmachine m
   where m.productid = e.productid
     and m.busid = r.busid;
  --�����Ű೵��������
  select count(1)
    into v_planonlinenum
    from om_view_busmachine mac,
         (select distinct t.busid
            from fdisarrangesequenceld t
           where t.busid is not null
             and t.execdate = trunc(sysdate - 1)) bus,
         (select distinct (t.productid) productid
            from bsvcbusrundatald5 t
           where t.actdatetime > trunc(sysdate - 1)
             and t.actdatetime < trunc(sysdate)) run
   where mac.busid = bus.busid
     and mac.productid = run.productid;
  -- �䳵�Ű೵����
  select count(distinct t.busid) into v_planrunnum from om_view_arrange t;
  -- ���ػ�������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --���ػ�����
  select count(1) into v_devnum from om_view_busmachine t;
  -- ���ػ�����ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when (ds.eventsign is null and ds.longer is not null) or
                    ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid,
                 event.productid eventsign,
                 mal.productid malsign,
                 longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_busmachine mac,
                 (select t.productid
                    from bsvcbusrundatald5 t
                   where t.actdatetime > trunc(sysdate - 1)
                     and t.actdatetime < trunc(sysdate)
                   group by t.productid) event,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '1'
                   group by t.productid) mal
           where mac.productid = event.productid(+)
             and mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  insert into om_faultequipmentlist
    (summarydate, devcode, routename, busselfid, productid)
    select trunc(sysdate - 1),
           '1',
           ds.routename,
           ds.busselfid,
           ds.productid
      from (select mac.routename,
                   mac.busselfid,
                   mac.productid,
                   event.productid eventsign,
                   mal.productid malsign,
                   longer.longer
              from (select t.busid,
                           round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                      from fdisbusrunrecgd t
                     where t.rundatadate = trunc(sysdate - 1)
                       and t.rectype = '1'
                       and t.isavailable = '1'
                     group by t.busid) longer,
                   om_view_busmachine mac,
                   (select t.productid
                      from bsvcbusrundatald5 t
                     where t.actdatetime > trunc(sysdate - 1)
                       and t.actdatetime < trunc(sysdate)
                     group by t.productid) event,
                   (select t.productid
                      from ms_monitorreportgd t
                     where t.repairstatus in (0, 1, 2, 99)
                       and t.devtypecode = '1'
                     group by t.productid) mal
             where mac.productid = event.productid(+)
               and mac.busid = longer.busid(+)
               and mac.productid = mal.productid(+)) ds
     where (ds.eventsign is null and ds.longer is not null)
        or ds.malsign is not null;
  commit;
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2,
     devmaltimes,
     devtimes)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '1',
     v_onlinenum,
     v_planonlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2,
     v_devmaltimes,
     v_devtimes);
  commit;
  -- DVR������
  select count(1)
    into v_onlinenum
    from (select distinct t.dvrselfid
            from dvr_onlinerecordgd t
           where (t.onlinedate >= trunc(sysdate - 1) and
                 t.onlinedate < trunc(sysdate))
              or (t.offonlinedate >= trunc(sysdate - 1) and
                 t.offonlinedate < trunc(sysdate))) e,
         (select distinct t.busid, t.rundatadate
            from fdisbusrunrecgd t
           where t.rundatadate >= trunc(sysdate - 1)
             and t.rundatadate < trunc(sysdate)
             and t.rectype = '1'
             and t.isavailable = '1') r,
         om_view_dvr m
   where m.dvrselfid = e.dvrselfid
     and m.busid = r.busid;
  --�����Ű೵��������
  select count(1)
    into v_planonlinenum
    from om_view_dvr dvr,
         (select distinct t.dvrselfid
            from dvr_onlinerecordgd t
           where (t.onlinedate >= trunc(sysdate - 1) and
                 t.onlinedate < trunc(sysdate))
              or (t.offonlinedate >= trunc(sysdate - 1) and
                 t.offonlinedate < trunc(sysdate))) r,
         (select distinct t.busid
            from fdisarrangesequenceld t
           where t.busid is not null
             and t.execdate = trunc(sysdate - 1)) run
   where dvr.dvrselfid = r.dvrselfid
     and dvr.busid = run.busid;

  -- DVR������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --DVR����
  select count(1) into v_devnum from om_view_dvr t;
  -- DVR ����ʱ��������ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid, mal.productid malsign, longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_dvr mac,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '41'
                   group by t.productid) mal
           where mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  insert into om_faultequipmentlist
    (summarydate, devcode, routename, busselfid, productid)
    select trunc(sysdate - 1),
           '41',
           ds.routename,
           ds.busselfid,
           ds.productid
      from (select mac.routename,
                   mac.busselfid,
                   mac.productid,
                   mal.productid malsign,
                   longer.longer
              from (select t.busid,
                           round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                      from fdisbusrunrecgd t
                     where t.rundatadate = trunc(sysdate - 1)
                       and t.rectype = '1'
                       and t.isavailable = '1'
                     group by t.busid) longer,
                   om_view_dvr mac,
                   (select t.productid
                      from ms_monitorreportgd t
                     where t.repairstatus in (0, 1, 2, 99)
                       and t.devtypecode = '41'
                     group by t.productid) mal
             where mac.busid = longer.busid(+)
               and mac.productid = mal.productid(+)) ds
     where ds.malsign is not null;

  select count(distinct dvr.dvrselfid)
    into v_dvrnovideonum
    from (select t.dvrselfid, t.errorcode, count(1) repirtnum
            from dvr_errorloggs t
           where t.errortype = '1'
             and (t.errorchannel <> '5' or t.errorchannel is null)
             and t.errortime >= trunc(sysdate) - 1
             and t.errortime < trunc(sysdate)
             and t.errorcode in (1, 2, 4, 6, 9)
           group by t.dvrselfid, t.errorcode, t.errorchannel) mal,
         om_view_dvr dvr
   where mal.dvrselfid = dvr.dvrselfid
     and ((mal.errorcode = '1' and mal.repirtnum > v_repirtnum1) or
         (mal.errorcode = '2' and mal.repirtnum > v_repirtnum2) or
         (mal.errorcode = '4' and mal.repirtnum > v_repirtnum4) or
         (mal.errorcode = '6' and mal.repirtnum > v_repirtnum6) or
         (mal.errorcode = '9' and mal.repirtnum > v_repirtnum9));

   insert into om_summarydatagd(SUMMARYDATAID,
                          Objectid,
                          SUMMARYDATE,
                          DEVTYPE,
                          ONLINENUM,
                          PLANONLINENUM,
                          PLANRUNNUM,
                          DEVMALNUM,
                          ALLDEVNUM,
                          DEVMALNUM0,
                          DEVMALNUM1,
                          DEVMALNUM2,
                          devmaltimes,
                          devtimes,
                          Dvrnovideonum) values(to_char(S_DEVEVENT.NEXTVAL),
                v_objectid,
                trunc(sysdate - 1),
                '41',
                v_onlinenum,
                v_planonlinenum,
                v_planrunnum,
                v_devmalnum,
                v_devnum,
                v_devmalnum0,
                v_devmalnum1,
                v_devmalnum2,
                v_devmaltimes,
                v_devtimes,
                v_dvrnovideonum);
  commit;
  -- ����վ��������
  select count(distinct e.productid)
    into v_onlinenum
    from om_devevent e
   where e.devtypecode = '2'
     and e.recorddate = trunc(sysdate - 1);
  -- ����վ���豸����
  v_planrunnum := 0;
  -- ����վ�ƹ�����
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����վ������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '2';
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '2',
     v_onlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2);
  commit;
  -- ������������
  select count(distinct e.productid)
    into v_onlinenum
    from om_devevent e
   where e.devtypecode = '14'
     and e.recorddate = trunc(sysdate - 1);
  -- �������豸����
  v_planrunnum := 0;
  -- ������������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '14';
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '14',
     v_onlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2);
  commit;
END P_OM_SUMMARYDATAGD;
/

prompt
prompt Creating procedure P_OM_SUMMARYDATAGD2
prompt ======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_SUMMARYDATAGD2 IS
  v_devnum     NUMBER(6); --�豸��
  v_devmalnum  NUMBER(6); --������
  v_devmalnum0 NUMBER(6); --���ŷ�������
  v_devmalnum1 NUMBER(6); --�ͻ���������
  v_devmalnum2 NUMBER(6); --������������
  /***************************************************
  ���ƣ�P_OM_OFFLINEMONITOR
  ��;�� ��άƽ̨���ݻ��ܱ�
  �����:   om_summarydatagd
  ��д��������
  ������ڣ�2014��01��22��
  �޸�ʱ�䣺2014��08��19�� �޸��ˣ�������  �޸����ݣ�Ч���Ż�
  �޸�ʱ�䣺2015��02��11�� �޸��ˣ�������  �޸����ݣ��޸�ͳ���豸�����ʣ��ƻ��Ű೵����
  **************************************************/
BEGIN

  --���ػ�
  for cur_busmachine in (select t.busmachinetype, count(1) num
                           from om_view_busmachine t
                          group by t.busmachinetype) loop

    -- ���ػ�������
    select count(distinct t.productid)
      into v_devmalnum
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_busmachine m
             where t.productid = m.productid
               and t.devtypecode = '1'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and m.busmachinetype = cur_busmachine.busmachinetype
             group by t.productid) t;
    select count(distinct t.productid)
      into v_devmalnum0
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_busmachine m
             where t.productid = m.productid
               and t.devtypecode = '1'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and m.busmachinetype = cur_busmachine.busmachinetype
             group by t.productid) t
     where t.responsibility = '0'
        or t.responsibility is null;
    select count(distinct t.productid)
      into v_devmalnum1
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_busmachine m
             where t.productid = m.productid
               and t.devtypecode = '1'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and m.busmachinetype = cur_busmachine.busmachinetype
             group by t.productid) t
     where t.responsibility = '1';
    select count(distinct t.productid)
      into v_devmalnum2
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_busmachine m
             where t.productid = m.productid
               and t.devtypecode = '1'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and m.busmachinetype = cur_busmachine.busmachinetype
             group by t.productid) t
     where t.responsibility = '2';

    --�豸����
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '101',
       cur_busmachine.num,
       sysdate,
       0);
    --�����豸��
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '102',
       cur_busmachine.num - v_devmalnum,
       sysdate,
       0);
    --�����豸��
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '103',
       v_devmalnum,
       sysdate,
       0);
    --ͣ���豸�� ��
    --����豸�� ��
    --���ŷ��豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '108',
       v_devmalnum0,
       sysdate,
       0);
    --�ͻ����豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '107',
       v_devmalnum1,
       sysdate,
       0);
    --�������豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '1-' || cur_busmachine.busmachinetype,
       '106',
       v_devmalnum2,
       sysdate,
       0);

    commit;
  end loop;

  -- DVR
  for cur_dvr in (select t.dvrtypevalue, count(1) num
                    from om_view_dvr t
                   group by t.dvrtypevalue) loop
    select count(distinct t.productid)
      into v_devmalnum
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_dvr d
             where t.productid = d.productid
               and t.devtypecode = '41'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and d.dvrtypevalue = cur_dvr.dvrtypevalue
             group by t.productid) t;
    select count(distinct t.productid)
      into v_devmalnum0
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_dvr d
             where t.productid = d.productid
               and t.devtypecode = '41'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and d.dvrtypevalue = cur_dvr.dvrtypevalue
             group by t.productid) t
     where t.responsibility = '0'
        or t.responsibility is null;
    select count(distinct t.productid)
      into v_devmalnum1
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_dvr d
             where t.productid = d.productid
               and t.devtypecode = '41'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and d.dvrtypevalue = cur_dvr.dvrtypevalue
             group by t.productid) t
     where t.responsibility = '1';
    select count(distinct t.productid)
      into v_devmalnum2
      from (select t.productid, max(t.responsibility) responsibility
              from ms_monitorreportgd t, om_view_dvr d
             where t.productid = d.productid
               and t.devtypecode = '41'
               and t.isactive = '1'
               and t.repairstatus in (0, 1, 2, 99)
               and d.dvrtypevalue = cur_dvr.dvrtypevalue
             group by t.productid) t
     where t.responsibility = '2';

    --�豸����
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '101',
       cur_dvr.num,
       sysdate,
       0);
    --�����豸��
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '102',
       cur_dvr.num - v_devmalnum,
       sysdate,
       0);
    --�����豸��
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '103',
       v_devmalnum,
       sysdate,
       0);
    --ͣ���豸�� ��
    --����豸�� ��
    --���ŷ��豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '108',
       v_devmalnum0,
       sysdate,
       0);
    --�ͻ����豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '107',
       v_devmalnum1,
       sysdate,
       0);
    --�������豸������
    insert into OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    values
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       '41-' || cur_dvr.dvrtypevalue,
       '106',
       v_devmalnum2,
       sysdate,
       0);
    commit;

  end loop;

  -- ����վ�ƹ�����
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����վ������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '2';

  --�豸����
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '101',
     v_devnum,
     sysdate,
     0);
  --�����豸��
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '102',
     v_devnum - v_devmalnum,
     sysdate,
     0);
  --�����豸��
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '103',
     v_devmalnum,
     sysdate,
     0);
  --ͣ���豸�� ��
  --����豸�� ��
  --���ŷ��豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '108',
     v_devmalnum0,
     sysdate,
     0);
  --�ͻ����豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '107',
     v_devmalnum1,
     sysdate,
     0);
  --�������豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '2',
     '106',
     v_devmalnum2,
     sysdate,
     0);

  commit;
  -- ������������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '14';

  --�豸����
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '101',
     v_devnum,
     sysdate,
     0);
  --�����豸��
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '102',
     v_devnum - v_devmalnum,
     sysdate,
     0);
  --�����豸��
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '103',
     v_devmalnum,
     sysdate,
     0);
  --ͣ���豸�� ��
  --����豸�� ��
  --���ŷ��豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '108',
     v_devmalnum0,
     sysdate,
     0);
  --�ͻ����豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '107',
     v_devmalnum1,
     sysdate,
     0);
  --�������豸������
  insert into OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  values
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     '14',
     '106',
     v_devmalnum2,
     sysdate,
     0);
  commit;
END P_OM_SUMMARYDATAGD2;
/

prompt
prompt Creating procedure P_OM_SUMMARYDATAGDCZ
prompt =======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_OM_SUMMARYDATAGDCZ IS
   v_devnum           NUMBER(6); --�豸��
  v_devmalnum        NUMBER(6); --������
  v_devmalnum0       NUMBER(6); --������
  v_devmalnum1       NUMBER(6); --������
  v_devmalnum2       NUMBER(6); --������
  v_planrunnum       NUMBER(6); --�Ű���
  v_onlinenum        NUMBER(6); --������
  v_planonlinenum    NUMBER(6); --�����Ű�������
  v_objectid         VARCHAR2(20);
  v_devmaltimes      NUMBER(10, 2);
  v_devtimes         NUMBER(10, 2);
  v_offlinebuslonger NUMBER(4, 2); --δӪ�˳���Ĭ��ʱ��
  v_repirtnum1       NUMBER(6); --������
  v_repirtnum2       NUMBER(6); --������
  v_repirtnum4       NUMBER(6); --������
  v_repirtnum6       NUMBER(6); --������
  v_repirtnum9       NUMBER(6); --������
  v_dvrnovideonum    NUMBER(6);
  /***************************************************
  ���ƣ�P_OM_OFFLINEMONITOR
  ��;�� ��άƽ̨���ݻ��ܱ�
  �����:   om_summarydatagd
  ��д��������
  ������ڣ�2014��01��22��
  �޸�ʱ�䣺2014��08��19�� �޸��ˣ�������  �޸����ݣ�Ч���Ż�
  �޸�ʱ�䣺2015��02��11�� �޸��ˣ�������  �޸����ݣ��޸�ͳ���豸�����ʣ��ƻ��Ű೵����
  �޸�ʱ�䣺2015��03��13�� �޸��ˣ�������  �޸����ݣ�ϵͳ�����ʡ�DVR¼����
  **************************************************/
BEGIN
  delete from om_summarydatagd t where t.summarydate = trunc(sysdate - 1);
  commit;
  delete from om_faultequipmentlist t
   where t.summarydate = trunc(sysdate - 1);
  commit;
  -- ��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  -- δӪ�˳���Ĭ��ʱ��
  select t.value
    into v_offlinebuslonger
    from configs t
   where t.section = 'OMFOFFLINEBUSLONGER';
  select t.value
    into v_repirtnum1
    from configs t
   where t.section = 'OMMAL1REPIRTNUM';
  select t.value
    into v_repirtnum2
    from configs t
   where t.section = 'OMMAL2REPIRTNUM';
  select t.value
    into v_repirtnum4
    from configs t
   where t.section = 'OMMAL4REPIRTNUM';
  select t.value
    into v_repirtnum6
    from configs t
   where t.section = 'OMMAL6REPIRTNUM';
  select t.value
    into v_repirtnum9
    from configs t
   where t.section = 'OMMAL9REPIRTNUM';
  -- ���ػ�������
  select count(1)
    into v_onlinenum
    from (select distinct (t.productid) productid
            from bsvcbusrundatald5 t
           where t.actdatetime > trunc(sysdate - 1)
             and t.actdatetime < trunc(sysdate)) e,
         (select distinct t.busid, t.rundatadate
            from fdisbusrunrecgd t
           where t.rundatadate = trunc(sysdate - 1)
             and t.rectype = '1'
             and t.isavailable = '1') r,
         om_view_busmachine m
   where m.productid = e.productid
     and m.busid = r.busid;
  --�����Ű೵��������
  select count(1)
    into v_planonlinenum
    from om_view_busmachine mac,
         (select distinct t.busid
            from fdisarrangesequenceld t
           where t.busid is not null
             and t.execdate = trunc(sysdate - 1)) bus,
         (select distinct (t.productid) productid
            from bsvcbusrundatald5 t
           where t.actdatetime > trunc(sysdate - 1)
             and t.actdatetime < trunc(sysdate)) run
   where mac.busid = bus.busid
     and mac.productid = run.productid;
  -- �䳵�Ű೵����
  select count(distinct t.busid) into v_planrunnum from om_view_arrange t;
  -- ���ػ�������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '1'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --���ػ�����
  select count(1) into v_devnum from om_view_busmachine t;
  -- ���ػ�����ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when (ds.eventsign is null and ds.longer is not null) or
                    ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid,
                 event.productid eventsign,
                 mal.productid malsign,
                 longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_busmachine mac,
                 (select t.productid
                    from bsvcbusrundatald5 t
                   where t.actdatetime > trunc(sysdate - 1)
                     and t.actdatetime < trunc(sysdate)
                   group by t.productid) event,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '1'
                   group by t.productid) mal
           where mac.productid = event.productid(+)
             and mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  insert into om_faultequipmentlist
    (summarydate, devcode, routename, busselfid, productid)
    select trunc(sysdate - 1),
           '1',
           ds.routename,
           ds.busselfid,
           ds.productid
      from (select mac.routename,
                   mac.busselfid,
                   mac.productid,
                   event.productid eventsign,
                   mal.productid malsign,
                   longer.longer
              from (select t.busid,
                           round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                      from fdisbusrunrecgd t
                     where t.rundatadate = trunc(sysdate - 1)
                       and t.rectype = '1'
                       and t.isavailable = '1'
                     group by t.busid) longer,
                   om_view_busmachine mac,
                   (select t.productid
                      from bsvcbusrundatald5 t
                     where t.actdatetime > trunc(sysdate - 1)
                       and t.actdatetime < trunc(sysdate)
                     group by t.productid) event,
                   (select t.productid
                      from ms_monitorreportgd t
                     where t.repairstatus in (0, 1, 2, 99)
                       and t.devtypecode = '1'
                     group by t.productid) mal
             where mac.productid = event.productid(+)
               and mac.busid = longer.busid(+)
               and mac.productid = mal.productid(+)) ds
     where (ds.eventsign is null and ds.longer is not null)
        or ds.malsign is not null;
  commit;
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2,
     devmaltimes,
     devtimes)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '1',
     v_onlinenum,
     v_planonlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2,
     v_devmaltimes,
     v_devtimes);
  commit;
  -- DVR������
  select count(1)
    into v_onlinenum
    from (select distinct t.dvrselfid
            from dvr_onlinerecordgd t
           where (t.onlinedate >= trunc(sysdate - 1) and
                 t.onlinedate < trunc(sysdate))
              or (t.offonlinedate >= trunc(sysdate - 1) and
                 t.offonlinedate < trunc(sysdate))) e,
         (select distinct t.busid, t.rundatadate
            from fdisbusrunrecgd t
           where t.rundatadate >= trunc(sysdate - 1)
             and t.rundatadate < trunc(sysdate)
             and t.rectype = '1'
             and t.isavailable = '1') r,
         om_view_dvr m
   where m.dvrselfid = e.dvrselfid
     and m.busid = r.busid;
  --�����Ű೵��������
  select count(1)
    into v_planonlinenum
    from om_view_dvr dvr,
         (select distinct t.dvrselfid
            from dvr_onlinerecordgd t
           where (t.onlinedate >= trunc(sysdate - 1) and
                 t.onlinedate < trunc(sysdate))
              or (t.offonlinedate >= trunc(sysdate - 1) and
                 t.offonlinedate < trunc(sysdate))) r,
         (select distinct t.busid
            from fdisarrangesequenceld t
           where t.busid is not null
             and t.execdate = trunc(sysdate - 1)) run
   where dvr.dvrselfid = r.dvrselfid
     and dvr.busid = run.busid;

  -- DVR������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '41'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --DVR����
  select count(1) into v_devnum from om_view_dvr t;
  -- DVR ����ʱ��������ʱ��
  select sum(decode(ds.longer, null, v_offlinebuslonger, ds.longer)) sumlonger,
         sum(case
               when ds.malsign is not null then
                decode(ds.longer, null, v_offlinebuslonger, ds.longer)
             end) summallonger
    into v_devtimes, v_devmaltimes
    from (select mac.productid, mal.productid malsign, longer.longer
            from (select t.busid,
                         round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                    from fdisbusrunrecgd t
                   where t.rundatadate = trunc(sysdate - 1)
                     and t.rectype = '1'
                     and t.isavailable = '1'
                   group by t.busid) longer,
                 om_view_dvr mac,
                 (select t.productid
                    from ms_monitorreportgd t
                   where t.repairstatus in (0, 1, 2, 99)
                     and t.devtypecode = '41'
                   group by t.productid) mal
           where mac.busid = longer.busid(+)
             and mac.productid = mal.productid(+)) ds;
  insert into om_faultequipmentlist
    (summarydate, devcode, routename, busselfid, productid)
    select trunc(sysdate - 1),
           '41',
           ds.routename,
           ds.busselfid,
           ds.productid
      from (select mac.routename,
                   mac.busselfid,
                   mac.productid,
                   mal.productid malsign,
                   longer.longer
              from (select t.busid,
                           round(sum(t.arrivetime - t.leavetime) * 24, 2) longer
                      from fdisbusrunrecgd t
                     where t.rundatadate = trunc(sysdate - 1)
                       and t.rectype = '1'
                       and t.isavailable = '1'
                     group by t.busid) longer,
                   om_view_dvr mac,
                   (select t.productid
                      from ms_monitorreportgd t
                     where t.repairstatus in (0, 1, 2, 99)
                       and t.devtypecode = '41'
                     group by t.productid) mal
             where mac.busid = longer.busid(+)
               and mac.productid = mal.productid(+)) ds
     where ds.malsign is not null;

  select count(distinct dvr.dvrselfid)
    into v_dvrnovideonum
    from (select t.dvrselfid, t.errorcode, count(1) repirtnum
            from dvr_errorloggs t
           where t.errortype = '1'
             and (t.errorchannel <> '5' or t.errorchannel is null)
             and t.errortime >= trunc(sysdate) - 1
             and t.errortime < trunc(sysdate)
             and t.errorcode in (1, 2, 4, 6, 9)
           group by t.dvrselfid, t.errorcode, t.errorchannel) mal,
         om_view_dvr dvr
   where mal.dvrselfid = dvr.dvrselfid
     and ((mal.errorcode = '1' and mal.repirtnum > v_repirtnum1) or
         (mal.errorcode = '2' and mal.repirtnum > v_repirtnum2) or
         (mal.errorcode = '4' and mal.repirtnum > v_repirtnum4) or
         (mal.errorcode = '6' and mal.repirtnum > v_repirtnum6) or
         (mal.errorcode = '9' and mal.repirtnum > v_repirtnum9));

   insert into om_summarydatagd(SUMMARYDATAID,
                          Objectid,
                          SUMMARYDATE,
                          DEVTYPE,
                          ONLINENUM,
                          PLANONLINENUM,
                          PLANRUNNUM,
                          DEVMALNUM,
                          ALLDEVNUM,
                          DEVMALNUM0,
                          DEVMALNUM1,
                          DEVMALNUM2,
                          devmaltimes,
                          devtimes,
                          Dvrnovideonum) values(to_char(S_DEVEVENT.NEXTVAL),
                v_objectid,
                trunc(sysdate - 1),
                '41',
                v_onlinenum,
                v_planonlinenum,
                v_planrunnum,
                v_devmalnum,
                v_devnum,
                v_devmalnum0,
                v_devmalnum1,
                v_devmalnum2,
                v_devmaltimes,
                v_devtimes,
                v_dvrnovideonum);
  commit;
  -- ����վ��������
  select count(distinct e.productid)
    into v_onlinenum
    from om_devevent e
   where e.devtypecode = '2'
     and e.recorddate = trunc(sysdate - 1);
  -- ����վ���豸����
  v_planrunnum := 0;
  -- ����վ�ƹ�����
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '2'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����վ������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '2';
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '2',
     v_onlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2);
  commit;
  -- ������������
  select count(distinct e.productid)
    into v_onlinenum
    from om_devevent e
   where e.devtypecode = '14'
     and e.recorddate = trunc(sysdate - 1);
  -- �������豸����
  v_planrunnum := 0;
  -- ������������
  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '14'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2, 99)
           group by t.productid) t
   where t.responsibility = '2';
  --����������
  select count(1)
    into v_devnum
    from om_view_electronscreen t
   where t.devtype = '14';
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '14',
     v_onlinenum,
     v_planrunnum,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2);
  commit;
   --������
  select count(1)
    into v_devnum
    from mcbusinfogs bus
   where bus.isactive = '1'
     and bus.isinstalloillmeasurement = '1';

  select count(distinct t.productid)
    into v_devmalnum
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '99'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2)
           group by t.productid) t;
  select count(distinct t.productid)
    into v_devmalnum0
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '99'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2)
           group by t.productid) t
   where t.responsibility = '0'
      or t.responsibility is null;
  select count(distinct t.productid)
    into v_devmalnum1
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '99'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2)
           group by t.productid) t
   where t.responsibility = '1';
  select count(distinct t.productid)
    into v_devmalnum2
    from (select t.productid, max(t.responsibility) responsibility
            from ms_monitorreportgd t
           where t.devtypecode = '99'
             and t.isactive = '1'
             and t.repairstatus in (0, 1, 2)
           group by t.productid) t
   where t.responsibility = '2';
  insert into om_summarydatagd
    (SUMMARYDATAID,
     Objectid,
     SUMMARYDATE,
     DEVTYPE,
     ONLINENUM,
     PLANRUNNUM,
     DEVMALNUM,
     ALLDEVNUM,
     DEVMALNUM0,
     DEVMALNUM1,
     DEVMALNUM2)
  values
    (to_char(S_DEVEVENT.NEXTVAL),
     v_objectid,
     trunc(sysdate - 1),
     '99',
     0,
     0,
     v_devmalnum,
     v_devnum,
     v_devmalnum0,
     v_devmalnum1,
     v_devmalnum2);
  commit;
END P_OM_SUMMARYDATAGDCZ;
/

prompt
prompt Creating procedure P_OM_SUMMARYDATAYY
prompt =====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.p_om_summarydatayy IS
  v_objectid    VARCHAR2(20);
  v_yycount     NUMBER(10); --Ӫ����
  v_fyycount    NUMBER(10); --��Ӫ����
  v_repaircount NUMBER(10); --ά����
  v_yymiles     NUMBER(12, 2); --Ӫ�����
  v_zxsmiles    NUMBER(12, 2); --����ʻ���
  v_plancount   NUMBER(10); --�ƻ�������
  v_zdcccount   NUMBER(10); --���㳵����
  v_khcccount   NUMBER(10); --�г����㿼�˳���
  v_workbus     NUMBER(10); --��������
BEGIN
  --��ȡ��ĿID
  select t.value
    into v_objectid
    from configs t
   where t.section = 'OM_OBJECTID';
  --Ӫ�˳�����
  SELECT SUM(F.SEQNUM) YYCOUNT
    INTO v_yycount
    FROM FDISBUSRUNRECGD F
   WHERE F.ISAVAILABLE = '1'
     and f.rectype = '1'
     AND F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --��Ӫ�˳�����
  SELECT SUM(F.SEQNUM) FYYCOUNT
    INTO v_fyycount
    FROM FDISBUSRUNRECGD F
   WHERE F.ISAVAILABLE = '1'
     and F.RECTYPE = '0'
     AND F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --ά����
  SELECT COUNT(1)
    INTO v_repaircount
    FROM MCBUSINFOGS M, BM_WORKORDERGD B
   WHERE M.ISACTIVE = '1'
     AND M.ORDERSTATUS <> '7'
     AND M.ORDERSTATUS IS NOT NULL
     AND B.BUSID = M.BUSID;
  --Ӫ�˹���
  SELECT SUM(F.MILENUM) YYMILES
    INTO v_yymiles
    FROM FDISBUSRUNRECGD F
   WHERE F.ISAVAILABLE = '1'
     and f.rectype = '1'
     AND F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --���㳵����
  SELECT SUM(f.seqnum) ZDCC
    INTO v_zdcccount
    FROM FDISBUSRUNRECGD F
   WHERE F.ISAVAILABLE = '1'
     and F.RECTYPE = '1'
     AND F.ISLATE = '0'
     AND F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --�г����㿼�˳��Σ���ˣ�ISLATE=3��
  /*  SELECT SUM(f.seqnum) KHCC
   INTO v_khcccount
   FROM FDISBUSRUNRECGD F
  WHERE F.ISLATE <> '3'
    and F.ISAVAILABLE = '1'
    and F.RECTYPE = '1'
    AND TRUNC(F.RUNDATADATE) = TRUNC(SYSDATE - 1);*/
  --�г����㿼�˳��Σ��ܳ���-�����㳵�Σ�
  SELECT ZCCT.ZCC - FZDCCT.FZDCC KHCC
    INTO v_khcccount
    FROM (SELECT SUM(f.seqnum) ZCC
            FROM FDISBUSRUNRECGD F
           WHERE F.ISAVAILABLE = '1'
             AND F.RECTYPE = '1'
             AND F.RUNDATADATE = TRUNC(SYSDATE - 1)) ZCCT,
         (SELECT SUM(f.seqnum) FZDCC
            FROM FDISBUSRUNRECGD F
           WHERE F.ISAVAILABLE = '1'
             AND F.RECTYPE = '1'
             AND F.ISLATE = '1'
             AND F.RUNDATADATE = TRUNC(SYSDATE - 1)) FZDCCT;

  --�ƻ���������
  SELECT sum(nvl(SEQ.Seqnum, 0)) planseqnum
    into v_plancount
    FROM fdisarrangesequenceld SEQ
   where SEQ.busid is not null
     and SEQ.execdate = trunc(sysdate - 1);
  --��������
  SELECT COUNT(f.seqnum) WORKBUS
    into v_workbus
    FROM FDISBUSRUNRECGD F
   where F.ISAVAILABLE = '1'
     and f.rectype = '1'
     and F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --����ʻ���(Ӫ�����+��Ӫ�����)
  SELECT SUM(F.MILENUM) ZXSMILES
    INTO v_zxsmiles
    FROM FDISBUSRUNRECGD F
   WHERE F.ISAVAILABLE = '1'
     AND F.RUNDATADATE = TRUNC(SYSDATE - 1);
  --�洢
  DELETE FROM OM_OVERALLSTATISTICS T
   WHERE T.STATISTIME = TRUNC(SYSDATE - 1)
     AND (T.TARGETID IN ('201', '202', '203', '301', '302', '303', '304',
          '305', '306', '307', '308', '309') or t.targetid like '40%');

  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '201',
     NVL(v_yycount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '202',
     NVL(v_fyycount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '203',
     NVL(v_repaircount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '301',
     NVL(v_yymiles, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '302',
     NVL(v_zxsmiles, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '304',
     NVL(v_yycount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '305',
     NVL(v_plancount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '306',
     NVL(v_zdcccount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '307',
     NVL(v_khcccount, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '308',
     NVL(v_yymiles, 0),
     trunc(sysdate) - 1,
     0);
  INSERT INTO OM_OVERALLSTATISTICS
    (OVERALLSTATISTICSID,
     DEVTYPE,
     TARGETID,
     TARGETVALUE,
     STATISTIME,
     ISYNC)
  VALUES
    (to_char(S_OVERALLSTATISTICS.NEXTVAL),
     null,
     '309',
     NVL(v_workbus, 0),
     trunc(sysdate) - 1,
     0);

  COMMIT;
  -- ��ȫָ��
  for cur_peccancy in (select t.targetid, p.peccancycount
                         from om_view_peccancy p, om_view_peccancytype t
                        where p.peccancytype = t.targetid2) loop
    INSERT INTO OM_OVERALLSTATISTICS
      (OVERALLSTATISTICSID,
       DEVTYPE,
       TARGETID,
       TARGETVALUE,
       STATISTIME,
       ISYNC)
    VALUES
      (to_char(S_OVERALLSTATISTICS.NEXTVAL),
       null,
       cur_peccancy.targetid,
       cur_peccancy.peccancycount,
       trunc(sysdate) - 1,
       0);
    commit;
  end loop;
END p_om_summarydatayy;
/

prompt
prompt Creating procedure P_PZHBUSSTATE
prompt ================================
prompt
create or replace procedure aptspzh.p_pzhbusstate is --��ǿ20151204
begin
  delete jc_pzhbusstate where jcdate = trunc(sysdate - 1);
  commit;
  insert into jc_pzhbusstate
    (busid,
     busorgid,
     busroute,
     yy_mile,
     fyy_mile,
     jcdate,
     busstate,
     createdate)
    (select f.busid,
            f.orgid,
            f.routeid,
            sum(case
                  when f.rectype = 1 or (f.MILETYPEID = 11 and f.rectype = 2) then
                   f.milenum
                  else
                   0
                end) yy_mile,
            sum(case
                  when f.rectype <> 1 and f.MILETYPEID <> 11 then
                   f.milenum
                  else
                   0
                end) fyy_mile,
            f.rundatadate,
            0,
            sysdate
       from fdisbusrunrecgd f
      where f.rundatadate = trunc(sysdate - 1, 'dd')
      group by f.busid, f.routeid, f.rundatadate, f.orgid);
      commit;
  begin
    --ͬһ�����ܶ�����·ֻ��¼��Ӫ������ģ�ɾ��������¼
    for cr in (select j.busid busid, min(j.yy_mile) yy_mile
                 from JC_PZHBUSSTATE j
                where j.jcdate = trunc(sysdate - 1)
                  and j.busid in (select j.busid
                                    from JC_PZHBUSSTATE j
                                   where j.jcdate = trunc(sysdate - 1)
                                   group by j.busid
                                  having count(*) > 1)
                group by j.busid
                order by j.busid) loop
      delete JC_PZHBUSSTATE j2
       where j2.busid = cr.busid
         and j2.yy_mile =cr.yy_mile;
    end loop;
  end;
  commit;
----����Ӫ���Ϊ0�ĳ�������Ϊά�޳� busstate=1
  begin
    for cr in (select busid, jcdate
                 from jc_pzhbusstate
                where jcdate = trunc(sysdate - 1)) loop
      update jc_pzhbusstate j
         set busstate = 1
       where j.busid = cr.busid
         and j.yy_mile = 0
         and exists
       (select busid, reportdate
                from BM_WORKORDERGD w
               where w.busid = cr.busid
                 and w.reportdate >= trunc(sysdate - 1)
                 and (w.finishdate < sysdate or w.finishdate is null));
    end loop;
  end;

  commit;

end;
/

prompt
prompt Creating procedure P_PZHDRB_REBULID
prompt ===================================
prompt
create or replace procedure aptspzh.P_Pzhdrb_Rebulid (V_Date varchar2) is
begin
delete from PZHDRB where recorddate=trunc(to_date(V_Date,'yyyy/mm/dd'));
  --------------��������
  insert into pzhdrb (orgid,orgname,routeid,routename,busnumber,subroutename,routelength,routestid,routeedid,routestname,routeedname,planpbrq,planpbzb,planbcrq,planbczb,clnum,realbczb,realbcrq,mails,recorddate)
  select o.parentorgid,ogp.orgname,a.routeid,a.routename,a.busnumber,b.subroutename,b.routenetlength,c.fststationid,c.lststationid,d.stationname ft,e.stationname lt,
sum(case
             when f.shiftdetailtype = 11 and f.shifttype = 1  then
              1
             else
              0
           end) riqin,
       sum(case
             when  f.shifttype=2  then
              2
             when f.shifttype=1 and f.shiftdetailtype!=11  then
              1
              else
                0
           end) zhengban,
           sum(case
             when f.shiftdetailtype = 11 and f.shifttype = 1  then
              f.seqnum1+f.seqnum2
             else
              0
           end) riqinbc,
       sum(case
             when f.shiftdetailtype != 11 and f.shifttype=1  then
              f.seqnum1
              when f.shifttype=2  then
                f.seqnum1+f.seqnum2
             else
              0
           end) zhengbanbc,
             round(sum(
              f.seqnum1+f.seqnum2
            )/sum(f.shifttype)/2,1) quanshu,
           h.realzb,h.realrq,h.miles,to_date(V_Date,'yyyy/mm/dd')
from mcrouteinfogs a,mcsubrouteinfogs b,mcsegmentinfogs c,mcstationinfogs d,mcstationinfogs e,SCHPLANGD g, SCHPLANSHIFTGD f,mcorginfogs o,
mcrorgroutegs ro,mcorginfogs ogp,
(select routeid,sum(case
           when shiftdetailtype!=11 and rectype=1 then
           seqnum
           else
              0
           end) realzb,
           sum(case
           when shiftdetailtype=11 and rectype=1 then
           seqnum
           else
              0
           end) realrq,
           sum(milenum��miles
             from fdisbusrunrecgd
           where  to_char(rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and isavailable=1 group by routeid) h
where a.routeid=b.routeid(+) and b.subrouteid=c.subrouteid(+) and c.fststationid=d.stationid(+) and c.lststationid=e.stationid(+)
and a.routeid=g.routeid(+) and g.planid=f.planid(+) and a.routeid=h.routeid(+) and a.routeid=ro.routeid(+) and ro.orgid=o.orgid(+)
and o.parentorgid=ogp.orgid(+) and
 g.planid in (select ASGNARRANGEGD.planid from ASGNARRANGEGD where
to_char(ASGNARRANGEGD.execdate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ASGNARRANGEGD.status='d' /*and ASGNARRANGEGD.routeid=4*/)
and c.rundirection!=2 and b.isactive=1
group by a.orgid,a.routeid,a.routename,a.busnumber,b.subroutename,b.routenetlength,c.fststationid,c.lststationid,
d.stationname,e.stationname,h.realzb,h.realrq,h.miles,o.orgname,ogp.orgname,o.parentorgid
order by o.parentorgid;

---�ϲ�102
update pzhdrb a set /*a.routelength=a.routelength+(select routelength from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(V_Date,'yyyy/mm/dd') and routeid=10201),*/
a.busnumber=a.busnumber+(select busnumber from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.planpbzb=a.planpbzb+(select planpbzb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.planpbrq=a.planpbrq+(select planpbrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.planbczb=a.planbczb+(select planbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.planbcrq=a.planbcrq+(select planbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.realbczb=a.realbczb+(select realbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.realbcrq=a.realbcrq+(select realbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201),
a.mails=a.mails+(select mails from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=10201)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and a.routeid=102;
commit;
update pzhdrb a set a.clnum=(a.planbczb+a.planbcrq)/((a.planpbzb+a.planpbrq)*2)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and a.routeid=102;
 
--�ϲ�111
update pzhdrb a set a.routename='111·',
/*a.routelength=a.routelength+(select routelength from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),*/
a.busnumber=a.busnumber+(select busnumber from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.planpbzb=a.planpbzb+(select planpbzb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.planpbrq=a.planpbrq+(select planpbrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.planbczb=a.planbczb+(select planbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.planbcrq=a.planbcrq+(select planbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.realbczb=a.realbczb+(select realbczb from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.realbcrq=a.realbcrq+(select realbcrq from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.mails=a.mails+(select mails from pzhdrb where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid=111001),
a.clnum=(a.planbczb+a.planbcrq)/(a.planpbzb+a.planpbrq)
where to_char(a.recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and a.routeid=111;
---����102·�ƻ���ࣨ����Ҫ���Ϊ���⣬һ�㲻��Ҫ�޸ģ�
update pzhdrb a set a.planpbzb=3.5,a.clnum=13 where routeid=108 and to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd');
----����25·��С������
update pzhdrb p
set p.routename='25��',
p.realbczb=(select sum(case
           when ff.shiftdetailtype!=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realzb
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����')��
p.realbcrq=(select
           sum(case
           when ff.shiftdetailtype=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realrq
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����'),
p.mails=(select
           sum(ff.milenum��miles
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='����')
where p.subroutename='25' and to_char(p.recorddate,'yyyy-mm-dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy-mm-dd');
------------------------------------
update pzhdrb p
set p.routename='25С',p.routeid=2501��
p.realbczb=(select sum(case
           when ff.shiftdetailtype!=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realzb
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����')��
p.realbcrq=(select
           sum(case
           when ff.shiftdetailtype=11 and ff.rectype=1 then
           ff.seqnum
           else
              0
           end) realrq
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����'),
p.mails=(select
           sum(ff.milenum��miles
             from fdisbusrunrecgd  ff,mcbusinfogs bb
           where  ff.busselfid=bb.busselfid(+) and
           to_char(ff.rundatadate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and ff.isavailable=1 and ff.routeid=25 and bb.retain1='С����')
where p.subroutename='25B' and to_char(p.recorddate,'yyyy-mm-dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy-mm-dd');
--------
--ɾ����������
delete pzhdrb a where to_char(recorddate,'yyyy/mm/dd')=to_char(to_date(V_Date,'yyyy-mm-dd'),'yyyy/mm/dd') and routeid in (10201,111001);

end P_Pzhdrb_Rebulid;
/

prompt
prompt Creating procedure P_PZH_RECTICKSTOCK
prompt =====================================
prompt
create or replace procedure aptspzh.p_pzh_rectickstock
is
begin
  delete from Pzh_TicketStock ts where to_char(ts.recdate,'yyyy-mm-dd')=to_char(sysdate,'yyyy-mm-dd');
  insert into Pzh_TicketStock (stid,Recdate,Tkclasscod,Tkclassname,Curpicenum,Curmoney,Curbookdata,Orgid)
  select pzh_seq.nextval,to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy/mm/dd'),b.tkclasscode,b.tkclassname,b.curpiecenum,
  b.curmoney,b.curbookdata,case when e.orgid in (select o.orgid from mcorginfogs o start with o.parentorgid
='55150203175953844320' connect by o.orgid=o.parentorgid) then '55150203175953844320'
when e.orgid in (select o.orgid from mcorginfogs o start with o.parentorgid
='55150213092542050000' connect by o.orgid=o.parentorgid)then '55150213092542050000'
when e.orgid in (select o.orgid from mcorginfogs o start with o.parentorgid
='55150213092857160000' connect by o.orgid=o.parentorgid)then '55150213092857160000'
when e.orgid in (select o.orgid from mcorginfogs o start with o.parentorgid
='55150213092919062000' connect by o.orgid=o.parentorgid)then '55150213092919062000' else null end gs from BFAREFKSTOCK b,mcemployeeinfogs e
where b.recorder=e.empid(+);
commit;
  end p_pzh_rectickstock;
/

prompt
prompt Creating procedure P_RBUSROUTE_BACKUP
prompt =====================================
prompt
create or replace procedure aptspzh.P_RBUSROUTE_BACKUP is
begin
  --���ݳ�����·��ϵ
  INSERT INTO MC_BU_RBUSROUTE
    (RBUSROUTEID, ROUTEBUSDATE, BUSID, ROUTEID, ORGID, BUSSELFID)
    SELECT S_RBUSROUTEID.NEXTVAL AS RBUSROUTEID,
           TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD'),
           BUSROUTE.BUSID,
           BUSROUTE.ROUTEID,
           BUSINFO.ORGID,
           BUSINFO.BUSSELFID
      FROM ASGNRBUSROUTELD BUSROUTE, MCBUSINFOGS BUSINFO
     WHERE BUSROUTE.BUSID = BUSINFO.BUSID
       AND BUSINFO.flag = '1';
  -- �ύ
  COMMIT;
end P_RBUSROUTE_BACKUP;
/

prompt
prompt Creating procedure P_RELOADASGNREMPROUTETMP
prompt ===========================================
prompt
create or replace procedure aptspzh.p_ReLoadASGNREMPROUTETMP(v_routeid   in NVARCHAR2,
                                                   v_rundate   in NVARCHAR2,
                                                   v_arrangeid in NVARCHAR2) is

  v_count  number;
  v_substr varchar2(4000);
begin
  delete from asgnremproutetmp
         where routeid = v_routeid
         and RECDATE = to_date(v_rundate, 'yyyy-MM-dd hh24:mi:ss');
    select count(*)
      into v_count
      from asgnremproutetmp2
     where routeid = v_routeid
       and RECDATE = to_date(v_rundate, 'yyyy-MM-dd hh24:mi:ss');
    if v_count > 0 then
      v_substr := 'INSERT INTO ASGNREMPROUTETMP
  (REMPRID,
   EMPID,
   ROUTEID,
   RECDATE,
   ARRANGEID,
   EMPSTATUS,
   EMPSTATUSDETAIL,
   EMPPAYMULTIPLE,
   MEMOS)
  SELECT S_ASGNREMPROUTETMP.NEXTVAL,
         AEMP.EMPID,
         AEMP.ROUTEID,
         AEMP.RECDATE,
         AEMP.ARRANGEID,
         AEMP.EMPSTATUS,
         AEMP.EMPSTATUSDETAIL,
         AEMP.EMPPAYMULTIPLE,
         AEMP.MEMOS
    FROM ASGNREMPROUTETMP2 AEMP,asgnarrangegd ARR
   WHERE AEMP.ARRANGEID=ARR.ARRANGEID
   AND ARR.STATUS=''d''
   AND ARR.ARRANGEID=''' || v_arrangeid || '''
   AND AEMP.ROUTEID=(' || v_routeid || ')
   AND AEMP.RECDATE=to_date(''' || v_rundate ||
                  ''' ,''yyyy-MM-dd hh24:mi:ss'')';
    else
      v_substr := 'INSERT INTO ASGNREMPROUTETMP
  (REMPRID,
   EMPID,
   ROUTEID,
   RECDATE,
   ARRANGEID,
   EMPSTATUS,
   MEMOS)
  SELECT S_ASGNREMPROUTETMP.NEXTVAL,
         EMPID,
         ROUTEID,
         to_date(''' || v_rundate || ''' ,''yyyy-MM-dd hh24:mi:ss''),
         '''',
         1,
         ''''
    FROM asgnremprouteld
   WHERE ROUTEID=(' || v_routeid || ')';
    end if;
    execute immediate v_substr;
  commit;
end p_ReLoadASGNREMPROUTETMP;
/

prompt
prompt Creating procedure P_REPAIR_DADA_ORG
prompt ====================================
prompt
create or replace procedure aptspzh.P_REPAIR_DADA_ORG( v_begindate IN date,
                                               v_enddate IN date) IS
/***************************************************
  ���ƣ�P_REPAIR_DADA_ORG
  ������v_begindate  ��ʼ����
        v_enddate     ��������
  ��;���޸�����������֯ ����ORGID
  �����:   asgnarrangeseqgd2
            asgnarrangeseqgd
            fdisdisplanld
            fdisbusrunrecgd
            dssticketreceiptld
            dssfuelcostld
            fdisfakeseqgd
            fdisbustrubleld
  ��д��    CoICE    20100520
  �޸ģ�    COICE 2010-11-18 �޸� 1����Ϊʱ������2����ȡ��֯��ʽ
            COICE 2011-3-22  �����޸�ԭʼ���ݱ�

***************************************************/
begin
--1.�����޳�����֯�ĳ���
--1.1
  update asgnarrangeseqgd2 t
         set t.orgid = (select g.orgid
                             from asgnarrangegd g
                            where g.arrangeid = t.arrangeid)
       where t.busid is null and t.orgid is null
       and t.EXECDATE between v_begindate and v_enddate         ;
  commit;
--1.2
  update asgnarrangeseqgd t
         set t.orgid = (select g.orgid
                             from asgnarrangegd g
                            where g.arrangeid = t.arrangeid)
      where t.busid is null and t.orgid is null
      and t.EXECDATE between v_begindate and v_enddate
      ;
   commit;
--2.�޸��г�������
--2.1�����Ŷӱ�
update fdisdisplanld a  set a.orgid=f_get_orgid_by_busid(a.busid,a.rundate)
where a.rundate between v_begindate and v_enddate
AND A.BUSID IS NOT NULL
  and( a.orgid<>f_get_orgid_by_busid(a.busid,a.rundate) or a.orgid is null);
commit;
--2.2���α�
update fdisbusrunrecgd a set a.orgid=f_get_orgid_by_busid(a.busid,a.rundatadate)
 where a.rundatadate between v_begindate and v_enddate
 AND A.BUSID IS NOT NULL
 and (a.orgid<>f_get_orgid_by_busid(a.busid,a.rundatadate) or a.orgid is null);
 commit;
 --2.3Ӫ��
update di_wx_ticketimportgd a set a.orgid=f_get_orgid_by_busid(a.busid,a.rundatadate)
 where a.rundatadate between v_begindate and v_enddate
 AND A.BUSID IS NOT NULL
and (a.orgid<>f_get_orgid_by_busid(a.busid,a.rundatadate) or a.orgid is null);
commit;
update dssticketreceiptld a set a.orgid=f_get_orgid_by_busid(a.busid,a.operationdate)
where a.operationdate between v_begindate and v_enddate
AND A.BUSID IS NOT NULL
 and (a.orgid<>f_get_orgid_by_busid(a.busid,a.operationdate) or a.orgid is null);
 commit;
--2.4�ͺ�
update dssfuelcostld a set a.orgid=f_get_orgid_by_busid(a.busid,a.runningdate)
 where a.runningdate between v_begindate and v_enddate
 AND A.BUSID IS NOT NULL
and (a.orgid<>f_get_orgid_by_busid(a.busid,a.runningdate) or a.orgid is null);
commit;
update di_wx_fuelcostimportgd a set a.orgid=f_get_orgid_by_busid(a.busid,a.rundatadate)
where a.rundatadate between v_begindate and v_enddate
AND A.BUSID IS NOT NULL
 and (a.orgid<>f_get_orgid_by_busid(a.busid,a.rundatadate) or a.orgid is null);
 commit;
--2.5�Ű�2
UPDATE ASGNARRANGESEQGD2 A
      SET A.ORGID=f_get_orgid_by_busid(a.busid,a.execdate)
      WHERE A.EXECDATE between v_begindate and v_enddate
      AND A.BUSID IS NOT NULL
   and ( (A.ORGID<>f_get_orgid_by_busid(a.busid,a.execdate) OR A.ORGID IS NULL)
       );
commit;
--2.6�Ű�
UPDATE ASGNARRANGESEQGD A
      SET A.ORGID=f_get_orgid_by_busid(a.busid,a.execdate)
      WHERE A.EXECDATE between v_begindate and v_enddate
      AND A.BUSID IS NOT NULL
   and ( (A.ORGID<>f_get_orgid_by_busid(a.busid,a.execdate) OR A.ORGID IS NULL)
       );
commit;
--2.7�ð�
UPDATE fdisfakeseqgd A
      SET A.ORGID=(SELECT F.ORGID FROM fdisdisplanld F WHERE f.displanid = a.seqid AND F.RUNDATE=TRUNC(SYSDATE-1))
      WHERE A.RUNDATE between v_begindate and v_enddate
      and  (A.ORGID<>(SELECT F.ORGID FROM fdisdisplanld F WHERE f.displanid = a.seqid AND F.RUNDATE=TRUNC(SYSDATE-1))
      OR A.ORGID IS NULL ) ;
commit;
--2.8����
update fdisbustrubleld a  set a.orgid=f_get_orgid_by_busid(a.busid,a.rundate)
where a.rundate between v_begindate and v_enddate
AND A.BUSID IS NOT NULL
  and( a.orgid<>f_get_orgid_by_busid(a.busid,a.rundate) or a.orgid is null);
commit;

--2.9�Ű�W
UPDATE asgnarrangewshiftld A
      SET A.ORGID=f_get_orgid_by_busid(a.busid,a.execdate)
      WHERE A.EXECDATE between v_begindate and v_enddate
      AND A.BUSID IS NOT NULL
   and ( (A.ORGID<>f_get_orgid_by_busid(a.busid,a.execdate) OR A.ORGID IS NULL)
       );
commit;

--3.0��Ա����
UPDATE fdisempdutyld A
      SET A.ORGID=f_get_orgid_by_EMPid(a.EMPid,a.execdate)
      WHERE A.EXECDATE between v_begindate and v_enddate
      AND A.EMPID IS NOT NULL
   and ( (A.ORGID<>f_get_orgid_by_EMPid(a.EMPid,a.execdate) OR A.ORGID IS NULL)
       );
commit;
--3
exception
  when others then
 null;
end P_REPAIR_DADA_ORG;
/

prompt
prompt Creating procedure P_ROUTECOPY
prompt ==============================
prompt
create or replace procedure aptspzh.p_routecopy(oldrouteid      varchar2, --ԭ��·��
                                        newrouteid      varchar2, --����·��
                                        newroutename    varchar2, --����·����
                                        oldsubrouteid   varchar2, --ԭ���ߺ�
                                        newsubrouteid   varchar2, --�����ߺ�
                                        newsubroutename varchar2, --����������
                                        style           varchar2, --1 ������·  2 ��������
                                        iscopybe        varchar2 --Y������·��Ӧ��������Ա N ��������·��Ӧ��������Ա
                                        ) as
  oldroute number(8);
  segid    number(20);
begin
  select max(segmentid) into segid from mcsegmentinfogs;
  select routeid into oldroute from mcsubrouteinfogs  where subrouteid = oldsubrouteid;
  --*********������·���÷�ʽ��begin(oldrouteid,newrouteid,newroutename,oldsubrouteid,newsubrouteid,newsubroutename,'1',iscopybe)*************--
  if style = '1' then
    DELETE FROM MCRORGROUTEGS T
     WHERE T.ROUTEID NOT IN (SELECT ROUTEID FROM MCROUTEINFOGS);
    --��·
    insert into mcrouteinfogs
      (routeid,
       routename,
       routetype,
       isconductor,
       dispatchway,
       memos,
       oilstdmile,
       servicestdmile,
       maintainstdmile,
       inoutstdmile,
       created,
       createby,
       updated,
       updateby,
       isactive,
       routecode,
       flag,
       orgid,
       offsetpos,
       offsetneg,
       routeowend,
       fstadate,
       startdate,
       enddate,
       tickettype,
       iccard,
       runs,
       hotvalue,
       normalvalue,
       coolvalue,
       ctrlroomadd,
       ctrlroomtel,
       stationnum,
       falseroutetype,
       ticketprice,
       airticket,
       ticket,
       busnumber)
      select newrouteid,
             newroutename,
             routetype,
             isconductor,
             dispatchway,
             memos,
             oilstdmile,
             servicestdmile,
             maintainstdmile,
             inoutstdmile,
             created,
             createby,
             updated,
             updateby,
             isactive,
             newrouteid,
             flag,
             orgid,
             offsetpos,
             offsetneg,
             routeowend,
             fstadate,
             startdate,
             enddate,
             tickettype,
             iccard,
             runs,
             hotvalue,
             normalvalue,
             coolvalue,
             ctrlroomadd,
             ctrlroomtel,
             stationnum,
             falseroutetype,
             ticketprice,
             airticket,
             ticket,
             busnumber
        from mcrouteinfogs
       where routeid = oldrouteid;
    --��֯��·��ϵ
    insert into MCRORGROUTEGS
      (rorsid, routeid, orgid)
      select s_sync.nextval, newrouteid, orgid
        from mcrorgroutegs
       where routeid = oldrouteid;
    --����
    insert into mcsubrouteinfogs
      (subrouteid,
       routeid,
       subroutename,
       mediaroutename,
       memos,
       routenetlength,
       ismainsub,
       showflag,
       updated,
       updateby,
       created,
       createby,
       isactive,
       flag,
       enddate,
       startdate)
      select newsubrouteid,
             newrouteid,
             newsubroutename,
             newsubroutename mediaroutename,
             memos,
             routenetlength,
             ismainsub,
             showflag,
             updated,
             updateby,
             created,
             createby,
             isactive,
             flag,
             enddate+(365*10),
             enddate+1
        from mcsubrouteinfogs
       WHERE ROUTEID = oldrouteid
         AND subrouteid = oldsubrouteid;
    --����
    insert into mcsegmentinfogs
      (segmentid,
       routeid,
       subrouteid,
       segmentname,
       rundirection,
       fstsendtime,
       lstsendtime,
       sngmile,
       sngtime,
       offsetpos,
       offsetneg,
       fststationid,
       lststationid,
       memos,
       subroutename,
       created,
       createby,
       updated,
       updateby,
       isactive,
       issecondday,
       flag,
       ctrlroomadd,
       ctrlroomtel,
       stationnum,
       defaultseqnum)
      select segid + rundirection as segmentid,
             newrouteid,
             newsubrouteid,
             newsubroutename ||
             (select itemkey
                from typeentry
               where typename = 'RUNDIRECTION'
                 and itemvalue = rundirection) as segmentname,
             rundirection,
             fstsendtime,
             lstsendtime,
             sngmile,
             sngtime,
             offsetpos,
             offsetneg,
             fststationid,
             lststationid,
             memos,
             subroutename,
             created,
             createby,
             updated,
             updateby,
             isactive,
             issecondday,
             flag,
             ctrlroomadd,
             ctrlroomtel,
             stationnum,
             defaultseqnum
        from mcsegmentinfogs
       where routeid = oldrouteid
         and subrouteid = oldsubrouteid;
    --��·վ���Ӧ��ϵ
    insert into mcrroutestationgs
      (rroutesid, routeid, stationid, dualserialid)
      select s_sync.nextval, newrouteid, stationid, dualserialid
        from mcrroutestationgs
       where routeid = oldrouteid;
    --����վ���Ӧ��ϵ
    insert into mcrsegmentstationgs
      (rsegmentsid,
       routeid,
       subrouteid,
       segmentid,
       stationid,
       sngserialid,
       stationtypeid,
       stationtypename,
       dualserialid,
       haselecboard,
       subcommid,
       distance,
       predistance,
       pretime,
       carryrate,
       recdate,
       ispredict,
       stationname,
       onhourtime,
       minstoptime,
       maxstoptime,
       overspeedstd,
       arriveshow,
       leaveshow,
       sboardid,
       fstsendtime,
       lstsendtime,
       created,
       createby,
       updated,
       updateby,
       isactive,
       flag)
      select s_sync.nextval,
             newrouteid,
             newsubrouteid,
             segid + sg.rundirection as segmentid,
             sgst.stationid,
             sgst.sngserialid,
             sgst.stationtypeid,
             sgst.stationtypename,
             sgst.dualserialid,
             sgst.haselecboard,
             sgst.subcommid,
             sgst.distance,
             sgst.predistance,
             sgst.pretime,
             sgst.carryrate,
             sgst.recdate,
             sgst.ispredict,
             sgst.stationname,
             sgst.onhourtime,
             sgst.minstoptime,
             sgst.maxstoptime,
             sgst.overspeedstd,
             sgst.arriveshow,
             sgst.leaveshow,
             sgst.sboardid,
             sgst.fstsendtime,
             sgst.lstsendtime,
             sgst.created,
             sgst.createby,
             sgst.updated,
             sgst.updateby,
             sgst.isactive,
             sgst.flag
        from mcrsegmentstationgs sgst, mcsegmentinfogs sg
       where sgst.routeid = sg.routeid
         and sgst.subrouteid = sg.subrouteid
         and sgst.segmentid = sg.segmentid(+)
         and sgst.routeid = oldrouteid
         and sgst.subrouteid = oldsubrouteid;

    --������ĩ��ʱ��
    insert into routefirendtime
      (routetimeid,
       routeid,
       startdate,
       enddate,
       startweek,
       endweek,
       firsttime,
       endtime,
       isactive,
       segmentid,
       subrouteid)
      select s_sync.nextval,
             newrouteid,
             startdate,
             enddate,
             startweek,
             endweek,
             firsttime,
             endtime,
             tim.isactive,
             segid + sg.rundirection,
             newsubrouteid
        from routefirendtime tim,mcsegmentinfogs sg
       where tim.routeid = oldrouteid
         and tim.segmentid=sg.segmentid
         and tim.subrouteid=sg.subrouteid
         and tim.subrouteid=oldsubrouteid;
  end if;
  if style = '1' and iscopybe = 'Y' then
    --��·������ϵ
    insert into asgnrbusrouteld
      (rbusrid, busid, routeid, recdate, tasktype)
      select s_sync.nextval, busid, newrouteid, recdate, tasktype
        from asgnrbusrouteld
       where routeid = oldrouteid;
    --��·��Ա��ϵ
    insert into asgnremprouteld
      (remprid, empid, routeid, recdate, tasktype)
      select s_sync.nextval, empid, newrouteid, recdate, tasktype
        from asgnremprouteld
       where routeid = oldrouteid;
  end if;

  --****************************************������·end**************************************************--

  --***************�������ߵ��÷�ʽ: begin('',newrouteid,'',oldsubrouteid,newsubrouteid,newsubroutename,'2','N')*********************************--
  if style = '2' then
    --����
    insert into mcsubrouteinfogs
      (subrouteid,
       routeid,
       subroutename,
       mediaroutename,
       memos,
       routenetlength,
       ismainsub,
       showflag,
       updated,
       updateby,
       created,
       createby,
       isactive,
       flag,
       enddate,
       startdate)
      select newsubrouteid,
             newrouteid,
             newsubroutename,
             newsubroutename as mediaroutename,
             memos,
             routenetlength,
             ismainsub,
             showflag,
             updated,
             updateby,
             created,
             createby,
             isactive,
             flag,
             enddate+(365*10),
             enddate+1
        from mcsubrouteinfogs
       where subrouteid = oldsubrouteid;
    --����
    insert into mcsegmentinfogs
      (segmentid,
       routeid,
       subrouteid,
       segmentname,
       rundirection,
       fstsendtime,
       lstsendtime,
       sngmile,
       sngtime,
       offsetpos,
       offsetneg,
       fststationid,
       lststationid,
       memos,
       subroutename,
       created,
       createby,
       updated,
       updateby,
       isactive,
       issecondday,
       flag,
       ctrlroomadd,
       ctrlroomtel,
       stationnum,
       defaultseqnum)
      select segid + rundirection as segmentid,
             newrouteid,
             newsubrouteid,
             newsubroutename ||
             (select itemkey
                from typeentry
               where typename = 'RUNDIRECTION'
                 and itemvalue = rundirection) as segmentname,
             rundirection,
             fstsendtime,
             lstsendtime,
             sngmile,
             sngtime,
             offsetpos,
             offsetneg,
             fststationid,
             lststationid,
             memos,
             subroutename,
             created,
             createby,
             updated,
             updateby,
             isactive,
             issecondday,
             flag,
             ctrlroomadd,
             ctrlroomtel,
             stationnum,
             defaultseqnum
        from mcsegmentinfogs
       where subrouteid = oldsubrouteid;
    --����վ���Ӧ��ϵ
    insert into mcrsegmentstationgs
      (rsegmentsid,
       routeid,
       subrouteid,
       segmentid,
       stationid,
       sngserialid,
       stationtypeid,
       stationtypename,
       dualserialid,
       haselecboard,
       subcommid,
       distance,
       predistance,
       pretime,
       carryrate,
       recdate,
       ispredict,
       stationname,
       onhourtime,
       minstoptime,
       maxstoptime,
       overspeedstd,
       arriveshow,
       leaveshow,
       sboardid,
       fstsendtime,
       lstsendtime,
       created,
       createby,
       updated,
       updateby,
       isactive,
       flag)
      select s_sync.nextval,
             newrouteid,
             newsubrouteid,
             segid + sg.rundirection as segmentid,
             sgst.stationid,
             sgst.sngserialid,
             sgst.stationtypeid,
             sgst.stationtypename,
             sgst.dualserialid,
             sgst.haselecboard,
             sgst.subcommid,
             sgst.distance,
             sgst.predistance,
             sgst.pretime,
             sgst.carryrate,
             sgst.recdate,
             sgst.ispredict,
             sgst.stationname,
             sgst.onhourtime,
             sgst.minstoptime,
             sgst.maxstoptime,
             sgst.overspeedstd,
             sgst.arriveshow,
             sgst.leaveshow,
             sgst.sboardid,
             sgst.fstsendtime,
             sgst.lstsendtime,
             sgst.created,
             sgst.createby,
             sgst.updated,
             sgst.updateby,
             sgst.isactive,
             sgst.flag
        from mcrsegmentstationgs sgst, mcsegmentinfogs sg
       where sgst.subrouteid = sg.subrouteid
         and sgst.segmentid = sg.segmentid(+)
         and sgst.subrouteid = oldsubrouteid;
    --��ͬ��·ʱ������·�����Ӷ����վ��
    if newrouteid <> oldroute then
      insert into mcrroutestationgs
        (rroutesid, routeid, stationid, dualserialid)
        select s_sync.nextval,
               newrouteid,
               rst.stationid,
               (select max(rst.dualserialid)
                  from mcrroutestationgs rst
                 where rst.routeid = newrouteid) + rownum
          from mcrroutestationgs rst
         where rst.routeid = oldroute
           and rst.stationid not in
               (select rst1.stationid
                  from mcrroutestationgs rst1
                 where rst1.routeid = newrouteid);
      update mcrsegmentstationgs sst
         set sst.dualserialid =
             (select rst.dualserialid
                from mcrroutestationgs rst
               where rst.routeid = sst.routeid
                 and rst.stationid = sst.stationid)
       where sst.routeid = newrouteid;
    end if;
    --������ĩ��ʱ��
        insert into routefirendtime
      (routetimeid,
       routeid,
       startdate,
       enddate,
       startweek,
       endweek,
       firsttime,
       endtime,
       isactive,
       segmentid,
       subrouteid)
      select s_sync.nextval,
             newrouteid,
             startdate,
             enddate,
             startweek,
             endweek,
             firsttime,
             endtime,
             tim.isactive,
             segid + sg.rundirection,
             newsubrouteid
        from routefirendtime tim,mcsegmentinfogs sg
       where tim.routeid = oldroute
         and tim.segmentid=sg.segmentid
         and tim.subrouteid=sg.subrouteid
         and tim.subrouteid=oldsubrouteid;
  end if;
  --****************************************��������end**************************************************--
  COMMIT;
end;
/

prompt
prompt Creating procedure P_ROUTEINFOFULL_INIT
prompt =======================================
prompt
create or replace procedure aptspzh.P_ROUTEINFOFULL_INIT(v_routeid      in varchar2, -- ��·ID
                                                 v_processingid in varchar2 -- Ԥ�ű�ID
                                                 ) is
  /***********************************************************************************
  ���ƣ�P_ROUTEINFOFULL_INIT
  ��;����·Ԥ�ŵǼ�ʱ���ȫ���ڱ���Ϣ��ʼ��
  �������·��Ϣȫ���ڱ�MCROUTEINFOFULLGS
          ����·��Ϣȫ���ڱ�MCSUBROUTEINFOFULLGS
          ������Ϣȫ���ڱ�MCSEGMENTINFOFULLGS
          ��·վ���ϵȫ���ڱ�MCRROUTESTATIONFULLGS
          ������վ���ϵȫ���ڱ�MCRSEGMENTSTATIONFULLGS
          ��������·��Ӧ��ϵȫ���ڱ�ASGNRBUSROUTEFULLLD
          ��Ա��·��Ӧȫ���ڱ�ASGNREMPROUTEFULLLD
          ��Ա������Ӧȫ���ڱ�ASGNRBUSEMPFULLLD
  ***********************************************************************************/
begin
  -- ɾ����·��Ϣȫ���ڱ�MCROUTEINFOFULLGS��ԭ����
  DELETE FROM MCROUTEINFOFULLGS ROUTEFULL
   WHERE ROUTEFULL.PROCESSINGID = v_processingid
     AND ROUTEFULL.ROUTESTATE = '2';
  -- ɾ������·��Ϣȫ���ڱ�MCSUBROUTEINFOFULLGS��ԭ����
  DELETE FROM MCSUBROUTEINFOFULLGS SUBROUTEFULL
   WHERE SUBROUTEFULL.PROCESSINGID = v_processingid
     AND SUBROUTEFULL.ROUTESTATE = '2';
  -- ɾ��������Ϣȫ���ڱ�MCSEGMENTINFOFULLGS��ԭ����
  DELETE FROM MCSEGMENTINFOFULLGS SEGFULL
   WHERE SEGFULL.PROCESSINGID = v_processingid
     AND SEGFULL.ROUTESTATE = '2';
  -- ɾ����·վ���ϵȫ���ڱ�MCRROUTESTATIONFULLGS��ԭ����
  DELETE FROM MCRROUTESTATIONFULLGS RROUTESTATIONFULL
   WHERE RROUTESTATIONFULL.PROCESSINGID = v_processingid
     AND RROUTESTATIONFULL.ROUTESTATE = '2';
  -- ɾ��������վ���ϵȫ���ڱ�MCRSEGMENTSTATIONFULLGS��ԭ����
  DELETE FROM MCRSEGMENTSTATIONFULLGS RSEGSTATIONFULL
   WHERE RSEGSTATIONFULL.PROCESSINGID = v_processingid
     AND RSEGSTATIONFULL.ROUTESTATE = '2';
  -- ɾ����������·��Ӧ��ϵȫ���ڱ�ASGNRBUSROUTEFULLLD��ԭ����
  DELETE FROM ASGNRBUSROUTEFULLLD RBUSROUTEFULL
   WHERE RBUSROUTEFULL.PROCESSINGID = v_processingid
     AND RBUSROUTEFULL.ROUTESTATE = '2';
  -- ɾ����Ա��·��Ӧȫ���ڱ�ASGNREMPROUTEFULLLD��ԭ����
  DELETE FROM ASGNREMPROUTEFULLLD REMPROUTEFULL
   WHERE REMPROUTEFULL.PROCESSINGID = v_processingid
     AND REMPROUTEFULL.ROUTESTATE = '2';
  -- ɾ����Ա������Ӧȫ���ڱ�ASGNRBUSEMPFULLLD��ԭ����
  DELETE FROM ASGNRBUSEMPFULLLD RBUSEMPFULL
   WHERE RBUSEMPFULL.PROCESSINGID = v_processingid
     AND RBUSEMPFULL.ROUTESTATE = '2';
  COMMIT;
  -- ��·��Ϣȫ��������д��
  insert into MCROUTEINFOFULLGS
    (ROUTEFULLID,
     PROCESSINGID,
     ROUTESTATE,
     ROUTEID,
     ROUTENAME,
     ROUTETYPE,
     ISCONDUCTOR,
     DISPATCHWAY,
     MEMOS,
     OILSTDMILE,
     SERVICESTDMILE,
     MAINTAINSTDMILE,
     INOUTSTDMILE,
     CREATED,
     CREATEBY,
     UPDATED,
     UPDATEBY,
     ISACTIVE,
     ROUTECODE,
     FLAG,
     ORGID,
     OFFSETPOS,
     OFFSETNEG,
     ROUTEOWEND,
     FSTADATE,
     STARTDATE,
     ENDDATE,
     TICKETTYPE,
     ICCARD,
     RUNS,
     HOTVALUE,
     NORMALVALUE,
     COOLVALUE,
     CTRLROOMADD,
     CTRLROOMTEL,
     STATIONNUM,
     FALSEROUTETYPE,
     TICKETPRICE,
     VERNUM,
     RETAIN1,
     RETAIN2,
     RETAIN3,
     RETAIN4,
     RETAIN5,
     RETAIN6,
     RETAIN7,
     RETAIN8,
     RETAIN9,
     RETAIN10,
     AIRTICKET,
     TICKET,
     BUSNUMBER)
    select ROUTEID,
           v_processingid,
           '2',
           ROUTEID,
           ROUTENAME,
           ROUTETYPE,
           ISCONDUCTOR,
           DISPATCHWAY,
           MEMOS,
           OILSTDMILE,
           SERVICESTDMILE,
           MAINTAINSTDMILE,
           INOUTSTDMILE,
           CREATED,
           CREATEBY,
           UPDATED,
           UPDATEBY,
           ISACTIVE,
           ROUTECODE,
           FLAG,
           ORGID,
           OFFSETPOS,
           OFFSETNEG,
           ROUTEOWEND,
           FSTADATE,
           STARTDATE,
           ENDDATE,
           TICKETTYPE,
           ICCARD,
           RUNS,
           HOTVALUE,
           NORMALVALUE,
           COOLVALUE,
           CTRLROOMADD,
           CTRLROOMTEL,
           STATIONNUM,
           FALSEROUTETYPE,
           TICKETPRICE,
           0,
           RETAIN1,
           RETAIN2,
           RETAIN3,
           RETAIN4,
           RETAIN5,
           RETAIN6,
           RETAIN7,
           RETAIN8,
           RETAIN9,
           RETAIN10,
           AIRTICKET,
           TICKET,
           BUSNUMBER
      from MCROUTEINFOGS
     where ROUTEID = v_routeid;
  -- ����·��Ϣȫ��������д��
  insert into MCSUBROUTEINFOFULLGS
    (SUBROUTEFULLID,
     PROCESSINGID,
     ROUTESTATE,
     SUBROUTEID,
     ROUTEID,
     SUBROUTENAME,
     MEDIAROUTENAME,
     MEMOS,
     ROUTENETLENGTH,
     ISMAINSUB,
     SHOWFLAG,
     UPDATED,
     UPDATEBY,
     CREATED,
     CREATEBY,
     ISACTIVE,
     FLAG,
     STARTDATE,
     ENDDATE,
     VERNUM,
     RETAIN1,
     RETAIN2,
     RETAIN3,
     RETAIN4,
     RETAIN5,
     RETAIN6,
     RETAIN7,
     RETAIN8,
     RETAIN9,
     RETAIN10)
    select SUBROUTEID,
           v_processingid,
           '2',
           SUBROUTEID,
           ROUTEID,
           SUBROUTENAME,
           MEDIAROUTENAME,
           MEMOS,
           ROUTENETLENGTH,
           ISMAINSUB,
           SHOWFLAG,
           UPDATED,
           UPDATEBY,
           CREATED,
           CREATEBY,
           ISACTIVE,
           FLAG,
           STARTDATE,
           ENDDATE,
           0,
           RETAIN1,
           RETAIN2,
           RETAIN3,
           RETAIN4,
           RETAIN5,
           RETAIN6,
           RETAIN7,
           RETAIN8,
           RETAIN9,
           RETAIN10
      from MCSUBROUTEINFOGS
     where ROUTEID = v_routeid;
  -- ������Ϣȫ��������д��
  insert into MCSEGMENTINFOFULLGS
    (SEGMENTFULLID,
     PROCESSINGID,
     ROUTESTATE,
     SEGMENTID,
     ROUTEID,
     SUBROUTEID,
     SEGMENTNAME,
     RUNDIRECTION,
     FSTSENDTIME,
     LSTSENDTIME,
     SNGMILE,
     SNGTIME,
     OFFSETPOS,
     OFFSETNEG,
     FSTSTATIONID,
     LSTSTATIONID,
     MEMOS,
     SUBROUTENAME,
     CREATED,
     CREATEBY,
     UPDATED,
     UPDATEBY,
     ISACTIVE,
     ISSECONDDAY,
     FLAG,
     CTRLROOMADD,
     CTRLROOMTEL,
     STATIONNUM,
     DEFAULTSEQNUM,
     RETAIN1,
     RETAIN2,
     RETAIN3,
     RETAIN4,
     RETAIN5,
     RETAIN6,
     RETAIN7,
     RETAIN8,
     RETAIN9,
     RETAIN10,
     VERNUM,
     GPSMILE,
     OFFSETGPSMILE)
    select SEGMENTID,
           v_processingid,
           '2',
           SEGMENTID,
           ROUTEID,
           SUBROUTEID,
           SEGMENTNAME,
           RUNDIRECTION,
           FSTSENDTIME,
           LSTSENDTIME,
           SNGMILE,
           SNGTIME,
           OFFSETPOS,
           OFFSETNEG,
           FSTSTATIONID,
           LSTSTATIONID,
           MEMOS,
           SUBROUTENAME,
           CREATED,
           CREATEBY,
           UPDATED,
           UPDATEBY,
           ISACTIVE,
           ISSECONDDAY,
           FLAG,
           CTRLROOMADD,
           CTRLROOMTEL,
           STATIONNUM,
           DEFAULTSEQNUM,
           RETAIN1,
           RETAIN2,
           RETAIN3,
           RETAIN4,
           RETAIN5,
           RETAIN6,
           RETAIN7,
           RETAIN8,
           RETAIN9,
           RETAIN10,
           0,
           GPSMILE,
           OFFSETGPSMILE
      from MCSEGMENTINFOGS
     where ROUTEID = v_routeid;
  -- ��·վ���ϵȫ��������д��
  insert into MCRROUTESTATIONFULLGS
    (RROUTESFULLID,
     PROCESSINGID,
     ROUTESTATE,
     ROUTEID,
     STATIONID,
     DUALSERIALID)
    select RROUTESID, v_processingid, '2', ROUTEID, STATIONID, DUALSERIALID
      from MCRROUTESTATIONGS
     where ROUTEID = v_routeid;
  -- ������վ���ϵȫ��������д��
  insert into MCRSEGMENTSTATIONFULLGS
    (RSEGMENTSFULLID,
     PROCESSINGID,
     ROUTESTATE,
     ROUTEID,
     SUBROUTEID,
     SEGMENTID,
     STATIONID,
     SNGSERIALID,
     STATIONTYPEID,
     STATIONTYPENAME,
     DUALSERIALID,
     HASELECBOARD,
     SUBCOMMID,
     DISTANCE,
     PREDISTANCE,
     PRETIME,
     CARRYRATE,
     RECDATE,
     ISPREDICT,
     STATIONNAME,
     ONHOURTIME,
     MINSTOPTIME,
     MAXSTOPTIME,
     OVERSPEEDSTD,
     ARRIVESHOW,
     LEAVESHOW,
     SBOARDID,
     FSTSENDTIME,
     LSTSENDTIME,
     CREATED,
     CREATEBY,
     UPDATED,
     UPDATEBY,
     ISACTIVE,
     FLAG,
     DEFAULTTIME,
     GPSDISTANCE)
    select RSEGMENTSID,
           v_processingid,
           '2',
           ROUTEID,
           SUBROUTEID,
           SEGMENTID,
           STATIONID,
           SNGSERIALID,
           STATIONTYPEID,
           STATIONTYPENAME,
           DUALSERIALID,
           HASELECBOARD,
           SUBCOMMID,
           DISTANCE,
           PREDISTANCE,
           PRETIME,
           CARRYRATE,
           RECDATE,
           ISPREDICT,
           STATIONNAME,
           ONHOURTIME,
           MINSTOPTIME,
           MAXSTOPTIME,
           OVERSPEEDSTD,
           ARRIVESHOW,
           LEAVESHOW,
           SBOARDID,
           FSTSENDTIME,
           LSTSENDTIME,
           CREATED,
           CREATEBY,
           UPDATED,
           UPDATEBY,
           ISACTIVE,
           FLAG,
           DEFAULTTIME,
           GPSDISTANCE
      from MCRSEGMENTSTATIONGS
     where ROUTEID = v_routeid;
  -- ��������·��Ӧ��ϵȫ��������д��
  insert into ASGNRBUSROUTEFULLLD
    (RBUSRFULLID,
     PROCESSINGID,
     ROUTESTATE,
     BUSID,
     ROUTEID,
     RECDATE,
     TASKTYPE)
    select RBUSRID, v_processingid, '2', BUSID, ROUTEID, RECDATE, TASKTYPE
      from ASGNRBUSROUTELD
     where ROUTEID = v_routeid;
  -- ��Ա��·��Ӧȫ��������д��
  insert into ASGNREMPROUTEFULLLD
    (REMPRFULLID,
     PROCESSINGID,
     ROUTESTATE,
     EMPID,
     ROUTEID,
     RECDATE,
     TASKTYPE)
    select REMPRID, v_processingid, '2', EMPID, ROUTEID, RECDATE, TASKTYPE
      from ASGNREMPROUTELD
     where ROUTEID = v_routeid;
  -- ��Ա������Ӧȫ��������д��
  insert into ASGNRBUSEMPFULLLD
    (RBUSEMPFULLID,
     PROCESSINGID,
     ROUTESTATE,
     BUSID,
     EMPID,
     ROUTEID,
     RECDATE,
     EMPORDER)
    select RBUSEMPID,
           v_processingid,
           '2',
           BUSID,
           EMPID,
           ROUTEID,
           RECDATE,
           EMPORDER
      from ASGNRBUSEMPLD
     where ROUTEID = v_routeid;
  COMMIT;
end P_ROUTEINFOFULL_INIT;
/

prompt
prompt Creating procedure P_ROUTE_PREPROCESSING_PROCESS
prompt ================================================
prompt
create or replace procedure aptspzh.P_ROUTE_PREPROCESSING_PROCESS is
  /***********************************************************************************
  ���ƣ�P_ROUTE_PREPROCESSING_PROCESS
  ��;����·Ԥ��ִ��
  �������·Ԥ�ű�MCROUTEPREPROCESSINGINFOGS
          ��·��Ϣȫ���ڱ�MCROUTEINFOFULLGS
          ����·��Ϣȫ���ڱ�MCSUBROUTEINFOFULLGS
          ������Ϣȫ���ڱ�MCSEGMENTINFOFULLGS
          ��·վ���ϵȫ���ڱ�MCRROUTESTATIONFULLGS
          ������վ���ϵȫ���ڱ�MCRSEGMENTSTATIONFULLGS
          ��������·��Ӧ��ϵȫ���ڱ�ASGNRBUSROUTEFULLLD
          ��Ա��·��Ӧȫ���ڱ�ASGNREMPROUTEFULLLD
          ��Ա������Ӧȫ���ڱ�ASGNRBUSEMPFULLLD
          ��·��Ϣ��MCROUTEINFOGS
          ����·��Ϣ��MCSUBROUTEINFOGS
          ������·��Ϣ��MCSEGMENTINFOGS
          ��·վ���ϵ��MCRROUTESTATIONGS
          ������·��վ���ϵ��MCRSEGMENTSTATIONGS
          ��������·��Ӧ��ϵ��ASGNRBUSROUTELD
          ��Ա��·��Ӧ��ASGNREMPROUTELD
          ��Ա������Ӧ��ϵ��ASGNRBUSEMPLD
          ��֯��·��ϵ��MCRORGROUTEGS
  ***********************************************************************************/
  V_COUNT NUMBER := 0;
  TYPE T_CURSOR IS REF CURSOR;
  CUR_ROUTEPREPROCESSING T_CURSOR;
  V_PROCESSINGID         VARCHAR2(20);
  V_ROUTEID              VARCHAR2(20);
  V_ORGID                VARCHAR2(20);
  V_CHANGETYPE           CHAR(1);
  V_RECOVERPROCESSINGID  VARCHAR2(20);
BEGIN
  -- ��ѯ�Ƿ����δִ�е���ЧԤ�ż�¼
  SELECT COUNT(1)
    INTO V_COUNT
    FROM MCROUTEPREPROCESSINGINFOGS
   WHERE TRUNC(RUNDATE) = TRUNC(SYSDATE)
     AND INSTANCEID IS NOT NULL
     AND STATUS = '5'
     AND ISOBSOLETE <> '1';
  --1 ����δִ�е���ЧԤ�ż�¼ʱ
  IF V_COUNT > 0 THEN
    BEGIN
      --OPEN CUR_ROUTEPREPROCESSING
      OPEN CUR_ROUTEPREPROCESSING FOR
        SELECT PROCESSINGID,
               ROUTEPREPROCESSINGINFO.ROUTEID,
               ROUTEPREPROCESSINGINFO.ORGID,
               ROUTEPREPROCESSINGINFO.CHANGETYPE
          FROM MCROUTEPREPROCESSINGINFOGS ROUTEPREPROCESSINGINFO
         WHERE TRUNC(RUNDATE) = TRUNC(SYSDATE)
           AND INSTANCEID IS NOT NULL
           AND STATUS = '5'
           AND ISOBSOLETE <> '1';
      LOOP
        FETCH CUR_ROUTEPREPROCESSING
          INTO V_PROCESSINGID, V_ROUTEID, V_ORGID, V_CHANGETYPE;
        BEGIN
          --1.1 �жϵ������ͣ���Ϊ��ʱ����ʱ
          --����ʱ���ߵĻָ���¼��·��Ϣд���Ӧ��·ȫ������Ϣ������ȫ����״̬дΪ2��������ݣ�
          IF V_CHANGETYPE = '2' THEN
            --1.1.1 ��ȡ�ָ���¼��Ӧ��Ԥ�ű�����ID
            SELECT PROCESSINGID
              INTO V_RECOVERPROCESSINGID
              FROM MCROUTEPREPROCESSINGINFOGS
             WHERE TEMPCHANGEID = V_PROCESSINGID;
            --1.1.2 д��ָ���¼��Ӧ��ȫ������Ϣ
            IF V_RECOVERPROCESSINGID IS NOT NULL THEN
              -- ɾ����·��Ϣȫ���ڱ�MCROUTEINFOFULLGS��ԭ����
              DELETE FROM MCROUTEINFOFULLGS ROUTEFULL
               WHERE ROUTEFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND ROUTEFULL.ROUTESTATE = '2';
              -- ɾ������·��Ϣȫ���ڱ�MCSUBROUTEINFOFULLGS��ԭ����
              DELETE FROM MCSUBROUTEINFOFULLGS SUBROUTEFULL
               WHERE SUBROUTEFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND SUBROUTEFULL.ROUTESTATE = '2';
              -- ɾ��������Ϣȫ���ڱ�MCSEGMENTINFOFULLGS��ԭ����
              DELETE FROM MCSEGMENTINFOFULLGS SEGFULL
               WHERE SEGFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND SEGFULL.ROUTESTATE = '2';
              -- ɾ����·վ���ϵȫ���ڱ�MCRROUTESTATIONFULLGS��ԭ����
              DELETE FROM MCRROUTESTATIONFULLGS RROUTESTATIONFULL
               WHERE RROUTESTATIONFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND RROUTESTATIONFULL.ROUTESTATE = '2';
              -- ɾ��������վ���ϵȫ���ڱ�MCRSEGMENTSTATIONFULLGS��ԭ����
              DELETE FROM MCRSEGMENTSTATIONFULLGS RSEGSTATIONFULL
               WHERE RSEGSTATIONFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND RSEGSTATIONFULL.ROUTESTATE = '2';
              -- ɾ����������·��Ӧ��ϵȫ���ڱ�ASGNRBUSROUTEFULLLD��ԭ����
              DELETE FROM ASGNRBUSROUTEFULLLD RBUSROUTEFULL
               WHERE RBUSROUTEFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND RBUSROUTEFULL.ROUTESTATE = '2';
              -- ɾ����Ա��·��Ӧȫ���ڱ�ASGNREMPROUTEFULLLD��ԭ����
              DELETE FROM ASGNREMPROUTEFULLLD REMPROUTEFULL
               WHERE REMPROUTEFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND REMPROUTEFULL.ROUTESTATE = '2';
              -- ɾ����Ա������Ӧȫ���ڱ�ASGNRBUSEMPFULLLD��ԭ����
              DELETE FROM ASGNRBUSEMPFULLLD RBUSEMPFULL
               WHERE RBUSEMPFULL.PROCESSINGID = V_RECOVERPROCESSINGID
                 AND RBUSEMPFULL.ROUTESTATE = '2';
              COMMIT;
              -- ��·��Ϣȫ��������д��
              INSERT INTO MCROUTEINFOFULLGS
                (ROUTEFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 ROUTEID,
                 ROUTENAME,
                 ROUTETYPE,
                 ISCONDUCTOR,
                 DISPATCHWAY,
                 MEMOS,
                 OILSTDMILE,
                 SERVICESTDMILE,
                 MAINTAINSTDMILE,
                 INOUTSTDMILE,
                 CREATED,
                 CREATEBY,
                 UPDATED,
                 UPDATEBY,
                 ISACTIVE,
                 ROUTECODE,
                 FLAG,
                 ORGID,
                 OFFSETPOS,
                 OFFSETNEG,
                 ROUTEOWEND,
                 FSTADATE,
                 STARTDATE,
                 ENDDATE,
                 TICKETTYPE,
                 ICCARD,
                 RUNS,
                 HOTVALUE,
                 NORMALVALUE,
                 COOLVALUE,
                 CTRLROOMADD,
                 CTRLROOMTEL,
                 STATIONNUM,
                 FALSEROUTETYPE,
                 TICKETPRICE,
                 VERNUM,
                 RETAIN1,
                 RETAIN2,
                 RETAIN3,
                 RETAIN4,
                 RETAIN5,
                 RETAIN6,
                 RETAIN7,
                 RETAIN8,
                 RETAIN9,
                 RETAIN10,
                 AIRTICKET,
                 TICKET,
                 BUSNUMBER)
                SELECT ROUTEID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       ROUTEID,
                       ROUTENAME,
                       ROUTETYPE,
                       ISCONDUCTOR,
                       DISPATCHWAY,
                       MEMOS,
                       OILSTDMILE,
                       SERVICESTDMILE,
                       MAINTAINSTDMILE,
                       INOUTSTDMILE,
                       CREATED,
                       CREATEBY,
                       UPDATED,
                       UPDATEBY,
                       ISACTIVE,
                       ROUTECODE,
                       FLAG,
                       ORGID,
                       OFFSETPOS,
                       OFFSETNEG,
                       ROUTEOWEND,
                       FSTADATE,
                       STARTDATE,
                       ENDDATE,
                       TICKETTYPE,
                       ICCARD,
                       RUNS,
                       HOTVALUE,
                       NORMALVALUE,
                       COOLVALUE,
                       CTRLROOMADD,
                       CTRLROOMTEL,
                       STATIONNUM,
                       FALSEROUTETYPE,
                       TICKETPRICE,
                       0,
                       RETAIN1,
                       RETAIN2,
                       RETAIN3,
                       RETAIN4,
                       RETAIN5,
                       RETAIN6,
                       RETAIN7,
                       RETAIN8,
                       RETAIN9,
                       RETAIN10,
                       AIRTICKET,
                       TICKET,
                       BUSNUMBER
                  FROM MCROUTEINFOGS
                 WHERE ROUTEID = V_ROUTEID;
              -- ����·��Ϣȫ��������д��
              INSERT INTO MCSUBROUTEINFOFULLGS
                (SUBROUTEFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 SUBROUTEID,
                 ROUTEID,
                 SUBROUTENAME,
                 MEDIAROUTENAME,
                 MEMOS,
                 ROUTENETLENGTH,
                 ISMAINSUB,
                 SHOWFLAG,
                 UPDATED,
                 UPDATEBY,
                 CREATED,
                 CREATEBY,
                 ISACTIVE,
                 FLAG,
                 STARTDATE,
                 ENDDATE,
                 VERNUM,
                 RETAIN1,
                 RETAIN2,
                 RETAIN3,
                 RETAIN4,
                 RETAIN5,
                 RETAIN6,
                 RETAIN7,
                 RETAIN8,
                 RETAIN9,
                 RETAIN10)
                SELECT SUBROUTEID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       SUBROUTEID,
                       ROUTEID,
                       SUBROUTENAME,
                       MEDIAROUTENAME,
                       MEMOS,
                       ROUTENETLENGTH,
                       ISMAINSUB,
                       SHOWFLAG,
                       UPDATED,
                       UPDATEBY,
                       CREATED,
                       CREATEBY,
                       ISACTIVE,
                       FLAG,
                       STARTDATE,
                       ENDDATE,
                       0,
                       RETAIN1,
                       RETAIN2,
                       RETAIN3,
                       RETAIN4,
                       RETAIN5,
                       RETAIN6,
                       RETAIN7,
                       RETAIN8,
                       RETAIN9,
                       RETAIN10
                  FROM MCSUBROUTEINFOGS
                 WHERE ROUTEID = V_ROUTEID;
              -- ������Ϣȫ��������д��
              INSERT INTO MCSEGMENTINFOFULLGS
                (SEGMENTFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 SEGMENTID,
                 ROUTEID,
                 SUBROUTEID,
                 SEGMENTNAME,
                 RUNDIRECTION,
                 FSTSENDTIME,
                 LSTSENDTIME,
                 SNGMILE,
                 SNGTIME,
                 OFFSETPOS,
                 OFFSETNEG,
                 FSTSTATIONID,
                 LSTSTATIONID,
                 MEMOS,
                 SUBROUTENAME,
                 CREATED,
                 CREATEBY,
                 UPDATED,
                 UPDATEBY,
                 ISACTIVE,
                 ISSECONDDAY,
                 FLAG,
                 CTRLROOMADD,
                 CTRLROOMTEL,
                 STATIONNUM,
                 DEFAULTSEQNUM,
                 RETAIN1,
                 RETAIN2,
                 RETAIN3,
                 RETAIN4,
                 RETAIN5,
                 RETAIN6,
                 RETAIN7,
                 RETAIN8,
                 RETAIN9,
                 RETAIN10,
                 VERNUM,
                 GPSMILE,
                 OFFSETGPSMILE)
                SELECT SEGMENTID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       SEGMENTID,
                       ROUTEID,
                       SUBROUTEID,
                       SEGMENTNAME,
                       RUNDIRECTION,
                       FSTSENDTIME,
                       LSTSENDTIME,
                       SNGMILE,
                       SNGTIME,
                       OFFSETPOS,
                       OFFSETNEG,
                       FSTSTATIONID,
                       LSTSTATIONID,
                       MEMOS,
                       SUBROUTENAME,
                       CREATED,
                       CREATEBY,
                       UPDATED,
                       UPDATEBY,
                       ISACTIVE,
                       ISSECONDDAY,
                       FLAG,
                       CTRLROOMADD,
                       CTRLROOMTEL,
                       STATIONNUM,
                       DEFAULTSEQNUM,
                       RETAIN1,
                       RETAIN2,
                       RETAIN3,
                       RETAIN4,
                       RETAIN5,
                       RETAIN6,
                       RETAIN7,
                       RETAIN8,
                       RETAIN9,
                       RETAIN10,
                       0,
                       GPSMILE,
                       OFFSETGPSMILE
                  FROM MCSEGMENTINFOGS
                 WHERE ROUTEID = V_ROUTEID;
              -- ��·վ���ϵȫ��������д��
              INSERT INTO MCRROUTESTATIONFULLGS
                (RROUTESFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 ROUTEID,
                 STATIONID,
                 DUALSERIALID)
                SELECT RROUTESID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       ROUTEID,
                       STATIONID,
                       DUALSERIALID
                  FROM MCRROUTESTATIONGS
                 WHERE ROUTEID = V_ROUTEID;
              -- ������վ���ϵȫ��������д��
              INSERT INTO MCRSEGMENTSTATIONFULLGS
                (RSEGMENTSFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 ROUTEID,
                 SUBROUTEID,
                 SEGMENTID,
                 STATIONID,
                 SNGSERIALID,
                 STATIONTYPEID,
                 STATIONTYPENAME,
                 DUALSERIALID,
                 HASELECBOARD,
                 SUBCOMMID,
                 DISTANCE,
                 PREDISTANCE,
                 PRETIME,
                 CARRYRATE,
                 RECDATE,
                 ISPREDICT,
                 STATIONNAME,
                 ONHOURTIME,
                 MINSTOPTIME,
                 MAXSTOPTIME,
                 OVERSPEEDSTD,
                 ARRIVESHOW,
                 LEAVESHOW,
                 SBOARDID,
                 FSTSENDTIME,
                 LSTSENDTIME,
                 CREATED,
                 CREATEBY,
                 UPDATED,
                 UPDATEBY,
                 ISACTIVE,
                 FLAG,
                 DEFAULTTIME,
                 GPSDISTANCE)
                SELECT RSEGMENTSID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       ROUTEID,
                       SUBROUTEID,
                       SEGMENTID,
                       STATIONID,
                       SNGSERIALID,
                       STATIONTYPEID,
                       STATIONTYPENAME,
                       DUALSERIALID,
                       HASELECBOARD,
                       SUBCOMMID,
                       DISTANCE,
                       PREDISTANCE,
                       PRETIME,
                       CARRYRATE,
                       RECDATE,
                       ISPREDICT,
                       STATIONNAME,
                       ONHOURTIME,
                       MINSTOPTIME,
                       MAXSTOPTIME,
                       OVERSPEEDSTD,
                       ARRIVESHOW,
                       LEAVESHOW,
                       SBOARDID,
                       FSTSENDTIME,
                       LSTSENDTIME,
                       CREATED,
                       CREATEBY,
                       UPDATED,
                       UPDATEBY,
                       ISACTIVE,
                       FLAG,
                       DEFAULTTIME,
                       GPSDISTANCE
                  FROM MCRSEGMENTSTATIONGS
                 WHERE ROUTEID = V_ROUTEID;
              -- ��������·��Ӧ��ϵȫ��������д��
              INSERT INTO ASGNRBUSROUTEFULLLD
                (RBUSRFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 BUSID,
                 ROUTEID,
                 RECDATE,
                 TASKTYPE)
                SELECT RBUSRID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       BUSID,
                       ROUTEID,
                       RECDATE,
                       TASKTYPE
                  FROM ASGNRBUSROUTELD
                 WHERE ROUTEID = V_ROUTEID;
              -- ��Ա��·��Ӧȫ��������д��
              INSERT INTO ASGNREMPROUTEFULLLD
                (REMPRFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 EMPID,
                 ROUTEID,
                 RECDATE,
                 TASKTYPE)
                SELECT REMPRID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       EMPID,
                       ROUTEID,
                       RECDATE,
                       TASKTYPE
                  FROM ASGNREMPROUTELD
                 WHERE ROUTEID = V_ROUTEID;
              -- ��Ա������Ӧȫ��������д��
              INSERT INTO ASGNRBUSEMPFULLLD
                (RBUSEMPFULLID,
                 PROCESSINGID,
                 ROUTESTATE,
                 BUSID,
                 EMPID,
                 ROUTEID,
                 RECDATE,
                 EMPORDER)
                SELECT RBUSEMPID,
                       V_RECOVERPROCESSINGID,
                       '2',
                       BUSID,
                       EMPID,
                       ROUTEID,
                       RECDATE,
                       EMPORDER
                  FROM ASGNRBUSEMPLD
                 WHERE ROUTEID = V_ROUTEID;
            END IF;
          END IF;
          COMMIT;
          --1.2 ��ԭ��·�����Ϣд���Ӧȫ������Ϣ������ȫ����״̬дΪ0����ʷ���ݣ�
          -- ɾ����·��Ϣȫ���ڱ�MCROUTEINFOFULLGS��ԭ����
          DELETE FROM MCROUTEINFOFULLGS ROUTEFULL
           WHERE ROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND ROUTEFULL.ROUTESTATE = '0';
          -- ɾ������·��Ϣȫ���ڱ�MCSUBROUTEINFOFULLGS��ԭ����
          DELETE FROM MCSUBROUTEINFOFULLGS SUBROUTEFULL
           WHERE SUBROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND SUBROUTEFULL.ROUTESTATE = '0';
          -- ɾ��������Ϣȫ���ڱ�MCSEGMENTINFOFULLGS��ԭ����
          DELETE FROM MCSEGMENTINFOFULLGS SEGFULL
           WHERE SEGFULL.PROCESSINGID = V_PROCESSINGID
             AND SEGFULL.ROUTESTATE = '0';
          -- ɾ����·վ���ϵȫ���ڱ�MCRROUTESTATIONFULLGS��ԭ����
          DELETE FROM MCRROUTESTATIONFULLGS RROUTESTATIONFULL
           WHERE RROUTESTATIONFULL.PROCESSINGID = V_PROCESSINGID
             AND RROUTESTATIONFULL.ROUTESTATE = '0';
          -- ɾ��������վ���ϵȫ���ڱ�MCRSEGMENTSTATIONFULLGS��ԭ����
          DELETE FROM MCRSEGMENTSTATIONFULLGS RSEGSTATIONFULL
           WHERE RSEGSTATIONFULL.PROCESSINGID = V_PROCESSINGID
             AND RSEGSTATIONFULL.ROUTESTATE = '0';
          -- ɾ����������·��Ӧ��ϵȫ���ڱ�ASGNRBUSROUTEFULLLD��ԭ����
          DELETE FROM ASGNRBUSROUTEFULLLD RBUSROUTEFULL
           WHERE RBUSROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND RBUSROUTEFULL.ROUTESTATE = '0';
          -- ɾ����Ա��·��Ӧȫ���ڱ�ASGNREMPROUTEFULLLD��ԭ����
          DELETE FROM ASGNREMPROUTEFULLLD REMPROUTEFULL
           WHERE REMPROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND REMPROUTEFULL.ROUTESTATE = '0';
          -- ɾ����Ա������Ӧȫ���ڱ�ASGNRBUSEMPFULLLD��ԭ����
          DELETE FROM ASGNRBUSEMPFULLLD RBUSEMPFULL
           WHERE RBUSEMPFULL.PROCESSINGID = V_PROCESSINGID
             AND RBUSEMPFULL.ROUTESTATE = '0';
          COMMIT;
          -- ��·��Ϣȫ��������д��
          INSERT INTO MCROUTEINFOFULLGS
            (ROUTEFULLID,
             PROCESSINGID,
             ROUTESTATE,
             ROUTEID,
             ROUTENAME,
             ROUTETYPE,
             ISCONDUCTOR,
             DISPATCHWAY,
             MEMOS,
             OILSTDMILE,
             SERVICESTDMILE,
             MAINTAINSTDMILE,
             INOUTSTDMILE,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             ROUTECODE,
             FLAG,
             ORGID,
             OFFSETPOS,
             OFFSETNEG,
             ROUTEOWEND,
             FSTADATE,
             STARTDATE,
             ENDDATE,
             TICKETTYPE,
             ICCARD,
             RUNS,
             HOTVALUE,
             NORMALVALUE,
             COOLVALUE,
             CTRLROOMADD,
             CTRLROOMTEL,
             STATIONNUM,
             FALSEROUTETYPE,
             TICKETPRICE,
             VERNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10,
             AIRTICKET,
             TICKET,
             BUSNUMBER)
            SELECT ROUTEID,
                   V_PROCESSINGID,
                   '0',
                   ROUTEID,
                   ROUTENAME,
                   ROUTETYPE,
                   ISCONDUCTOR,
                   DISPATCHWAY,
                   MEMOS,
                   OILSTDMILE,
                   SERVICESTDMILE,
                   MAINTAINSTDMILE,
                   INOUTSTDMILE,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   ROUTECODE,
                   FLAG,
                   ORGID,
                   OFFSETPOS,
                   OFFSETNEG,
                   ROUTEOWEND,
                   FSTADATE,
                   STARTDATE,
                   ENDDATE,
                   TICKETTYPE,
                   ICCARD,
                   RUNS,
                   HOTVALUE,
                   NORMALVALUE,
                   COOLVALUE,
                   CTRLROOMADD,
                   CTRLROOMTEL,
                   STATIONNUM,
                   FALSEROUTETYPE,
                   TICKETPRICE,
                   VERNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10,
                   AIRTICKET,
                   TICKET,
                   BUSNUMBER
              FROM MCROUTEINFOGS
             WHERE ROUTEID = V_ROUTEID;
          -- ����·��Ϣȫ��������д��
          INSERT INTO MCSUBROUTEINFOFULLGS
            (SUBROUTEFULLID,
             PROCESSINGID,
             ROUTESTATE,
             SUBROUTEID,
             ROUTEID,
             SUBROUTENAME,
             MEDIAROUTENAME,
             MEMOS,
             ROUTENETLENGTH,
             ISMAINSUB,
             SHOWFLAG,
             UPDATED,
             UPDATEBY,
             CREATED,
             CREATEBY,
             ISACTIVE,
             FLAG,
             STARTDATE,
             ENDDATE,
             VERNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10)
            SELECT SUBROUTEID,
                   V_PROCESSINGID,
                   '0',
                   SUBROUTEID,
                   ROUTEID,
                   SUBROUTENAME,
                   MEDIAROUTENAME,
                   MEMOS,
                   ROUTENETLENGTH,
                   ISMAINSUB,
                   SHOWFLAG,
                   UPDATED,
                   UPDATEBY,
                   CREATED,
                   CREATEBY,
                   ISACTIVE,
                   FLAG,
                   STARTDATE,
                   ENDDATE,
                   VERNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10
              FROM MCSUBROUTEINFOGS
             WHERE ROUTEID = V_ROUTEID;
          -- ������Ϣȫ��������д��
          INSERT INTO MCSEGMENTINFOFULLGS
            (SEGMENTFULLID,
             PROCESSINGID,
             ROUTESTATE,
             SEGMENTID,
             ROUTEID,
             SUBROUTEID,
             SEGMENTNAME,
             RUNDIRECTION,
             FSTSENDTIME,
             LSTSENDTIME,
             SNGMILE,
             SNGTIME,
             OFFSETPOS,
             OFFSETNEG,
             FSTSTATIONID,
             LSTSTATIONID,
             MEMOS,
             SUBROUTENAME,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             ISSECONDDAY,
             FLAG,
             CTRLROOMADD,
             CTRLROOMTEL,
             STATIONNUM,
             DEFAULTSEQNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10,
             VERNUM,
             GPSMILE,
             OFFSETGPSMILE)
            SELECT SEGMENTID,
                   V_PROCESSINGID,
                   '0',
                   SEGMENTID,
                   ROUTEID,
                   SUBROUTEID,
                   SEGMENTNAME,
                   RUNDIRECTION,
                   FSTSENDTIME,
                   LSTSENDTIME,
                   SNGMILE,
                   SNGTIME,
                   OFFSETPOS,
                   OFFSETNEG,
                   FSTSTATIONID,
                   LSTSTATIONID,
                   MEMOS,
                   SUBROUTENAME,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   ISSECONDDAY,
                   FLAG,
                   CTRLROOMADD,
                   CTRLROOMTEL,
                   STATIONNUM,
                   DEFAULTSEQNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10,
                   VERNUM,
                   GPSMILE,
                   OFFSETGPSMILE
              FROM MCSEGMENTINFOGS
             WHERE ROUTEID = V_ROUTEID;
          -- ��·վ���ϵȫ��������д��
          INSERT INTO MCRROUTESTATIONFULLGS
            (RROUTESFULLID,
             PROCESSINGID,
             ROUTESTATE,
             ROUTEID,
             STATIONID,
             DUALSERIALID)
            SELECT RROUTESID,
                   V_PROCESSINGID,
                   '0',
                   ROUTEID,
                   STATIONID,
                   DUALSERIALID
              FROM MCRROUTESTATIONGS
             WHERE ROUTEID = V_ROUTEID;
          -- ������վ���ϵȫ��������д��
          INSERT INTO MCRSEGMENTSTATIONFULLGS
            (RSEGMENTSFULLID,
             PROCESSINGID,
             ROUTESTATE,
             ROUTEID,
             SUBROUTEID,
             SEGMENTID,
             STATIONID,
             SNGSERIALID,
             STATIONTYPEID,
             STATIONTYPENAME,
             DUALSERIALID,
             HASELECBOARD,
             SUBCOMMID,
             DISTANCE,
             PREDISTANCE,
             PRETIME,
             CARRYRATE,
             RECDATE,
             ISPREDICT,
             STATIONNAME,
             ONHOURTIME,
             MINSTOPTIME,
             MAXSTOPTIME,
             OVERSPEEDSTD,
             ARRIVESHOW,
             LEAVESHOW,
             SBOARDID,
             FSTSENDTIME,
             LSTSENDTIME,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             FLAG,
             DEFAULTTIME,
             GPSDISTANCE)
            SELECT RSEGMENTSID,
                   V_PROCESSINGID,
                   '0',
                   ROUTEID,
                   SUBROUTEID,
                   SEGMENTID,
                   STATIONID,
                   SNGSERIALID,
                   STATIONTYPEID,
                   STATIONTYPENAME,
                   DUALSERIALID,
                   HASELECBOARD,
                   SUBCOMMID,
                   DISTANCE,
                   PREDISTANCE,
                   PRETIME,
                   CARRYRATE,
                   RECDATE,
                   ISPREDICT,
                   STATIONNAME,
                   ONHOURTIME,
                   MINSTOPTIME,
                   MAXSTOPTIME,
                   OVERSPEEDSTD,
                   ARRIVESHOW,
                   LEAVESHOW,
                   SBOARDID,
                   FSTSENDTIME,
                   LSTSENDTIME,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   FLAG,
                   DEFAULTTIME,
                   GPSDISTANCE
              FROM MCRSEGMENTSTATIONGS
             WHERE ROUTEID = V_ROUTEID;
          -- ��������·��Ӧ��ϵȫ��������д��
          INSERT INTO ASGNRBUSROUTEFULLLD
            (RBUSRFULLID,
             PROCESSINGID,
             ROUTESTATE,
             BUSID,
             ROUTEID,
             RECDATE,
             TASKTYPE)
            SELECT RBUSRID,
                   V_PROCESSINGID,
                   '0',
                   BUSID,
                   ROUTEID,
                   RECDATE,
                   TASKTYPE
              FROM ASGNRBUSROUTELD
             WHERE ROUTEID = V_ROUTEID;
          -- ��Ա��·��Ӧȫ��������д��
          INSERT INTO ASGNREMPROUTEFULLLD
            (REMPRFULLID,
             PROCESSINGID,
             ROUTESTATE,
             EMPID,
             ROUTEID,
             RECDATE,
             TASKTYPE)
            SELECT REMPRID,
                   V_PROCESSINGID,
                   '0',
                   EMPID,
                   ROUTEID,
                   RECDATE,
                   TASKTYPE
              FROM ASGNREMPROUTELD
             WHERE ROUTEID = V_ROUTEID;
          -- ��Ա������Ӧȫ��������д��
          INSERT INTO ASGNRBUSEMPFULLLD
            (RBUSEMPFULLID,
             PROCESSINGID,
             ROUTESTATE,
             BUSID,
             EMPID,
             ROUTEID,
             RECDATE,
             EMPORDER)
            SELECT RBUSEMPID,
                   V_PROCESSINGID,
                   '0',
                   BUSID,
                   EMPID,
                   ROUTEID,
                   RECDATE,
                   EMPORDER
              FROM ASGNRBUSEMPLD
             WHERE ROUTEID = V_ROUTEID;
          COMMIT;
          --1.3 ��ȫ����״̬Ϊ2��������ݣ� ����·ȫ������Ϣд���Ӧ��·�����Ϣ�����Ԥ��ִ��
          -- ɾ����·��Ϣ��MCROUTEINFOGS��ԭ����
          DELETE FROM MCROUTEINFOGS ROUTE WHERE ROUTE.ROUTEID = V_ROUTEID;
          -- ɾ������·��Ϣ��MCSUBROUTEINFOGS��ԭ����
          DELETE FROM MCSUBROUTEINFOGS SUBROUTE
           WHERE SUBROUTE.ROUTEID = V_ROUTEID;
          -- ɾ��������Ϣ��MCSEGMENTINFOGS��ԭ����
          DELETE FROM MCSEGMENTINFOGS SEG WHERE SEG.ROUTEID = V_ROUTEID;
          -- ɾ����·վ���ϵ��MCRROUTESTATIONGS��ԭ����
          DELETE FROM MCRROUTESTATIONGS RROUTESTATION
           WHERE RROUTESTATION.ROUTEID = V_ROUTEID;
          -- ɾ��������վ���ϵ��MCRSEGMENTSTATIONGS��ԭ����
          DELETE FROM MCRSEGMENTSTATIONGS RSEGSTATION
           WHERE RSEGSTATION.ROUTEID = V_ROUTEID;
          -- ɾ����������·��Ӧ��ϵ��ASGNRBUSROUTELD��ԭ����
          DELETE FROM ASGNRBUSROUTELD RBUSROUTE
           WHERE RBUSROUTE.ROUTEID = V_ROUTEID;
          -- ɾ����Ա��·��Ӧ��ASGNREMPROUTELD��ԭ����
          DELETE FROM ASGNREMPROUTELD REMPROUTE
           WHERE REMPROUTE.ROUTEID = V_ROUTEID;
          -- ɾ����Ա������Ӧ��ASGNRBUSEMPLD��ԭ����
          DELETE FROM ASGNRBUSEMPLD RBUSEMP
           WHERE RBUSEMP.ROUTEID = V_ROUTEID;
          -- ɾ����֯��·��ϵ����ԭ����
          DELETE FROM MCRORGROUTEGS RORGROUTE
           WHERE RORGROUTE.ROUTEID = V_ROUTEID
             AND RORGROUTE.ORGID = V_ORGID;
          COMMIT;
          -- ��·����д��
          INSERT INTO MCROUTEINFOGS
            (ROUTEID,
             ROUTENAME,
             ROUTETYPE,
             ISCONDUCTOR,
             DISPATCHWAY,
             MEMOS,
             OILSTDMILE,
             SERVICESTDMILE,
             MAINTAINSTDMILE,
             INOUTSTDMILE,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             ROUTECODE,
             FLAG,
             ORGID,
             OFFSETPOS,
             OFFSETNEG,
             ROUTEOWEND,
             FSTADATE,
             STARTDATE,
             ENDDATE,
             TICKETTYPE,
             ICCARD,
             RUNS,
             HOTVALUE,
             NORMALVALUE,
             COOLVALUE,
             CTRLROOMADD,
             CTRLROOMTEL,
             STATIONNUM,
             FALSEROUTETYPE,
             TICKETPRICE,
             VERNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10,
             AIRTICKET,
             TICKET,
             BUSNUMBER)
            SELECT ROUTEID,
                   ROUTENAME,
                   ROUTETYPE,
                   ISCONDUCTOR,
                   DISPATCHWAY,
                   MEMOS,
                   OILSTDMILE,
                   SERVICESTDMILE,
                   MAINTAINSTDMILE,
                   INOUTSTDMILE,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   ROUTECODE,
                   FLAG,
                   ORGID,
                   OFFSETPOS,
                   OFFSETNEG,
                   ROUTEOWEND,
                   FSTADATE,
                   STARTDATE,
                   ENDDATE,
                   TICKETTYPE,
                   ICCARD,
                   RUNS,
                   HOTVALUE,
                   NORMALVALUE,
                   COOLVALUE,
                   CTRLROOMADD,
                   CTRLROOMTEL,
                   STATIONNUM,
                   FALSEROUTETYPE,
                   TICKETPRICE,
                   VERNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10,
                   AIRTICKET,
                   TICKET,
                   BUSNUMBER
              FROM MCROUTEINFOFULLGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ����·��Ϣ����д��
          INSERT INTO MCSUBROUTEINFOGS
            (SUBROUTEID,
             ROUTEID,
             SUBROUTENAME,
             MEDIAROUTENAME,
             MEMOS,
             ROUTENETLENGTH,
             ISMAINSUB,
             SHOWFLAG,
             UPDATED,
             UPDATEBY,
             CREATED,
             CREATEBY,
             ISACTIVE,
             FLAG,
             STARTDATE,
             ENDDATE,
             VERNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10)
            SELECT SUBROUTEID,
                   ROUTEID,
                   SUBROUTENAME,
                   MEDIAROUTENAME,
                   MEMOS,
                   ROUTENETLENGTH,
                   ISMAINSUB,
                   SHOWFLAG,
                   UPDATED,
                   UPDATEBY,
                   CREATED,
                   CREATEBY,
                   ISACTIVE,
                   FLAG,
                   STARTDATE,
                   ENDDATE,
                   VERNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10
              FROM MCSUBROUTEINFOFULLGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ������Ϣ����д��
          INSERT INTO MCSEGMENTINFOGS
            (SEGMENTID,
             ROUTEID,
             SUBROUTEID,
             SEGMENTNAME,
             RUNDIRECTION,
             FSTSENDTIME,
             LSTSENDTIME,
             SNGMILE,
             SNGTIME,
             OFFSETPOS,
             OFFSETNEG,
             FSTSTATIONID,
             LSTSTATIONID,
             MEMOS,
             SUBROUTENAME,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             ISSECONDDAY,
             FLAG,
             CTRLROOMADD,
             CTRLROOMTEL,
             STATIONNUM,
             DEFAULTSEQNUM,
             RETAIN1,
             RETAIN2,
             RETAIN3,
             RETAIN4,
             RETAIN5,
             RETAIN6,
             RETAIN7,
             RETAIN8,
             RETAIN9,
             RETAIN10,
             VERNUM,
             GPSMILE,
             OFFSETGPSMILE)
            SELECT SEGMENTID,
                   ROUTEID,
                   SUBROUTEID,
                   SEGMENTNAME,
                   RUNDIRECTION,
                   FSTSENDTIME,
                   LSTSENDTIME,
                   SNGMILE,
                   SNGTIME,
                   OFFSETPOS,
                   OFFSETNEG,
                   FSTSTATIONID,
                   LSTSTATIONID,
                   MEMOS,
                   SUBROUTENAME,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   ISSECONDDAY,
                   FLAG,
                   CTRLROOMADD,
                   CTRLROOMTEL,
                   STATIONNUM,
                   DEFAULTSEQNUM,
                   RETAIN1,
                   RETAIN2,
                   RETAIN3,
                   RETAIN4,
                   RETAIN5,
                   RETAIN6,
                   RETAIN7,
                   RETAIN8,
                   RETAIN9,
                   RETAIN10,
                   VERNUM,
                   GPSMILE,
                   OFFSETGPSMILE
              FROM MCSEGMENTINFOFULLGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ��·վ���ϵ����д��
          INSERT INTO MCRROUTESTATIONGS
            (RROUTESID, ROUTEID, STATIONID, DUALSERIALID)
            SELECT RROUTESFULLID, ROUTEID, STATIONID, DUALSERIALID
              FROM MCRROUTESTATIONFULLGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ������վ���ϵ����д��
          INSERT INTO MCRSEGMENTSTATIONGS
            (RSEGMENTSID,
             ROUTEID,
             SUBROUTEID,
             SEGMENTID,
             STATIONID,
             SNGSERIALID,
             STATIONTYPEID,
             STATIONTYPENAME,
             DUALSERIALID,
             HASELECBOARD,
             SUBCOMMID,
             DISTANCE,
             PREDISTANCE,
             PRETIME,
             CARRYRATE,
             RECDATE,
             ISPREDICT,
             STATIONNAME,
             ONHOURTIME,
             MINSTOPTIME,
             MAXSTOPTIME,
             OVERSPEEDSTD,
             ARRIVESHOW,
             LEAVESHOW,
             SBOARDID,
             FSTSENDTIME,
             LSTSENDTIME,
             CREATED,
             CREATEBY,
             UPDATED,
             UPDATEBY,
             ISACTIVE,
             FLAG,
             DEFAULTTIME,
             GPSDISTANCE)
            SELECT RSEGMENTSFULLID,
                   ROUTEID,
                   SUBROUTEID,
                   SEGMENTID,
                   STATIONID,
                   SNGSERIALID,
                   STATIONTYPEID,
                   STATIONTYPENAME,
                   DUALSERIALID,
                   HASELECBOARD,
                   SUBCOMMID,
                   DISTANCE,
                   PREDISTANCE,
                   PRETIME,
                   CARRYRATE,
                   RECDATE,
                   ISPREDICT,
                   STATIONNAME,
                   ONHOURTIME,
                   MINSTOPTIME,
                   MAXSTOPTIME,
                   OVERSPEEDSTD,
                   ARRIVESHOW,
                   LEAVESHOW,
                   SBOARDID,
                   FSTSENDTIME,
                   LSTSENDTIME,
                   CREATED,
                   CREATEBY,
                   UPDATED,
                   UPDATEBY,
                   ISACTIVE,
                   FLAG,
                   DEFAULTTIME,
                   GPSDISTANCE
              FROM MCRSEGMENTSTATIONFULLGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ��������·��Ӧ��ϵ����д��
          INSERT INTO ASGNRBUSROUTELD
            (RBUSRID, BUSID, ROUTEID, RECDATE, TASKTYPE)
            SELECT RBUSRFULLID, BUSID, ROUTEID, RECDATE, TASKTYPE
              FROM ASGNRBUSROUTEFULLLD
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ��Ա��·��Ӧ����д��
          INSERT INTO ASGNREMPROUTELD
            (REMPRID, EMPID, ROUTEID, RECDATE, TASKTYPE)
            SELECT REMPRFULLID, EMPID, ROUTEID, RECDATE, TASKTYPE
              FROM ASGNREMPROUTEFULLLD
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ��Ա������Ӧ����д��
          INSERT INTO ASGNRBUSEMPLD
            (RBUSEMPID, BUSID, EMPID, ROUTEID, RECDATE, EMPORDER)
            SELECT RBUSEMPFULLID, BUSID, EMPID, ROUTEID, RECDATE, EMPORDER
              FROM ASGNRBUSEMPFULLLD
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTESTATE = '2'
               AND ROUTEID = V_ROUTEID;
          -- ��·��֯��ϵ������д��
          INSERT INTO MCRORGROUTEGS
            (RORSID, ROUTEID, ORGID)
            SELECT S_FDISDISPLANGD.NEXTVAL, ROUTEID, ORGID
              FROM MCROUTEPREPROCESSINGINFOGS
             WHERE PROCESSINGID = V_PROCESSINGID
               AND ROUTEID = V_ROUTEID;
          COMMIT;
          --1.4 �����Ԥ��ִ�е�ȫ������Ϣ��ȫ����״̬��2��������ݣ� ����Ϊ1����ǰ���ݣ�
          -- ��·��Ϣȫ���ڱ����
          UPDATE MCROUTEINFOFULLGS ROUTEFULL
             SET ROUTEFULL.ROUTESTATE = '1'
           WHERE ROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND ROUTEFULL.ROUTESTATE = '2'
             AND ROUTEFULL.ROUTEID = V_ROUTEID;
          -- ����·��Ϣȫ���ڱ����
          UPDATE MCSUBROUTEINFOFULLGS SUBROUTEFULL
             SET SUBROUTEFULL.ROUTESTATE = '1'
           WHERE SUBROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND SUBROUTEFULL.ROUTESTATE = '2'
             AND SUBROUTEFULL.ROUTEID = V_ROUTEID;
          -- ������Ϣȫ���ڱ����
          UPDATE MCSEGMENTINFOFULLGS SEGMENTFULL
             SET SEGMENTFULL.ROUTESTATE = '1'
           WHERE SEGMENTFULL.PROCESSINGID = V_PROCESSINGID
             AND SEGMENTFULL.ROUTESTATE = '2'
             AND SEGMENTFULL.ROUTEID = V_ROUTEID;
          -- ��·վ���ϵȫ���ڱ����
          UPDATE MCRROUTESTATIONFULLGS RROUTESTATIONFULL
             SET RROUTESTATIONFULL.ROUTESTATE = '1'
           WHERE RROUTESTATIONFULL.PROCESSINGID = V_PROCESSINGID
             AND RROUTESTATIONFULL.ROUTESTATE = '2'
             AND RROUTESTATIONFULL.ROUTEID = V_ROUTEID;
          -- ������վ���ϵȫ���ڱ����
          UPDATE MCRSEGMENTSTATIONFULLGS RSEGSTATIONFULL
             SET RSEGSTATIONFULL.ROUTESTATE = '1'
           WHERE RSEGSTATIONFULL.PROCESSINGID = V_PROCESSINGID
             AND RSEGSTATIONFULL.ROUTESTATE = '2'
             AND RSEGSTATIONFULL.ROUTEID = V_ROUTEID;
          -- ��������·��Ӧ��ϵȫ���ڱ����
          UPDATE ASGNRBUSROUTEFULLLD RBUSROUTEFULL
             SET RBUSROUTEFULL.ROUTESTATE = '1'
           WHERE RBUSROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND RBUSROUTEFULL.ROUTESTATE = '2'
             AND RBUSROUTEFULL.ROUTEID = V_ROUTEID;
          -- ��Ա��·��Ӧȫ���ڱ����
          UPDATE ASGNREMPROUTEFULLLD REMPROUTEFULL
             SET REMPROUTEFULL.ROUTESTATE = '1'
           WHERE REMPROUTEFULL.PROCESSINGID = V_PROCESSINGID
             AND REMPROUTEFULL.ROUTESTATE = '2'
             AND REMPROUTEFULL.ROUTEID = V_ROUTEID;
          -- ��Ա������Ӧȫ���ڱ����
          UPDATE ASGNRBUSEMPFULLLD RBUSEMPFULL
             SET RBUSEMPFULL.ROUTESTATE = '1'
           WHERE RBUSEMPFULL.PROCESSINGID = V_PROCESSINGID
             AND RBUSEMPFULL.ROUTESTATE = '2'
             AND RBUSEMPFULL.ROUTEID = V_ROUTEID;
          COMMIT;
          --1.5 ����·Ԥ�ű�MCROUTEPREPROCESSINGINFOGS״̬STATUS�ֶθ���Ϊ9��ִ����ɣ�
          UPDATE MCROUTEPREPROCESSINGINFOGS ROUTEPREPROCESSING
             SET ROUTEPREPROCESSING.STATUS = '9'
           WHERE ROUTEPREPROCESSING.PROCESSINGID = V_PROCESSINGID
             AND ROUTEPREPROCESSING.ROUTEID = V_ROUTEID;
          COMMIT;
        END;
        EXIT WHEN CUR_ROUTEPREPROCESSING%NOTFOUND;
      END LOOP;
      CLOSE CUR_ROUTEPREPROCESSING;
      --CLOSE CUR_ROUTEPREPROCESSING
    END;
  END IF;
END P_ROUTE_PREPROCESSING_PROCESS;
/

prompt
prompt Creating procedure P_SERIAL
prompt ===========================
prompt
create or replace procedure aptspzh.p_serial(v_subject IN VARCHAR2,
                                     v_sql     IN VARCHAR2,
                                     v_result  OUT NUMBER,
                                     v_sql2    IN VARCHAR2 := '') IS
  v_Message    note;
  v_MsgId      RAW(16);
  v_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
  v_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
begin
  v_Message            := note(subject    => v_subject,
                               Content    => v_sql || v_sql2,
                               createTime => sysdate);
  v_options.visibility := DBMS_AQ.IMMEDIATE;

  dbms_aq.enqueue(queue_name         => 'noteq',
                  enqueue_options    => v_options,
                  message_properties => v_properties,
                  payload            => v_Message,
                  msgid              => v_MsgId);

  v_result := 1;

  commit;

exception
  when others then
    v_result := 0;
end;
/

prompt
prompt Creating procedure P_SERIAL_ANALYZE
prompt ===================================
prompt
create or replace procedure aptspzh.p_serial_analyze IS
  v_Message    note;
  v_MsgId      RAW(16);
  v_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
  v_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
  c            INTEGER := dbms_sql.open_cursor;
  fdbk         INTEGER;
  v_count      NUMBER;
  v_count2     NUMBER;
  v_count3  NUMBER;
  v_sql        VARCHAR2(4000);
  v_start      DATE;
  v_msg        VARCHAR2(400);
  -- ����SQL����
  procedure process_queue is
  begin
    dbms_aq.dequeue(queue_name         => 'noteq',
                    dequeue_options    => v_options,
                    message_properties => v_properties,
                    payload            => v_Message,
                    msgid              => v_MsgId);

    v_sql := v_Message.content;

    dbms_sql.parse(c, v_sql, dbms_sql.native);

    fdbk := dbms_sql.execute(c);
    commit;

    --�������ã�������ִ�й���SQL���ȫ�������ad_sql3
    /*insert into ad_sql3
    values
      (fdbk, v_Message.content, default, v_Message.createTime);
    commit;
    */
    if fdbk = 0 then
      insert into ad_sql values (0, v_Message.content, default);
    end if;

  exception
    when others then
      insert into ad_sql values (-1, v_sql, default);
  end;

  -- ����SQL�쳣
  procedure process_exception is
    cursor cur_sql is
      select t.createdate, t.sql sqla, t.rowid
        from ad_sql t
       where t.id = 0 --and rownum<10000
            and t.createdate>sysdate-1/6
       order by t.createdate;
  begin
  v_count2 := 0;
  v_count3 := 0;
  for cur in cur_sql loop
    begin
      v_sql := cur.sqla;

      dbms_sql.parse(c, v_sql, dbms_sql.native);

      fdbk := dbms_sql.execute(c);
      if fdbk >= 1 or (sysdate - cur.createdate) > 1/24 then
        delete from ad_sql where rowid = cur.rowid;
      end if;
      v_count2 := v_count2 + 1;
    exception
      when others then
        update ad_sql set id = -2 where rowid = cur.rowid;
        v_count3 := v_count3 + 1;
    end;
    commit;
  end loop;

end;

begin
  v_start  := sysdate;
  v_count  := 0;
  v_count2 := 0;
  begin

    v_options.visibility := DBMS_AQ.IMMEDIATE;

    -- �Ӷ��л�ȡ��¼ִ��
    select count(1) into v_count from notetab;
    if (v_count > 2000) then
      v_count := 2000;
    end if;
    for i in 1 .. v_count loop
     process_queue;
    end loop;

    v_msg := to_char(sysdate, 'hh24:mi:ss') || '--' ||
             to_char(v_start, 'hh24:mi:ss') || '--' ||v_count || '--' ||
             round((sysdate - v_start) * 24 * 60 * 60, 3);
    insert into ad_sql values (8, v_msg, default);
    -- �����ɹ������
   process_exception;

    -- �ر��α�
    dbms_sql.close_cursor(c);

  exception
    when others then
      null;
  end;

  v_msg := to_char(sysdate, 'hh24:mi:ss') || '--' ||
           to_char(v_start, 'hh24:mi:ss') || '--' || v_count2 || '--' ||v_count3 || '--' ||
           round((sysdate - v_start) * 24 * 60 * 60, 3);
  insert into ad_sql values (9, v_msg, default);
  commit;
end;
/

prompt
prompt Creating procedure P_SETAVERAGEPRICE
prompt ====================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_SETAVERAGEPRICE(p_warehouseTeam CHAR, --�ֿ���
                                              p_year          CHAR, --�½���
                                              p_month         CHAR, --�½��·�
                                              p_qDateFrom     date, --�½Ὺʼ����
                                              p_qDateTo       date, --�½��������
                                              p_userid        CHAR, --��½��id
                                              reflg           out char) as
  /************************************************************************************************
    �����Ȩƽ���ۣ��˹��̹�WEB�������  lixiugang 2011-8-20
  ************************************************************************************************/
  v_qdatefrom      date := trunc(p_qdatefrom); --�½Ὺʼ����
  v_qdateto        date := trunc(p_qdateto); --�½��������
  v_incount        number(14, 4); --�������
  v_intotalsum     number(14, 2); --�����
  v_aveprice       number(14, 6); --��Ȩƽ����
  v_priorcount     number(14, 4); --�ڳ�����
  v_priorsumcount  number(14, 2); --�ڳ����
  v_priceaccuracy  number(1); --���ʼ۸�ȷ��
  v_outsumcount    number(14, 2); --������
  v_sumcount       number(14, 2); --��ĩ���
  v_sumcount2      number(14, 2); --ƫ���������ĩ���
  v_sumendingcount number(14, 4); --��ĩ����
  v_diff           number(14, 2); --�����
  v_materialcount  number(10, 0); --���β����漰���ʵ�������
  v_i              number(10, 0); --�Ѽ���������
  v_conditionid    varchar(20); --���ȱ�id
begin
  reflg := '0';
  v_i   := 0;
  --���㱾�β����漰����������
  select count(distinct (whdetail.materialid))
    into v_materialcount
    from mm_whmonthlyclosingmnggd     whc,
         mm_whmonthlyclosingdeatailgd whdetail
   where whc.whmonid = whdetail.whmonid
     and whc.yearnum = p_year
     and whc.monthnum = p_month
     and whc.WAREHOUSEID in
         (select rwt.warehouseid
            from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
           where rwt.warehouseid = wh.warehouseid(+)
             and wh.auditflg = '2'
             and wh.isactive = '1'
             and rwt.warehouseteamid = p_warehouseTeam);
  --������ȱ�
  select S_FDISDISPLANGD.NEXTVAL into v_conditionid from dual;
  insert into MM_LONGTASKCONDITIONGD
    (CONDITIONID,
     WAREHOUSETEAM,
     YEAR,
     MONTH,
     DATEFROM,
     DATETO,
     SUMCOUNT,
     EXCUTECOUNT,
     RESULT,
     CREATED,
     CREATEBY)
  values
    (v_conditionid,
     p_warehouseTeam,
     p_year,
     p_month,
     p_qDateFrom,
     p_qDateTo,
     v_materialcount,
     0,
     'ִ����',
     sysdate,
     p_userid);
  -- 1�����Ȩƽ���۲����³���ۺ���ĩ���
  for cur_priorsum in (select distinct (whdetail.materialid)
                         from mm_whmonthlyclosingmnggd     whc,
                              mm_whmonthlyclosingdeatailgd whdetail
                        where whc.whmonid = whdetail.whmonid
                          and whc.yearnum = p_year
                          and whc.monthnum = p_month
                          and whc.WAREHOUSEID in
                              (select rwt.warehouseid
                                 from mm_rwarehouseteamwhgd rwt,
                                      mm_warehousegd        wh
                                where rwt.warehouseid = wh.warehouseid(+)
                                  and wh.auditflg = '2'
                                  and wh.isactive = '1'
                                  and rwt.warehouseteamid = p_warehouseTeam)) loop

    -- 1.1�½��ڼ���ʵ�ֵ�һ����⡢�ɹ���⡢��װ�����ͺ��������������ͽ��
    v_incount    := 0;
    v_intotalsum := 0;
    for cur_stocksum in (select stockDetail.stockbilldetailid,
                                stockDetail.count,
                                stockDetail.Totalsum,
                                teamin.warehouseteamid teaminid,
                                teamout.warehouseteamid teamoutid,
                                stockbill.billfrom billfrom
                           from mm_stockbilldetailgd  stockDetail,
                                mm_stockbillgd        stockbill,
                                mm_warehousegd        whin,
                                mm_rwarehouseteamwhgd teamin,
                                mm_rwarehouseteamwhgd teamout
                          where stockbill.stockbillid =
                                stockDetail.stockbillid
                            and stockbill.acceptwarehouse =
                                whin.warehouseid(+)
                            and stockbill.acceptwarehouse =
                                teamin.warehouseid(+)
                            and stockbill.issuewarehouse =
                                teamout.warehouseid(+)
                            and stockbill.billdate between v_qdatefrom and
                                v_qdateto
                            and stockbill.acceptwarehouse in
                                (select rwt.warehouseid
                                   from mm_rwarehouseteamwhgd rwt,
                                        mm_warehousegd        wh
                                  where rwt.warehouseid = wh.warehouseid(+)
                                    and wh.auditflg = '2'
                                    and wh.isactive = '1'
                                    and rwt.warehouseteamid = p_warehouseTeam)
                            and whin.inited = '1'
                            and whin.isactive = '1'
                            and whin.auditflg = '2'
                            and stockbill.verifystatus = '2'
                            and stockbill.billtype = '2'
                            and stockbill.billfrom in
                                ('0', '1', '4', '6', '8')
                            and stockDetail.materialid =
                                cur_priorsum.materialid) loop

      if cur_stocksum.billfrom = '6' and
         cur_stocksum.teaminid = cur_stocksum.teamoutid then
        v_incount    := v_incount + 0;
        v_intotalsum := v_intotalsum + 0;
      else
        v_incount    := v_incount + cur_stocksum.count;
        v_intotalsum := v_intotalsum + cur_stocksum.Totalsum;
      end if;
    end loop;

    -- 1.2 �½��·ݵ��ڳ��������ڳ����
    select sum(detail.priorcount) as priorcount,
           sum(detail.priorsumcount) as priorsumcount
      into v_priorcount, v_priorsumcount
      from mm_whmonthlyclosingmnggd wc, mm_whmonthlyclosingdeatailgd detail
     where wc.whmonid = detail.whmonid
       and wc.yearnum = p_year
       and wc.monthnum = p_month
       and wc.warehouseid in
           (select rwt.warehouseid
              from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
             where rwt.warehouseid = wh.warehouseid(+)
               and wh.auditflg = '2'
               and wh.isactive = '1'
               and rwt.warehouseteamid = p_warehouseTeam)
       and detail.materialid = cur_priorsum.materialid;

    if v_priorcount is null then
      v_priorcount := 0;
    end if;

    if v_priorsumcount is null then
      v_priorsumcount := 0;
    end if;

    --1.2.2 ȡ�����ʼ۸�ȷ��
    select mat.priceaccuracy
      into v_priceaccuracy
      from mm_materialgd mat
     where mat.materialid = cur_priorsum.materialid;

    -- 1.3 ��Ȩƽ���ۼ���
    if v_incount + v_priorcount <= 0 then
      v_aveprice := 0;
    else
      v_aveprice := round((v_intotalsum + v_priorsumcount) /
                          (v_incount + v_priorcount),
                          v_priceaccuracy);

      -- 1.4�����½��ڼ��ڳ��ⵥ�����ʼ۸�
      update mm_stockbilldetailgd t
         set t.price    = v_aveprice,
             t.totalsum = t.count * v_aveprice,
             t.updated  = sysdate,
             t.updateby = p_userid
       where t.stockbilldetailid in
             (select detail.stockbilldetailid
                from mm_stockbilldetailgd detail, mm_stockbillgd stockbill
               where stockbill.stockbillid = detail.stockbillid
                 and stockbill.billdate between v_qdatefrom and v_qdateto
                 and detail.materialid = cur_priorsum.materialid
                 and stockbill.verifystatus = '2'
                 and ((stockbill.billfrom in ('1', '2', '3', '6', '5', '9') and
                     stockbill.billtype = '1') OR
                     (stockbill.billtype = '2' AND stockbill.billfrom = '6'))
                 and stockbill.billbackflag = '0'
                 and stockbill.issuewarehouse in
                     (select rwt.warehouseid
                        from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                       where rwt.warehouseid = wh.warehouseid(+)
                         and wh.auditflg = '2'
                         and wh.isactive = '1'
                         and rwt.warehouseteamid = p_warehouseTeam));
      commit;
      -- ʵ���и��ڼ���������з�ʽ�����ܽ��
      select nvl(sum(nvl(t.totalsum, 0)), 0)
        into v_outsumcount
        from mm_stockbilldetailgd t
       where t.stockbilldetailid in
             (select detail.stockbilldetailid
                from mm_stockbilldetailgd detail, mm_stockbillgd stockbill
               where stockbill.stockbillid = detail.stockbillid
                 and stockbill.billdate between v_qdatefrom and v_qdateto
                 and detail.materialid = cur_priorsum.materialid
                 and stockbill.verifystatus = '2'
                 and stockbill.issuewarehouse in
                     (select rwt.warehouseid
                        from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                       where rwt.warehouseid = wh.warehouseid(+)
                         and wh.auditflg = '2'
                         and wh.isactive = '1'
                         and rwt.warehouseteamid = p_warehouseTeam)
                 and stockbill.billfrom in ('1', '2', '3', '6', '8', '9')
                 and stockbill.billtype = '1');

      -- 1.5�����½����ĩ���ۺ���ĩ���
      update mm_whmonthlyclosingdeatailgd t
         set t.price    = v_aveprice,
             t.sumcount = t.endingcount * v_aveprice,
             t.updated  = sysdate,
             t.updateby = p_userid
       where t.whmondetailid in
             (select detail.whmondetailid
                from mm_whmonthlyclosingmnggd     wc,
                     mm_whmonthlyclosingdeatailgd detail
               where wc.whmonid = detail.whmonid
                 and wc.yearnum = p_year
                 and wc.monthnum = p_month
                 and wc.warehouseid in
                     (select rwt.warehouseid
                        from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                       where rwt.warehouseid = wh.warehouseid(+)
                         and wh.auditflg = '2'
                         and wh.isactive = '1'
                         and rwt.warehouseteamid = p_warehouseTeam)
                 and detail.materialid = cur_priorsum.materialid);
      commit;

      -- 1.5.1��������ĩ�ܽ�����ƫ�
      select sum(detail.sumcount) as sumcount
        into v_sumcount
        from mm_whmonthlyclosingmnggd     wc,
             mm_whmonthlyclosingdeatailgd detail
       where wc.whmonid = detail.whmonid
         and wc.yearnum = p_year
         and wc.monthnum = p_month
         and wc.warehouseid in
             (select rwt.warehouseid
                from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
               where rwt.warehouseid = wh.warehouseid(+)
                 and wh.auditflg = '2'
                 and wh.isactive = '1'
                 and rwt.warehouseteamid = p_warehouseTeam)
         and detail.materialid = cur_priorsum.materialid;

      -- 1.5.1��������ĩ������
      select sum(detail.endingcount) as sumendingcount
        into v_sumendingcount
        from mm_whmonthlyclosingmnggd     wc,
             mm_whmonthlyclosingdeatailgd detail
       where wc.whmonid = detail.whmonid
         and wc.yearnum = p_year
         and wc.monthnum = p_month
         and wc.warehouseid in
             (select rwt.warehouseid
                from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
               where rwt.warehouseid = wh.warehouseid(+)
                 and wh.auditflg = '2'
                 and wh.isactive = '1'
                 and rwt.warehouseteamid = p_warehouseTeam)
         and detail.materialid = cur_priorsum.materialid;

      -- 1.5.2���ݵ���ƫ��
      v_diff := v_intotalsum + v_priorsumcount - v_outsumcount - v_sumcount;
      if v_diff <> 0 then
        -- ��ĩ����������ݵ���ƫ��
        update mm_whmonthlyclosingdeatailgd t
           set t.sumcount = t.sumcount + v_diff,
               t.updated  = sysdate,
               t.updateby = p_userid
         where t.whmondetailid =
               (select max(detail.whmondetailid)
                  from mm_whmonthlyclosingmnggd     wc,
                       mm_whmonthlyclosingdeatailgd detail
                 where wc.whmonid = detail.whmonid
                   and wc.yearnum = p_year
                   and wc.monthnum = p_month
                   and wc.warehouseid in
                       (select rwt.warehouseid
                          from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                         where rwt.warehouseid = wh.warehouseid(+)
                           and wh.auditflg = '2'
                           and wh.isactive = '1'
                           and rwt.warehouseteamid = p_warehouseTeam)
                   and detail.materialid = cur_priorsum.materialid
                   and detail.sumcount =
                       (select max(detail2.sumcount)
                          from mm_whmonthlyclosingmnggd     wc2,
                               mm_whmonthlyclosingdeatailgd detail2
                         where wc2.whmonid = detail2.whmonid
                           and wc2.yearnum = p_year
                           and wc2.monthnum = p_month
                           and wc2.warehouseid in
                               (select rwt.warehouseid
                                  from mm_rwarehouseteamwhgd rwt,
                                       mm_warehousegd        wh
                                 where rwt.warehouseid = wh.warehouseid(+)
                                   and wh.auditflg = '2'
                                   and wh.isactive = '1'
                                   and rwt.warehouseteamid = p_warehouseTeam)
                           and detail2.materialid = cur_priorsum.materialid));
        commit;
      end if;

      -- 1.5.3 ƫ����������¸�������ĩ�ܽ��
      select sum(detail.sumcount) as sumcount
        into v_sumcount2
        from mm_whmonthlyclosingmnggd     wc,
             mm_whmonthlyclosingdeatailgd detail
       where wc.whmonid = detail.whmonid
         and wc.yearnum = p_year
         and wc.monthnum = p_month
         and wc.warehouseid in
             (select rwt.warehouseid
                from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
               where rwt.warehouseid = wh.warehouseid(+)
                 and wh.auditflg = '2'
                 and wh.isactive = '1'
                 and rwt.warehouseteamid = p_warehouseTeam)
         and detail.materialid = cur_priorsum.materialid;

      --1.5.4 ��ĩ����Ϊ0����ĩ��Ϊ0�����г����¼ʱ���ڳ��������������ϴ���ƫ���������ĩ��
      if v_sumendingcount = 0 and v_sumcount2 <> 0 and v_outsumcount <> 0 then
        -- ƫ���������ĩ������Ϊ0
        update mm_whmonthlyclosingdeatailgd t
           set t.sumcount = 0, t.updated = sysdate, t.updateby = p_userid
         where t.whmondetailid in
               (select detail.whmondetailid
                  from mm_whmonthlyclosingmnggd     wc,
                       mm_whmonthlyclosingdeatailgd detail
                 where wc.whmonid = detail.whmonid
                   and wc.yearnum = p_year
                   and wc.monthnum = p_month
                   and wc.warehouseid in
                       (select rwt.warehouseid
                          from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                         where rwt.warehouseid = wh.warehouseid(+)
                           and wh.auditflg = '2'
                           and wh.isactive = '1'
                           and rwt.warehouseteamid = p_warehouseTeam)
                   and detail.materialid = cur_priorsum.materialid);

        -- ���ⵥ����������� + ƫ���������ĩ���
        update mm_stockbilldetailgd t
           set t.totalsum = t.totalsum + v_sumcount2,
               t.updated  = sysdate,
               t.updateby = p_userid
         where t.stockbilldetailid =
               (select max(detail.stockbilldetailid)
                  from mm_stockbillgd stockbill, mm_stockbilldetailgd detail
                 where stockbill.stockbillid = detail.stockbillid
                   and stockbill.billdate between v_qdatefrom and v_qdateto
                   and detail.materialid = cur_priorsum.materialid
                   and stockbill.verifystatus = '2'
                   and stockbill.issuewarehouse in
                       (select rwt.warehouseid
                          from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
                         where rwt.warehouseid = wh.warehouseid(+)
                           and wh.auditflg = '2'
                           and wh.isactive = '1'
                           and rwt.warehouseteamid = p_warehouseTeam)
                   and stockbill.billfrom in ('1', '2', '3', '6', '8', '9')
                   and stockbill.billtype = '1'
                   and detail.totalsum =
                       (select max(detail2.totalsum)
                          from mm_stockbillgd       stockbill2,
                               mm_stockbilldetailgd detail2
                         where stockbill2.stockbillid = detail2.stockbillid
                           and stockbill2.billdate between v_qdatefrom and
                               v_qdateto
                           and detail2.materialid = cur_priorsum.materialid
                           and stockbill2.verifystatus = '2'
                           and stockbill2.issuewarehouse in
                               (select rwt.warehouseid
                                  from mm_rwarehouseteamwhgd rwt,
                                       mm_warehousegd        wh
                                 where rwt.warehouseid = wh.warehouseid(+)
                                   and wh.auditflg = '2'
                                   and wh.isactive = '1'
                                   and rwt.warehouseteamid = p_warehouseTeam)
                           and stockbill2.billfrom in
                               ('1', '2', '3', '6', '8', '9')
                           and stockbill2.billtype = '1'));
        commit;
      end if;

      -- 1.6���¸����ʳ����
      update mm_issuepricegd t
         set t.issueprice = v_aveprice,
             t.updated    = sysdate,
             t.updateby   = p_userid
       where t.materialid = cur_priorsum.materialid
         and t.warehouseteamid = p_warehouseTeam;
      commit;

      -- 1.7׷�ӵ���Ȩƽ����ʷ���ݹ����
      insert into MM_AVEPRICEHISTORYGD
        (AVEPRICEID,
         WAREHOUSETEAMID,
         materialID,
         AVEPRICE,
         STARTDATE,
         ENDDATE,
         MEMOS,
         CREATED,
         CREATEBY)
      values
        (S_FDISDISPLANGD.NEXTVAL,
         p_warehouseTeam,
         cur_priorsum.materialid,
         v_aveprice,
         v_qdatefrom,
         v_qdateto,
         '',
         sysdate,
         p_userid);
      commit;

      -- 1.8���½��ȱ�
      v_i := v_i + 1;
      update MM_LONGTASKCONDITIONGD t
         set t.excutecount = v_i
       where t.conditionid = v_conditionid;
      commit;
    end if;
  end loop;

  -- ���½��ȱ���
  update MM_LONGTASKCONDITIONGD t
     set t.result = 'ִ�гɹ�'
   where t.conditionid = v_conditionid;

  commit;
  -- 2�����½������Ƿ�����־λ
  update mm_whmonthlyclosingmnggd t
     set t.closeflag = '1', t.updated = sysdate, t.updateby = p_userid
   where t.yearnum = p_year
     and t.monthnum = p_month
     and t.warehouseid in
         (select rwt.warehouseid
            from mm_rwarehouseteamwhgd rwt, mm_warehousegd wh
           where rwt.warehouseid = wh.warehouseid(+)
             and wh.auditflg = '2'
             and wh.isactive = '1'
             and rwt.warehouseteamid = p_warehouseTeam);
  commit;
exception
  when others then
    reflg := '1';
    rollback;
    --ִ��ʧ��
    update MM_LONGTASKCONDITIONGD t
       set t.result = 'ִ��ʧ��'
     where t.conditionid = v_conditionid;
    commit;
end;
/

prompt
prompt Creating procedure P_SETAVERAGEPRICE_TZ
prompt =======================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_SETAVERAGEPRICE_TZ(p_verifystatus number,
                                                 p_stockbillid  CHAR --��ⵥID
                                                 ) as
  /************************************************************************************************
    �����Ȩƽ���ۣ��˹��̹�WEB�������  ������ 2013-8-13
  ************************************************************************************************/
  v_aveprice      number(14, 6); --��Ȩƽ����
  v_priceaccuracy number(1); --���ʼ۸�ȷ��
  v_priorcount    number(14, 4); --�ڳ�����
  v_priortotalsum number(14, 2); --�ڳ����
  v_sign          number(1);

begin
  -- ��ȡ��ⵥ�����ʼ��۸�������Ϣ
  for cur_mater in (select d.materialid,
                           d.price,
                           d.count,
                           d.totalsum,
                           s.acceptwarehouse as warehouseid,
                           team.warehouseteamid
                      from mm_stockbillgd        s,
                           mm_stockbilldetailgd  d,
                           mm_rwarehouseteamwhgd team
                     where s.stockbillid = d.stockbillid
                       and s.acceptwarehouse = team.warehouseid
                       and s.stockbillid in (p_stockbillid)) loop
    --ȡ�����ʼ۸�ȷ��
    select mat.priceaccuracy
      into v_priceaccuracy
      from mm_materialgd mat
     where mat.materialid = cur_mater.materialid;
    -- �жϼ�Ȩƽ���۱����Ƿ��д����ʵ�����
    select count(1)
      into v_sign
      from mm_issuepricegd t
     where t.materialid = cur_mater.materialid
       and t.warehouseteamid = cur_mater.warehouseteamid;
    if v_sign > 0 then
      --��ȡ֮ǰ���������ܽ��
      select t.matercount, t.totalsum
        into v_priorcount, v_priortotalsum
        from mm_issuepricegd t
       where t.materialid = cur_mater.materialid
         and t.warehouseteamid = cur_mater.warehouseteamid;
      --��ʱ��Ȩƽ����
      if (v_priorcount + cur_mater.count * p_verifystatus) > 0 then
        v_aveprice := round((v_priortotalsum +
                            cur_mater.totalsum * p_verifystatus) /
                            (v_priorcount +
                            cur_mater.count * p_verifystatus),
                            v_priceaccuracy);
      else
        v_aveprice := 0;
      end if;
      --���¼�Ȩƽ����
      update mm_issuepricegd t
         set t.issueprice = v_aveprice,
             t.matercount = t.matercount + cur_mater.count * p_verifystatus,
             t.totalsum   = t.totalsum + cur_mater.totalsum * p_verifystatus,
             t.vernum     = t.vernum + 1
       where t.materialid = cur_mater.materialid
         and t.warehouseteamid = cur_mater.warehouseteamid;
      --���¼�ʱ���
      update mm_realtimestockgd t
         set t.price    = v_aveprice,
             t.totalsum = round(v_aveprice * t.count, 2)
       where t.warehouseid = cur_mater.warehouseid
         and t.materialid = cur_mater.materialid;
      commit;
    else
      --�������ݣ���Ȩƽ���۱�
      insert into mm_issuepricegd
        (issuepriceid,
         materialid,
         issueprice,
         verifystatus,
         warehouseteamid,
         matercount,
         totalsum)
      values
        (S_FDISDISPLANGD.NEXTVAL,
         cur_mater.materialid,
         cur_mater.price,
         '2',
         cur_mater.warehouseteamid,
         cur_mater.count,
         cur_mater.totalsum);
      --���¼�ʱ���
      update mm_realtimestockgd t
         set t.price = cur_mater.price, t.totalsum = cur_mater.totalsum
       where t.warehouseid = cur_mater.warehouseid
         and t.materialid = cur_mater.materialid;
      commit;
    end if;
  end loop;
end;
/

prompt
prompt Creating procedure P_TIRESUSINGINFO
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_TIRESUSINGINFO is
  TYPE T_CURSOR IS REF CURSOR;
  CUR_TIRE           T_CURSOR; --��̥�����α�
  V_TIRESID          VARCHAR2(20); --��̥ID
  V_TIRESTYPEID      VARCHAR2(20); --��̥����
  V_BUYDATE          DATE; --��̥��������
  V_STARTMILE        NUMBER(10, 2); --��̥��ʼ���
  V_TIRESPLACE       VARCHAR2(2); --��̥λ��
  V_BUYTIREKIND      VARCHAR2(2); --����״̬
  V_WORKMILES        NUMBER(10, 2); --��ʻ���
  V_RUNSUMMILES      NUMBER(10, 2); --�����
  V_LIFECYCLE        NUMBER(10, 2); --��ʹ������
  V_RULEMILES        NUMBER(10, 2); --�������
  V_RULELIFECYCLE    NUMBER(10, 2); --������������
  V_MILEPERCENT      NUMBER(10, 2); --��̰ٷֱ�
  V_LIFECYCLEPERCENT NUMBER(10, 2); --�������ڰٷֱ�
  V_DATA_COUNT       NUMBER := 0;
  V_ISEXIST          NUMBER := 0;
BEGIN

  OPEN CUR_TIRE FOR
    SELECT BM_TIRESINFOGD.TIRESID, --��̥ID
           BM_TIRESINFOGD.TIRESTYPEID, --��̥����
           BM_TIRESINFOGD.BUYDATE, --��̥��������
           BM_TIRESINFOGD.STARTMILE, --��̥��ʼ���
           NVL(RBUSTIRE.TIRESPLACE, '99') TIRESPLACE, --��̥λ��
           BM_TIRESINFOGD.BUYTIREKIND --����״̬
      FROM BM_TIRESINFOGD, BM_RBUSTIRESGD RBUSTIRE
     WHERE BM_TIRESINFOGD.STATUS != '0'
       AND BM_TIRESINFOGD.STATUS != '4'
       AND BM_TIRESINFOGD.TIRESID = RBUSTIRE.TIRESID(+);
  <<Firstloop>>
  LOOP
    --��ʼ�����б���
    V_WORKMILES        := 0;
    V_RUNSUMMILES      := 0;
    V_LIFECYCLE        := 0;
    V_RULEMILES        := 0;
    V_RULELIFECYCLE    := 0;
    V_MILEPERCENT      := 0;
    V_LIFECYCLEPERCENT := 0;
    FETCH CUR_TIRE
      INTO V_TIRESID, V_TIRESTYPEID, V_BUYDATE, V_STARTMILE, V_TIRESPLACE, V_BUYTIREKIND;
    -- û������ʱ�˳�
    EXIT WHEN CUR_TIRE%NOTFOUND;
    BEGIN
      --//��̼���
      --��̥λ�ü��
      IF (V_TIRESPLACE = '99') THEN
        -- ��ѯ�����
        SELECT COUNT(1)
          INTO V_DATA_COUNT
          FROM BM_TIREBUSHISGD T1
         WHERE T1.TIRESID = V_TIRESID;

        IF V_DATA_COUNT > 0 THEN
          --��̥��ǰλ�ò�����
          SELECT NVL(T.TIRESPOSI, '') TIRESPOSI
            INTO V_TIRESPLACE --ȡ���һ����̥λ��
            FROM (SELECT T1.*,
                         ROW_NUMBER() OVER(ORDER BY T1.REMOVEDATE DESC) ROW_
                    FROM BM_TIREBUSHISGD T1
                   WHERE T1.TIRESID = V_TIRESID) T
           WHERE ROW_ = 1;
        END IF;
      END IF;
      --��̥��ʻ���
      SELECT (SELECT NVL(SUM(T.WOKKMILE), 0)
                FROM BM_TIREBUSHISGD T
               WHERE T.TIRESID = V_TIRESID) +
             (SELECT NVL(SUM(MILE.MILE), 0)
                FROM BM_RBUSTIRESGD RTIRE, BUS_DAYMILE_V MILE
               WHERE RTIRE.TIRESID = V_TIRESID
                 AND RTIRE.BUSID = MILE.BUSID
                 AND MILE.RUNDATE >=
                     (SELECT TRUNC(MAX(T.INSTALLDATE))
                        FROM BM_TIREBUSHISGD T
                       WHERE T.REMOVEDATE IS NULL
                         AND T.TIRESID = V_TIRESID)) MILES
        INTO V_WORKMILES
        FROM DUAL;
      V_RUNSUMMILES := V_WORKMILES + V_STARTMILE; --�����=��ʼ���+��ʻ���
      --�������ڼ���
      V_LIFECYCLE := NVL(ROUND(TO_NUMBER(SYSDATE - V_BUYDATE)), 0); --�������
      --����ƥ��
      SELECT COUNT(*)
        INTO V_ISEXIST
        FROM BM_TIRERULEGD
       WHERE BM_TIRERULEGD.TIRETYPE = V_TIRESTYPEID;

      IF (V_ISEXIST > 0) THEN
        SELECT CASE
                 WHEN V_BUYTIREKIND = '0' THEN
                  BM_TIRERULEGD.NEWCYCLE
                 WHEN V_BUYTIREKIND = '1' THEN
                  BM_TIRERULEGD.WARECYCLE
                 ELSE
                  0
               END
          INTO V_RULELIFECYCLE --�������ڹ���
          FROM BM_TIRERULEGD
         WHERE BM_TIRERULEGD.TIRETYPE = V_TIRESTYPEID;
        SELECT CASE
                 WHEN V_TIRESPLACE <= 1 THEN
                  BM_TIRERULEGD.FRONTMILE
                 WHEN V_TIRESPLACE < 10 THEN
                  BM_TIRERULEGD.MIDMILE
                 WHEN V_TIRESPLACE >= 10 THEN
                  BM_TIRERULEGD.BACKMILE
                 ELSE
                  0
               END
          INTO V_RULEMILES --��̹���
          FROM BM_TIRERULEGD
         WHERE BM_TIRERULEGD.TIRETYPE = V_TIRESTYPEID;
      END IF;
      --��̥��ʻ��̹�����֤
      IF (V_RULEMILES IS NOT NULL AND V_RULEMILES != 0) THEN
        V_MILEPERCENT := V_RUNSUMMILES * 100 / V_RULEMILES;
      END IF;

      --��̥����������֤
      IF (V_RULELIFECYCLE IS NOT NULL AND V_RULELIFECYCLE != 0) THEN
        --�����Ƿ�����
        V_LIFECYCLEPERCENT := V_LIFECYCLE * 100 / (V_RULELIFECYCLE * 365);
      END IF;
      --Ԥ���ж� 80%:Yellow:0,95:Red:1
      IF (V_LIFECYCLEPERCENT >= 95 OR V_MILEPERCENT >= 95) THEN
        --red
        UPDATE BM_TIRESINFOGD
           SET USINGSTATUS = '1'
         WHERE TIRESID = V_TIRESID;
        COMMIT;
      else
        IF (V_LIFECYCLEPERCENT >= 80 OR V_MILEPERCENT >= 80) THEN
          --YELLOW
          UPDATE BM_TIRESINFOGD
             SET USINGSTATUS = '0'
           WHERE TIRESID = V_TIRESID;
          COMMIT;
        else
          --���ȷ��״̬
          UPDATE BM_TIRESINFOGD
             SET ISCONFIRMED = ''
           WHERE TIRESID = V_TIRESID;
          COMMIT;
        END IF;
      END IF;
      --���������
      UPDATE BM_TIRESINFOGD
         SET RUNMILE = V_WORKMILES
       WHERE TIRESID = V_TIRESID;
      COMMIT;
    END;
    EXIT Firstloop WHEN CUR_TIRE%NOTFOUND;
  END LOOP Firstloop;
  CLOSE CUR_TIRE;
END P_TIRESUSINGINFO;
/

prompt
prompt Creating procedure P_TM_DAYBACKUP
prompt =================================
prompt
create or replace procedure aptspzh.P_TM_DAYBACKUP IS
  /***************************************************
  ���ƣ�P_TM_DAYBACKUP
  ��;���ս�
  �����: DAYBFAREFKSTOCK��DAYBFARECKSTOCK
  ��д��
  �޸ģ� ����������棬����Ա��Ʊ
  ***************************************************/
  V_DAY DATE;
BEGIN

  SELECT SYSDATE - 1 INTO V_DAY FROM DUAL;
  --ɾ����������
  DELETE FROM DAYBFARECKSTOCK T WHERE trunc(T.CREATED) = trunc(V_DAY);
  DELETE FROM DAYBFAREFKSTOCK T WHERE trunc(T.CREATED) = trunc(V_DAY);
  commit;
  --���ݵ�������
  --����Ա��Ʊ
  INSERT INTO DAYBFARECKSTOCK
    (RECORDER,
     TKCLASSCODE,
     TKCLASSNAME,
     CURTKORDER,
     CURSTARTORDER,
     CURENDERORDER,
     CURPIECENUM,
     CURMONEY,
     CURBOOKDATA,
     ISACTIVE,
     CREATED,
     CREATEBY,
     UPDATED,
     UPDATEBY,
     MEMOS)
    SELECT RECORDER,
           TKCLASSCODE,
           TKCLASSNAME,
           CURTKORDER,
           CURSTARTORDER,
           CURENDERORDER,
           CURPIECENUM,
           CURMONEY,
           CURBOOKDATA,
           ISACTIVE,
           V_DAY,
           CREATEBY,
           UPDATED,
           UPDATEBY,
           MEMOS
      FROM BFARECKSTOCK;
  --�ⷿ
  INSERT INTO DAYBFAREFKSTOCK
    (RECORDER,
     TKCLASSCODE,
     TKCLASSNAME,
     CURTKORDER,
     CURSTARTORDER,
     CURENDERORDER,
     CURPIECENUM,
     CURMONEY,
     CURBOOKDATA,
     ISACTIVE,
     CREATED,
     CREATEBY,
     UPDATED,
     UPDATEBY,
     MEMOS)
    SELECT RECORDER,
           TKCLASSCODE,
           TKCLASSNAME,
           CURTKORDER,
           CURSTARTORDER,
           CURENDERORDER,
           CURPIECENUM,
           CURMONEY,
           CURBOOKDATA,
           ISACTIVE,
           V_DAY,
           CREATEBY,
           UPDATED,
           UPDATEBY,
           MEMOS
      FROM BFARECKSTOCK;

  COMMIT;
END P_TM_DAYBACKUP;
/

prompt
prompt Creating procedure P_UNCOSTSHARE_KM
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE APTSPZH.P_UNCOSTSHARE_KM(p_costshareno in char --��̯���
                                             ) as
  /************************************************************************************************
    ��ⵥ���÷���̯���˹��̹�WEB������ã�������  ������ 2013-10-29
  ************************************************************************************************/
begin
  --��ȡ��ⵥ�������ܽ��
  for cur_stock in (select d.stockbilldetailid,
                           d.materialid,
                           d.batchno,
                           d.price,
                           d.count,
                           d.totalsum,
                           d.oldprice,
                           d.oldtotalsum
                      from mm_stockbillgd s, mm_stockbilldetailgd d
                     where s.stockbillid = d.stockbillid
                       and s.costshareno in
                           (select s.costshareno
                              from mm_stockbillgd s
                             where instr(p_costshareno, s.costshareno) > 0)) loop
    update mm_stockbilldetailgd t
       set t.price = cur_stock.oldprice, t.totalsum = cur_stock.oldtotalsum
     where t.stockbilldetailid = cur_stock.stockbilldetailid;
    --��ʱ�����еĵ��ۼ��ܽ��
    update mm_realtimestockgd t
       set t.price = cur_stock.oldprice, t.totalsum = cur_stock.oldtotalsum
     where t.materialid = cur_stock.materialid
       and t.batchno = cur_stock.batchno;
    commit;

  end loop;
  --���½��׵���
  update mm_stockbillgd t
     set t.iscostshare = '0', t.costshareno = '', t.costshareprice = 0
   where t.costshareno in
         (select s.costshareno
            from mm_stockbillgd s
           where instr(p_costshareno, s.costshareno) > 0);
  commit;
end;
/

prompt
prompt Creating procedure P_VM_CURRENTDATA
prompt ===================================
prompt
create or replace procedure aptspzh.P_VM_CURRENTDATA IS
/*
**********ʵʱ������ͳ�Ʒ���*******
*/
  V_OBJECTID    VARCHAR2(20) := '';--����ID
  V_OBJECTTYPE  VARCHAR2(2) := '';--��������,�ֵ��MDOBJECTTYPE���ܹ�˾ID��1���ֹ�˾ID��2��·��ID��3����·ID��4������ID��5��Ա��ID��6
  V_CURRENTTYPE VARCHAR2(2) := '';--��ǰ�������ͣ��ֵ��CURRENTTYPE,��ǰ�䳵����0���ƻ���ǰ��Ӫ������1��ʵ�ʵ�ǰ��Ӫ������2����ǰ����������3����ǰ�����ʣ�4
  V_DATETIMENOW DATE;             --��ǰʱ��
  V_MINUTES     NUMBER := 2;      --Ĭ��2����������Ϊ����
BEGIN
  UPDATE VM_CURRENTDATA SET ISLATEST = '0';
  COMMIT;
  --V_MINUTES��ֵ(��ȡ������)
  SELECT VALUE INTO V_MINUTES FROM CONFIGS WHERE SECTION = 'ONLINEMINUTES';
  V_DATETIMENOW := SYSDATE - V_MINUTES / 1440;
  --��·��V_OBJECTTYPEΪ4
  V_OBJECTTYPE := '4';
  --0��ǰ�䳵��
  V_CURRENTTYPE := '0';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T.ROUTEID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM ASGNRBUSROUTELD T
             GROUP BY T.ROUTEID) T;
  --1�ƻ���ǰ��Ӫ����
  V_CURRENTTYPE := '1';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT SEQ.ROUTEID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT SEQ.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM ASGNARRANGESEQGD SEQ, ASGNARRANGEGD T
             WHERE T.ARRANGEID = SEQ.ARRANGEID
               AND T.STATUS = 'd'
               AND SEQ.LEAVETIME <= V_DATETIMENOW
               AND SEQ.ARRIVETIME >= V_DATETIMENOW
               AND SEQ.EXECDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY SEQ.ROUTEID) T;
  --2ʵ�ʵ�ǰ��Ӫ����
  V_CURRENTTYPE := '2';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T.ROUTEID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM FDISDISPLANLD T
             WHERE T.ISACTIVE = '1'
               AND T.REALLEAVETIME <= V_DATETIMENOW
               AND T.RUNDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY T.ROUTEID) T;
  --3��ǰ��������
  V_CURRENTTYPE := '3';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T.ROUTEID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.PRODUCTID),
                   '1',
                   V_DATETIMENOW
              FROM BSVCBUSLASTPOSITIONDATALD5 T
             WHERE T.ACTDATETIME >= V_DATETIMENOW
             GROUP BY T.ROUTEID) T;
  --4��ǰ������
  V_CURRENTTYPE := '4';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T2.ROUTEID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   (CASE
                     WHEN NVL(T2.NUM, 0) = 0 THEN
                      0
                     ELSE
                      (T1.NUM / T2.NUM)
                   END) PERCENT,
                   '1',
                   V_DATETIMENOW
              FROM (SELECT T.ROUTEID, COUNT(DISTINCT T.PRODUCTID) NUM
                      FROM BSVCBUSLASTPOSITIONDATALD5 T
                     WHERE T.ACTDATETIME >= V_DATETIMENOW
                     GROUP BY T.ROUTEID) T1,
                   (SELECT T.ROUTEID, COUNT(DISTINCT T.BUSID) NUM
                      FROM FDISDISPLANLD T
                     WHERE T.ISACTIVE = '1'
                       AND T.REALLEAVETIME <= V_DATETIMENOW
                       AND T.RUNDATE >=
                           TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                                   'YYYY-MM-DD')
                     GROUP BY T.ROUTEID) T2
             WHERE T1.ROUTEID(+) = T2.ROUTEID) T;
  COMMIT;
  --·�ӣ�V_OBJECTTYPEΪ3
  V_OBJECTTYPE := '3';
  --0��ǰ�䳵��
  V_CURRENTTYPE := '0';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T.ORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM MCBUSINFOGS T
             WHERE T.USENATURE = '1'
             GROUP BY T.ORGID) T;
  --1�ƻ���ǰ��Ӫ����
  V_CURRENTTYPE := '1';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT SEQ.ORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT SEQ.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM ASGNARRANGESEQGD SEQ, ASGNARRANGEGD T
             WHERE T.ARRANGEID = SEQ.ARRANGEID
               AND T.STATUS = 'd'
               AND SEQ.LEAVETIME <= V_DATETIMENOW
               AND SEQ.ARRIVETIME >= V_DATETIMENOW
               AND SEQ.EXECDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY SEQ.ORGID) T;
  --2ʵ�ʵ�ǰ��Ӫ����
  V_CURRENTTYPE := '2';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T.ORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM FDISDISPLANLD T
             WHERE T.ISACTIVE = '1'
               AND T.REALLEAVETIME <= V_DATETIMENOW
               AND T.RUNDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY T.ORGID) T;
  --3��ǰ��������
  V_CURRENTTYPE := '3';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT P.ORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.PRODUCTID),
                   '1',
                   V_DATETIMENOW
              FROM BSVCBUSLASTPOSITIONDATALD5 T, MCBUSMACHINEINFOGS P
             WHERE T.PRODUCTID = P.PRODUCTID
               AND T.ACTDATETIME >= V_DATETIMENOW
             GROUP BY P.ORGID) T;
  --4��ǰ������
  V_CURRENTTYPE := '4';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T2.ORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   (CASE
                     WHEN NVL(T2.NUM, 0) = 0 THEN
                      0
                     ELSE
                      (T1.NUM / T2.NUM)
                   END) PERCENT,
                   '1',
                   V_DATETIMENOW
              FROM (SELECT P.ORGID, COUNT(DISTINCT T.PRODUCTID) NUM
                      FROM BSVCBUSLASTPOSITIONDATALD5 T, MCBUSMACHINEINFOGS P
                     WHERE T.PRODUCTID = P.PRODUCTID
                       AND T.ACTDATETIME >= V_DATETIMENOW
                     GROUP BY P.ORGID) T1,
                   (SELECT T.ORGID, COUNT(DISTINCT T.BUSID) NUM
                      FROM FDISDISPLANLD T
                     WHERE T.ISACTIVE = '1'
                       AND T.REALLEAVETIME <= V_DATETIMENOW
                       AND T.RUNDATE >=
                           TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                                   'YYYY-MM-DD')
                     GROUP BY T.ORGID) T2
             WHERE T1.ORGID(+) = T2.ORGID) T;
  COMMIT;
  --�ֹ�˾��V_OBJECTTYPEΪ2
  V_OBJECTTYPE := '2';
  --0��ǰ�䳵��
  V_CURRENTTYPE := '0';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT ORG.Parentorgid,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM MCBUSINFOGS T, MCORGINFOGS ORG
             WHERE T.ORGID = ORG.ORGID
               AND T.USENATURE = '1'
             GROUP BY ORG.Parentorgid) T;
  --1�ƻ���ǰ��Ӫ����
  V_CURRENTTYPE := '1';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT ORG.Parentorgid,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT SEQ.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM ASGNARRANGESEQGD SEQ, ASGNARRANGEGD T, MCORGINFOGS ORG
             WHERE T.ARRANGEID = SEQ.ARRANGEID
               AND T.ORGID = ORG.ORGID
               AND T.STATUS = 'd'
               AND SEQ.LEAVETIME <= V_DATETIMENOW
               AND SEQ.ARRIVETIME >= V_DATETIMENOW
               AND SEQ.EXECDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY ORG.Parentorgid) T;
  --2ʵ�ʵ�ǰ��Ӫ����
  V_CURRENTTYPE := '2';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT ORG.Parentorgid,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.BUSID),
                   '1',
                   V_DATETIMENOW
              FROM FDISDISPLANLD T, MCORGINFOGS ORG
             WHERE T.ISACTIVE = '1'
               AND T.ORGID = ORG.ORGID
               AND T.REALLEAVETIME <= V_DATETIMENOW
               AND T.RUNDATE >=
                   TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                           'YYYY-MM-DD')
             GROUP BY ORG.Parentorgid) T;
  --3��ǰ��������
  V_CURRENTTYPE := '3';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT ORG.Parentorgid,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   COUNT(DISTINCT T.PRODUCTID),
                   '1',
                   V_DATETIMENOW
              FROM BSVCBUSLASTPOSITIONDATALD5 T,
                   MCBUSMACHINEINFOGS         P,
                   MCORGINFOGS                ORG
             WHERE T.PRODUCTID = P.PRODUCTID
               AND P.ORGID = ORG.ORGID
               AND T.ACTDATETIME >= V_DATETIMENOW
             GROUP BY ORG.Parentorgid) T;
  --4��ǰ������
  V_CURRENTTYPE := '4';
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL, T.*
      FROM (SELECT T2.PARENTORGID,
                   V_OBJECTTYPE,
                   V_CURRENTTYPE,
                   (CASE
                     WHEN NVL(T2.NUM, 0) = 0 THEN
                      0
                     ELSE
                      (T1.NUM / T2.NUM)
                   END) PERCENT,
                   '1',
                   V_DATETIMENOW
              FROM (SELECT ORG.PARENTORGID, COUNT(DISTINCT T.PRODUCTID) NUM
                      FROM BSVCBUSLASTPOSITIONDATALD5 T,
                           MCBUSMACHINEINFOGS         P,
                           MCORGINFOGS                ORG
                     WHERE T.PRODUCTID = P.PRODUCTID
                       AND P.ORGID = ORG.ORGID
                       AND T.ACTDATETIME >= V_DATETIMENOW
                     GROUP BY ORG.PARENTORGID) T1,
                   (SELECT ORG.PARENTORGID, COUNT(DISTINCT T.BUSID) NUM
                      FROM FDISDISPLANLD T, MCORGINFOGS ORG
                     WHERE T.ISACTIVE = '1'
                       AND T.ORGID = ORG.ORGID
                       AND T.REALLEAVETIME <= V_DATETIMENOW
                       AND T.RUNDATE >=
                           TO_DATE(TO_CHAR(V_DATETIMENOW - 1, 'YYYY-MM-DD'),
                                   'YYYY-MM-DD')
                     GROUP BY ORG.PARENTORGID) T2
             WHERE T1.PARENTORGID(+) = T2.PARENTORGID) T;
  COMMIT;
  --�ܹ�˾��V_OBJECTTYPEΪ1
  V_OBJECTTYPE := '1';
  --��ȡ�ܹ�˾��֯�仯
  SELECT T.ORGID
    INTO V_OBJECTID
    FROM MCORGINFOGS T
   WHERE T.PARENTORGID = '-1';
  --��������ֹ�˾�ĺϼ�����
  INSERT INTO VM_CURRENTDATA
    (CURRENTID,
     OBJECTID,
     OBJECTTYPE,
     CURRENTTYPE,
     CURRENTDATA,
     ISLATEST,
     CREATED)
    SELECT S_CURRENT.NEXTVAL,T.* FROM
    (SELECT
           V_OBJECTID,
           V_OBJECTTYPE,
           T.CURRENTTYPE,
           SUM(CURRENTDATA),
           '1',
           V_DATETIMENOW
      FROM VM_CURRENTDATA T
     WHERE T.ISLATEST = '1'
       AND OBJECTTYPE = '2'
       GROUP BY T.CURRENTTYPE)T;
       COMMIT;
END P_VM_CURRENTDATA;
/


spool off
