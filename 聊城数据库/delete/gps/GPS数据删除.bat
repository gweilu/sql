@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置需要删除的日期，格式为20160101
set part=20160101

echo alter table BSVCBUSRUNDATALD5 truncate partition P_%part%; > %basedir%\delete\gps\gpsdel.sql

echo exit; >> %basedir%\delete\gps\gpsdel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\gps\gpsdel.sql