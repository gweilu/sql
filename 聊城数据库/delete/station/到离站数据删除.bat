@rem 设置连接符
set CONNECTION_STRING=aptslc/lc@APTS
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=E:
@rem 设置需要删除的月份，格式为201601
set part=201601

echo alter table BSVCBUSARRLFTLD5 truncate partition P_%part%; > %basedir%\delete\station\stationdel.sql

echo exit; >> %basedir%\delete\station\stationdel.sql

sqlplus %CONNECTION_STRING% @ %basedir%\delete\station\stationdel.sql