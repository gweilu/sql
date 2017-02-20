@rem 设置连接符
set CONNECTION_STRING=aptshz5/hz5@APTS_HZ_LOCAL
@rem 设置此脚本所在文件夹保存的路径，注意末尾不要加'\'
set basedir=D:\BACKUP
@rem 设置备份文件保存的绝对路径，注意末尾不要加'\'
set dumpdir=d:\dumpdir

call %basedir%\backup\basic\table_name.bat

echo userid=%CONNECTION_STRING% > %basedir%\backup\basic\basic.par

type %basedir%\backup\basic\table_name.txt >> %basedir%\backup\basic\basic.par

type %basedir%\backup\basic\loader.txt >> %basedir%\backup\basic\basic.par

echo file=%dumpdir%\apts%date:~0,4%%date:~5,2%%date:~8,2%.dmp log=%dumpdir%\apts%date:~0,4%%date:~5,2%%date:~8,2%.log >> %basedir%\backup\basic\basic.par

exp parfile=%basedir%\backup\basic\basic.par

