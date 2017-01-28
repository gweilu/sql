create or replace procedure P_INSERT_SEGMENT_GPS2(v_routeid   in number,
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
