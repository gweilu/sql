
--查看表空间及使用情况
select a.tablespace_name,
       a.bytes / 1024 / 1024 "Sum MB",
       (a.bytes - b.bytes) / 1024 / 1024 "used MB",
       b.bytes / 1024 / 1024 "free MB",
       round(((a.bytes - b.bytes) / a.bytes) * 100, 2) "percent_used"
  from (select tablespace_name, sum(bytes) bytes
          from dba_data_files
         group by tablespace_name) a,
       (select tablespace_name, sum(bytes) bytes, max(bytes) largest
          from dba_free_space
         group by tablespace_name) b
 where a.tablespace_name = b.tablespace_name
 order by ((a.bytes - b.bytes) / a.bytes) desc
          --查看表空间及使用情况
            select tablespace_name "表空间名称",
                   filecount       "数据文件个数",
                   round((bytes - freebytes) / 1024 / 1024 / 1024, 3) 已占用表空间G,
                   round(freebytes / 1024 / 1024 / 1024, 3) 未占用表空间G,
                   round(bytes / 1024 / 1024 / 1024, 3) 当前已分配表空间G,
                   round((bytes - freebytes) * 100 / bytes, 1) "当前占用率%",
                   round((maxbytes - bytes) / 1024 / 1024 / 1024, 3) 未扩展表空间G,
                   round(maxbytes / 1024 / 1024 / 1024, 3) 最大值表空间G
              from (
                    select df.tablespace_name, -- count(1),    
                            SUM(df.bytes) bytes,
                            SUM((case
                                  when df.autoextensible = 'YES' THEN
                                   df.maxbytes
                                  ELSE
                                   df.bytes
                                END)) maxbytes,
                            SUM(dfs.sbytes) freebytes,
                            count(1) filecount
                      from dba_data_files df,
                            (select file_id, sum(bytes) sbytes
                               from dba_free_space
                              group by file_id) dfs
                     where df.file_id = dfs.file_id(+)
                     group by df.tablespace_name) d
             order by tablespace_name;


select * from dba_data_files d where d.tablespace_name='TBS_APTSHZ5_BSVC';

alter tablespace TBS_APTSHZ5_FDIS add datafile '/data1/tbs_aptshz5_fdis3.dbf' size 30G autoextend on;
