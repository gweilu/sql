-- Create table
create table BZ_ROUTEGPSPOINTS
(
  routeid   VARCHAR2(36) not null,
  longitude NUMBER(9,6),
  latitude  NUMBER(9,6)
);
-- Add comments to the table 
comment on table BZ_ROUTEGPSPOINTS
  is '线路GPS数据表';
-- Add comments to the columns 
comment on column BZ_ROUTEGPSPOINTS.routeid
  is '线路ID';
comment on column BZ_ROUTEGPSPOINTS.longitude
  is '经度';
comment on column BZ_ROUTEGPSPOINTS.latitude
  is '纬度';
