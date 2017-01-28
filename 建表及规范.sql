/*
    
    近期研发同事流动也很快，好多新同事在新建数据表建立维护时，出现一些问题，请后期注意；
    1、表名不规范（未加MC FDIS等前缀）；
    2、索引不建立，或建立了不合理
    3、视图或存储过程等留有空白行
    4、大数据表未分区
这样一段时间后，会把系统拖垮的。
  
    请给各位同事强调一下在新建表时，先评估数据量的大小，是否需要建立分区表（建分区表，一定同时将表加入到DBA_PART_TABLE表中）；

    建议研发同事梳理评估一下当前的新的数据表，是否有需要调整分区表的，是否有表名需要规范的，统一进行处理。

   以下为 CAN数据表的调整 改为月分区
    
   新建表空间 TBS_APTS_CAN ;
  
写入分区管理表DBA_PART_TABLE 
insert into DBA_PART_TABLE (TABLE_NAME, TABLESPACE_TBL, TABLESPACE_IDX, PARTITION_COLUMN, PARTITION_TYPE, TRUNCATE_DATE, MEMO)
values ('BSVCBUSCANDATA', 'TBS_APTS_CAN', 'TBS_APTS_CAN', 'ACTDATETIME', '1', 60, 'CAN数据表');

建表语句调整为（索引一定改为分区索引，索引顺序也进行了调整）
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
  is 'CAN数据表，存储车载机上传的CAN数据';
-- Add comments to the columns 
comment on column BSVCBUSCANDATA.candataid
  is '唯一号';
comment on column BSVCBUSCANDATA.routeid
  is '线路号';
comment on column BSVCBUSCANDATA.productid
  is '车载机编号';
comment on column BSVCBUSCANDATA.actdatetime
  is '业务时间';
comment on column BSVCBUSCANDATA.protocoltype
  is '协议类型  1:海信系统测试; 2:上海张江用协议; 3:威帝协议; 4:欧科佳协议; 5:本安协议; 6:雪利曼; 32:SAE J1939';
comment on column BSVCBUSCANDATA.recdatetime
  is '记录时间';
comment on column BSVCBUSCANDATA.writeid
  is '存储服务号';
comment on column BSVCBUSCANDATA.isappend
  is '0 正常，1 GPRS补发';
comment on column BSVCBUSCANDATA.canpgn
  is '参数组编号';
comment on column BSVCBUSCANDATA.canspn1
  is '参数编号1的值';
comment on column BSVCBUSCANDATA.canspn2
  is '参数编号2的值';
comment on column BSVCBUSCANDATA.canspn3
  is '参数编号3的值';
comment on column BSVCBUSCANDATA.canspn4
  is '参数编号4的值';
comment on column BSVCBUSCANDATA.canspn5
  is '参数编号5的值';
comment on column BSVCBUSCANDATA.canspn6
  is '参数编号6的值';
comment on column BSVCBUSCANDATA.canspn7
  is '参数编号7的值';
comment on column BSVCBUSCANDATA.canspn8
  is '参数编号8的值';
comment on column BSVCBUSCANDATA.canspn9
  is '参数编号9的值';
comment on column BSVCBUSCANDATA.canspn10
  is '参数编号10的值';
comment on column BSVCBUSCANDATA.canspn11
  is '参数编号11的值';
comment on column BSVCBUSCANDATA.canspn12
  is '参数编号12的值';
comment on column BSVCBUSCANDATA.canspn13
  is '参数编号13的值';
comment on column BSVCBUSCANDATA.canspn14
  is '参数编号14的值';
comment on column BSVCBUSCANDATA.canspn15
  is '参数编号15的值';
comment on column BSVCBUSCANDATA.canspn16
  is '参数编号16的值';
comment on column BSVCBUSCANDATA.canspn17
  is '参数编号17的值';
comment on column BSVCBUSCANDATA.canspn18
  is '参数编号18的值';
comment on column BSVCBUSCANDATA.canspn19
  is '参数编号19的值';
comment on column BSVCBUSCANDATA.canspn20
  is '参数编号20的值';
comment on column BSVCBUSCANDATA.canspn21
  is '参数编号21的值';
comment on column BSVCBUSCANDATA.canspn22
  is '参数编号22的值';
comment on column BSVCBUSCANDATA.canspn23
  is '参数编号23的值';
comment on column BSVCBUSCANDATA.canspn24
  is '参数编号24的值';
comment on column BSVCBUSCANDATA.canspn25
  is '参数编号25的值';
comment on column BSVCBUSCANDATA.canspn26
  is '参数编号26的值';
comment on column BSVCBUSCANDATA.canspn27
  is '参数编号27的值';
comment on column BSVCBUSCANDATA.canspn28
  is '参数编号28的值';
comment on column BSVCBUSCANDATA.canspn29
  is '参数编号29的值';
comment on column BSVCBUSCANDATA.canspn30
  is '参数编号30的值';
comment on column BSVCBUSCANDATA.canspn31
  is '参数编号31的值';
comment on column BSVCBUSCANDATA.canspn32
  is '参数编号32的值';
comment on column BSVCBUSCANDATA.canspn33
  is '参数编号33的值';
comment on column BSVCBUSCANDATA.canspn34
  is '参数编号34的值';
comment on column BSVCBUSCANDATA.canspn35
  is '参数编号35的值';
comment on column BSVCBUSCANDATA.canspn36
  is '参数编号36的值';
comment on column BSVCBUSCANDATA.canspn37
  is '参数编号37的值';
comment on column BSVCBUSCANDATA.canspn38
  is '参数编号38的值';
comment on column BSVCBUSCANDATA.canspn39
  is '参数编号39的值';
comment on column BSVCBUSCANDATA.canspn40
  is '参数编号40的值';
comment on column BSVCBUSCANDATA.canspn41
  is '参数编号41的值';
comment on column BSVCBUSCANDATA.canspn42
  is '参数编号42的值';
comment on column BSVCBUSCANDATA.canspn43
  is '参数编号43的值';
comment on column BSVCBUSCANDATA.canspn44
  is '参数编号44的值';
comment on column BSVCBUSCANDATA.canspn45
  is '参数编号45的值';
comment on column BSVCBUSCANDATA.canspn46
  is '参数编号46的值';
comment on column BSVCBUSCANDATA.canspn47
  is '参数编号47的值';
comment on column BSVCBUSCANDATA.canspn48
  is '参数编号48的值';
comment on column BSVCBUSCANDATA.canspn49
  is '参数编号49的值';
comment on column BSVCBUSCANDATA.canspn50
  is '参数编号50的值';
comment on column BSVCBUSCANDATA.issvrappend
  is '存储服务自动补交标志 - 数据入库失败后,存储服务保存到文件然后再补交 0,非补交(直接入库);1,补交;';
comment on column BSVCBUSCANDATA.svrappendtime
  is '存储服务自动补交时间';
comment on column BSVCBUSCANDATA.pduaddress
  is 'PDU源地址';
-- Create/Recreate indexes 
create index IDX_BSVCBUSCANDATA1 on BSVCBUSCANDATA (ACTDATETIME, CANPGN, PRODUCTID, ROUTEID) LOCAL;
