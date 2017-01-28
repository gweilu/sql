/*
    
    �����з�ͬ������Ҳ�ܿ죬�ö���ͬ�����½����ݱ���ά��ʱ������һЩ���⣬�����ע�⣻
    1���������淶��δ��MC FDIS��ǰ׺����
    2�������������������˲�����
    3����ͼ��洢���̵����пհ���
    4�������ݱ�δ����
����һ��ʱ��󣬻��ϵͳ�Ͽ�ġ�
  
    �����λͬ��ǿ��һ�����½���ʱ���������������Ĵ�С���Ƿ���Ҫ������������������һ��ͬʱ������뵽DBA_PART_TABLE���У���

    �����з�ͬ����������һ�µ�ǰ���µ����ݱ��Ƿ�����Ҫ����������ģ��Ƿ��б�����Ҫ�淶�ģ�ͳһ���д���

   ����Ϊ CAN���ݱ�ĵ��� ��Ϊ�·���
    
   �½���ռ� TBS_APTS_CAN ;
  
д����������DBA_PART_TABLE 
insert into DBA_PART_TABLE (TABLE_NAME, TABLESPACE_TBL, TABLESPACE_IDX, PARTITION_COLUMN, PARTITION_TYPE, TRUNCATE_DATE, MEMO)
values ('BSVCBUSCANDATA', 'TBS_APTS_CAN', 'TBS_APTS_CAN', 'ACTDATETIME', '1', 60, 'CAN���ݱ�');

����������Ϊ������һ����Ϊ��������������˳��Ҳ�����˵�����
*/
create table BSVCBUSCANDATA
(
  candataid     NUMBER(16) not null,
  routeid       NUMBER(8),
  productid     NUMBER(10) not null,
  actdatetime   DATE not null,
  protocoltype  VARCHAR2(3),
  recdatetime   DATE default sysdate not null,
  writeid       NUMBER(8),
  isappend      CHAR(1),
  canpgn        NUMBER(10) not null,
  canspn1       VARCHAR2(50),
  canspn2       VARCHAR2(50),
  canspn3       VARCHAR2(50),
  canspn4       VARCHAR2(50),
  canspn5       VARCHAR2(50),
  canspn6       VARCHAR2(50),
  canspn7       VARCHAR2(50),
  canspn8       VARCHAR2(50),
  canspn9       VARCHAR2(50),
  canspn10      VARCHAR2(50),
  canspn11      VARCHAR2(50),
  canspn12      VARCHAR2(50),
  canspn13      VARCHAR2(50),
  canspn14      VARCHAR2(50),
  canspn15      VARCHAR2(50),
  canspn16      VARCHAR2(50),
  canspn17      VARCHAR2(50),
  canspn18      VARCHAR2(50),
  canspn19      VARCHAR2(50),
  canspn20      VARCHAR2(50),
  canspn21      VARCHAR2(50),
  canspn22      VARCHAR2(50),
  canspn23      VARCHAR2(50),
  canspn24      VARCHAR2(50),
  canspn25      VARCHAR2(50),
  canspn26      VARCHAR2(50),
  canspn27      VARCHAR2(50),
  canspn28      VARCHAR2(50),
  canspn29      VARCHAR2(50),
  canspn30      VARCHAR2(50),
  canspn31      VARCHAR2(50),
  canspn32      VARCHAR2(50),
  canspn33      VARCHAR2(50),
  canspn34      VARCHAR2(50),
  canspn35      VARCHAR2(50),
  canspn36      VARCHAR2(50),
  canspn37      VARCHAR2(50),
  canspn38      VARCHAR2(50),
  canspn39      VARCHAR2(50),
  canspn40      VARCHAR2(50),
  canspn41      VARCHAR2(50),
  canspn42      VARCHAR2(50),
  canspn43      VARCHAR2(50),
  canspn44      VARCHAR2(50),
  canspn45      VARCHAR2(50),
  canspn46      VARCHAR2(50),
  canspn47      VARCHAR2(50),
  canspn48      VARCHAR2(50),
  canspn49      VARCHAR2(50),
  canspn50      VARCHAR2(50),
  issvrappend   CHAR(1) default '0',
  svrappendtime DATE,
  isshow        CHAR(1),
  pduaddress    NUMBER(4)
)
partition by range (ACTDATETIME)
(
  partition P_201601 values less than (TO_DATE(' 2016-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace TBS_APTS_CAN,
  partition P_201602 values less than (TO_DATE(' 2016-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace TBS_APTS_CAN,
  partition P_201603 values less than (TO_DATE(' 2016-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace TBS_APTS_CAN,
  partition P_201604 values less than (TO_DATE(' 2016-05-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace TBS_APTS_CAN,
  partition P_201605 values less than (TO_DATE(' 2016-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    tablespace TBS_APTS_CAN,
  partition P_MAX values less than (MAXVALUE)
    tablespace TBS_APTS_CAN
);
-- Add comments to the table 
comment on table BSVCBUSCANDATA
  is 'CAN���ݱ��洢���ػ��ϴ���CAN����';
-- Add comments to the columns 
comment on column BSVCBUSCANDATA.candataid
  is 'Ψһ��';
comment on column BSVCBUSCANDATA.routeid
  is '��·��';
comment on column BSVCBUSCANDATA.productid
  is '���ػ����';
comment on column BSVCBUSCANDATA.actdatetime
  is 'ҵ��ʱ��';
comment on column BSVCBUSCANDATA.protocoltype
  is 'Э������  1:����ϵͳ����; 2:�Ϻ��Ž���Э��; 3:����Э��; 4:ŷ�Ƽ�Э��; 5:����Э��; 6:ѩ����; 32:SAE J1939';
comment on column BSVCBUSCANDATA.recdatetime
  is '��¼ʱ��';
comment on column BSVCBUSCANDATA.writeid
  is '�洢�����';
comment on column BSVCBUSCANDATA.isappend
  is '0 ������1 GPRS����';
comment on column BSVCBUSCANDATA.canpgn
  is '��������';
comment on column BSVCBUSCANDATA.canspn1
  is '�������1��ֵ';
comment on column BSVCBUSCANDATA.canspn2
  is '�������2��ֵ';
comment on column BSVCBUSCANDATA.canspn3
  is '�������3��ֵ';
comment on column BSVCBUSCANDATA.canspn4
  is '�������4��ֵ';
comment on column BSVCBUSCANDATA.canspn5
  is '�������5��ֵ';
comment on column BSVCBUSCANDATA.canspn6
  is '�������6��ֵ';
comment on column BSVCBUSCANDATA.canspn7
  is '�������7��ֵ';
comment on column BSVCBUSCANDATA.canspn8
  is '�������8��ֵ';
comment on column BSVCBUSCANDATA.canspn9
  is '�������9��ֵ';
comment on column BSVCBUSCANDATA.canspn10
  is '�������10��ֵ';
comment on column BSVCBUSCANDATA.canspn11
  is '�������11��ֵ';
comment on column BSVCBUSCANDATA.canspn12
  is '�������12��ֵ';
comment on column BSVCBUSCANDATA.canspn13
  is '�������13��ֵ';
comment on column BSVCBUSCANDATA.canspn14
  is '�������14��ֵ';
comment on column BSVCBUSCANDATA.canspn15
  is '�������15��ֵ';
comment on column BSVCBUSCANDATA.canspn16
  is '�������16��ֵ';
comment on column BSVCBUSCANDATA.canspn17
  is '�������17��ֵ';
comment on column BSVCBUSCANDATA.canspn18
  is '�������18��ֵ';
comment on column BSVCBUSCANDATA.canspn19
  is '�������19��ֵ';
comment on column BSVCBUSCANDATA.canspn20
  is '�������20��ֵ';
comment on column BSVCBUSCANDATA.canspn21
  is '�������21��ֵ';
comment on column BSVCBUSCANDATA.canspn22
  is '�������22��ֵ';
comment on column BSVCBUSCANDATA.canspn23
  is '�������23��ֵ';
comment on column BSVCBUSCANDATA.canspn24
  is '�������24��ֵ';
comment on column BSVCBUSCANDATA.canspn25
  is '�������25��ֵ';
comment on column BSVCBUSCANDATA.canspn26
  is '�������26��ֵ';
comment on column BSVCBUSCANDATA.canspn27
  is '�������27��ֵ';
comment on column BSVCBUSCANDATA.canspn28
  is '�������28��ֵ';
comment on column BSVCBUSCANDATA.canspn29
  is '�������29��ֵ';
comment on column BSVCBUSCANDATA.canspn30
  is '�������30��ֵ';
comment on column BSVCBUSCANDATA.canspn31
  is '�������31��ֵ';
comment on column BSVCBUSCANDATA.canspn32
  is '�������32��ֵ';
comment on column BSVCBUSCANDATA.canspn33
  is '�������33��ֵ';
comment on column BSVCBUSCANDATA.canspn34
  is '�������34��ֵ';
comment on column BSVCBUSCANDATA.canspn35
  is '�������35��ֵ';
comment on column BSVCBUSCANDATA.canspn36
  is '�������36��ֵ';
comment on column BSVCBUSCANDATA.canspn37
  is '�������37��ֵ';
comment on column BSVCBUSCANDATA.canspn38
  is '�������38��ֵ';
comment on column BSVCBUSCANDATA.canspn39
  is '�������39��ֵ';
comment on column BSVCBUSCANDATA.canspn40
  is '�������40��ֵ';
comment on column BSVCBUSCANDATA.canspn41
  is '�������41��ֵ';
comment on column BSVCBUSCANDATA.canspn42
  is '�������42��ֵ';
comment on column BSVCBUSCANDATA.canspn43
  is '�������43��ֵ';
comment on column BSVCBUSCANDATA.canspn44
  is '�������44��ֵ';
comment on column BSVCBUSCANDATA.canspn45
  is '�������45��ֵ';
comment on column BSVCBUSCANDATA.canspn46
  is '�������46��ֵ';
comment on column BSVCBUSCANDATA.canspn47
  is '�������47��ֵ';
comment on column BSVCBUSCANDATA.canspn48
  is '�������48��ֵ';
comment on column BSVCBUSCANDATA.canspn49
  is '�������49��ֵ';
comment on column BSVCBUSCANDATA.canspn50
  is '�������50��ֵ';
comment on column BSVCBUSCANDATA.issvrappend
  is '�洢�����Զ�������־ - �������ʧ�ܺ�,�洢���񱣴浽�ļ�Ȼ���ٲ��� 0,�ǲ���(ֱ�����);1,����;';
comment on column BSVCBUSCANDATA.svrappendtime
  is '�洢�����Զ�����ʱ��';
comment on column BSVCBUSCANDATA.pduaddress
  is 'PDUԴ��ַ';
-- Create/Recreate indexes 
create index IDX_BSVCBUSCANDATA1 on BSVCBUSCANDATA (ACTDATETIME, CANPGN, PRODUCTID, ROUTEID) LOCAL;
