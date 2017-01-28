-- Create table
create table BZ_ROUTEGPSPOINTS
(
  routeid   VARCHAR2(36) not null,
  longitude NUMBER(9,6),
  latitude  NUMBER(9,6)
);
-- Add comments to the table 
comment on table BZ_ROUTEGPSPOINTS
  is '��·GPS���ݱ�';
-- Add comments to the columns 
comment on column BZ_ROUTEGPSPOINTS.routeid
  is '��·ID';
comment on column BZ_ROUTEGPSPOINTS.longitude
  is '����';
comment on column BZ_ROUTEGPSPOINTS.latitude
  is 'γ��';
