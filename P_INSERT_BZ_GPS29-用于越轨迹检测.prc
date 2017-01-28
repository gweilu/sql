create or replace procedure P_INSERT_BZ_GPS2(v_routeid   in number) is
  TYPE T_CURSOR IS REF CURSOR;
  /**********************************************
  name :P_INSERT_SEGMENT_GPS
  createby: NY_COICE
  CREATED:20161026
  USE TO: ��ERP���ã�д��HC_SEGMENT ���̾�γ�� ��ͼΪ�Ȼ���ϵͳд����·���й켣
  table:  GPS���� bsvcbusrundatald5
           д�� ATIS_SEGSTALINE ������ϵͳ���켣ʹ��
  memos��
  UPDATEBY:
  UPDATERD:
  **********************************************/
  CUR_station     T_CURSOR;
  v_jwd         clob;
  v_LO           varchar2(20);
  v_CHAR           varchar2(1);
  v_LA       varchar2(20);
  v_jwdlength     number;
  x     number;
  y     number;
  v_count11     number(8);
  v_count21     number(8);
begin
  v_jwdlength    := 0;
  x   := 0;
  y   := 0;  
--1ɾ��atis_segstalineԭ������
delete from bz_routegpspoints a  where  a.routeid=v_routeid;
  commit;
  --2��վ���α�
  OPEN CUR_station FOR
        select jwd,length(jwd)
         from atis_segstaline s where routeid=v_routeid ;
--2.1ѭ�� ��ȡ����վ������
 LOOP
    FETCH CUR_STATION  INTO v_jwd,v_jwdlength;    
    EXIT WHEN CUR_STATION%NOTFOUND;
  --   IF  v_jwdlength>0 THEN
  --120.182115,30.20124;120.181952,30.201134
  -- 0    1      2    3   0
      begin
        x:=0;
        y:=0;
        v_CHAR:='';
        v_lo:='';
        v_la:='';
        WHILE x<=v_jwdlength and v_jwdlength>0 LOOP
        x:=x+1;
        v_CHAR:=substr(v_jwd,x,1);
         if  x=v_jwdlength then
           v_la:=v_la||v_CHAR;
            insert into bz_routegpspoints (routeid,LONGITUDE,LATITUDE)             
                                          values (v_routeid,to_number(v_lo),to_number(v_la));
         commit;
         end if;
        if v_CHAR=';' then
           y:=0;
            insert into bz_routegpspoints (routeid,LONGITUDE,LATITUDE)             
                                          values (v_routeid,to_number(v_lo),to_number(v_la));
         commit;
        end if;
        if v_CHAR=',' then
           y:=2;
         end if;
        if y=1 then
           v_lo:=v_lo||v_CHAR;
         end if;
        if y=3 then
           v_la:=v_la||v_CHAR;
         end if;
        if y=0 and v_CHAR<>';' then
           v_lo:=v_CHAR;
           y:=1;
         end if;
        if y=2 and v_CHAR<>','  then
          v_la:=v_CHAR;
          y:=3;
         end if;
        end loop;
      end;
  END LOOP;
  CLOSE CUR_STATION;
end;
/
